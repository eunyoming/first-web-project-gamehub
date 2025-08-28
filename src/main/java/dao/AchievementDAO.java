package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.game.UserAchievementDTO;

public class AchievementDAO {

	/*
	 * AchievementDTO, UserAchievementDTO
	 * 업적 정의, 사용자 업적 달성 기록 관리 DAO
	 * 
	 */
	
	private static AchievementDAO instance;

	private AchievementDAO() {}

	// getInstance
	public synchronized static AchievementDAO getInstance() {
		if(instance == null) {
			instance = new AchievementDAO();
		}
		return instance;
	}
	
	
	// getConnection
		public Connection getConnection() throws Exception{
			Context cxt = new InitialContext();

			DataSource ds = (DataSource)cxt.lookup("java:comp/env/jdbc/oracle");

			return ds.getConnection();
		}
		
		
		//UserAchievement 테이블에 이미 해당 업적이 있는지 확인
		public boolean hasUserUnlocked(String id, String achievID ) throws Exception, Exception {
			
			String sql = "SELECT seq FROM achiev WHERE id = 'ACH_FIRST_KILL' and userid = ?";
			
			try(	Connection conn = this.getConnection();
					PreparedStatement pstmt = conn.prepareStatement(sql);
					ResultSet rs = pstmt.executeQuery();
					){
					
					
					return rs.next();
			}
			
		
		}
		
		public boolean insertUserAchievement(UserAchievementDTO userAchievDto) throws Exception {
			String sql = "INSERT INTO UserAchievement " +
	                 "(SEQ, USERID, ACHIEV_SEQ, ISEQUIP, UNLOCKED_AT) " +
	                 "VALUES (USERACH_SEQ.NEXTVAL, ?, ?, ?, ?)";
	    
	    try (PreparedStatement pstmt = this.getConnection().prepareStatement(sql)) {
	        pstmt.setString(1, userAchievDto.getUserId());
	        pstmt.setInt(2, userAchievDto.getSeq());
	        pstmt.setString(3, userAchievDto.getIsEquip());  // Y/N
	        pstmt.setTimestamp(4, userAchievDto.getUnlocked_At()); // java.sql.Timestamp
	        
	        if(pstmt.executeUpdate() >0) {
	        	return true;
	        }else {
	        	return false;
	        }
	    }
			
		
		}
		
		
}
