package dao;

import java.nio.channels.SelectableChannel;
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
			        Timestamp updatedAt = rs.getTimestamp("created_at");
					FriendshipDTO friendshipDTO = new FriendshipDTO(seq, userIdA, userIdB, status, createdAt, updatedAt);
					friendRequestsList.add(friendshipDTO);
					
					
					}
				return friendRequestsList;
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
			        Timestamp updatedAt = rs.getTimestamp("created_at");
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
			        Timestamp updatedAt = rs.getTimestamp("created_at");
					FriendshipDTO friendshipDTO = new FriendshipDTO(seq, userIdA, userIdB, status, createdAt, updatedAt);
					friendRequestsList.add(friendshipDTO);
					
					
					}
				return friendRequestsList;
				}
				
			}
	}
		
	

}
