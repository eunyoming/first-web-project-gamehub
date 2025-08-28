package dto.game;

import java.sql.Timestamp;

public class UserAchievementDTO{
    private int seq;
    private String userId;
    private String achievementId;
    private String isEquip;
    private Timestamp unlocked_At;
    // Getters and Setters
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getAchievementId() {
		return achievementId;
	}
	public void setAchievementId(String achievementId) {
		this.achievementId = achievementId;
	}
	
	public Timestamp getUnlocked_At() {
		return unlocked_At;
	}
	public void setUnlocked_At(Timestamp unlocked_At) {
		this.unlocked_At = unlocked_At;
	}
	public String getIsEquip() {
		return isEquip;
	}
	public void setIsEquip(String isEquip) {
		this.isEquip = isEquip;
	}
	
    
    
}
