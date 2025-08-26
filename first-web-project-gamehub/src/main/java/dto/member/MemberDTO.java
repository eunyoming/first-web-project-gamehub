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
    private Timestamp createdAt;
    private Timestamp privacyAgreedAt;
    // Getters and Setters
}