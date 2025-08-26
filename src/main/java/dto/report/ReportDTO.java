package dto.report;

import java.sql.Timestamp;

public class ReportDTO {
	 private int seq;
	 private String reporterId;
	private String targetType; // "board, reply, user"
	private String targetSeq;  // 대상 PK (게시글seq, 댓글seq는 int, 유저id는 String이므로 String으로 통일)
	    private String reason;
	    private String status; // 'pending', 'reviewed', 'rejected'
	    private Timestamp createdAt;
	    private Timestamp processedAt;
	    private String processedBy; // 신고 처리한 관리자 ID (nullable)
}
