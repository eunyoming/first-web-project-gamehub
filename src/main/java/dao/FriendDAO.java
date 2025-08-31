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
	
	
	
	public  boolean requestFriend(String userA,String userB) throws Exception {
		 String sql = "INSERT INTO FRIENDSHIPS (SEQ, USERIDA, USERIDB, STATUS, CREATED_AT, UPDATED_AT) " +
                 "VALUES (FRIENDSHIP_SEQ.nextval, ?, ?, 'pending', SYSTIMESTAMP, SYSTIMESTAMP)";
		try(Connection con = this.getConnection();
				PreparedStatement pstmt = con.prepareStatement(sql); ){
				
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
	
	
	//
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
	
	// 내 친구 ID 목록만 반환
	public List<String> selectAllFriendIds(String userId) throws Exception {
	    String sql = "SELECT * FROM FRIENDSHIPS WHERE (userIDA = ? OR userIDB = ?) AND STATUS = 'accepted'";

	    List<String> friendIds = new ArrayList<>();
	    
	    try (Connection con = this.getConnection();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setString(1, userId);
	        pstmt.setString(2, userId);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                String userIdA = rs.getString("userIdA");
	                String userIdB = rs.getString("userIdB");

	                // 내 ID가 아니면 추가
	                String friendId = userId.equals(userIdA) ? userIdB : userIdA;
	                friendIds.add(friendId);
	            }
	        }
	    }
	    
	    return friendIds;
	}
	
	// 친구 요청 승낙 함수 
	public boolean acceptFriendship(String userIdA, String userIdB) throws Exception {
	    String sql = "UPDATE FRIENDSHIPS SET STATUS = 'accepted', UPDATED_AT = sysdate "
	               + "WHERE userIDA = ? AND userIDB = ? AND STATUS = 'pending'";

	    try (Connection con = this.getConnection();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setString(1, userIdA);
	        pstmt.setString(2, userIdB);

	        return pstmt.executeUpdate() > 0;
	    }
	}
	
	// 친구 요청 취소
	public boolean cancelFriendshipRequest(String userA, String userB) throws Exception {
	    String sql = "DELETE FROM FRIENDSHIPS WHERE userIDA = ? AND userIDB = ? AND STATUS = 'pending'";
	    
	    try (Connection con = this.getConnection();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setString(1, userA); // 요청을 보낸 사람 (나)
	        pstmt.setString(2, userB); // 요청을 받은 사람
	        
	        return pstmt.executeUpdate() > 0;
	    }
	}
	
	// 친구 삭제
	public boolean deleteFriendship(String userA, String userB) throws Exception {
	    String sql = "DELETE FROM FRIENDSHIPS WHERE (userIDA = ? AND userIDB = ? OR userIDA = ? AND userIDB = ?) AND STATUS = 'accepted'";
	    
	    try (Connection con = this.getConnection();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setString(1, userA); // 친구 삭제를 요청한 사람
	        pstmt.setString(2, userB); // 삭제 대상인 친구
	        pstmt.setString(3, userB); // 반대 경우 (친구 관계가 userB-userA로 저장된 경우)
	        pstmt.setString(4, userA); // 반대 경우
	        
	        return pstmt.executeUpdate() > 0;
	    }
	}
		
	

}
