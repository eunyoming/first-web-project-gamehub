package dto.chat;

import java.sql.Timestamp;


public class ChatroomMemberDTO {
    private int chatroomSeq;
    private String userId;
    private Timestamp joinedAt;

    public int getChatroomSeq() {
        return chatroomSeq;
    }

    public void setChatroomSeq(int chatroomSeq) {
        this.chatroomSeq = chatroomSeq;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Timestamp getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(Timestamp joinedAt) {
        this.joinedAt = joinedAt;
    }
}
