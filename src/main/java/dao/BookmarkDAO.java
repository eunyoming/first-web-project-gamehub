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
import dto.board.ReplyDTO;

public class BookmarkDAO {

	private static BookmarkDAO instance;

	public synchronized static BookmarkDAO getInstance() {
		if(instance==null)
		{
			instance = new BookmarkDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	public List<BoardDTO> selectBookmarkJoinBoardsByUserId(String userId) throws Exception {
		String sql = "SELECT b.*, bm.userid, bm.seq as bookmark_seq FROM bookmark bm JOIN boards b ON bm.board_seq = b.seq WHERE bm.userid = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			System.out.println(userId +"유저아이디");
			pstat.setString(1, userId);
			try(
					ResultSet result = pstat.executeQuery();)
			{
				List<BoardDTO> list = new ArrayList<>();
				
				while(result.next())
				{
					int seq = result.getInt("seq");
					String writer = result.getString("writer");
					String title = result.getString("title");
					String contents = result.getString("contents");

					Timestamp timestamp =result.getTimestamp("created_at");
					//visibility 삭제를 안하고 신고가 들어오면 숨김처리 해주는 숨김표시
					BoardDTO dto = new BoardDTO(seq,writer,title,contents,"","",0,0,"",timestamp);

					list.add(dto);
				}
				System.out.println("북마크 글 list");
				return list;		
			}

		}

	}

	public List<BoardDTO> selectBoardsByWriter(String userId) throws Exception {
		String sql = "select * from boards where writer = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setString(1, userId);
			try(
					ResultSet result = pstat.executeQuery();)
			{
				List<BoardDTO> list = new ArrayList<>();

				while(result.next())
				{
					System.out.println("board들어옴");
					int seq = result.getInt("seq");
					String writer = result.getString("writer");
					String title = result.getString("title");
					String contents = result.getString("contents");

					Timestamp timestamp =result.getTimestamp("created_at");
					//visibility 삭제를 안하고 신고가 들어오면 숨김처리 해주는 숨김표시
					BoardDTO dto = new BoardDTO(seq,writer,title,contents,"","",0,0,"",timestamp);

					list.add(dto);
				}
				System.out.println("보드 list");
				return list;		
			}

		}
	}

	public List<ReplyDTO> selectReplysByWriter(String userId) throws Exception {
		String sql = "select * from replys where Writer = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setString(1, userId);
			try(
					ResultSet result = pstat.executeQuery();)
			{
				List<ReplyDTO> list = new ArrayList<>();

				while(result.next())
				{
					int seq = result.getInt("seq");
					String writer = result.getString("writer");
					String contents = result.getString("contents");
					int board_seq = result.getInt("board_seq");

					Timestamp timestamp =result.getTimestamp("created_at");

					ReplyDTO dto = new ReplyDTO(seq,writer,contents,board_seq,timestamp);

					list.add(dto);
				}
				System.out.println("댓글 list");
				return list;		
			}

		}
	}
	
	
	public int deleteBookmarkByBoard_seqAndUserId(int board_seq, String userId) throws Exception{
		String sql = "delete from bookmark where board_seq = ? and userId = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			
			pstat.setInt(1, board_seq);
			pstat.setString(2, userId);
			
			int result = pstat.executeUpdate();
			System.out.println("북마크제거까지 왔어요");
			return result;
		}
		
	}
	
	

}
