package dto.game;


public class GameDTO {
    private int seq;
    private String title;
    private String description;
    private String url;
    private String creator;
    
    
    
    
    
    
	public GameDTO(int seq, String title, String description, String url, String creator) {
		super();
		this.seq = seq;
		this.title = title;
		this.description = description;
		this.url = url;
		this.creator = creator;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
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
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
    
    
	
    
    // Getters and Setters
}