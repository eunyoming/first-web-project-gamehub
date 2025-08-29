package dto.board;

import java.sql.Timestamp;

//replys 테이블
public class ReplyDTO {
	private int seq = 0;
	private String writer;
	private String contents;
	private int likeCount = 0;
	private int board_seq = 0;
	private int parent_seq = 0;
	private String path;
	private String visibility;
	private Timestamp created_at;
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
	public int getLikeCount() {
		return likeCount;
	}
	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	public int getBoard_seq() {
		return board_seq;
	}
	public void setBoard_seq(int board_seq) {
		this.board_seq = board_seq;
	}
	public int getParent_seq() {
		return parent_seq;
	}
	public void setParent_seq(int parent_seq) {
		this.parent_seq = parent_seq;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getVisibility() {
		return visibility;
	}
	public void setVisibility(String visibility) {
		this.visibility = visibility;
	}
	public Timestamp getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}
	public ReplyDTO(int seq, String writer, String contents, int likeCount, int board_seq, int parent_seq, String path,
			String visibility, Timestamp created_at) {
		this.seq = seq;
		this.writer = writer;
		this.contents = contents;
		this.likeCount = likeCount;
		this.board_seq = board_seq;
		this.parent_seq = parent_seq;
		this.path = path;
		this.visibility = visibility;
		this.created_at = created_at;
	}
	public ReplyDTO() {
	}

}