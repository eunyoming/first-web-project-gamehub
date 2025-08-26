package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.member.MemberDTO;

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
	
}
