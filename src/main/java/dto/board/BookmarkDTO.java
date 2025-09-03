package dto.board;

//bookmark 테이블
public class BookmarkDTO {
 private int seq;
 private String userId;
 private int board_seq;
 
 public BookmarkDTO(int seq, String userId, int board_seq) {
	this.seq = seq;
	this.userId = userId;
	this.board_seq = board_seq;
 }
 public BookmarkDTO() {
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
 public int getBoard_seq() {
	return board_seq;
 }
 public void setBoard_seq(int board_seq) {
	this.board_seq = board_seq;
 }

 
}