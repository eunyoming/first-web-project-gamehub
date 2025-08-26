package dto.board;

import java.sql.Timestamp;

public class BoardDTO {
    private int seq = 0;
    private String writer;
    private String title;
    private String contents;
    private String category;
    private String refgame;
    private int viewCount = 0;
    private int likeCount = 0;
    private String visibility;
    private Timestamp created_at;
    
    public BoardDTO() {
	}
    
	public BoardDTO(int seq, String writer, String title, String contents, String category, String refgame,
		int viewCount, int likeCount, String visibility, Timestamp created_at) {
		this.seq = seq;
		this.writer = writer;
		this.title = title;
		this.contents = contents;
		this.category = category;
		this.refgame = refgame;
		this.viewCount = viewCount;
		this.likeCount = likeCount;
		this.visibility = visibility;
		this.created_at = created_at;
	}
	
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
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getRefgame() {
		return refgame;
	}
	public void setRefgame(String refgame) {
		this.refgame = refgame;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public int getLikeCount() {
		return likeCount;
	}
	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
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
}