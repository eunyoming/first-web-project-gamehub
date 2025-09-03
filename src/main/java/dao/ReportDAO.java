package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.member.BannedUserDTO;
import dto.report.ReportDTO;

public class ReportDAO {
	private static ReportDAO instance;

	
	// getInstance
	public synchronized static ReportDAO getInstance() {
		if(instance == null) {
			instance = new ReportDAO();
		}
		return instance;
	}

	// getConnection
	public Connection getConnection() throws Exception{
		Context cxt = new InitialContext();

		DataSource ds = (DataSource)cxt.lookup("java:comp/env/jdbc/oracle");

		return ds.getConnection();
	}
	
	
	//신고 들어오게
	
	public boolean insertReports(String reporterId,String targetId, String targetType, String tartget_seq, String reason) throws Exception {
		String sql = "insert into reports "
				+ "(seq,reporterId, targetType, target_seq, reason,status, created_at,TARGETUSER  ) "
				+ "values(reports_seq.nextval,?, ?, ?, ?, 'pending' ,sysdate,? )";
		
		try(	Connection conn =  getConnection();
				PreparedStatement pstmt= conn.prepareStatement(sql);){
				
			pstmt.setString(1, reporterId);
			pstmt.setString(2, targetType);
			pstmt.setString(3, tartget_seq);
			pstmt.setString(4, reason);
			pstmt.setString(5, targetId);
			
			return pstmt.executeUpdate() > 0;
		}
				
	}
	
	public Date getLatestBannedUntil(String userId) throws Exception {
		String sql = 
		        "SELECT PROCEED_BANNED_UNTIL " +
		        "FROM ( " +
		        "    SELECT PROCEED_BANNED_UNTIL " +
		        "    FROM reports " +
		        "    WHERE TARGETUSER = ? AND STATUS = 'processed' " +
		        "    ORDER BY PROCESSED_AT DESC " +
		        ") " +
		        "WHERE ROWNUM = 1";
		  try (Connection con = getConnection();
			         PreparedStatement pstat = con.prepareStatement(sql)) {
			        pstat.setString(1, userId);
			        try (ResultSet rs = pstat.executeQuery()) {
			            if (rs.next()) {
			                return rs.getTimestamp("PROCEED_BANNED_UNTIL");
			            } else {
			                return null;
			            }
			        }
			    }
	}
	
	
	public List<ReportDTO> selectAllReportsNoneProcessed() throws Exception{
		List<ReportDTO> result = new ArrayList<ReportDTO>();
		String sql = "SELECT SEQ, REPORTERID, TARGETTYPE, TARGET_SEQ, REASON, STATUS, "
                + "CREATED_AT "
                + "FROM REPORTS " // 테이블 이름 맞게 수정
                + "WHERE PROCESSED_AT IS NULL "
                + "ORDER BY CREATED_AT DESC";
		
		try(	Connection conn =  getConnection();
				PreparedStatement pstmt= conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery();
				){
			while(rs.next()) {
				ReportDTO dto = new ReportDTO();
				 dto.setSeq(rs.getInt("SEQ"));
	                dto.setReporterId(rs.getString("REPORTERID"));
	                dto.setTargetType(rs.getString("TARGETTYPE"));
	                dto.setTargetSeq(rs.getString("TARGET_SEQ"));
	                dto.setReason(rs.getString("REASON"));
	                dto.setStatus(rs.getString("STATUS"));
	                dto.setCreatedAt(rs.getTimestamp("CREATED_AT"));
	                
	                result.add(dto);

			}
			return result;
		
		}

	}
	
	
	public boolean rejectReport(String managerID,int seq,String rejectReason ) throws Exception {
		
		String sql = "UPDATE reports SET status = 'rejected',"
				+ " rejectReason = ?, processed_at = SYSTIMESTAMP, "
				+ "processed_by = ? WHERE seq = ?";
		
		try(	Connection conn =  getConnection();
				PreparedStatement pstmt= conn.prepareStatement(sql);){
			
			
			pstmt.setString(1, rejectReason);
			pstmt.setString(2, managerID);
			pstmt.setInt(3, seq);
			
			return pstmt.executeUpdate() > 0;
			
		}
		
	}
	
	 // 1. 신고 대상 찾기
    public ReportDTO findReportTarget(int reportSeq) throws Exception {
        String sql = "SELECT targetType, target_seq FROM reports WHERE seq = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reportSeq);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ReportDTO dto = new ReportDTO();
                    dto.setTargetType(rs.getString("targettype"));
                    dto.setTargetSeq(rs.getString("target_seq"));
                    return dto;
                }
            }
        }
        return null;
    }
    
 // 2. 신고 대상 유저 찾기
    public String findTargetUserId(String targetType, String targetSeq) throws Exception {
        String sql = null;

        if ("Board".equalsIgnoreCase(targetType)) {
            sql = "SELECT writer FROM boards WHERE seq = ?";
        } else if ("Reply".equalsIgnoreCase(targetType)) {
            sql = "SELECT writer FROM replies WHERE seq = ?";
        } else if ("User".equalsIgnoreCase(targetType)) {
            return targetSeq; // 이미 userId 그대로 저장된 경우
        }

        if (sql != null) {
            try (Connection conn = getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, targetSeq);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) return rs.getString("writer");
                }
            }
        }
        return null;
    }
    
 // 3. 유저 차단
    public void banUser(String userId) throws Exception {
        String sql = "UPDATE Role SET category = 'Banned', updated_at = CURRENT_DATE WHERE ID = ? AND category = 'User'";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.executeUpdate();
        }
    }

	
	//4유저 숨기기
	 public void hideContent(String targetType, String targetSeq) throws Exception {
	        String sql = null;
	        if ("Board".equalsIgnoreCase(targetType)) {
	            sql = "UPDATE boards SET VISIBILITY = 'private' WHERE seq = ?";
	        } else if ("Reply".equalsIgnoreCase(targetType)) {
	            sql = "UPDATE replies SET VISIBILITY = 'private' WHERE seq = ?";
	        }

	        if (sql != null) {
	            try (Connection conn = getConnection();
	                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
	                pstmt.setString(1, targetSeq);
	                pstmt.executeUpdate();
	            }
	        }
	    }
	 
	 // 5. Report 상태 갱신
	    public void updateReportStatus(int reportSeq, String adminId,String proceedReason, int bannedDays) throws Exception {
	        String sql = "UPDATE reports SET status = 'processed', processed_at = SYSTIMESTAMP, processed_by = ?, PROCEEDREASON=?,proceed_banned_until = SYSTIMESTAMP + ? * INTERVAL '1' DAY\r\n"
	        		+ "  WHERE seq = ?";
	        try (Connection conn = getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {
	            pstmt.setString(1, adminId);
	            pstmt.setString(2,proceedReason);
	            pstmt.setInt(3, bannedDays);
	            pstmt.setInt(4, reportSeq);
	            pstmt.executeUpdate();
	        }
	    }
	
	    public List<BannedUserDTO> selectBannedUser() throws Exception {
	    	String sql = 
	    		    "SELECT r.id,\r\n"
	    		    + "       rp.proceed_banned_until AS banned_until,\r\n"
	    		    + "       rp.proceedreason AS banned_reason\r\n"
	    		    + "FROM role r\r\n"
	    		    + "JOIN (\r\n"
	    		    + "    SELECT TARGETUSER,\r\n"
	    		    + "           PROCEED_BANNED_UNTIL,\r\n"
	    		    + "           PROCEEDREASON\r\n"
	    		    + "    FROM (\r\n"
	    		    + "        SELECT TARGETUSER,\r\n"
	    		    + "               PROCEED_BANNED_UNTIL,\r\n"
	    		    + "               PROCEEDREASON,\r\n"
	    		    + "               ROW_NUMBER() OVER (PARTITION BY TARGETUSER ORDER BY PROCESSED_AT DESC) AS rn\r\n"
	    		    + "        FROM reports\r\n"
	    		    + "        WHERE STATUS = 'processed'\r\n"
	    		    + "    )\r\n"
	    		    + "    WHERE rn = 1\r\n"
	    		    + ") rp\r\n"
	    		    + "ON r.id = rp.TARGETUSER\r\n"
	    		    + "WHERE r.CATEGORY = 'Banned'";

	        List<BannedUserDTO> list = new ArrayList<>();
	        try (Connection con = this.getConnection();
	             PreparedStatement pstat = con.prepareStatement(sql);
	             ResultSet rs = pstat.executeQuery()) {

	            while (rs.next()) {
	                BannedUserDTO dto = new BannedUserDTO();
	                dto.setId(rs.getString("id"));
	                dto.setBannedUntil(rs.getTimestamp("banned_until")); // proceed_banned_until
	                dto.setBannedReason(rs.getString("banned_reason"));
	                list.add(dto);
	            }
	        }
	        return list;
	    }
}
