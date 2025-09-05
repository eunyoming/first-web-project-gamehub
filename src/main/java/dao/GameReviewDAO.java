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

import dto.game.GameReviewDTO;

public class GameReviewDAO {
	//대상 DTO : GameReviewDTO  
	/*
	 * 게임 리뷰 제거하기, 
	 * 게임 리뷰 목록 불러오기, 
	 * 게임 리뷰 작성하기,
	 * 게임 리뷰 수정하기.
	 */

	private static GameReviewDAO instance;

	public synchronized static GameReviewDAO getInstance() {
		if(instance==null)
		{
			instance = new GameReviewDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	public List<GameReviewDTO> selectGameReviewsByGame_seq(int game_seq) throws Exception {
		String sql = "select * from gameReviews where game_seq = ? order by created_at desc";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{

			pstat.setInt(1, game_seq);

			try(
					ResultSet result = pstat.executeQuery();)
			{
				List<GameReviewDTO> list = new ArrayList<>();
				
				while(result.next())
				{
					int seq = result.getInt("seq");
					String writer = result.getString("writer");
					String title = result.getString("title");
					String content = result.getString("content");
					int rating = result.getInt("rating");
					Timestamp timestamp =result.getTimestamp("created_at");
					
					GameReviewDTO dto = new GameReviewDTO(seq,writer,title,content,game_seq,rating,timestamp);

					list.add(dto);
				}
				
				return list;		
			}
			
		}
	}
	public GameReviewDTO selectGameReviewsBygame_seqAndWriter(int game_seq, String writer) throws Exception {
		String sql = "select * from gameReviews where game_seq = ? and writer = ? order by created_at desc";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setInt(1, game_seq);
			pstat.setString(2, writer);
			try(
					ResultSet result = pstat.executeQuery();)
			{
				if(result.next())
				{
					
					String title = result.getString("title");
					String content = result.getString("content");
					int rating = result.getInt("rating");
					return new GameReviewDTO(0,writer,title,content,game_seq,rating,null);
				}
				else
				{
					return null;
				}
			}
		}
	}
	public int insertGameReviews(GameReviewDTO gameReviewDTO) throws Exception{

		String sql = "insert into GameReviews values(GameReviews_seq.nextval,?,?,?,?,?,sysdate)";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setString(1, gameReviewDTO.getWriter());
			pstat.setString(2, gameReviewDTO.getTitle());
			pstat.setString(3, gameReviewDTO.getContent());
			pstat.setInt(4, gameReviewDTO.getGame_seq());
			pstat.setInt(5,gameReviewDTO.getRating());
			
			int result = pstat.executeUpdate();
			
			System.out.println("리뷰 작성 dao 까지 왔어요");
			return result;
		}
	}
	
	public int deleteGameReviewsBygame_seqAndWriter(int game_seq, String writer) throws Exception{
		String sql = "delete from gamereviews where game_seq = ? and writer = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			
			pstat.setInt(1, game_seq);
			pstat.setString(2, writer);
			
			int result = pstat.executeUpdate();
			System.out.println("리뷰제거까지 왔어요");
			return result;
		}
		
	}
	
	public int updateGameReviewsBygame_seqAndWriter(GameReviewDTO gameReviewDTO) throws Exception{
		String sql = "update gamereviews set title= ?,content=?,rating= ? where game_seq = ? and writer = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			
			pstat.setString(1, gameReviewDTO.getTitle());
			pstat.setString(2, gameReviewDTO.getContent());
			pstat.setInt(3, gameReviewDTO.getRating());
			pstat.setInt(4, gameReviewDTO.getGame_seq());
			pstat.setString(5, gameReviewDTO.getWriter());
			
			int result = pstat.executeUpdate();
			System.out.println("리뷰 업데이트 까지 왔어요");
			return result;
		}
		
	}
	//	[ 우리끼리의 DAO 메서드명 컨벤션 ]
	//			( select )
	//			- select * from 테이블명
	//			selectAll테이블명
	//
	//			- select * from 테이블명 where id = ?
	//			select테이블명By조건필드명
	//
	//			( insert )
	//			insert테이블명
	//
	//			( delete )
	//			delete테이블명By조건필드명
	//
	//			( update )
	//			update테이블명By조건필드명
	//
	//			( Connection )
	//			getConnection();
	//
	//			( DAO instance )
	//			// 멤버필드
	//			private static DAO명 instance;
	//			// 기본 생성자 막기
	//			private DAO명(){};
	//			// DAO getter
	//			public synchronized static DAO명 getInstance(){};

}
