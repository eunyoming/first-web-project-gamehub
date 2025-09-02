package dto.game;

public class GameRecentDTO {
	private int gameSeq;
	private  String title;
	private  String url;
	private  String totalplaytime;
	private  String recentPlayedDate;
	private int currentAchievement;
	private int totalAchievement;
	
	
	
	
	
	
	
	
	
	public GameRecentDTO(int gameSeq,String title, String url, String totalplaytime, String recentPlayedDate
			) {
		super();
		this.gameSeq = gameSeq;
		this.title = title;
		this.url = url;
		this.totalplaytime = totalplaytime;
		this.recentPlayedDate = recentPlayedDate;
//		this.currentAchievement = currentAchievement;
//		this.totalAchievement = totalAchievement;
	}
	public int getGameSeq() {
		return gameSeq;
	}
	public void setGameSeq(int gameSeq) {
		this.gameSeq = gameSeq;
	}
	
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getTotalplaytime() {
		return totalplaytime;
	}
	public void setTotalplaytime(String totalplaytime) {
		this.totalplaytime = totalplaytime;
	}
	public String getRecentPlayedDate() {
		return recentPlayedDate;
	}
	public void setRecentPlayedDate(String recentPlayedDate) {
		this.recentPlayedDate = recentPlayedDate;
	}
	public int getCurrentAchievement() {
		return currentAchievement;
	}
	public void setCurrentAchievement(int currentAchievement) {
		this.currentAchievement = currentAchievement;
	}
	public int getTotalAchievement() {
		return totalAchievement;
	}
	public void setTotalAchievement(int totalAchievement) {
		this.totalAchievement = totalAchievement;
	}
	
}		
