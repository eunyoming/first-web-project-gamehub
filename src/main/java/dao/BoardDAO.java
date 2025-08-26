package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.board.BoardDTO;



public class BoardDAO {
	//대상 DTO : BoardDTO, ReplyDTO, BookmarkDTO
	/*boards, replys, bookmark 테이블에 대한 데이터 접근 및 조작. 
	 * 게시글 목록/상세 조회, 작성, 수정, 삭제, 
	 * 댓글 관리, 북마크 추가/삭제 등을 담당합니다.
	 */
	private static BoardDAO instance;

	private BoardDAO() {}

	// getInstance
	public synchronized static BoardDAO getInstance() {
		if(instance == null) {
			instance = new BoardDAO();
		}
		return instance;
	}

	// getConnection
	public Connection getConnection() throws Exception{
		Context cxt = new InitialContext();

		DataSource ds = (DataSource)cxt.lookup("java:comp/env/jdbc/oracle");

		return ds.getConnection();
	}

	// insert
	public int insertBoards(BoardDTO dto) throws Exception{
		String sql = "insert to boards values (boards_seq.nextval, ?, ?, ?, ?, ?, ?, ?, default, sysdate)";

		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql);){
			pst.setString(1, dto.getWriter());
			pst.setString(2, dto.getTitle());
			pst.setString(3, dto.getContents());
			pst.setString(4, dto.getCategory());
			pst.setString(5, dto.getRefgame());
			pst.setInt(6, dto.getViewCount());
			pst.setInt(7, dto.getLikeCount());

			return pst.executeUpdate();
		}
	}

	// delete by seq ( 작성자 본인이 본인글 삭제시 )
	public int deleteBoardsBySeq(int seq) throws Exception{
		String sql = "delete from boards where seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql);){
			pst.setInt(1, seq);

			return pst.executeUpdate();
		}
	}

	// update by seq set title, cntents, category
	public int updateBoardsBySeq(String title, String contents, String category, int seq) throws Exception{
		String sql = "update boards set title = ?, contents = ?, category = ? where seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql);){
			pst.setString(1, title);
			pst.setString(2, contents);
			pst.setString(3, category);
			pst.setInt(4, seq);

			return pst.executeUpdate();
		}
	}

}
