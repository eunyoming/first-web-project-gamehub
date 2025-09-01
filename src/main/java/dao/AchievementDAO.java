package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.game.AchievementDTO;
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
		public boolean hasUserUnlocked(String id, int achievSeq ) throws Exception, Exception {
			
			String sql = "SELECT seq FROM UserAchievement WHERE ACHIEV_SEQ = ? and userid = ?";
			
			try(	Connection conn = this.getConnection();
					PreparedStatement pstmt = conn.prepareStatement(sql);
					
					){
					pstmt.setInt(1, achievSeq );
					pstmt.setString(2, id);
				try(ResultSet rs = pstmt.executeQuery();){
					return rs.next();
				}
					
					
					
			}
			
		
		}
		
		
		public AchievementDTO selectAchievementByID(String achievementId) throws Exception {
		    String sql = "SELECT * FROM Achievement WHERE id = ?";
		    try (Connection conn = this.getConnection();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {
		        pstmt.setString(1, achievementId);

		        try (ResultSet rs = pstmt.executeQuery()) {
		            AchievementDTO achiev = null;
		            if (rs.next()) {
		                achiev = new AchievementDTO();
		                achiev.setSeq(rs.getInt("seq"));
		                achiev.setId(rs.getString("id"));
		                achiev.setTitle(rs.getString("title"));
		                achiev.setDescription(rs.getString("description"));
		                achiev.setIconUrl(rs.getString("icon_url"));
		                achiev.setGameSeq(rs.getInt("game_seq"));
		                achiev.setPointSeq(rs.getInt("point_seq"));
		            }
		            return achiev;
		        }
		    }
		}

		
		public boolean insertUserAchievement(String userId,int achiev_Seq, Timestamp unlocked_At ) throws Exception {
			String sql = "INSERT INTO UserAchievement " +
	                 "(SEQ, USERID, ACHIEV_SEQ, ISEQUIP, UNLOCKED_AT) " +
	                 "VALUES (USERACH_SEQ.NEXTVAL, ?, ?, default, ?)";
	    
	    try (Connection conn = this.getConnection();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, userId);
	        pstmt.setInt(2, achiev_Seq);
	        pstmt.setTimestamp(3,unlocked_At ); // java.sql.Timestamp
	        
	        if(pstmt.executeUpdate() >0) {
	        	return true;
	        }else {
	        	return false;
	        }
	    }
			
		
		}
		
		
}
