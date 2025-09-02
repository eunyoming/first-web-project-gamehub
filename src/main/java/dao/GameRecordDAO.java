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

import dto.game.GameRecentDTO;
import dto.game.GameRecordDTO;

public class GameRecordDAO {
	
	private static GameRecordDAO instance;

	public synchronized static GameRecordDAO getInstance() {
		if(instance==null)
		{
			instance = new GameRecordDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	
	
	public List<GameRecordDTO> selectGameRecordsByRank(int game_seq)throws Exception {
		String sql = "SELECT * FROM ( SELECT game_seq,userId,Max(gameScore) AS gameScore, "
				+ "ROW_NUMBER() OVER (PARTITION BY game_seq ORDER BY Max(gameScore) DESC)"
				+ " AS rank FROM gameRecords GROUP BY game_seq, userId) "
				+ "WHERE rank <= 5 and game_seq = ?";
		try(Connection con = this.getConnection(); PreparedStatement pstat = con.prepareStatement(sql)){
			pstat.setInt(1, game_seq);
			try(ResultSet rs = pstat.executeQuery()){
				List<GameRecordDTO> list =  new ArrayList<>();
				while(rs.next()) {
					
					String userId = rs.getString("userId");
					int gameScore = rs.getInt("gameScore");
						
					GameRecordDTO dto = new GameRecordDTO(0,userId,game_seq,gameScore,null,null);
					list.add(dto);
					//game_seq , userId, gameScore ,rank
				}
				
				return list;
				
			}
		}
		
		
	}
	
		 public List<GameRecentDTO> selectGameRecordsByLoginId(String loginId)throws Exception{
//			 String sql = "SELECT * FROM (SELECT  g.title AS title, g.url AS gameIcon,\r\n"
//			 		+ "    FLOOR(\r\n"
//			 		+ "      (\r\n"
//			 		+ "        SUM(EXTRACT(SECOND FROM gr.gameEndTime)) +\r\n"
//			 		+ "        SUM(EXTRACT(MINUTE FROM gr.gameEndTime)) * 60 +\r\n"
//			 		+ "        SUM(EXTRACT(HOUR FROM gr.gameEndTime)) * 3600 +\r\n"
//			 		+ "        SUM(EXTRACT(DAY FROM gr.gameEndTime)) * 86400\r\n"
//			 		+ "      ) -\r\n"
//			 		+ "      (\r\n"
//			 		+ "        SUM(EXTRACT(SECOND FROM gr.gameStartTime)) +\r\n"
//			 		+ "        SUM(EXTRACT(MINUTE FROM gr.gameStartTime)) * 60 +\r\n"
//			 		+ "        SUM(EXTRACT(HOUR FROM gr.gameStartTime)) * 3600 +\r\n"
//			 		+ "        SUM(EXTRACT(DAY FROM gr.gameStartTime)) * 86400\r\n"
//			 		+ "      )\r\n"
//			 		+ "    ) AS totalplaytime,\r\n"
//			 		+ "    -- 마지막 플레이 날짜 (MM월 DD일 형식)\r\n"
//			 		+ "    TO_CHAR(MAX(gr.gameEndTime), 'MM\"월\" DD\"일\"') AS recentPlayedDate\r\n"
//			 		+ "  FROM gameRecords gr\r\n"
//			 		+ "  JOIN games g ON gr.game_seq = g.seq\r\n"
//			 		+ "  WHERE gr.userId = ?\r\n"
//			 		+ "  GROUP BY g.seq, g.title, g.url\r\n"
//			 		+ "  ORDER BY MAX(gr.gameEndTime) DESC\r\n"
//			 		+ ")\r\n"
//			 		+ "WHERE ROWNUM <= 3";
			 String sql ="SELECT title, gameIcon,\r\n"
			 		+ "  FLOOR(totalplaytime / 3600) || '시간 ' || FLOOR(MOD(totalplaytime, 3600) / 60) || '분' AS totalplaytime,\r\n"
			 		+ "  recentPlayedDate\r\n"
			 		+ "FROM (\r\n"
			 		+ "  SELECT  \r\n"
			 		+ "    g.title AS title,\r\n"
			 		+ "    g.url AS gameIcon,\r\n"
			 		+ "    -- 초 단위로 총 플레이 시간 계산\r\n"
			 		+ "    FLOOR((\r\n"
			 		+ "      SUM(\r\n"
			 		+ "        (CAST(gr.gameEndTime AS DATE) - CAST(gr.gameStartTime AS DATE)) * 86400\r\n"
			 		+ "      )\r\n"
			 		+ "    )) AS totalplaytime,\r\n"
			 		+ "    TO_CHAR(MAX(gr.gameEndTime), 'MM\"월\" DD\"일\"') AS recentPlayedDate\r\n"
			 		+ "  FROM gameRecords gr\r\n"
			 		+ "  JOIN games g ON gr.game_seq = g.seq\r\n"
			 		+ "  WHERE gr.userId = ?\r\n"
			 		+ "  GROUP BY g.seq, g.title, g.url\r\n"
			 		+ "  ORDER BY MAX(gr.gameEndTime) DESC\r\n"
			 		+ ")\r\n"
			 		+ "WHERE ROWNUM <= 3";
			 
			 
			 try(Connection con = this.getConnection(); PreparedStatement pstat = con.prepareStatement(sql)){
					pstat.setString(1, loginId);
					try(ResultSet rs = pstat.executeQuery()){
						List<GameRecentDTO> list =  new ArrayList<>();
						while(rs.next()) {
							
							String title = rs.getString("title");
							String url = rs.getString("gameIcon");
							String totalplaytime = rs.getString("totalplaytime");
							String recentPlayedDate = rs.getString("recentPlayedDate");
							
							
							GameRecentDTO gameRecentDTO = new GameRecentDTO(title,url,totalplaytime,recentPlayedDate);
							list.add(gameRecentDTO);
							//game_seq , userId, gameScore ,rank
						}
						
						return list;
						
					}
				}
			 
		 }
	
	
	
	public int insertGameRecords(GameRecordDTO dto)throws Exception{
		String sql = "insert into gameRecords values (gameRecords_seq.nextval,?,?,?,?,?)";
		try(Connection con = this.getConnection(); PreparedStatement pstat = con.prepareStatement(sql)){
			pstat.setString(1,dto.getUserId());
			pstat.setInt(2,dto.getGame_seq());
			pstat.setInt(3,dto.getGameScore());
			pstat.setTimestamp(4,dto.getGameStartTime());
			pstat.setTimestamp(5,dto.getGameEndTime());
			int result = pstat.executeUpdate();
			return result;
		}
				//insert into gameRecords values (gameRecords_seq.nextval,userId,game_seq,gameStartTime,gameEndTime)
	}
	//insert 만들기  -- gamerecord에서 입력된 데이터를 

}
