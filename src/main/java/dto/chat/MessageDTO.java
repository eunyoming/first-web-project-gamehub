package dto.chat;

import java.sql.Timestamp;

import com.google.gson.annotations.SerializedName;

public class MessageDTO {
    private int seq;
    @SerializedName("sender_Id") 
    private String sender_Id;
    @SerializedName("chatroom_seq") 
    private int chatroom_seq;
    private String content;
    @SerializedName("created_at")
    private Timestamp created_at;
    // Getters and Setters
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getSender_Id() {
		return sender_Id;
	}
	public void setSender_Id(String sender_Id) {
		this.sender_Id = sender_Id;
	}
	public int getChatroom_seq() {
		return chatroom_seq;
	}
	public void setChatroom_seq(int chatroom_seq) {
		this.chatroom_seq = chatroom_seq;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Timestamp getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}
	
	public MessageDTO() {
		
	}
	
	
	public MessageDTO(int seq, String sender_Id, int chatroom_seq, String content, Timestamp created_at) {
		super();
		this.seq = seq;
		this.sender_Id = sender_Id;
		this.chatroom_seq = chatroom_seq;
		this.content = content;
		this.created_at = created_at;
	}
    
    
}