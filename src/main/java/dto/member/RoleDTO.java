package dto.member;

import java.sql.Date;

public class RoleDTO {
    private int seq;
    private String id;
    private String category;
    private Date updated_at;
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
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public Date getUpdated_at() {
		return updated_at;
	}
	public void setUpdated_at(Date updated_at) {
		this.updated_at = updated_at;
	}
	public RoleDTO(int seq, String id, String category, Date updated_at) {
		super();
		this.seq = seq;
		this.id = id;
		this.category = category;
		this.updated_at = updated_at;
	}
    
	public RoleDTO() {
		
	}
    
    

}