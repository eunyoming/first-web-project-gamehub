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
	
	public List<GameRecordDTO> selectGameRecords(int game_seq)throws Exception {
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

}
