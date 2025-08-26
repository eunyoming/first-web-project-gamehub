package dto.point;

import java.sql.Timestamp;

public class PointLogDTO {
	 private int seq;
	    private String userId;
	    private String typeCode; // ref: point.type
	    private int value; // 양수: 획득 / 음수: 사용
	    private String description;
	    private Timestamp createdAt;

	    // Default constructor
	    public PointLogDTO() {}

	    // Constructor with all fields
	    public PointLogDTO(int seq, String userId, String typeCode, int value, String description, Timestamp createdAt) {
	        this.seq = seq;
	        this.userId = userId;
	        this.typeCode = typeCode;
	        this.value = value;
	        this.description = description;
	        this.createdAt = createdAt;
	    }

	    // Getters and Setters
	    public int getSeq() { return seq; }
	    public void setSeq(int seq) { this.seq = seq; }
	    public String getUserId() { return userId; }
	    public void setUserId(String userId) { this.userId = userId; }
	    public String getTypeCode() { return typeCode; }
	    public void setTypeCode(String typeCode) { this.typeCode = typeCode; }
	    public int getValue() { return value; }
	    public void setValue(int value) { this.value = value; }
	    public String getDescription() { return description; }
	    public void setDescription(String description) { this.description = description; }
	    public Timestamp getCreatedAt() { return createdAt; }
	    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
