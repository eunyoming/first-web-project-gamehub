package dto.member;

import java.sql.Timestamp;

public class MemberDTO {
	private String id;
	private String pw;
	private String name;
	private String phone;
	private String email;
	private String zipcode;
	private String address;
	private String addressDetail;
	private int point;
	private char privacyAgreed;
	private Timestamp created_at;
	private Timestamp privacy_agreed_at;

	public MemberDTO() {

	}

	public MemberDTO(String id, String pw, String name, String phone, String email, String zipcode, String address,
			String addressDetail, int point, char privacyAgreed, Timestamp created_at, Timestamp privacy_agreed_at) {
		super();
		this.id = id;
		this.pw = pw;
		this.name = name;
		this.phone = phone;
		this.email = email;
		this.zipcode = zipcode;
		this.address = address;
		this.addressDetail = addressDetail;
		this.point = point;
		this.privacyAgreed = privacyAgreed;
		this.created_at = created_at;
		this.privacy_agreed_at = privacy_agreed_at;
	}
	public MemberDTO(String id, String name, String phone, String email, 
			String zipcode, String address, String addressDetail) {
		this.id = id;
		this.name = name;
		this.phone = phone;
		this.email = email;
		this.zipcode = zipcode;
		this.address = address;
		this.addressDetail = addressDetail;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getZipcode() {
		return zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getAddressDetail() {
		return addressDetail;
	}

	public void setAddressDetail(String addressDetail) {
		this.addressDetail = addressDetail;
	}

	public int getPoint() {
		return point;
	}

	public void setPoint(int point) {
		this.point = point;
	}

	public char getPrivacyAgreed() {
		return privacyAgreed;
	}

	public void setPrivacyAgreed(char privacyAgreed) {
		this.privacyAgreed = privacyAgreed;
	}

	public Timestamp getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}

	public Timestamp getPrivacy_agreed_at() {
		return privacy_agreed_at;
	}

	public void setPrivacy_agreed_at(Timestamp privacy_agreed_at) {
		this.privacy_agreed_at = privacy_agreed_at;
	}
}