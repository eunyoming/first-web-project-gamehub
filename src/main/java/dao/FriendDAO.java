package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.friend.FriendshipDTO;

public class FriendDAO {
	
	private static FriendDAO instance;

	public synchronized static FriendDAO getInstance() {
		if (instance == null) {
			instance = new FriendDAO();
		}
		return instance;
	}

	public Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	public enum FriendshipStatus {
	    FRIEND,         // 이미 친구
	    REQUEST_SENT,   // 내가 요청 보낸 상태
	    REQUEST_RECEIVED, // 상대방이 나에게 요청 보낸 상태
	    NONE            // 아무 관계도 아님
	}
	
	
	
    // 친구 요청 보내기
    public boolean requestFriend(String userA, String userB) throws Exception {
        if (checkFriendshipStatus(userA, userB) != FriendshipStatus.NONE) return false;

        String sql = "INSERT INTO FRIENDSHIPS (SEQ, USERIDA, USERIDB, STATUS, CREATED_AT, UPDATED_AT) " +
                     "VALUES (FRIENDSHIP_SEQ.nextval, ?, ?, 'pending', SYSTIMESTAMP, SYSTIMESTAMP)";
        try (Connection con = this.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, userA);
            pstmt.setString(2, userB);
            return pstmt.executeUpdate() > 0;
        }
    }
	
	//내가 보낸 요청 전부 확인해서 반환
	public List<FriendshipDTO> selectFriendShipRequestsByID(String userId) throws Exception{
		String sql = "SELECT *  FROM FRIENDSHIPS WHERE userIDA = ? AND STATUS = 'pending'";
		List<FriendshipDTO> friendRequestsList = new ArrayList<>();
		try(Connection con = this.getConnection();
				PreparedStatement pstmt = con.prepareStatement(sql); ){
			
				pstmt.setString(1, userId);
			try(	
					ResultSet rs = pstmt.executeQuery();
					
					){
				while(rs.next()) {
					
					int seq = rs.getInt("seq");
					String userIdA = rs.getString("userIdA");
					String userIdB = rs.getString("userIdB");
					String status = rs.getString("status");
			        Timestamp createdAt = rs.getTimestamp("created_at");
			        Timestamp updatedAt =rs.getTimestamp("updated_at");
					FriendshipDTO friendshipDTO = new FriendshipDTO(seq, userIdA, userIdB, status, createdAt, updatedAt);
					friendRequestsList.add(friendshipDTO);
					
					
					}
				return friendRequestsList;
				}
				
			}
			
			
		}
	
	
	
	
	//친구 테이블에 내 요청 이력이 있는지 확인
	public FriendshipDTO selectFriendShipByID(String userId) throws Exception{
		String sql = "SELECT *  FROM FRIENDSHIPS WHERE userIDA = ? or userIDB = ?";
		
		try(Connection con = this.getConnection();
				PreparedStatement pstmt = con.prepareStatement(sql); ){
			
				pstmt.setString(1, userId);

			try(	
					ResultSet rs = pstmt.executeQuery();
					
					){
				
				if(rs.next()) {
					int seq = rs.getInt("seq");
					String userIdA = rs.getString("userIdA");
					String userIdB = rs.getString("userIdB");
					String status = rs.getString("status");
			        Timestamp createdAt = rs.getTimestamp("created_at");
			        Timestamp updatedAt = rs.getTimestamp("updated_at");
			        
			        return new FriendshipDTO(seq, userIdA, userIdB, status, createdAt, updatedAt);
				}else {
					return null;
				}
				
				}
				
			}
			
			
		}
	
	
	//이미 요청을 보낸 적이 있는지 확인
	public boolean isAlreadyRequested(String userIDA, String userIDB) throws Exception{
	String sql = "SELECT *  FROM FRIENDSHIPS WHERE userIDA = ? or userIDB = ?";
	
	try(Connection con = this.getConnection();
			PreparedStatement pstmt = con.prepareStatement(sql); ){
		
			pstmt.setString(1, userIDA);
			pstmt.setString(2, userIDB);

		try(	
				ResultSet rs = pstmt.executeQuery();
				
				){			
					return rs.next();
				}
			
			
			}
			
		}
		
		
	
	
	//내게 온 친구 요청 전부 반환
	public List<FriendshipDTO> selectFriendShipResponsesByID(String userId) throws Exception{
		String sql = "SELECT *  FROM FRIENDSHIPS WHERE userIDB = ? AND STATUS = 'pending'";
		List<FriendshipDTO> friendRequestsList = new ArrayList<>();
		try(Connection con = this.getConnection();
				PreparedStatement pstmt = con.prepareStatement(sql); ){
			
				pstmt.setString(1, userId);
			try(	
					ResultSet rs = pstmt.executeQuery();
					
					){
				while(rs.next()) {
					
					int seq = rs.getInt("seq");
					String userIdA = rs.getString("userIdA");
					String userIdB = rs.getString("userIdB");
					String status = rs.getString("status");
			        Timestamp createdAt = rs.getTimestamp("created_at");
			        Timestamp updatedAt = rs.getTimestamp("updated_at");
					FriendshipDTO friendshipDTO = new FriendshipDTO(seq, userIdA, userIdB, status, createdAt, updatedAt);
					friendRequestsList.add(friendshipDTO);
					
					
					}
				return friendRequestsList;
				}
				
			}
			
			
		}
	
	//친구 목록 확인
	
	public List<FriendshipDTO> selectAllMyFriendships(String userId) throws Exception{
		String sql = "SELECT * FROM FRIENDSHIPS WHERE (userIDA = ? OR userIDB = ?) AND STATUS = 'accepted'";

		List<FriendshipDTO> friendRequestsList = new ArrayList<>();
		try(Connection con = this.getConnection();
				PreparedStatement pstmt = con.prepareStatement(sql); ){
			
				pstmt.setString(1, userId);
				pstmt.setString(2, userId);
			try(	
					ResultSet rs = pstmt.executeQuery();
					
					){
				while(rs.next()) {
					
					int seq = rs.getInt("seq");
					String userIdA = rs.getString("userIdA");
					String userIdB = rs.getString("userIdB");
					String status = rs.getString("status");
			        Timestamp createdAt = rs.getTimestamp("created_at");
			        Timestamp updatedAt = rs.getTimestamp("updated_at");
					FriendshipDTO friendshipDTO = new FriendshipDTO(seq, userIdA, userIdB, status, createdAt, updatedAt);
					friendRequestsList.add(friendshipDTO);
					
					
					}
				return friendRequestsList;
				}
				
			}
	}
	
	// 친구 목록 조회
    public List<String> getAllFriendIds(String userId) throws Exception {
        String sql = "SELECT userIDA, userIDB FROM FRIENDSHIPS " +
                     "WHERE (userIDA = ? OR userIDB = ?) AND STATUS = 'accepted'";
        List<String> friends = new ArrayList<>();

        try (Connection con = this.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String a = rs.getString("userIDA");
                    String b = rs.getString("userIDB");
                    friends.add(userId.equals(a) ? b : a);
                }
            }
        }
        return friends;
    }
	

	 // 친구 요청 수락
    public boolean acceptFriendship(String userA, String userB) throws Exception {
        String sql = "UPDATE FRIENDSHIPS SET STATUS = 'accepted', UPDATED_AT = SYSTIMESTAMP " +
                     "WHERE userIDA = ? AND userIDB = ? AND STATUS = 'pending'";
        try (Connection con = this.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, userA);
            pstmt.setString(2, userB);
            return pstmt.executeUpdate() > 0;
        }
    }
	
    // 친구 요청 취소 / 삭제
    public boolean cancelOrDeleteFriendship(String userA, String userB) throws Exception {
        String sql = "DELETE FROM FRIENDSHIPS " +
                     "WHERE (userIDA = ? AND userIDB = ?) OR (userIDA = ? AND userIDB = ?)";
        try (Connection con = this.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, userA);
            pstmt.setString(2, userB);
            pstmt.setString(3, userB);
            pstmt.setString(4, userA);
            return pstmt.executeUpdate() > 0;
        }
    }
	
		
	
	public FriendshipStatus checkFriendshipStatus(String myId, String otherId) throws Exception {
	    String sql = "SELECT * FROM FRIENDSHIPS " +
	                 "WHERE (userIDA = ? AND userIDB = ?) OR (userIDA = ? AND userIDB = ?)";
	    
	    try (Connection con = this.getConnection();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setString(1, myId);
	        pstmt.setString(2, otherId);
	        pstmt.setString(3, otherId);
	        pstmt.setString(4, myId);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                String status = rs.getString("status");
	                String userIdA = rs.getString("userIdA");
	                String userIdB = rs.getString("userIdB");

	                if ("accepted".equalsIgnoreCase(status)) {
	                    return FriendshipStatus.FRIEND;
	                } else if ("pending".equalsIgnoreCase(status)) {
	                    if (myId.equals(userIdA) && otherId.equals(userIdB)) {
	                        return FriendshipStatus.REQUEST_SENT;
	                    } else if (myId.equals(userIdB) && otherId.equals(userIdA)) {
	                        return FriendshipStatus.REQUEST_RECEIVED;
	                    }
	                }
	            }
	        }
	    }

	    return FriendshipStatus.NONE;
	}

	

}
