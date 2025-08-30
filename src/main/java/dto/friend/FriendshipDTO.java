package dto.friend;

import java.sql.Timestamp;

//friendships 테이블
public class FriendshipDTO {
 private int seq;
 private String userIdA;
 private String userIdB;
 private String status;
 private Timestamp created_at;
 private Timestamp updated_at;
 
 public FriendshipDTO() {};

 
 public FriendshipDTO(int seq, String userIdA, String userIdB, String status, Timestamp createdAt, Timestamp updatedAt) {
	super();
	this.seq = seq;
	this.userIdA = userIdA;
	this.userIdB = userIdB;
	this.status = status;
	this.created_at = createdAt;
	this.updated_at = updatedAt;
}
	// Getters and Setters
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getUserIdA() {
		return userIdA;
	}
	public void setUserIdA(String userIdA) {
		this.userIdA = userIdA;
	}
	public String getUserIdB() {
		return userIdB;
	}
	public void setUserIdB(String userIdB) {
		this.userIdB = userIdB;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}


	public Timestamp getCreated_at() {
		return created_at;
	}


	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}


	public Timestamp getUpdated_at() {
		return updated_at;
	}


	public void setUpdated_at(Timestamp updated_at) {
		this.updated_at = updated_at;
	}
	
}
