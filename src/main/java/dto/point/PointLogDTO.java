package dto.point;

import java.sql.Timestamp;

public class PointLogDTO {
	 private int seq;
	    private String userId;
	    private String type_Code; // ref: point.type
	    private int value; // 양수: 획득 / 음수: 사용
	    private String description;
	    private Timestamp created_at;
	    
	    
		public PointLogDTO(int seq, String userId, String type_Code, int value, String description,
				Timestamp created_at) {
			super();
			this.seq = seq;
			this.userId = userId;
			this.type_Code = type_Code;
			this.value = value;
			this.description = description;
			this.created_at = created_at;
		}
		
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
		public String getType_Code() {
			return type_Code;
		}
		public void setType_Code(String type_Code) {
			this.type_Code = type_Code;
		}
		public int getValue() {
			return value;
		}
		public void setValue(int value) {
			this.value = value;
		}
		public String getDescription() {
			return description;
		}
		public void setDescription(String description) {
			this.description = description;
		}
		public Timestamp getCreated_at() {
			return created_at;
		}
		public void setCreated_at(Timestamp created_at) {
			this.created_at = created_at;
		}

	  
}
