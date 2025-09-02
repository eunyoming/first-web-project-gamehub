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

import commons.Config;
import dto.board.BoardDTO;
import dto.board.PageNaviDTO;



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
	public int insertBoards(BoardDTO dto) throws Exception {
		String sql = "insert into boards values (boards_seq.nextval, ?, ?, ?, ?, ?, 0, 0, 'public', sysdate)";

		try (Connection con = getConnection();
				PreparedStatement ps = con.prepareStatement(sql, new String[]{"seq"})) {

			ps.setString(1, dto.getWriter());
			ps.setString(2, dto.getTitle());
			ps.setString(3, dto.getContents());
			ps.setString(4, dto.getCategory());
			ps.setString(5, dto.getRefgame());

			int result = ps.executeUpdate();

			if(result != 0) {
				// 생성된 seq 가져오기
				try (ResultSet rs = ps.getGeneratedKeys()) {
					if (rs.next()) {
						return rs.getInt(1);  // 방금 insert된 seq
					}
				}
			}
			return 0;
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

	// update by seq set title, contents, category, refgame
	public int updateBoardsBySeq(int seq, String title, String contents, String category, String refgame) throws Exception{
		String sql = "update boards set title = ?, contents = ?, category = ?, refgame = ? where seq = ?";
		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql);){
			pst.setString(1, title);
			pst.setString(2, contents);
			pst.setString(3, category);
			pst.setString(4, refgame);
			pst.setInt(5, seq);

			return pst.executeUpdate();
		}
	}

	// select * from boards order by seq desc";
	public List<BoardDTO> selectAllBoards() throws Exception{
		String sql = "select * from boards where visibility = 'public' order by seq desc";
		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql);
				ResultSet rs = pst.executeQuery();){

			List<BoardDTO> list = new ArrayList<>();
			while(rs.next()) {

				int seq = rs.getInt("seq");
				String writer = rs.getString("writer");
				String title = rs.getString("title");
				String contents = rs.getString("contents");
				String category = rs.getString("category");
				String refgame = rs.getString("refgame");
				int viewCount = rs.getInt("viewCount");
				int likeCount = rs.getInt("likeCount");
				String visibility = rs.getString("visibility");
				Timestamp created_at = rs.getTimestamp("created_at");

				BoardDTO dto = new BoardDTO(seq, writer, title, contents, category, refgame, viewCount, likeCount, visibility, created_at);
				list.add(dto);
			}
			return list;
		}
	}

	// selectFromToBoards / 원하는 게시물 수 만큼 가져오기.
	public List<BoardDTO> selectFromToBoards(int from, int to) throws Exception{
		String sql = "select * from (select boards.*,  row_number() over(order by seq desc) rn "
				+ "from boards where visibility = 'public') where rn between ? and ? order by 1 desc";

		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql)){
			pst.setInt(1, from);
			pst.setInt(2, to);

			try(ResultSet rs = pst.executeQuery()){

				List<BoardDTO> list = new ArrayList<>();

				while(rs.next()) {
					int seq = rs.getInt("seq");
					String writer = rs.getString("writer");
					String title = rs.getString("title");
					String contents = rs.getString("contents");
					String category = rs.getString("category");
					String refgame = rs.getString("refgame");
					int viewCount = rs.getInt("viewCount");
					int likeCount = rs.getInt("likeCount");
					String visibility = rs.getString("visibility");
					Timestamp created_at = rs.getTimestamp("created_at");

					BoardDTO dto = new BoardDTO(seq, writer, title, contents, category, refgame, viewCount, likeCount, visibility, created_at);
					list.add(dto);
				}
				return list;
			}
		}
	}

	// select * from boards where seq = ?
	public BoardDTO selectBoardsBySeq(int seq) throws Exception{
		String sql = "select * from boards where seq = ? and visibility = 'public'";
		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql);){

			pst.setInt(1, seq);

			try(ResultSet rs = pst.executeQuery();){
				while(rs.next()) {
					seq = rs.getInt("seq");
					String writer = rs.getString("writer");
					String title = rs.getString("title");
					String contents = rs.getString("contents");
					String category = rs.getString("category");
					String refgame = rs.getString("refgame");
					int viewCount = rs.getInt("viewCount");
					int likeCount = rs.getInt("likeCount");
					String visibility = rs.getString("visibility");
					Timestamp created_at = rs.getTimestamp("created_at");

					BoardDTO dto = new BoardDTO(seq, writer, title, contents, category, refgame, viewCount, likeCount, visibility, created_at);
					return dto;
				}
				return null;
			}
		}
	}

	// 총 글 개수 : getRecordTotalCount()
	public int getRecordTotalCount() throws Exception{
		String sql = "select count(*) from boards";
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);
				ResultSet rs = pstat.executeQuery();) {

			rs.next();
			return rs.getInt("count(*)");
		}
	}

	// page Navi
	public PageNaviDTO getPageNavi(int currentPage) throws Exception{
		// 1. 전체 레코드가 몇 개인지?
		int recordTotalCount = this.getRecordTotalCount();

		// 2. 한 페이지 당 몇개의 게시글을 보여줄지?
		int recordCountPerPage = Config.RECORD_COUNT_PER_PAGE;

		// 3. 한 번에 네비게이터를 몇개씩 보여줄지?
		int naviCountPerPage = Config.NAVI_COUNT_PER_PAGE;

		// 4. 전체 몇 페이지가 생성 될 지?
		int pageTotalCount = 0;
		if(recordTotalCount % recordCountPerPage > 0) { // 나머지가 있으면
			pageTotalCount = (recordTotalCount / recordCountPerPage) + 1;

		}else { // 딱 떨어지면
			pageTotalCount = recordTotalCount / recordCountPerPage;
		}

		// 현재 내가 클릭해 둔 페이지
		if(currentPage < 1) { // 혹시 모르는 음수 값 막기
			currentPage = 1;
		}else if(currentPage > pageTotalCount) { // 전체 페이지보다 큰 수 막기
			currentPage = pageTotalCount;
		}

		// 네비게이터의 시작 값
		int startNavi = (currentPage-1) / naviCountPerPage * naviCountPerPage + 1;
		// 일의 자리를 잘라내는 효과

		// 네비게이터의 끝 값
		int endNavi = startNavi + (naviCountPerPage - 1);

		if(endNavi > pageTotalCount) { // 전체 페이지 값보다 클 수 없으므로
			endNavi = pageTotalCount;
		}
		boolean jumpPrev = true;
		boolean needPrev = true;
		boolean jumpNext = true;
		boolean needNext = true;

		if(startNavi == 1) { // 시작페이지가 1 이라면	
			jumpPrev = false;
			needPrev = false;
		}
		if(endNavi == pageTotalCount) { // 끝 페이지가 총 페이지와 같다면
			jumpNext = false;
		}

		// 총 페이지가 한 페이지일 경우
		if (pageTotalCount <= naviCountPerPage) {
			jumpPrev = false;
			jumpNext = false;
			needPrev = false;
			needNext = false;
		} else { // 마지막 전 페이지까지
			needNext = currentPage < pageTotalCount;
		}

		PageNaviDTO dto = new PageNaviDTO(startNavi, endNavi, jumpPrev, needPrev, jumpNext, needNext, currentPage, pageTotalCount);

		// 계산만 수행하고 결과 객체로 반환
		return dto;
	}

}
