package dto.member;

import java.sql.Timestamp;

public class MemberProfileDTO {
    private String userID;
    private String profileImage;
    private String bio;
    private String statusMessage;
    private Timestamp updatedAt;
    // Getters and Setters
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getProfileImage() {
		return profileImage;
	}
	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}
	public String getBio() {
		return bio;
	}
	public void setBio(String bio) {
		this.bio = bio;
	}
	public String getStatusMessage() {
		return statusMessage;
	}
	public void setStatusMessage(String statusMessage) {
		this.statusMessage = statusMessage;
	}
	public Timestamp getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}
	public MemberProfileDTO(String userID, String profileImage, String bio, String statusMessage, Timestamp updatedAt) {
		super();
		this.userID = userID;
		this.profileImage = profileImage;
		this.bio = bio;
		this.statusMessage = statusMessage;
		this.updatedAt = updatedAt;
	}
	public MemberProfileDTO() {
		
	}
    
}