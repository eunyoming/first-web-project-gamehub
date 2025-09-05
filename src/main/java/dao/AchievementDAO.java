package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.game.AchievementDTO;

public class AchievementDAO {

	/*
	 * AchievementDTO, UserAchievementDTO 업적 정의, 사용자 업적 달성 기록 관리 DAO
	 * 
	 */

	private static AchievementDAO instance;

	private AchievementDAO() {
	}

	// getInstance
	public synchronized static AchievementDAO getInstance() {
		if (instance == null) {
			instance = new AchievementDAO();
		}
		return instance;
	}

	// getConnection
	public Connection getConnection() throws Exception {
		Context cxt = new InitialContext();

		DataSource ds = (DataSource) cxt.lookup("java:comp/env/jdbc/oracle");

		return ds.getConnection();
	}

	// UserAchievement 테이블에 이미 해당 업적이 있는지 확인
	public boolean hasUserUnlocked(String id, int achievSeq) throws Exception, Exception {

		String sql = "SELECT seq FROM UserAchievement WHERE ACHIEV_SEQ = ? and userid = ?";

		try (Connection conn = this.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql);

		) {
			pstmt.setInt(1, achievSeq);
			pstmt.setString(2, id);
			try (ResultSet rs = pstmt.executeQuery();) {
				return rs.next();
			}

		}

	}

	public AchievementDTO selectAchievementByID(String achievementId) throws Exception {
		String sql = "SELECT * FROM Achievement WHERE id = ?";
		try (Connection conn = this.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
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

	public boolean insertUserAchievement(String userId, int achiev_Seq, Timestamp unlocked_At) throws Exception {
		String sql = "INSERT INTO UserAchievement " + "(SEQ, USERID, ACHIEV_SEQ, ISEQUIP, UNLOCKED_AT) "
				+ "VALUES (USERACH_SEQ.NEXTVAL, ?, ?, default, ?)";

		try (Connection conn = this.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, userId);
			pstmt.setInt(2, achiev_Seq);
			pstmt.setTimestamp(3, unlocked_At); // java.sql.Timestamp

			if (pstmt.executeUpdate() > 0) {
				return true;
			} else {
				return false;
			}
		}

	}

	public int CountAchievementByGame_Seq(int game_seq) throws Exception {
		String sql = "select count(*) as totalAch from(select * from ACHIEVEMENT where game_seq = ?)";
		try (Connection conn = this.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, game_seq);

			try (ResultSet rs = pstmt.executeQuery()) {

				if (rs.next()) {
					return rs.getInt("totalAch");
				}

			}
		}
		return 0;
	}

	public int CountAchievementByGame_SeqAndLoginId(String loginId, int game_seq) throws Exception {
		String sql = "select count(*) as currentAch from(SELECT a.*\r\n" + "FROM achievement a\r\n"
				+ "JOIN userAchievement ua ON a.seq = ua.achiev_seq\r\n" + "WHERE ua.userId = ? AND a.game_seq = ?)";
		try (Connection conn = this.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, loginId);
			pstmt.setInt(2, game_seq);
			try (ResultSet rs = pstmt.executeQuery()) {

				if (rs.next()) {
					return rs.getInt("currentAch");
				}

			}
		}
		return 0;

	}
	
	public AchievementDTO equipAchievement(String userId, int achievSeq) throws Exception {
		AchievementDTO achiev = new AchievementDTO();

	    try (Connection conn = this.getConnection()) {
	        conn.setAutoCommit(false);

	        try (
	            PreparedStatement pstmt1 = conn.prepareStatement(
	                "UPDATE USERACHIEVEMENT SET ISEQUIP = 'N' WHERE USERID = ?"
	            );
	            PreparedStatement pstmt2 = conn.prepareStatement(
	                "UPDATE USERACHIEVEMENT SET ISEQUIP = 'Y' WHERE USERID = ? AND ACHIEV_SEQ = ?"
	            );
	            PreparedStatement pstmt3 = conn.prepareStatement(
	                "SELECT * FROM achievement a WHERE a.seq = ?"
	            )
	        ) {
	            // 1. 모든 칭호 해제
	            pstmt1.setString(1, userId);
	            pstmt1.executeUpdate();

	            // 2. 선택한 칭호 장착
	            pstmt2.setString(1, userId);
	            pstmt2.setInt(2, achievSeq);
	            pstmt2.executeUpdate();

	            // 3. 장착된 칭호 조회
	            pstmt3.setInt(1, achievSeq);
	            try (ResultSet rs = pstmt3.executeQuery()) {
	                if (rs.next()) {
	                	achiev.setId(rs.getString("id"));
						achiev.setTitle(rs.getString("title"));
						achiev.setDescription(rs.getString("description"));
						achiev.setIconUrl(rs.getString("icon_url"));
						achiev.setGameSeq(rs.getInt("game_seq"));
	                }
	            }

	            conn.commit();
	        } catch (Exception e) {
	            conn.rollback();
	            throw e;
	        }
	    }

	    return achiev;
	}
		
		
	
	
	public List<Map<String, Object>> selectUserAchievements(String userId) throws Exception {
	    String sql = 
	        "SELECT a.game_seq, g.title AS game_title, " +
	        "       a.title AS achievement_title, a.description, a.icon_url,ua.ISEQUIP as ISEQUIP, ua.ACHIEV_SEQ as achiev_seq , ua.unlocked_at " +
	        "FROM achievement a " +
	        "JOIN games g ON a.game_seq = g.seq " +
	        "LEFT JOIN userAchievement ua " +
	        "       ON a.seq = ua.achiev_seq AND ua.userId = ? " +
	        "ORDER BY a.game_seq, ua.unlocked_at DESC NULLS LAST";

	    try (Connection con = this.getConnection();
	         PreparedStatement pstat = con.prepareStatement(sql)) {
	        
	        pstat.setString(1, userId);
	        try (ResultSet rs = pstat.executeQuery()) {
	            List<Map<String, Object>> list = new ArrayList<>();
	            while (rs.next()) {
	                Map<String, Object> row = new HashMap<>();
	                row.put("gameSeq", rs.getInt("game_seq"));
	                row.put("gameTitle", rs.getString("game_title"));
	                row.put("achievementTitle", rs.getString("achievement_title"));
	                row.put("description", rs.getString("description"));
	                row.put("iconUrl", rs.getString("icon_url"));
	                row.put("unlockedAt", rs.getTimestamp("unlocked_at"));
	                row.put("achievSeq", rs.getInt("achiev_seq"));
	                row.put("isequip", rs.getString("ISEQUIP"));
	                list.add(row);
	            }
	            return list;
	        }
	    }
	}

}
