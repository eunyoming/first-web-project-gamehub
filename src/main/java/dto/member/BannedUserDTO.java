package dto.member;

import java.sql.Timestamp;

public class BannedUserDTO {
	  private String id;
	  private Timestamp bannedUntil;
	  private String bannedReason;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Timestamp getBannedUntil() {
		return bannedUntil;
	}
	public void setBannedUntil(Timestamp bannedUntil) {
		this.bannedUntil = bannedUntil;
	}
	public String getBannedReason() {
		return bannedReason;
	}
	public void setBannedReason(String bannedReason) {
		this.bannedReason = bannedReason;
	}
	public BannedUserDTO(String id, Timestamp bannedUntil, String bannedReason) {
		super();
		this.id = id;
		this.bannedUntil = bannedUntil;
		this.bannedReason = bannedReason;
	}
	public BannedUserDTO() {}
	  
	  
}
