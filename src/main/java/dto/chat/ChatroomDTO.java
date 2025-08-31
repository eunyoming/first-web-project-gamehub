package dto.chat;

import java.sql.Timestamp;
import java.util.List;

public class ChatroomDTO {
    private int seq;
    private String name;
    private String type; // direct, group, guild...
    private Timestamp createdAt;

    // 필요하다면 채팅방 멤버, 최근 메시지 등도 포함 가능
    private List<ChatroomMemberDTO> members;
    private MessageDTO lastMessage;

    public int getSeq() {
        return seq;
    }

    public void setSeq(int seq) {
        this.seq = seq;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<ChatroomMemberDTO> getMembers() {
        return members;
    }

    public void setMembers(List<ChatroomMemberDTO> members) {
        this.members = members;
    }

    public MessageDTO getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(MessageDTO lastMessage) {
        this.lastMessage = lastMessage;
    }
}
