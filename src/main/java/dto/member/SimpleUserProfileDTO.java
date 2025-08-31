package dto.member;

public class SimpleUserProfileDTO {
	
	//심플유저프로필 DTO는 딱 세가지 필드로 구성됩니다.
	//유저아이디, 프로필 사진, 장착한 칭호(업적타이틀), 유저권한(카테고리)
	//어디에 쓰는 지 알겠죠? 우리는 그냥 아이디만 보여줄게 아니라 이걸 보여주도록 합시다.
	
	 private String userId;
	  private String profileImage;
	  private String equipedAchiev;
	  private String category;

	    // 생성자
	    public SimpleUserProfileDTO(String userId, String profileImage, String equipedAchiev, String category) {
	        this.userId = userId;
	        this.profileImage = profileImage;
	        this.equipedAchiev = equipedAchiev;
	        this.category = category;
	    }

	    // Getter / Setter
	    public String getUserId() {
	        return userId;
	    }

	    public void setUserId(String userId) {
	        this.userId = userId;
	    }

	    public String getProfileImage() {
	        return profileImage;
	    }

	    public void setProfileImage(String profileImage) {
	        this.profileImage = profileImage;
	    }

	    public String getEquipedAchiev() {
	        return equipedAchiev;
	    }

	    public void setEquipedAchiev(String equipedAchiev) {
	        this.equipedAchiev = equipedAchiev;
	    }

		public String getCategory() {
			return category;
		}

		public void setCategory(String category) {
			this.category = category;
		}
	    
	    
}
