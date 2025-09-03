package dto.notification;

import java.sql.Timestamp;

public class NotificationDTO {
	private int seq;
    private String userId;
    private String type;
    private String message;
    private String isRead;
    private Timestamp created_At;
    private String related_userId;
    private String related_objectId;
    
	public NotificationDTO(int seq, String userId, String type, String message, String isRead, Timestamp created_At,
			String related_userId, String related_objectId) {
		super();
		this.seq = seq;
		this.userId = userId;
		this.type = type;
		this.message = message;
		this.isRead = isRead;
		this.created_At = created_At;
		this.related_userId = related_userId;
		this.related_objectId = related_objectId;
	}
	
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getIsRead() {
		return isRead;
	}
	public void setIsRead(String isRead) {
		this.isRead = isRead;
	}
	public Timestamp getCreated_At() {
		return created_At;
	}
	public void setCreated_At(Timestamp created_At) {
		this.created_At = created_At;
	}
	public String getRelated_userId() {
		return related_userId;
	}
	public void setRelated_userId(String related_userId) {
		this.related_userId = related_userId;
	}
	public String getRelated_objectId() {
		return related_objectId;
	}
	public void setRelated_objectId(String related_objectId) {
		this.related_objectId = related_objectId;
	}
    
    
}
