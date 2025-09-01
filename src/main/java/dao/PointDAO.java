package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class PointDAO {
	//PointDTO, PointLogsDTO ... 
	/*
	 * 포인트 유형 정의, 사용자 포인트 획득/사용 기록 관리 DAO

	 */
	private static PointDAO instance;

	public synchronized static PointDAO getInstance() {
		if(instance==null)
		{
			instance = new PointDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	//여러 회원들의 point 적립 
	public void updateMemberPoints(List<String> ids, int addPoint) {
        String sql = "UPDATE member SET point = point + ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (String id : ids) {
                pstmt.setInt(1, addPoint);
                pstmt.setString(2, id);
                pstmt.addBatch();
            }
            pstmt.executeBatch();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
