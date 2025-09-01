package dto.game;

public class GameRecentDTO {
	
	private  String title;
	private  String url;
	private  String totalplaytime;
	private  String recentPlayedDate;
	
	
	
	
	
	
	
	public GameRecentDTO(String title, String url, String totalplaytime, String recentPlayedDate) {
		super();
		this.title = title;
		this.url = url;
		this.totalplaytime = totalplaytime;
		this.recentPlayedDate = recentPlayedDate;
		
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
	
	
}		
