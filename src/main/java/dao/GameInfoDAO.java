package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.game.GameDTO;
import dto.game.GameInfoDTO;

public class GameInfoDAO {

	private static GameInfoDAO instance;

	public synchronized static GameInfoDAO getInstance() {
		if (instance == null) {
			instance = new GameInfoDAO();
		}
		return instance;
	}

	public Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

//	public int updateGameInfoBySeq(GameInfoDTO gameInfoDTO) throws Exception {	
//		
//		String sql = "update gameinfo set guide  = ?  where seq = ?";
//		try (Connection con = this.getConnection(); PreparedStatement pstat = con.prepareStatement(sql)) {
//			pstat.setString(1, gameInfoDTO.getGuide());
//
//			pstat.setInt(2, gameInfoDTO.getSeq());
//			int result = pstat.executeUpdate();
//			return result;
//		}
//	}
	
	public boolean updateGameComment(int seq, String comment) throws Exception {
		String sql = "update gameInfo set CREATORCOMMENT = ? where seq = ?";
		try (Connection con = this.getConnection(); 
				PreparedStatement pstat = con.prepareStatement(sql)) {
			pstat.setString(1, comment);
			pstat.setInt(2, seq);
			
			return pstat.executeUpdate() >0;
		}
	}
	
	
	public boolean updateGuide(int seq, String guide) throws Exception  {
		String sql = "update gameInfo set guide = ? where seq = ?";
		try (Connection con = this.getConnection(); 
				PreparedStatement pstat = con.prepareStatement(sql)) {
			pstat.setString(1, guide);
			pstat.setInt(2, seq);
			
			return pstat.executeUpdate() >0;
		}
	}

	public GameInfoDTO selectGameInfoBySeq(int game_seq) throws Exception {
		String sql = "select * from gameInfo where seq = ?";
		try (Connection con = this.getConnection(); PreparedStatement pstat = con.prepareStatement(sql)) {
			pstat.setInt(1, game_seq);
			try (ResultSet rs = pstat.executeQuery()) {
				if (rs.next()) {
					String screenshot = rs.getString("screenshot");
					String creator = rs.getString("creator");
					String creatorComment = rs.getString("creatorComment");
					String guide = rs.getString("guide");

					GameInfoDTO gameInfoDTO = new GameInfoDTO(game_seq, screenshot, creator, creatorComment, guide);
					return gameInfoDTO;
				}
				return null;

			}
		}
	}

}
