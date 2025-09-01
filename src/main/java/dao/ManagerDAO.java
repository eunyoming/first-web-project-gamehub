package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ManagerDAO {
	private static ManagerDAO instance;

	public synchronized static ManagerDAO getInstance() {
		if(instance==null)
		{
			instance = new ManagerDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	//여러 회원들의 role 변경 
	public void updateMemberRoles(List<String> ids, String newRole) {
	    String sql = "MERGE INTO role r " +
	                 "USING (SELECT ? AS id, ? AS category FROM dual) src " +
	                 "ON (r.id = src.id) " +
	                 "WHEN MATCHED THEN " +
	                 "  UPDATE SET r.category = src.category, r.updated_at = SYSDATE " +
	                 "WHEN NOT MATCHED THEN " +
	                 "  INSERT (seq, id, category,updated_at) " +
	                 "  VALUES (role_seq.nextval, src.id, src.category,  SYSDATE)";

	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        for (String id : ids) {
	            pstmt.setString(1, id);      // src.id
	            pstmt.setString(2, newRole); // src.category
	            pstmt.addBatch();
	        }
	        pstmt.executeBatch();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	

	public List<Map<String,String>> selectGamePlayCount() throws Exception {
		//전체 이용자 게임별 플레이 횟수 - 완
		String sql = "SELECT g.title, NVL(tc.count, 0) as count	FROM games g LEFT JOIN (SELECT gr.game_seq, COUNT(*) AS count FROM gamerecords gr GROUP BY gr.game_seq) tc ON g.seq = tc.game_seq ORDER BY g.title "; 
		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			try(
					ResultSet result = pstat.executeQuery();)
			{
				List<Map<String,String>> list = new ArrayList<>();

				while(result.next())
				{
					String title = result.getString("title");
					String count = result.getString("count");

					Map<String,String> map = new HashMap<String,String>();
					map.put("title", title);
					map.put("count", count);
					list.add(map);


				}

				return list;		
			}		
		}
	}

	public List<Map<String,String>> selectSignUp_Data(String type) throws Exception{
		// 가입자 수 -
		//일별
		String typeDaySql = "WITH week_table AS ( SELECT TRUNC(SYSDATE) - LEVEL + 1 AS day_date FROM dual CONNECT BY LEVEL <= 7) SELECT w.day_date, NVL(b.post_count, 0) AS post_count	FROM week_table w LEFT JOIN (SELECT TRUNC(created_at) AS created_day, COUNT(*) AS post_count FROM members WHERE created_at >= TRUNC(SYSDATE) - 6 GROUP BY TRUNC(created_at)) b ON w.day_date = b.created_day ORDER BY w.day_date";

		//주차별
		String typeWeekSql = "WITH week_table AS ( SELECT TRUNC(SYSDATE) - LEVEL + 1 AS day_date FROM dual CONNECT BY LEVEL <= 31),	week_group AS ( SELECT TO_CHAR(day_date, 'YYYY-MM') AS month, CEIL(TO_CHAR(day_date, 'DD') / 7) AS week_in_month FROM week_table GROUP BY TO_CHAR(day_date, 'YYYY-MM'), CEIL(TO_CHAR(day_date, 'DD') / 7)),	members_count AS ( SELECT TO_CHAR(CREATED_AT, 'YYYY-MM') AS month, CEIL(TO_CHAR(CREATED_AT, 'DD') / 7) AS week_in_month, COUNT(*) AS post_count FROM members WHERE CREATED_AT >= TRUNC(SYSDATE)-32 GROUP BY TO_CHAR(CREATED_AT, 'YYYY-MM'), CEIL(TO_CHAR(CREATED_AT, 'DD') / 7)), members_total AS ( SELECT wg.month, wg.week_in_month, NVL(bc.post_count, 0) AS post_count FROM week_group wg LEFT JOIN members_count bc ON wg.month = bc.month AND wg.week_in_month = bc.week_in_month) SELECT * FROM (SELECT *  FROM members_total ORDER BY month DESC, week_in_month DESC) WHERE ROWNUM < 6";

		//월간별
		String typeMonthSql = "WITH month_table AS ( SELECT ADD_MONTHS(TRUNC(SYSDATE, 'MM'), - (LEVEL - 1)) AS month_start FROM dual CONNECT BY LEVEL <= 6), members_count AS ( SELECT TRUNC(CREATED_AT, 'MM') AS month_start, COUNT(*) AS post_count FROM members WHERE CREATED_AT >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -5) GROUP BY TRUNC(CREATED_AT, 'MM')) SELECT mt.month_start, NVL(bc.post_count, 0) AS post_count FROM month_table mt LEFT JOIN members_count bc	ON mt.month_start = bc.month_start	ORDER BY mt.month_start DESC";	

		switch(type) {
		case("daily"):
			try(	
					Connection con = getConnection();
					PreparedStatement pstat = con.prepareStatement(typeDaySql); )
			{
				try(
						ResultSet result = pstat.executeQuery();)
				{
					List<Map<String,String>> list = new ArrayList<>();

					while(result.next())
					{
						String date = result.getString("day_date");
						String label = date.split(" ")[0];    
						label = label.replace("-", "/"); // "2025/08/23"

						String count = result.getString("post_count");

						Map<String,String> map = new HashMap<String,String>();
						map.put("label", label);
						map.put("data", count);
						list.add(map);
					}
					return list;		
				}		
			}
		case("weekly"):
			try(	
					Connection con = getConnection();
					PreparedStatement pstat = con.prepareStatement(typeWeekSql); )
			{
				try(
						ResultSet result = pstat.executeQuery();)
				{
					List<Map<String,String>> list = new ArrayList<>();

					while(result.next())
					{
						String month = result.getString("month");
						String label = month.split(" ")[0];    
						label = label.replace("-", "/"); // "2025/08/23"
						String week_in_month = result.getString("week_in_month");
						String post_count = result.getString("post_count");

						Map<String,String> map = new HashMap<String,String>();
						map.put("label", label+"/"+week_in_month+"주차");
						map.put("data", post_count);
						list.add(map);
					}

					return list;		
				}		
			}
		case("monthly"):
			try(	
					Connection con = getConnection();
					PreparedStatement pstat = con.prepareStatement(typeMonthSql); )
			{
				try(
						ResultSet result = pstat.executeQuery();)
				{
					List<Map<String,String>> list = new ArrayList<>();

					while(result.next())
					{
						String month_start = result.getString("month_start");
						String label = month_start.split(" ")[0];    
						label = label.replace("-", "/"); // "2025/08/23"
						label = label.substring(0, 7); // "2025/08"
						
						String post_count = result.getString("post_count");
						
						Map<String,String> map = new HashMap<String,String>();
						map.put("label", label);
						map.put("data", post_count);
						list.add(map);
					}

					return list;		
				}		
			}

		default:
			return null;
		}


	}

	public List<Map<String,String>> selectPost_Data(String type) throws Exception{
		// 게시글 수 -
		//일별
		String typeDaySql = "WITH week_table AS (SELECT TRUNC(SYSDATE) - LEVEL + 1 AS day_date FROM dual CONNECT BY LEVEL <= 7) SELECT w.day_date, NVL(b.post_count, 0) AS post_count FROM week_table w LEFT JOIN (SELECT TRUNC(created_at) AS created_day,COUNT(*) AS post_count FROM boards WHERE created_at >= TRUNC(SYSDATE) - 6 GROUP BY TRUNC(created_at)) b ON w.day_date = b.created_day	ORDER BY w.day_date";

		//주차별
		String typeWeekSql = "WITH week_table AS ( SELECT TRUNC(SYSDATE) - LEVEL + 1 AS day_date FROM dual CONNECT BY LEVEL <= 31),	week_group AS (SELECT TO_CHAR(day_date, 'YYYY-MM') AS month, CEIL(TO_CHAR(day_date, 'DD') / 7) AS week_in_month FROM week_table GROUP BY TO_CHAR(day_date, 'YYYY-MM'), CEIL(TO_CHAR(day_date, 'DD') / 7)), board_count AS ( SELECT TO_CHAR(CREATED_AT, 'YYYY-MM') AS month, CEIL(TO_CHAR(CREATED_AT, 'DD') / 7) AS week_in_month, COUNT(*) AS post_count FROM boards WHERE CREATED_AT >= TRUNC(SYSDATE)-32 GROUP BY TO_CHAR(CREATED_AT, 'YYYY-MM'), CEIL(TO_CHAR(CREATED_AT, 'DD') / 7)	), board_total AS ( SELECT wg.month, wg.week_in_month, NVL(bc.post_count, 0) AS post_count FROM week_group wg LEFT JOIN board_count bc ON wg.month = bc.month AND wg.week_in_month = bc.week_in_month) SELECT * FROM ( SELECT * FROM board_total ORDER BY month DESC, week_in_month DESC ) WHERE ROWNUM < 6";

		//월간별
		String typeMonthSql = "WITH month_table AS ( SELECT ADD_MONTHS(TRUNC(SYSDATE, 'MM'), - (LEVEL - 1)) AS month_start FROM dual CONNECT BY LEVEL <= 6), board_count AS ( SELECT TRUNC(CREATED_AT, 'MM') AS month_start, COUNT(*) AS post_count FROM boards WHERE CREATED_AT >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -5) GROUP BY TRUNC(CREATED_AT, 'MM')) SELECT mt.month_start, NVL(bc.post_count, 0) AS post_count FROM month_table mt LEFT JOIN board_count bc ON mt.month_start = bc.month_start ORDER BY mt.month_start DESC";

		System.out.println(type +":타입");
		switch(type) {
		case("daily"):
			try(	
					Connection con = getConnection();
					PreparedStatement pstat = con.prepareStatement(typeDaySql); )
			{
				try(
						ResultSet result = pstat.executeQuery();)
				{
					List<Map<String,String>> list = new ArrayList<>();

					while(result.next())
					{
						String date = result.getString("day_date");
						String label = date.split(" ")[0];    
						label = label.replace("-", "/"); // "2025/08/23"

						String count = result.getString("post_count");

						Map<String,String> map = new HashMap<String,String>();
						map.put("label", label);
						map.put("data", count);
						list.add(map);
					}
					return list;		
				}		
			}
		case("weekly"):
			try(	
					Connection con = getConnection();
					PreparedStatement pstat = con.prepareStatement(typeWeekSql); )
			{
				try(
						ResultSet result = pstat.executeQuery();)
				{
					List<Map<String,String>> list = new ArrayList<>();

					while(result.next())
					{
						String month = result.getString("month");
						String label = month.split(" ")[0];    
						label = label.replace("-", "/"); // "2025/08/23"
						String week_in_month = result.getString("week_in_month");
						String post_count = result.getString("post_count");

						Map<String,String> map = new HashMap<String,String>();
						map.put("label", label+"/"+week_in_month+"주차");
						map.put("data", post_count);
						list.add(map);
					}

					return list;		
				}		
			}
		case("monthly"):
			try(	
					Connection con = getConnection();
					PreparedStatement pstat = con.prepareStatement(typeMonthSql); )
			{
				try(
						ResultSet result = pstat.executeQuery();)
				{
					List<Map<String,String>> list = new ArrayList<>();

					while(result.next())
					{
						String month_start = result.getString("month_start");
						String post_count = result.getString("post_count");
						
						String label = month_start.split(" ")[0];    
						label = label.replace("-", "/"); // "2025/08/23"
						label = label.substring(0, 7); // "2025/08"
						
						Map<String,String> map = new HashMap<String,String>();
						map.put("label", label);
						map.put("data", post_count);
						list.add(map);
					}

					return list;		
				}		
			}

		default:
			return null;
		}


	}


	public List<Map<String,String>> selectTop_Players(int game_seq) throws Exception{

		String sql = "SELECT userid, play_count FROM ( SELECT gr.userid, COUNT(*) AS play_count, ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn FROM gamerecords gr WHERE gr.game_seq = ? GROUP BY gr.userid)	WHERE rn <= 10";		
		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setInt(1, game_seq);
			try(
					ResultSet result = pstat.executeQuery();)
			{
				List<Map<String,String>> list = new ArrayList<>();

				while(result.next())
				{
					String userid = result.getString("userid");
					String play_count = result.getString("play_count");

					Map<String,String> map = new HashMap<String,String>();
					map.put("label", userid);
					map.put("data", play_count);
					list.add(map);


				}

				return list;		
			}		
		}
	}
}


// 게임별 게임 횟수 상위 10명 rownum 은 임시로 매겨진 행 번호
//SELECT userid, play_count
//FROM (
//    SELECT gr.userid,
//           COUNT(*) AS play_count,
//           ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
//    FROM gamerecords gr
//    WHERE gr.game_seq = '2'  -- 특정 게임 시퀀스
//    GROUP BY gr.userid
//)
//WHERE rn <= 10;
//
//
//// 전체 이용자 게임별 플레이 횟수 - 완
//SELECT g.title, NVL(tc.count, 0)
//FROM games g
//LEFT JOIN (
//    SELECT gr.game_seq, COUNT(*) AS count
//    FROM gamerecords gr
//    GROUP BY gr.game_seq
//) tc
//ON g.seq = tc.game_seq
//ORDER BY g.title;
//
//// 게시글 수
//// 일별
//-- 1. 최근 7일 날짜 테이블 생성 (CTE 사용)
//WITH week_table AS (
//    SELECT TRUNC(SYSDATE) - LEVEL + 1 AS day_date
//    FROM dual
//    CONNECT BY LEVEL <= 7
//)
//-- 2. 일별 게시글 수 계산
//SELECT w.day_date,
//       NVL(b.post_count, 0) AS post_count
//FROM week_table w
//LEFT JOIN (
//    SELECT TRUNC(created_at) AS created_day,
//           COUNT(*) AS post_count
//    FROM boards
//    WHERE created_at >= TRUNC(SYSDATE) - 6  -- 최근 7일
//    GROUP BY TRUNC(created_at)
//) b
//ON w.day_date = b.created_day
//ORDER BY w.day_date;
//
////주차별
//WITH week_table AS (
//	    SELECT TRUNC(SYSDATE) - LEVEL + 1 AS day_date
//	    FROM dual
//	    CONNECT BY LEVEL <= 31
//	),
//	week_group AS (
//	    SELECT TO_CHAR(day_date, 'YYYY-MM') AS month,
//	           CEIL(TO_CHAR(day_date, 'DD') / 7) AS week_in_month
//	    FROM week_table
//	    GROUP BY TO_CHAR(day_date, 'YYYY-MM'),
//	             CEIL(TO_CHAR(day_date, 'DD') / 7)
//	),
//	board_count AS (
//	    SELECT TO_CHAR(CREATED_AT, 'YYYY-MM') AS month,
//	           CEIL(TO_CHAR(CREATED_AT, 'DD') / 7) AS week_in_month,
//	           COUNT(*) AS post_count
//	    FROM boards
//	    WHERE CREATED_AT >= TRUNC(SYSDATE)-32
//	    GROUP BY TO_CHAR(CREATED_AT, 'YYYY-MM'),
//	             CEIL(TO_CHAR(CREATED_AT, 'DD') / 7)
//	),
//	board_total AS (
//	    SELECT wg.month,
//	           wg.week_in_month,
//	           NVL(bc.post_count, 0) AS post_count
//	    FROM week_group wg
//	    LEFT JOIN board_count bc
//	    ON wg.month = bc.month
//	    AND wg.week_in_month = bc.week_in_month
//	)
//	SELECT *
//	FROM (
//	    SELECT *
//	    FROM board_total
//	    ORDER BY month DESC, week_in_month DESC
//	)
//	WHERE ROWNUM < 6;
//
////월간별
//WITH month_table AS (
//	    -- 최근 6개월 생성
//	    SELECT ADD_MONTHS(TRUNC(SYSDATE, 'MM'), - (LEVEL - 1)) AS month_start
//	    FROM dual
//	    CONNECT BY LEVEL <= 6
//	),
//	board_count AS (
//	    -- 실제 게시글 수 집계
//	    SELECT TRUNC(CREATED_AT, 'MM') AS month_start,
//	           COUNT(*) AS post_count
//	    FROM boards
//	    WHERE CREATED_AT >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -5)
//	    GROUP BY TRUNC(CREATED_AT, 'MM')
//	)
//	SELECT mt.month_start,
//	       NVL(bc.post_count, 0) AS post_count
//	FROM month_table mt
//	LEFT JOIN board_count bc
//	ON mt.month_start = bc.month_start
//	ORDER BY mt.month_start DESC;
//
//
//// 가입자 수
////일별
//-- 1. 최근 7일 날짜 테이블 생성 (CTE 사용)
//WITH week_table AS (
//    SELECT TRUNC(SYSDATE) - LEVEL + 1 AS day_date
//    FROM dual
//    CONNECT BY LEVEL <= 7
//)
//-- 2. 일별 가입자 수 계산
//SELECT w.day_date,
//       NVL(b.post_count, 0) AS post_count
//FROM week_table w
//LEFT JOIN (
//    SELECT TRUNC(created_at) AS created_day,
//           COUNT(*) AS post_count
//    FROM members
//    WHERE created_at >= TRUNC(SYSDATE) - 6  -- 최근 7일
//    GROUP BY TRUNC(created_at)
//) b
//ON w.day_date = b.created_day
//ORDER BY w.day_date;
//
////주차별
//WITH week_table AS (
//	    SELECT TRUNC(SYSDATE) - LEVEL + 1 AS day_date
//	    FROM dual
//	    CONNECT BY LEVEL <= 31
//	),
//	week_group AS (
//	    SELECT TO_CHAR(day_date, 'YYYY-MM') AS month,
//	           CEIL(TO_CHAR(day_date, 'DD') / 7) AS week_in_month
//	    FROM week_table
//	    GROUP BY TO_CHAR(day_date, 'YYYY-MM'),
//	             CEIL(TO_CHAR(day_date, 'DD') / 7)
//	),
//	members_count AS (
//	    SELECT TO_CHAR(CREATED_AT, 'YYYY-MM') AS month,
//	           CEIL(TO_CHAR(CREATED_AT, 'DD') / 7) AS week_in_month,
//	           COUNT(*) AS post_count
//	    FROM members
//	    WHERE CREATED_AT >= TRUNC(SYSDATE)-32
//	    GROUP BY TO_CHAR(CREATED_AT, 'YYYY-MM'),
//	             CEIL(TO_CHAR(CREATED_AT, 'DD') / 7)
//	),
//	members_total AS (
//	    SELECT wg.month,
//	           wg.week_in_month,
//	           NVL(bc.post_count, 0) AS post_count
//	    FROM week_group wg
//	    LEFT JOIN members_count bc
//	    ON wg.month = bc.month
//	    AND wg.week_in_month = bc.week_in_month
//	)
//	SELECT *
//	FROM (
//	    SELECT *
//	    FROM members_total
//	    ORDER BY month DESC, week_in_month DESC
//	)
//	WHERE ROWNUM < 6;
////월간별
//WITH month_table AS (
//	    -- 최근 6개월 생성
//	    SELECT ADD_MONTHS(TRUNC(SYSDATE, 'MM'), - (LEVEL - 1)) AS month_start
//	    FROM dual
//	    CONNECT BY LEVEL <= 6
//	),
//	members_count AS (
//	    -- 실제 게시글 수 집계
//	    SELECT TRUNC(CREATED_AT, 'MM') AS month_start,
//	           COUNT(*) AS post_count
//	    FROM members
//	    WHERE CREATED_AT >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -5)
//	    GROUP BY TRUNC(CREATED_AT, 'MM')
//	)
//	SELECT mt.month_start,
//	       NVL(bc.post_count, 0) AS post_count
//	FROM month_table mt
//	LEFT JOIN members_count bc
//	ON mt.month_start = bc.month_start
//	ORDER BY mt.month_start DESC;
