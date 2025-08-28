package dto.board;

import java.sql.Timestamp;

//replys 테이블
public class ReplyDTO {
	private int seq;
	private String writer;
	private String contents;
	private int board_seq;
	private Timestamp created_at;
	// Getters and Setters
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public int getBoard_seq() {
		return board_seq;
	}
	public void setBoard_seq(int board_seq) {
		this.board_seq = board_seq;
	}
	public Timestamp getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}
	public ReplyDTO(int seq, String writer, String contents, int board_seq, Timestamp created_at) {
		super();
		this.seq = seq;
		this.writer = writer;
		this.contents = contents;
		this.board_seq = board_seq;
		this.created_at = created_at;
	}
	
}