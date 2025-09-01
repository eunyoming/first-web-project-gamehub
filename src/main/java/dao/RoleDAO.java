package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.member.RoleDTO;

public class RoleDAO {
	  private static RoleDAO instance;

	    public synchronized static RoleDAO getInstance() {
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
	        String sql = "INSERT INTO role (seq, id, category,updated_at) VALUES (role_seq.NEXTVAL, ?, 'User',sysdate)";
	        try (Connection conn = getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            ps.setString(1, userId);
	            return ps.executeUpdate(); // 1이면 성공
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return 0;
	    }
	    
	    //밴된 유저 검색
	    public List<RoleDTO> selectBannedUser() throws Exception{
	    	
	    	List<RoleDTO> list = new ArrayList<>();
	    	
	    	String sql = "SELECT * from role where category ='Banned'";
	    	try (Connection conn = getConnection();
		             PreparedStatement ps = conn.prepareStatement(sql);
	    			ResultSet rs = ps.executeQuery();
		            		 ) {
		          
		           while(rs.next()) {
		        	   RoleDTO dto = new RoleDTO();
		    
		        	   dto.setId(rs.getString("id"));
		        	   
		        	   dto.setUpdated_at(rs.getDate("updated_at"));
		        	   dto.setSeq(rs.getInt("seq"));
		        	   dto.setCategory(rs.getString("category"));
		        	   
		        	   list.add(dto);
		           }
		           
		           return list;
	    	}
	    	
	    }
	    
	    public boolean unbanUser(String userId) throws Exception {
	        String sql = "UPDATE Role SET category = 'User', updated_at = CURRENT_DATE WHERE ID = ? AND category = 'Banned'";
;
	        try (Connection conn =getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {
	            pstmt.setString(1, userId);
	            return pstmt.executeUpdate() > 0;
	            
	        } 
	        
	    }
}
