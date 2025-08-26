package dto.game;

import java.sql.Timestamp;

public class GameReviewDTO {

	private int seq;
	private String writer;
	private String title;
	private String content;
	private int game_seq;
	private int rating;
	private Timestamp created_at;
	
	
	public GameReviewDTO(int seq, String writer, String title, String content, int game_seq, int rating,
			Timestamp created_at) {
		super();
		this.seq = seq;
		this.writer = writer;
		this.title = title;
		this.content = content;
		this.game_seq = game_seq;
		this.rating = rating;
		this.created_at = created_at;
	}
	
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
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getGame_seq() {
		return game_seq;
	}
	public void setGame_seq(int game_seq) {
		this.game_seq = game_seq;
	}
	public int getRating() {
		return rating;
	}
	public void setRating(int rating) {
		this.rating = rating;
	}
	public Timestamp getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}
}