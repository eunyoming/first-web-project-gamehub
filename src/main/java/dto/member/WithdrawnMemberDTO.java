package dto.member;

import java.sql.Timestamp;

public class WithdrawnMemberDTO {

	private String id;
	private Timestamp withdrawDate;


	public WithdrawnMemberDTO() {}

	public WithdrawnMemberDTO(String id, Timestamp withdrawDate) {
		this.id = id;
		this.withdrawDate = withdrawDate;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}

	public Timestamp getWithdrawDate() {
		return withdrawDate;
	}
	public void setWithdrawDate(Timestamp withdrawDate) {
		this.withdrawDate = withdrawDate;
	}
}
