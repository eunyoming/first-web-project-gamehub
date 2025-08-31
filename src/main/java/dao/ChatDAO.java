package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.chat.MessageDTO;

public class ChatDAO {
	//ChatroomDTO, ChatroomMemberDTO, MessageDTO
	/*
	 * chatrooms, chatroom_members, messages 테이블에 대한 데이터 접근 및 조작. 
	 * 채팅방 생성/관리, 채팅방 멤버 관리, 
	 * 메시지 저장 및 조회 등을 담당합니다.
	 * 
	 */
	private static ChatDAO instance;

	public synchronized static ChatDAO getInstance() {
		if(instance==null)
		{
			instance = new ChatDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	public int createChatroom(String receiveID,String type) throws Exception {
	    String seqSql = "SELECT chatrooms_seq.NEXTVAL FROM dual";
	    String insertSql = "INSERT INTO chatrooms (seq, name, type) VALUES (?, ?, ?)";

	    try (Connection connection = getConnection()) {
	        int newSeq = 0;

	        // 1. 새 시퀀스 값 뽑기
	        try (PreparedStatement pstmt = connection.prepareStatement(seqSql);
	             ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                newSeq = rs.getInt(1);
	            }
	        }

	        // 2. 채팅방 INSERT
	        try (PreparedStatement pstmt = connection.prepareStatement(insertSql)) {
	            pstmt.setInt(1, newSeq);
	            pstmt.setString(2, receiveID);
	            pstmt.setString(3, type);
	            pstmt.executeUpdate();
	        }

	        return newSeq;
	    }
	}
	
	public void addChatroomMember(int chatroomSeq, String userId) throws Exception {
	    String sql = "INSERT INTO chatroom_members (chatroom_seq, user_id) VALUES (?, ?)";

	    try (Connection connection = getConnection();
	         PreparedStatement pstmt = connection.prepareStatement(sql)) {
	        pstmt.setInt(1, chatroomSeq);
	        pstmt.setString(2, userId);
	        pstmt.executeUpdate();
	    }
	}
	
	// 1:1 채팅방 확인 및 없으면 생성
	public int findOrCreateChatroom(String loginId, String friendId) throws Exception {
	    Integer chatroomSeq = findDirectChatroom(loginId, friendId); // 기존 존재 여부 체크
	    if (chatroomSeq != null) {
	        return chatroomSeq; // 이미 있으면 그대로 반환
	    }

	    // 없으면 새 채팅방 생성
	    String roomName = loginId + "와 " + friendId + "의 채팅방";
	    int newSeq = createChatroom(roomName, "direct");

	    // 멤버 추가
	    addChatroomMember(newSeq, loginId);
	    addChatroomMember(newSeq, friendId);

	    return newSeq;
	}
	
	public Integer findDirectChatroom(String userA, String userB) throws Exception {
	    String sql = "SELECT c.seq " +
	                 "FROM chatrooms c " +
	                 "JOIN chatroom_members m1 ON c.seq = m1.chatroom_seq AND m1.user_id = ? " +
	                 "JOIN chatroom_members m2 ON c.seq = m2.chatroom_seq AND m2.user_id = ? " +
	                 "WHERE c.type = 'direct' " +
	                 "AND (SELECT COUNT(*) FROM chatroom_members m WHERE m.chatroom_seq = c.seq) = 2";

	    try (Connection connection = getConnection();
	         PreparedStatement pstmt = connection.prepareStatement(sql)) {
	        pstmt.setString(1, userA);
	        pstmt.setString(2, userB);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                return rs.getInt("seq");
	            }
	        }
	    }
	    return null; // 존재하지 않음
	}


	public MessageDTO saveMessage(int chatroomSeq, String senderId, String content) throws Exception {
	    String seqSql = "SELECT messages_seq.NEXTVAL FROM dual";
	    String insertSql = "INSERT INTO messages (seq, chatroom_seq, sender_id, content, created_at) VALUES (?, ?, ?, ?, SYSTIMESTAMP)";

	    try (Connection connection = getConnection()) {
	        int newSeq = 0;

	        // 1. 메시지 seq 발급
	        try (PreparedStatement pstmt = connection.prepareStatement(seqSql);
	             ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                newSeq = rs.getInt(1);
	            }
	        }

	        // 2. 메시지 저장
	        try (PreparedStatement pstmt = connection.prepareStatement(insertSql)) {
	            pstmt.setInt(1, newSeq);
	            pstmt.setInt(2, chatroomSeq);
	            pstmt.setString(3, senderId);
	            pstmt.setString(4, content);
	            pstmt.executeUpdate();
	        }

	        // 3. 저장한 메시지 DTO로 반환
	        String selectSql = "SELECT seq, chatroom_seq, sender_id, content, created_at FROM messages WHERE seq = ?";
	        try (PreparedStatement pstmt = connection.prepareStatement(selectSql)) {
	            pstmt.setInt(1, newSeq);
	            try (ResultSet rs = pstmt.executeQuery()) {
	                if (rs.next()) {
	                    dto.chat.MessageDTO message = new dto.chat.MessageDTO();
	                    message.setSeq(rs.getInt("seq"));
	                    message.setChatroom_seq(rs.getInt("chatroom_seq"));
	                    message.setSender_Id(rs.getString("sender_id"));
	                    message.setContent(rs.getString("content"));
	                    message.setCreated_at(rs.getTimestamp("created_at"));
	                    return message;
	                }
	            }
	        }
	    }

	    return null; // 혹시 실패 시
	}

	public List<MessageDTO> getMessages(int chatroomSeq, int limit) throws Exception {
	    String sql = "SELECT * FROM ( " +
	                 "    SELECT seq, chatroom_seq, sender_id, content, created_at " +
	                 "    FROM messages " +
	                 "    WHERE chatroom_seq = ? " +
	                 "    ORDER BY created_at DESC " +
	                 ") " +
	                 "WHERE ROWNUM <= ?";

	    List<MessageDTO> messages = new ArrayList<>();

	    try (Connection connection = getConnection();
	         PreparedStatement pstmt = connection.prepareStatement(sql)) {

	        pstmt.setInt(1, chatroomSeq);
	        pstmt.setInt(2, limit);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                MessageDTO msg = new MessageDTO();
	                msg.setSeq(rs.getInt("seq"));
	                msg.setChatroom_seq(rs.getInt("chatroom_seq"));
	                msg.setSender_Id(rs.getString("sender_id"));
	                msg.setContent(rs.getString("content"));
	                msg.setCreated_at(rs.getTimestamp("created_at"));
	                messages.add(msg);
	            }
	        }
	    }

	    // 최신순 DESC로 가져왔으므로 필요하면 List 뒤집기
	    Collections.reverse(messages); 
	    return messages;
	}

	
	
}
