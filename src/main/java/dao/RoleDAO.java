package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class RoleDAO {
	  private static RoleDAO instance;

	    public static RoleDAO getInstance() {
	        if (instance == null) {
	            instance = new RoleDAO();
	        }
	        return instance;
	    }

	    public Connection getConnection() throws Exception{
			Context ctx = new InitialContext();
			DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
			return ds.getConnection();
		}

	    

	    // 회원가입 시 기본 권한(User) insert
	    public int insertDefaultRole(String userId) {
	        String sql = "INSERT INTO role (seq, id, category) VALUES (role_seq.NEXTVAL, ?, 'User')";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setString(1, userId);
	            return ps.executeUpdate(); // 1이면 성공
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return 0;
	    }
}
