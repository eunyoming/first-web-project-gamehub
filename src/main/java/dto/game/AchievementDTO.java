package dto.game;

public class AchievementDTO {

	 private int seq;
	 private String id;
	private String title;
	 private String description;
	 private String iconUrl;
	 private int gameSeq; // game.seq를 참조 
	 private int pointSeq;  // point.seq를 참조
	 
	 
	 public AchievementDTO(int seq, String id, String title, String description, String iconUrl, int gameSeq,
				int pointSeq) {
			super();
			this.seq = seq;
			this.id = id;
			this.title = title;
			this.description = description;
			this.iconUrl = iconUrl;
			this.gameSeq = gameSeq;
			this.pointSeq = pointSeq;
		}
		
		public AchievementDTO() {
			
		}
	 
	 
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	 public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getIconUrl() {
		return iconUrl;
	}
	public void setIconUrl(String iconUrl) {
		this.iconUrl = iconUrl;
	}
	public int getGameSeq() {
		return gameSeq;
	}
	public void setGameSeq(int gameSeq) {
		this.gameSeq = gameSeq;
	}
	public int getPointSeq() {
		return pointSeq;
	}
	public void setPointSeq(int pointSeq) {
		this.pointSeq = pointSeq;
	}
	
	 
	 
}
