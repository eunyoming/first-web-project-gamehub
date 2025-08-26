package dto.notification;

import java.security.Timestamp;

public class NotificationDTO {
	private int seq;
    private String userId;
    private String related_userId;
    private String type;
    private String content;
    private String isRead;
    private Timestamp createdAt;
}
