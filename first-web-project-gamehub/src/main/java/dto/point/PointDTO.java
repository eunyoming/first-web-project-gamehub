package dto.point;

public class PointDTO {
	 private int seq;
	 private String title;
	 private String description;
	 private String type; // 'game, achievement, event, admin'
	 private int value;
	 
	 // Default constructor
	    public PointDTO() {}

	    // Constructor with all fields
	    public PointDTO(int seq, String title, String description, String type, int value) {
	        this.seq = seq;
	        this.title = title;
	        this.description = description;
	        this.type = type;
	        this.value = value;
	    }

	    // Getters and Setters
	    public int getSeq() { return seq; }
	    public void setSeq(int seq) { this.seq = seq; }
	    public String getTitle() { return title; }
	    public void setTitle(String title) { this.title = title; }
	    public String getDescription() { return description; }
	    public void setDescription(String description) { this.description = description; }
	    public String getType() { return type; }
	    public void setType(String type) { this.type = type; }
	    public int getValue() { return value; }
	    public void setValue(int value) { this.value = value; }
}
