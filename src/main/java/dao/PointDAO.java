package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.point.PointDTO;

public class PointDAO {
	//PointDTO, PointLogsDTO ... 
	/*
	 * 포인트 유형 정의, 사용자 포인트 획득/사용 기록 관리 DAO

	 */
	private static PointDAO instance;

	public synchronized static PointDAO getInstance() {
		if(instance==null)
		{
			instance = new PointDAO();
		}	
		return instance;
	}
	


	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	
	public PointDTO selectPointBySeq(int seq) throws Exception {
		String sql = "select * from point where seq = ?";
		
		try ( Connection conn = getConnection();
	    		PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setInt(1, seq);
	        try (ResultSet rs = pstmt.executeQuery()) {
	        	if(rs.next()) {
	        		
	        		PointDTO dto = new PointDTO();
		        	dto.setSeq(rs.getInt("seq"));
		        	dto.setTitle(rs.getString("title"));
		        	dto.setDescription(rs.getString("description"));
		        	dto.setType(rs.getString("type"));
		        	dto.setValue(rs.getInt("value"));
		        	
		        	return dto;
	        	}else {
	        		return null;
	        	}
	        	
	        	
	        	
	        }
	      }
	}
	
	public int getCurrentPoints(String userId) throws Exception {
		String sql = "select point from members where id = ?";
		try ( Connection conn = getConnection();
	    		PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, userId);
	        try (ResultSet rs = pstmt.executeQuery()) {
	        	
	        	if(rs.next()) {
	        		return rs.getInt("point");
	        	}else {
	        		return 0;
	        	}
	        	
	        	}
	        }
		
	}
	
	public PointDTO selectPointByAchievementSeq( int achievementSeq) throws Exception {
	    String sql = "SELECT P.SEQ, P.TITLE, P.DESCRIPTION, P.TYPE, P.VALUE " +
	                 "FROM ACHIEVEMENT A " +
	                 "JOIN POINT P ON A.POINT_SEQ = P.SEQ " +
	                 "WHERE A.SEQ = ?";

	    try ( Connection conn = getConnection();
	    		PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setLong(1, achievementSeq);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                PointDTO dto = new PointDTO();
	                dto.setSeq(rs.getInt("SEQ"));
	                dto.setTitle(rs.getString("TITLE"));
	                dto.setDescription(rs.getString("DESCRIPTION"));
	                dto.setType(rs.getString("TYPE"));
	                dto.setValue(rs.getInt("VALUE"));
	                return dto;
	            }
	        }
	    }
	    return null;
	}

	
	
	//한 회원에게 포인트 지급 순서대로 아이디, 포인트, 설명, 타입코드
	public void addPoint(String userId, int points, String description, String typeCode) throws Exception{
	    String updateMemberSql = "UPDATE members SET point = point + ? WHERE id = ?";
	    String insertLogSql = "INSERT INTO point_logs (seq, userid, type_code, value, description, created_at) " +
	                          "VALUES (point_logs_seq.nextval, ?, ?, ?, ?, SYSTIMESTAMP)";

	    try (Connection conn = getConnection()) {
	        conn.setAutoCommit(false);

	        try (PreparedStatement pstmtUpdate = conn.prepareStatement(updateMemberSql);
	             PreparedStatement pstmtLog = conn.prepareStatement(insertLogSql)) {

	            // 1) member 테이블 포인트 업데이트
	            pstmtUpdate.setInt(1, points);
	            pstmtUpdate.setString(2, userId);
	            pstmtUpdate.executeUpdate();

	            // 2) point_logs 기록
	            pstmtLog.setString(1, userId);
	            pstmtLog.setString(2, typeCode);
	            pstmtLog.setInt(3, points);
	            pstmtLog.setString(4, description);
	            pstmtLog.executeUpdate();

	            conn.commit();
	        } catch (Exception e) {
	            conn.rollback();
	            throw e;
	        } finally {
	            conn.setAutoCommit(true);
	        }
	    }
	}
	
	//여러 회원들에게 포인트 지급
	public void addPointsWithLogUsers(String[] ids, int points,String typeCode, String description)  throws Exception{
	    String updateMemberSql = "UPDATE members SET point = point + ? WHERE id = ?";
	    String insertLogSql = "INSERT INTO point_logs (seq, userid, type_code, value, description, created_at) " +
	                          "VALUES (point_logs_seq.nextval, ?, ?, ?, ?, SYSTIMESTAMP)";


	    try (Connection conn = getConnection()) {
	        conn.setAutoCommit(false); // 트랜잭션 시작

	        try (PreparedStatement pstmtUpdate = conn.prepareStatement(updateMemberSql);
	             PreparedStatement pstmtLog = conn.prepareStatement(insertLogSql)) {

	            for (String id : ids) {
	                // 1) member 테이블 포인트 업데이트
	                pstmtUpdate.setInt(1, points);
	                pstmtUpdate.setString(2, id);
	                pstmtUpdate.addBatch();

	                // 2) point_logs 기록
	                pstmtLog.setString(1, id);
	                pstmtLog.setString(2, typeCode);
	                pstmtLog.setInt(3, points);
	                pstmtLog.setString(4, description);
	                pstmtLog.addBatch();
	            }

	            pstmtUpdate.executeBatch();
	            pstmtLog.executeBatch();

	            conn.commit();
	        } catch (Exception e) {
	            conn.rollback();
	            throw e;
	        } finally {
	            conn.setAutoCommit(true);
	        }
	    } 
	}
	
	
}
