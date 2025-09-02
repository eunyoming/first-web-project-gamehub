package dto.member;

import java.sql.Timestamp;

public class ManagerMemberDTO {
	 private String id;
	    private String email;
	    private int point;
	    private Timestamp createdAt;
	    private String role;

	    // getter & setter
	    public String getId() { return id; }
	    public void setId(String id) { this.id = id; }

	    public String getEmail() { return email; }
	    public void setEmail(String email) { this.email = email; }

	    public int getPoint() { return point; }
	    public void setPoint(int point) { this.point = point; }

	    public Timestamp getCreatedAt() { return createdAt; }
	    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

	    public String getRole() { return role; }
	    public void setRole(String role) { this.role = role; }
}
