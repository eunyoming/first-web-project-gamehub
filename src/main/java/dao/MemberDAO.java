package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.member.ManagerMemberDTO;
import dto.member.MemberDTO;
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
	// 아이디 찾기	public 
	// 회원가입 insert

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
	// 회원가입 insert	
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
	// ID 중복 확인
	public boolean isIdExist (String id) throws Exception {

			String sql = "select * from members where id=?";

			try(
					Connection con = getConnection();
					PreparedStatement pstat = con.prepareStatement(sql)) {

				pstat.setString(1, id);

				try (ResultSet rs = pstat.executeQuery()) {
					return rs.next();
				}
			}
		}

		public SimpleUserProfileDTO login(String id, String pw) {
			String sql = "SELECT m.id AS userId,\n"
					+ "       mp.profileImage,\n"
					+ "       NVL(a.title, '업적 칭호 없음') AS equipedAchiev,\n"
					+ "       NVL(r.category, 'User') AS category "
					+ "FROM members m\n"
					+ "LEFT JOIN member_profiles mp ON m.id = mp.userId\n"
					+ "LEFT JOIN (\n"
					+ "    SELECT ua.userId, ach.title\n"
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
							rs.getString("equipedAchiev"),
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
							"       mp.profileImage, " +
							"       NVL(a.title, '업적 칭호 없음') AS equipedAchiev " +
							"FROM members m " +
							"LEFT JOIN member_profiles mp ON m.id = mp.userID " +
							"LEFT JOIN ( " +
							"    SELECT ua.userid, ach.title " +
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
						String equipedAchiev = rs.getString("equipedAchiev");
						return new SimpleUserProfileDTO(userId, profileImage, "🏆"+equipedAchiev,null);
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
							"       mp.profileImage, " +
							"       NVL(a.title, '업적 칭호 없음') AS equipedAchiev " +
							"FROM members m " +
							"LEFT JOIN member_profiles mp ON m.id = mp.userID " +
							"LEFT JOIN ( " +
							"    SELECT ua.userid, ach.title " +
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
						String equipedAchiev = rs.getString("equipedAchiev");
						result.add(new SimpleUserProfileDTO(userId, profileImage,"🏆"+ equipedAchiev, null));
					}
				}

			} catch (Exception e) {
				e.printStackTrace();
			}

			return result;
		}

	}
