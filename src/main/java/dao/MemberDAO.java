package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.game.AchievementDTO;
import dto.member.ManagerMemberDTO;
import dto.member.MemberDTO;
import dto.member.MemberProfileDTO;
import dto.member.SimpleUserProfileDTO;

public class MemberDAO {
	//대상DTO: MemberDTO, MemberProfileDTO, RoleDTO
	private static MemberDAO instance;

	public synchronized static MemberDAO getInstance() {
		if(instance==null)
		{
			instance = new MemberDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	public MemberDTO selectMembersByIdAndPW(String id, String pw) throws Exception{
		//로그인 시에 사용되는 메서드 입니다.
		String sql = "select * from members where id=? and pw=?";

		try(
				Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);
				)
		{
			pstat.setString(1, id);
			pstat.setString(2, pw);
			ResultSet rs = pstat.executeQuery();
			if(rs.next()) {
				MemberDTO dto = new MemberDTO();
				dto.setId(rs.getString("id"));
				dto.setPoint(rs.getInt("point"));


				return dto;
			}else {
				return null;
			}
		}
	}
	// 아이디 찾기
	public String matchedId (String name, String email) throws Exception {

		String sql = "select id from members where name=? and email=?";

		try(
				Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setString(1, name);
			pstat.setString(2, email);

			try (ResultSet rs = pstat.executeQuery()) {
				if (rs.next()) {
					return rs.getString("id");
				}
			}
		}
		return null;
	}
	// 비밀번호 찾기
	public String matchedUser (String id, String name, String email) throws Exception {

		String sql = "select id from members where id=? and name=? and email=?";

		try(
				Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setString(1, id);
			pstat.setString(2, name);
			pstat.setString(3, email);

			try (ResultSet rs = pstat.executeQuery()) {
				if (rs.next()) {
					return rs.getString("id");
				}
			}
		}
		return null;
	}

	// 비밀번호 변경
	public int updateMembersById (MemberDTO dto) throws Exception {

		String sql = "update members set pw=? where id=?";

		try(
				Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {

			pstat.setString(1, dto.getPw());
			pstat.setString(2, dto.getId());

			int result = pstat.executeUpdate();
			return result;
		}
	}
	// 회원가입
	public int insertMembers (MemberDTO dto) throws Exception {

		String sql = "insert into members values (?,?,?,?,?,?,?,?,default,?,sysdate,sysdate)";

		try(
				Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setString(1, dto.getId());
			pstat.setString(2, dto.getPw() );
			pstat.setString(3, dto.getName());
			pstat.setString(4, dto.getPhone());
			pstat.setString(5, dto.getEmail());
			pstat.setString(6, dto.getZipcode());
			pstat.setString(7, dto.getAddress());
			pstat.setString(8, dto.getAddressDetail());
			pstat.setString(9,"Y");

			int result =  pstat.executeUpdate();
			if(result >0) {
				RoleDAO.getInstance().insertDefaultRole(dto.getId());
			}
			return result;
		}
	}
	// ID 중복 확인 (회원 + 탈퇴회원)
	public boolean isIdExist(String id) throws Exception {
	    try (Connection con = getConnection()) {

	        // members 테이블 확인
	        String sql1 = "select 1 from members where id=?";
	        try (PreparedStatement pstat1 = con.prepareStatement(sql1)) {
	            pstat1.setString(1, id);
	            try (ResultSet rs1 = pstat1.executeQuery()) {
	                if (rs1.next()) {
	                    return true; // 회원 테이블에 존재
	                }
	            }
	        }

	        // withdraw_members 탈퇴회원 테이블 확인
	        String sql2 = "select 1 from withdrawn_members where id=?";
	        try (PreparedStatement pstat2 = con.prepareStatement(sql2)) {
	            pstat2.setString(1, id);
	            try (ResultSet rs2 = pstat2.executeQuery()) {
	                if (rs2.next()) {
	                    return true; // 탈퇴 회원 테이블에 존재
	                }
	            }
	        }
	    }
	    return false; // 두 테이블 모두 없으면 false
	}
	// Email 중복 확인
	public boolean isEmailExist (String email, String userId) throws Exception {
		
		String sql = "select * from members where email=? and id=?";
		
		try(
				Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setString(1, email);
			pstat.setString(2, userId);

			 try (ResultSet rs = pstat.executeQuery()) {
		            if (rs.next()) {
		            	
		                String foundId = rs.getString("id");
		                // 찾은 이메일이 본인(userId)의 것이면 중복 아님
		                return !foundId.equals(userId);
		            }
		            // 이메일 없음 → 중복 아님
		            return false;
		        }
		    }
		}
	// 회원정보 리스트
	public MemberDTO selectAllMemberId (String loginId) throws Exception {

		String sql = "select id,name,phone,email,zipcode,address,addressDetail from members where id=? ";

		try (Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)){

			pstat.setString(1, loginId);

			try(ResultSet rs = pstat.executeQuery()){
				while(rs.next()) {
					
					return new MemberDTO (
					 rs.getString("id"),
					 rs.getString("name"),
					 rs.getString("phone"),
					 rs.getString("email"),
					 rs.getString("zipcode"),
					 rs.getString("address"),
					 rs.getString("addressDetail")
					 );
				}
			}
		}
		return null;
	}
	// 회원정보 수정 update테이블명By조건필드명
	public int updateMemberById (MemberDTO dto) throws Exception {
		
		String sql = "update members set name=? , phone=? , email=? , zipcode=? , address=? , addressDetail=? where id=?";
	
		try (Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {
			
			pstat.setString(1, dto.getName());
			pstat.setString(2, dto.getPhone());
			pstat.setString(3, dto.getEmail());
			pstat.setString(4, dto.getZipcode());
			pstat.setString(5, dto.getAddress());
			pstat.setString(6, dto.getAddressDetail());
			pstat.setString(7, dto.getId());
			
			int result = pstat.executeUpdate();
			return result;
		}
	}
	// 회원탈퇴 처리 , 탈퇴 테이블에 기록 + 기존 회원 테이블에서 데이터 삭제
	public void withdrawMember(String id) throws Exception {
	    String insertSql = "insert into withdrawn_members (id) values (?)";
	    String deleteSql = "delete from members where id = ?";

	    try (Connection conn = getConnection();
	         PreparedStatement pstmt1 = conn.prepareStatement(insertSql);
	         PreparedStatement pstmt2 = conn.prepareStatement(deleteSql)) {

	        conn.setAutoCommit(false);

	        // 1. 탈퇴 테이블에 기록
	        pstmt1.setString(1, id);
	        pstmt1.executeUpdate();

	        // 2. 원래 회원 테이블에서 삭제
	        pstmt2.setString(1, id);
	        pstmt2.executeUpdate();

	        conn.commit();
	    } 
	}
	public SimpleUserProfileDTO login(String id, String pw) {
		String sql = "SELECT m.id AS userId,\n"
				+ "       mp.profileImage,\n"
				+ "       NVL(a.id, '업적 칭호 없음') AS eqipedAchievId,\n"
				+ "       NVL(a.title, '업적 칭호 없음') AS equipedAchievTitle,\n"
				+ "       NVL(a.DESCRIPTION, '업적 칭호 없음') AS equipedAchievDescription,\n"
				+ "       NVL(a.GAME_SEQ, 0) AS equipedAchievGameSeq,\n"
				+ "       NVL(a.ICON_URL, '업적 칭호 없음') AS equipedAchievImgUrl,\n"
				+ "       NVL(r.category, 'User') AS category "
				+ "FROM members m\n"
				+ "LEFT JOIN member_profiles mp ON m.id = mp.userId\n"
				+ "LEFT JOIN (\n"
				+ "    SELECT ua.userId, ach.*\n"
				+ "    FROM userAchievement ua\n"
				+ "    JOIN Achievement ach ON ua.achiev_seq = ach.seq\n"
				+ "    WHERE ua.isEquip = 'Y'\n"
				+ ") a ON m.id = a.userId\n"
				+ "LEFT JOIN role r ON m.id = r.id "
				+ "WHERE m.id = ? AND m.pw = ?";

		try (Connection conn = getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, id);
			ps.setString(2, pw);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return new SimpleUserProfileDTO(
						rs.getString("userId"),
						rs.getString("profileImage"),
						new AchievementDTO(0,
								rs.getString("eqipedAchievId"),
								"🏆"+ rs.getString("equipedAchievTitle"),
								rs.getString("equipedAchievDescription"),
								rs.getString("equipedAchievImgUrl"), 
								rs.getInt("equipedAchievGameSeq"),
								0 ),
						rs.getString("category")
						);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<ManagerMemberDTO> getMemberList(int startRow, int endRow) {
		List<ManagerMemberDTO> list = new ArrayList<>();
		String sql =
				"SELECT * FROM ( " +
						"  SELECT ROWNUM rnum, A.* FROM ( " +
						"    SELECT m.id, m.email, m.point, m.created_at, r.category " +
						"    FROM members m " +
						"    LEFT JOIN role r ON m.id = r.id " +
						"    ORDER BY m.created_at DESC " +
						"  ) A " +
						"  WHERE ROWNUM <= ? " +
						") " +
						"WHERE rnum >= ?";

		try (Connection conn =getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, endRow);
			pstmt.setInt(2, startRow);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					ManagerMemberDTO dto = new ManagerMemberDTO();
					dto.setId(rs.getString("id"));
					dto.setEmail(rs.getString("email"));
					dto.setPoint(rs.getInt("point"));
					dto.setCreatedAt(rs.getTimestamp("created_at"));
					dto.setRole(rs.getString("category"));
					list.add(dto);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/** 총 회원 수 조회 */
	public int getTotalMemberCount() {
		int count = 0;
		String sql = "SELECT COUNT(*) FROM members";
		try (Connection conn = getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}




	//프로필용 
	public SimpleUserProfileDTO getSimpleUserProfile(String userId) {
		String sql = 
				"SELECT m.id AS userId, " +
						"       mp.profileImage, " 
						+ "       NVL(a.id, '업적 칭호 없음') AS eqipedAchievId,\n"
						+ "       NVL(a.title, '업적 칭호 없음') AS equipedAchievTitle,\n"
						+ "       NVL(a.DESCRIPTION, '업적 칭호 없음') AS equipedAchievDescription,\n"
						+ "       NVL(a.GAME_SEQ, 0) AS equipedAchievGameSeq,\n"
						+ "       NVL(a.ICON_URL, '업적 칭호 없음') AS equipedAchievImgUrl\n"+
						"FROM members m " +
						"LEFT JOIN member_profiles mp ON m.id = mp.userID " +
						"LEFT JOIN ( " +
						"    SELECT ua.userid, ach.* " +
						"    FROM userAchievement ua " +
						"    JOIN Achievement ach ON ua.achiev_seq = ach.seq " +
						"    WHERE ua.isEquip = 'Y' " +
						") a ON m.id = a.userid " +
						"WHERE m.id = ?";

		try (Connection conn = getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, userId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					String profileImage = rs.getString("profileImage");
				
					AchievementDTO achievDTO = new AchievementDTO(0,
							rs.getString("eqipedAchievId"),
							 "🏆"+ rs.getString("equipedAchievTitle"),
							rs.getString("equipedAchievDescription"),
							rs.getString("equipedAchievImgUrl"), 
							rs.getInt("equipedAchievGameSeq"),
							0 );
					
					return new SimpleUserProfileDTO(userId, profileImage,achievDTO,null);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null; // 유저 없을 경우
	}



	//여러 유저의 
	public List<SimpleUserProfileDTO> getMultiSimpleUserProfiles(List<String> userIds) {
		if (userIds == null || userIds.isEmpty()) {
			return Collections.emptyList();
		}

		String placeholders = String.join(",", Collections.nCopies(userIds.size(), "?"));

		String sql = 
				"SELECT m.id AS userId, " +
						"       mp.profileImage, " 
						+ "       NVL(a.id, '업적 칭호 없음') AS eqipedAchievId,\n"
						+ "       NVL(a.title, '업적 칭호 없음') AS equipedAchievTitle,\n"
						+ "       NVL(a.DESCRIPTION, '업적 칭호 없음') AS equipedAchievDescription,\n"
						+ "       NVL(a.GAME_SEQ, 0) AS equipedAchievGameSeq,\n"
						+ "       NVL(a.ICON_URL, '업적 칭호 없음') AS equipedAchievImgUrl,\n"+
						"FROM members m " +
						"LEFT JOIN member_profiles mp ON m.id = mp.userID " +
						"LEFT JOIN ( " +
						"    SELECT ua.userid, ach.* " +
						"    FROM userAchievement ua " +
						"    JOIN Achievement ach ON ua.achiev_seq = ach.seq " +
						"    WHERE ua.isEquip = 'Y' " +
						") a ON m.id = a.userid " +
						"WHERE m.id IN (" + placeholders + ")";

		List<SimpleUserProfileDTO> result = new ArrayList<>();

		try (Connection conn = getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			// 파라미터 세팅
			for (int i = 0; i < userIds.size(); i++) {
				ps.setString(i + 1, userIds.get(i));
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					String userId = rs.getString("userId");
					String profileImage = rs.getString("profileImage");
					AchievementDTO achievDTO = new AchievementDTO(0,
							rs.getString("eqipedAchievId"),
							 "🏆"+ rs.getString("equipedAchievTitle"),
							rs.getString("equipedAchievDescription"),
							rs.getString("equipedAchievImgUrl"), 
							rs.getInt("equipedAchievGameSeq"),
							0 );
					result.add(new SimpleUserProfileDTO(userId, profileImage, achievDTO, null));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	
	public MemberProfileDTO getProfileByUserId(String userId) throws Exception {
		MemberProfileDTO profile = null;
        String sql = "SELECT USERID, PROFILEIMAGE, BIO, STATUSMESSAGE, UPDATED_AT FROM member_profiles WHERE USERID = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                profile = new MemberProfileDTO();
                profile.setUserID(rs.getString("USERID"));
                profile.setProfileImage(rs.getString("PROFILEIMAGE"));
                profile.setBio(rs.getString("BIO"));
                profile.setStatusMessage(rs.getString("STATUSMESSAGE"));
                profile.setUpdatedAt(rs.getTimestamp("UPDATED_AT"));
                
                
              
            }
        }
		return profile;
	}
	
	public boolean insertDefaultProfile(MemberProfileDTO profile) throws Exception{
		String sql = "INSERT INTO member_profiles (USERID, PROFILEIMAGE, BIO, STATUSMESSAGE, UPDATED_AT) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, profile.getUserID());
            pstmt.setString(2, profile.getProfileImage());
            pstmt.setString(3, profile.getBio());
            pstmt.setString(4, profile.getStatusMessage());
            pstmt.setTimestamp(5, profile.getUpdatedAt());

            int result = pstmt.executeUpdate();
            return result > 0;

        } 

	}
	
	public boolean updateProfileImage(String userId, String imageUrl) throws Exception{
        String sql = "UPDATE member_profiles SET PROFILEIMAGE = ?, UPDATED_AT = ? WHERE USERID = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, imageUrl);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            pstmt.setString(3, userId);

            int result = pstmt.executeUpdate();
            return result > 0;

        }
    }
	
	public boolean updateProfileText(String userId, String bio, String statusMessage) throws Exception {
	    String sql = "UPDATE member_profiles SET BIO = ?, STATUSMESSAGE = ?, UPDATED_AT = ? WHERE USERID = ?";

	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, bio);
	        pstmt.setString(2, statusMessage);
	        pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
	        pstmt.setString(4, userId);

	        int result = pstmt.executeUpdate();
	        return result > 0;

	    } 
	}



}
