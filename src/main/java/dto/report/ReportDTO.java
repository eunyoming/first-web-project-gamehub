package dto.report;

import java.sql.Timestamp;

public class ReportDTO {
	 private int seq;
	 private String reporterId;
	private String targetType; // "board, reply, user"
	private String targetSeq;  // 대상 PK (게시글seq, 댓글seq는 int, 유저id는 String이므로 String으로 통일)
	    private String reason;
	    private String rejectReason;
	    private String proceedReason;
	    private String status; // 'pending', 'reviewed', 'rejected'
	    private Timestamp createdAt;
	    private Timestamp processedAt;
	    private String processedBy; // 신고 처리한 관리자 ID (nullable)
		public int getSeq() {
			return seq;
		}
		public void setSeq(int seq) {
			this.seq = seq;
		}
		public String getReporterId() {
			return reporterId;
		}
		public void setReporterId(String reporterId) {
			this.reporterId = reporterId;
		}
		public String getTargetType() {
			return targetType;
		}
		public void setTargetType(String targetType) {
			this.targetType = targetType;
		}
		public String getTargetSeq() {
			return targetSeq;
		}
		public void setTargetSeq(String targetSeq) {
			this.targetSeq = targetSeq;
		}
		public String getReason() {
			return reason;
		}
		public void setReason(String reason) {
			this.reason = reason;
		}
		public String getStatus() {
			return status;
		}
		public void setStatus(String status) {
			this.status = status;
		}
		public Timestamp getCreatedAt() {
			return createdAt;
		}
		public void setCreatedAt(Timestamp createdAt) {
			this.createdAt = createdAt;
		}
		public Timestamp getProcessedAt() {
			return processedAt;
		}
		public void setProcessedAt(Timestamp processedAt) {
			this.processedAt = processedAt;
		}
		public String getProcessedBy() {
			return processedBy;
		}
		public void setProcessedBy(String processedBy) {
			this.processedBy = processedBy;
		}
		
		
		public String getRejectReason() {
			return rejectReason;
		}
		public void setRejectReason(String rejectReason) {
			this.rejectReason = rejectReason;
		}
		
		public String getProceedReason() {
			return proceedReason;
		}
		public void setProceedReason(String proceedReason) {
			this.proceedReason = proceedReason;
		}
		public ReportDTO(int seq, String reporterId, String targetType, String targetSeq, String reason, String status,
				Timestamp createdAt, Timestamp processedAt, String processedBy) {
			super();
			this.seq = seq;
			this.reporterId = reporterId;
			this.targetType = targetType;
			this.targetSeq = targetSeq;
			this.reason = reason;
			this.status = status;
			this.createdAt = createdAt;
			this.processedAt = processedAt;
			this.processedBy = processedBy;
		}
	    
		public ReportDTO() {
			
		}
	    
}
