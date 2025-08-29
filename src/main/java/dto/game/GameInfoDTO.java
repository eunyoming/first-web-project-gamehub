package dto.game;

public class GameInfoDTO {

	private int seq;
	private String screenshot;
	private String creator;
	private String creatorComment;
	private String guide;
	
	
	
	public GameInfoDTO(int seq, String screenshot, String creator, String creatorComment, String guide) {
		super();
		this.seq = seq;
		this.screenshot = screenshot;
		this.creator = creator;
		this.creatorComment = creatorComment;
		this.guide = guide;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getScreenshot() {
		return screenshot;
	}
	public void setScreenshot(String screenshot) {
		this.screenshot = screenshot;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getCreatorComment() {
		return creatorComment;
	}
	public void setCreatorComment(String creatorComment) {
		this.creatorComment = creatorComment;
	}
	public String getGuide() {
		return guide;
	}
	public void setGuide(String guide) {
		this.guide = guide;
	}
	
	
	
	
}
