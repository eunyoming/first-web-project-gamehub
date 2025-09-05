package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.board.BoardDTO;
import dto.point.PointDTO;
import dto.point.PointLogDTO;

public class PointLogDAO {

	private static PointLogDAO instance;

	public synchronized static PointLogDAO getInstance() {
		if(instance==null)
		{
			instance = new PointLogDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	public List<PointLogDTO> selectPoint_LogsByUserId(String userId) throws Exception{
		String sql = "select * from point_logs where userId = ? order by created_at desc";

		try ( Connection conn = getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, userId);
			try (ResultSet result = pstmt.executeQuery()) {

				List<PointLogDTO> list = new ArrayList<>();

				while(result.next())
				{
					int seq = result.getInt("seq");
					String typeCode = result.getString("type_Code");
					int value = result.getInt("value");
					String description = result.getString("description");
					Timestamp created_at =result.getTimestamp("created_at");
					//visibility 삭제를 안하고 신고가 들어오면 숨김처리 해주는 숨김표시
					PointLogDTO dto = new PointLogDTO(seq,userId,typeCode,value,description,created_at);

					list.add(dto);
				}
				System.out.println("포인트 글 list");
				return list;	



			}
		}
	}

	public List<PointLogDTO> selectPoint_LogsByFromTo(String userId, int from, int to) throws Exception{

		String sql = "SELECT * FROM ( SELECT Point_Logs.*, ROW_NUMBER()	OVER (ORDER BY created_at DESC) AS rnk	FROM Point_Logs	where userid= ? ) sub WHERE rnk BETWEEN ? AND ? ORDER BY seq DESC";
		
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);){
			pstat.setString(1, userId);
			pstat.setInt(2, from);
			pstat.setInt(3, to);

			try(ResultSet result = pstat.executeQuery())
			{
				List<PointLogDTO> list = new ArrayList<PointLogDTO>();
				while(result.next())
				{
					int seq = result.getInt("seq");
					String type_Code = result.getString("type_Code");
					int value =result.getInt("value");
					String description = result.getString("description");
					
					Timestamp created_at =result.getTimestamp("created_at");
					

					PointLogDTO dto = new PointLogDTO(seq,userId,type_Code,value,description,created_at);

					list.add(dto);
				}
				return list;		
			}
		}
	}

	
	public int countPoint_LogsByUserId(String userId) throws Exception {
		String sql = "select count(*) from point_logs where userId = ? group by userid";
		
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);){
			pstat.setString(1, userId);

			try(ResultSet result = pstat.executeQuery())
			{
				if(result.next())
				{
					return result.getInt("count(*)");
				}
				else
				{
					return 0;
				}	
			}
		}
		
	}
	



}
