package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.board.BoardDTO;
import dto.board.BookmarkDTO;
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
		String sql = "select * from replies where Writer = ?";

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
	
	// insert
	public int insertBookmark(BookmarkDTO dto) throws Exception{
		String sql = "insert into bookmark values(bookmark_seq.nextval,?,?)";
		
		try (Connection con = getConnection();
				PreparedStatement ps = con.prepareStatement(sql);) {
			
			ps.setString(1, dto.getUserId());
			ps.setInt(2, dto.getBoard_seq());

			return ps.executeUpdate();
		} catch (SQLIntegrityConstraintViolationException e) {
            // UNIQUE 제약조건 위반 → 이미 북마크된 상태
            return 0; 
        }		
	}
	
	// 북마크 삭제
    public int deleteBookmark(String userId, int boardSeq) throws Exception {
        String sql = "delete from bookmark where userId = ? and board_seq = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setInt(2, boardSeq);
            return ps.executeUpdate();
        }
    }

    // 북마크 여부 확인
    public boolean isBookmarked(String userId, int boardSeq) throws Exception {
        String sql = "select count(*) from bookmark where userId = ? and board_seq = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setInt(2, boardSeq);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
                return false;
            }
        }
    }
}
