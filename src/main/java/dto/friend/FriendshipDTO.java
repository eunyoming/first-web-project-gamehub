package dto.friend;

import java.sql.Timestamp;

//friendships 테이블
public class FriendshipDTO {
 private int seq;
 private String userIdA;
 private String userIdB;
 private String status;
 private Timestamp createdAt;
 
 public FriendshipDTO(int seq, String userIdA, String userIdB, String status, Timestamp createdAt) {
	super();
	this.seq = seq;
	this.userIdA = userIdA;
	this.userIdB = userIdB;
	this.status = status;
	this.createdAt = createdAt;
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
public Timestamp getCreatedAt() {
	return createdAt;
}
public void setCreatedAt(Timestamp createdAt) {
	this.createdAt = createdAt;
}
}
