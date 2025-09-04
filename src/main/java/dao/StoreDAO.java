package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.pointStore.PointStoreDTO;

public class StoreDAO {

	//PointStoreDTO, PointPurchaseDTO
	
	/*pointStore, pointPurchase 테이블에 대한 데이터 접근 및 조작. 
	 * 상점 아이템 목록 조회, 
	 * 아이템 구매 기록 저장 및 조회 등을 담당합니다.
	 * 
	 */
	
	private static StoreDAO instance;

	public synchronized static StoreDAO getInstance() {
		if(instance==null)
		{
			instance = new StoreDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	public List<PointStoreDTO> selectAllPointStore() throws Exception {
		String sql = "SELECT * FROM PointStore";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			try(
					ResultSet result = pstat.executeQuery();)
			{
				List<PointStoreDTO> list = new ArrayList<>();
				
				while(result.next())
				{
					int seq = result.getInt("seq");
					String itemName = result.getString("itemname");
					int price = result.getInt("price");
					String url = result.getString("url");
					String contents = result.getString("contents");
					//int stock = result.getInt("stock");
					Timestamp created_at = result.getTimestamp("created_at");
					//Timestamp updated_at = result.getTimestamp("updated_at");
					
					PointStoreDTO dto = new PointStoreDTO(seq,itemName,price,url,contents,0,created_at,null);

					list.add(dto);
				}
				System.out.println("pointstore list");
				return list;		
			}

		}

	}
	
	public List<Map<String,Object>> selectPointStoreLeftJoinPointpurchase(String userId) throws Exception {
		String sql = "select * from pointstore ps left join pointpurchase pp on ps.seq = pp.item_seq and userid = ? order by ps.seq";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setString(1, userId);
			try(
					ResultSet result = pstat.executeQuery();)
			{
				List<Map<String,Object>> list = new ArrayList<>();
				
				while(result.next())
				{
					
					Map<String, Object> resultMap = new HashMap<>();
					resultMap.put("seq", result.getInt("seq"));
					resultMap.put("itemName", result.getString("itemname"));
					resultMap.put("price", result.getInt("price"));
					resultMap.put("url", result.getString("url"));
					resultMap.put("contents", result.getString("contents"));

					resultMap.put("created_at", result.getTimestamp("created_at"));
					
					if(result.getTimestamp("purchased_at") != null)
					{
						resultMap.put("isPurchased", "true");
					}
					else
					{
						resultMap.put("isPurchased", "false");
					}
					
					list.add(resultMap);
				}
				System.out.println("pointstore list");
				return list;		
			}

		}

	}
	
	public PointStoreDTO selectPointStoreBySeq(int itemSeq) throws Exception {
		String sql = "SELECT * FROM PointStore where seq = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			
			pstat.setInt(1, itemSeq);
			
			try(
					ResultSet result = pstat.executeQuery();)
			{
				
				if(result.next())
				{
					int seq = result.getInt("seq");
					String itemName = result.getString("itemname");
					int price = result.getInt("price");
					String url = result.getString("url");
					String contents = result.getString("contents");
					//int stock = result.getInt("stock");
					Timestamp created_at = result.getTimestamp("created_at");
					//Timestamp updated_at = result.getTimestamp("updated_at");
					
					PointStoreDTO dto = new PointStoreDTO(seq,itemName,price,url,contents,0,created_at,null);
					
					return dto;
				}
				else
				{
					System.out.println("에러! 없는 seq");
					return null;
				}
			}

		}

	}
	
	public boolean updateItemInfo(PointStoreDTO dto) throws Exception {
		String sql = "UPDATE PointStore SET itemname = ?, price = ?, contents = ? WHERE seq = ?";

		try (Connection con = getConnection();
			 PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setString(1, dto.getItemName());
			pstat.setInt(2, dto.getPrice());
			pstat.setString(3, dto.getContents());
			pstat.setInt(4, dto.getSeq());

			int result = pstat.executeUpdate();
			return result > 0;
		}
	}
	
	public boolean selectPointPurchaseBySeqAndUserId(int itemSeq,String userId) throws Exception {
		String sql = "select * from pointpurchase where item_seq = ? and userid = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			
			pstat.setInt(1, itemSeq);
			pstat.setString(2, userId);
			
			try(
					ResultSet result = pstat.executeQuery();)
			{
				
				return result.next();
				
			}

		}

	}
	
	public boolean updateItemImage(int seq, String imageUrl) throws Exception {
		String sql = "UPDATE PointStore SET url = ? WHERE seq = ?";

		try (Connection con = getConnection();
			 PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setString(1, imageUrl);
			pstat.setInt(2, seq);

			int result = pstat.executeUpdate();
			return result > 0;
		}
	}
	
	public boolean insertNewItem(PointStoreDTO dto) throws Exception {
		String sql = "INSERT INTO PointStore (seq,itemname, price, url, contents, created_at) VALUES (pointstoreSeq.nextval , ?, ?, ?, ?, CURRENT_TIMESTAMP)";

		try (Connection con = getConnection();
			 PreparedStatement pstat = con.prepareStatement(sql)) {

			pstat.setString(1, dto.getItemName());
			pstat.setInt(2, dto.getPrice());
			pstat.setString(3, dto.getUrl());
			pstat.setString(4, dto.getContents());

			int result = pstat.executeUpdate();
			return result > 0;
		}
	}
	
	
	//가장 많이 팔린 5개의 아이템을 추출하는 함수
	public List<PointStoreDTO> getTop5PopularItems() {
	    String sql = "SELECT ps.seq, ps.itemname, ps.price, ps.url, ps.contents, ps.created_at " +
	                 "FROM pointStore ps " +
	                 "JOIN (SELECT item_seq, COUNT(*) AS cnt FROM pointpurchase GROUP BY item_seq) pp " +
	                 "ON ps.seq = pp.item_seq " +
	                 "ORDER BY pp.cnt DESC, ps.created_at DESC " +
	                 "FETCH FIRST 5 ROWS ONLY";

	    List<PointStoreDTO> list = new ArrayList<>();

	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
	            PointStoreDTO dto = new PointStoreDTO();
	            dto.setSeq(rs.getInt("seq"));
	            dto.setItemName(rs.getString("itemname"));
	            dto.setPrice(rs.getInt("price"));
	            dto.setUrl(rs.getString("url"));
	            dto.setContents(rs.getString("contents"));
	            dto.setCreated_At(rs.getTimestamp("created_at"));
	            list.add(dto);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	
	
	//아이템 구매시 회원 포인트 감소. 순서대로 아이디, 포인트, 설명, 타입코드
		public void buyItem(String userId, int points, String description, String typeCode,int storeSeq) throws Exception{
		    String updateMemberSql = "UPDATE members SET point = point - ? WHERE id = ?";
		    String insertLogSql = "INSERT INTO point_logs (seq, userid, type_code, value, description, created_at) " +
		                          "VALUES (point_logs_seq.nextval, ?, ?, ?, ?, SYSTIMESTAMP)";
		    
		    
		    String insertPointPurchaseSql =  "INSERT INTO pointpurchase VALUES (POINTPURCHASE_SEQ.nextval, ?, ?, SYSTIMESTAMP)";
		    		
		    		
		    try (Connection conn = getConnection()) {
		        conn.setAutoCommit(false);

		        try (	PreparedStatement pstmtUpdate = conn.prepareStatement(updateMemberSql);
		        		PreparedStatement pstmtLog = conn.prepareStatement(insertLogSql);
		        		PreparedStatement pstmtPurchase = conn.prepareStatement(insertPointPurchaseSql);
		        		) {
		            // 1) member 테이블 포인트 업데이트
		            pstmtUpdate.setInt(1, points);
		            pstmtUpdate.setString(2, userId);
		            pstmtUpdate.executeUpdate();

		            // 2) point_logs 기록
		            pstmtLog.setString(1, userId);
		            pstmtLog.setString(2, typeCode);
		            pstmtLog.setInt(3, -points);
		            pstmtLog.setString(4, description);
		            pstmtLog.executeUpdate();
		            
		            
		            // 3) pointpurchase 기록
		            pstmtPurchase.setString(1,userId);
		            pstmtPurchase.setInt(2,storeSeq);
		            pstmtPurchase.executeUpdate();
		            
		            conn.commit();
		            
		        } catch (Exception e) {
		            conn.rollback();
		            throw e;
		        } finally {
		            conn.setAutoCommit(true);
	
		        }
		        
		    }
		    
		}
}
