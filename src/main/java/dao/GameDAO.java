package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.game.GameDTO;
public class GameDAO {
//대상 DTO : GameDTO, GameRecordDTO, 
	/*
	 * 테이블에 대한 데이터 접근 및 조작. 게임 정보 조회, 게임 기록 저장/조회, 랭킹 조회 등을 담당합니다.
	 * 
	 */
	private static GameDAO instance;

	public synchronized static GameDAO getInstance() {
		if (instance == null) {
			instance = new GameDAO();
		}
		return instance;
	}

	public Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	public GameDTO selectGamesBySeq(int seq) throws Exception {
		String sql = "select * from games where seq = ?";
		try (Connection con = this.getConnection(); PreparedStatement pstat = con.prepareStatement(sql)) {
			pstat.setInt(1, seq);
			try (ResultSet rs = pstat.executeQuery()) {
				if (rs.next()) {
					String title = rs.getString("title");
					String content = rs.getString("content");
					String url = rs.getString("url");
					String creator = rs.getString("creator");

					GameDTO dto = new GameDTO(seq,title,content,url,creator);
					return dto;
				}
				return null;

			}
		}
	}
	
	public List<GameDTO> getAllGames() throws Exception{
		List<GameDTO> result = new ArrayList<GameDTO>();
		String sql = "select * from games";
		try (Connection con = this.getConnection(); 
				PreparedStatement pstat = con.prepareStatement(sql);
						ResultSet rs = pstat.executeQuery();) {	
			
			while(rs.next()) {
				int seq = rs.getInt("seq");
				String title = rs.getString("title");
				String content = rs.getString("content");
				String url = rs.getString("url");
				String creator = rs.getString("creator");

				GameDTO dto = new GameDTO(seq,title,content,url,creator);
				result.add(dto);
			
		}
		
			return result;
			
		}
		
		
	}
	

//	[ 우리끼리의 DAO 메서드명 컨벤션 ]
	// ( select )
	// - select * from 테이블명
	// selectAll테이블명
	//
	// - select * from 테이블명 where id = ?
	// select테이블명By조건필드명
	//
	// ( insert )
	// insert 테이블명
	//
	// ( delete )
	// delete테이블명By조건필드명
	//
	// ( update )
	// update테이블명By조건필드명
	//
	// ( Connection )
	// getConnection();
	//
	// ( DAO instance )
	// // 멤버필드
	// private static DAO명 instance;
	// // 기본 생성자 막기
	// private DAO명(){};
	// // DAO getter
	// public synchronized static DAO명 getInstance(){};

}
