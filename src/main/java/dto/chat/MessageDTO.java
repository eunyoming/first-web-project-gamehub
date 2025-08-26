package dto.chat;

import java.sql.Timestamp;

public class MessageDTO {
    private int seq;
    private String senderId;
    private String receiverId;
    private int chatroom_seq;
    private String content;
    private Timestamp sentAt;
    // Getters and Setters
}