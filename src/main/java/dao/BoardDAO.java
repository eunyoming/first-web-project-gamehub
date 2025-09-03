package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
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

		// 카테고리 선택 안 했을 시 - 기본 : 자유
		if(dto.getCategory() == null || dto.getCategory().trim().equals("")) {
			dto.setCategory("자유"); // 기본값
		}

		// 게임 선택 안 했을 시 - 전체로 넣기
		if(dto.getRefgame() == null || dto.getRefgame().trim().equals("")) {
			dto.setRefgame("전체"); 
		}

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

	// 게시글 본문 수정
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

	// 추천수 수정
	public int updateBoardsLikeCount(int board_seq, int likeCount) throws Exception {
		String sql = "UPDATE boards SET likeCount = ? WHERE seq = ?";
		try (Connection conn = getConnection();
				PreparedStatement pst = conn.prepareStatement(sql)) {
			pst.setInt(1, likeCount);
			pst.setInt(2, board_seq);
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
	// 검색 필터 추가 ( 제목, 작성자, 본문 - 대소문자 구분 x )
	// 카테고리, 관련 게임 필터링도 추가
	public List<BoardDTO> selectFromToBoards(int start, int end, String category, String refgame, String search) {
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT * FROM ( ");
		sql.append("  SELECT rownum rnum, a.* FROM ( ");
		sql.append("    SELECT b.seq, b.writer, b.title, b.category, b.refgame, ");
		sql.append("           b.viewCount, b.likeCount, b.created_at, ");
		sql.append("           (SELECT COUNT(*) FROM replies r WHERE r.board_seq = b.seq) AS replyCount ");
		sql.append("    FROM boards b ");
		sql.append("    WHERE b.visibility = 'public' ");

		// ✅ 동적 조건 추가
		if (category != null && !category.isEmpty()) {
			sql.append("AND b.category = ? ");
		}
		if (refgame != null && !refgame.isEmpty()) {
			sql.append("AND b.refgame = ? ");
		}
		if (search != null && !search.isEmpty()) {
			sql.append("AND (LOWER(b.title) LIKE ? OR LOWER(b.writer) LIKE ? OR LOWER(b.contents) LIKE ?) ");
		}

		sql.append("    ORDER BY b.created_at DESC ");
		sql.append("  ) a ");
		sql.append(") WHERE rnum BETWEEN ? AND ?");

		try (Connection con = getConnection();
				PreparedStatement pst = con.prepareStatement(sql.toString())) {

			int idx = 1;

			// 조건 파라미터 세팅
			if (category != null && !category.isEmpty()) {
				pst.setString(idx++, category);
			}
			if (refgame != null && !refgame.isEmpty()) {
				pst.setString(idx++, refgame);
			}
			if (search != null && !search.isEmpty()) {
				String likeSearch = "%" + search.toLowerCase() + "%"; // 🔽 소문자로 변환
				pst.setString(idx++, likeSearch); // title
				pst.setString(idx++, likeSearch); // writer
				pst.setString(idx++, likeSearch); // contents
			}

			// 페이징
			pst.setInt(idx++, start);
			pst.setInt(idx, end);

			try (ResultSet rs = pst.executeQuery()) {
				List<BoardDTO> list = new ArrayList<>();
				while (rs.next()) {
					BoardDTO dto = new BoardDTO();
					dto.setSeq(rs.getInt("seq"));
					dto.setWriter(rs.getString("writer"));
					dto.setTitle(rs.getString("title"));
					dto.setCategory(rs.getString("category"));
					dto.setRefgame(rs.getString("refgame"));
					dto.setViewCount(rs.getInt("viewCount"));
					dto.setLikeCount(rs.getInt("likeCount"));
					dto.setCreated_at(rs.getTimestamp("created_at"));
					dto.setReplyCount(rs.getInt("replyCount"));
					list.add(dto);
				}
				return list;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return Collections.emptyList();
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

	// getRecordTotalCount() 오버로딩
	// 조건에 맞는 총 글 개수
	public int getRecordTotalCount(String category, String refgame, String search) throws Exception {
		StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM boards b WHERE b.visibility = 'public' ");

		if (category != null && !category.isEmpty()) {
			sql.append("AND b.category = ? ");
		}
		if (refgame != null && !refgame.isEmpty()) {
			sql.append("AND b.refgame = ? ");
		}
		if (search != null && !search.isEmpty()) {
			sql.append("AND (LOWER(b.title) LIKE ? OR LOWER(b.writer) LIKE ? OR LOWER(b.contents) LIKE ?) ");
		}

		try (Connection con = getConnection();
				PreparedStatement pst = con.prepareStatement(sql.toString())) {

			int idx = 1;
			if (category != null && !category.isEmpty()) {
				pst.setString(idx++, category);
			}
			if (refgame != null && !refgame.isEmpty()) {
				pst.setString(idx++, refgame);
			}
			if (search != null && !search.isEmpty()) {
				String likeSearch = "%" + search.toLowerCase() + "%";
				pst.setString(idx++, likeSearch);
				pst.setString(idx++, likeSearch);
				pst.setString(idx++, likeSearch);
			}

			try (ResultSet rs = pst.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		}
		return 0;
	}

	// 총 공개글 개수 : getRecordTotalCount()
	public int getPublicRecordTotalCount() throws Exception{
		String sql = "select count(*) from boards where visibility = 'public'";
		try (Connection con = this.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);
				ResultSet rs = pstat.executeQuery();) {

			rs.next();
			return rs.getInt("count(*)");
		}
	}

	// PageNavi
	public PageNaviDTO getPageNavi(int currentPage) throws Exception{
		// 1. 전체 공개 레코드가 몇 개인지?
		int recordTotalCount = this.getPublicRecordTotalCount();

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

	// PageNavi 오버로딩
	public PageNaviDTO getPageNavi(int currentPage, int recordTotalCount) throws Exception {
		int recordCountPerPage = Config.RECORD_COUNT_PER_PAGE;
		int naviCountPerPage = Config.NAVI_COUNT_PER_PAGE;

		int pageTotalCount = (recordTotalCount + recordCountPerPage - 1) / recordCountPerPage;

		if (currentPage < 1) currentPage = 1;
		else if (currentPage > pageTotalCount) currentPage = pageTotalCount;

		int startNavi = (currentPage - 1) / naviCountPerPage * naviCountPerPage + 1;
		int endNavi = startNavi + (naviCountPerPage - 1);

		if (endNavi > pageTotalCount) endNavi = pageTotalCount;

		boolean jumpPrev = startNavi > 1;
		boolean needPrev = startNavi > 1;
		boolean jumpNext = endNavi < pageTotalCount;
		boolean needNext = currentPage < pageTotalCount;

		return new PageNaviDTO(startNavi, endNavi, jumpPrev, needPrev, jumpNext, needNext, currentPage, pageTotalCount);
	}

	// 조회수 증가
	public int updateBoardsViewCount(int seq) throws Exception {
		String sql = "UPDATE boards SET viewCount = viewCount + 1 WHERE seq = ?";
		try (Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql)) {
			pstat.setInt(1, seq);
			return pstat.executeUpdate();
		}
	}

	// 댓글수 가져오기
	public int selectRepliesReplyCount(int board_seq) throws Exception {
		String sql = "SELECT COUNT(*) FROM replies WHERE board_seq = ? and visibility = 'public'";
		try (Connection con = getConnection();
				PreparedStatement pst = con.prepareStatement(sql)) {
			pst.setInt(1, board_seq);
			try (ResultSet rs = pst.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		}
		return 0;
	}

	// ------------ Q&A 전용 --------- 
	// Q&A 목록 가져오기
	public List<BoardDTO> selectQnaList(String loginId, String userCategory, int start, int end) throws Exception {
	    String sql;
	    if ("manager".equalsIgnoreCase(userCategory)) { // 관리자 → 전체 조회
	        sql = "SELECT * FROM boards " +
	              "WHERE category = 'Q&A' " +
	              "ORDER BY seq DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
	    } else { // 일반 유저 → 자기 글만 조회
	        sql = "SELECT * FROM boards " +
	              "WHERE category = 'Q&A' AND writer = ? " +
	              "ORDER BY seq DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
	    }

	    try (Connection con = getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	    	if ("manager".equalsIgnoreCase(userCategory)) {
	            ps.setInt(1, start);
	            ps.setInt(2, Config.RECORD_COUNT_PER_PAGE);
	        } else {
	            ps.setString(1, loginId);
	            ps.setInt(2, start);
	            ps.setInt(3, Config.RECORD_COUNT_PER_PAGE);
	        }

	        try (ResultSet rs = ps.executeQuery()) {
	            List<BoardDTO> list = new ArrayList<>();
	            while (rs.next()) {
	                BoardDTO dto = new BoardDTO();
	                dto.setSeq(rs.getInt("seq"));
	                dto.setWriter(rs.getString("writer"));
	                dto.setTitle(rs.getString("title"));
	                dto.setContents(rs.getString("contents"));
	                dto.setCategory(rs.getString("category"));
	                dto.setRefgame(rs.getString("refgame"));
	                dto.setViewCount(rs.getInt("viewCount"));
	                dto.setLikeCount(rs.getInt("likeCount"));
	                dto.setVisibility(rs.getString("visibility"));
	                dto.setCreated_at(rs.getTimestamp("created_at"));
	                list.add(dto);
	            }
	            return list;
	        }
	    }
	}

	// Q&A 전체 글 개수
	public int getQnaRecordTotalCount(String loginId, String userCategory) throws Exception {
	    String sql;
	    if ("manager".equalsIgnoreCase(userCategory)) {
	        sql = "SELECT COUNT(*) FROM boards WHERE category = 'Q&A'";
	    } else {
	        sql = "SELECT COUNT(*) FROM boards WHERE category = 'Q&A' AND writer = ?";
	    }

	    try (Connection con = getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        if (!"manager".equalsIgnoreCase(userCategory)) {
	            ps.setString(1, loginId);
	        }

	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                return rs.getInt(1);
	            }
	        }
	    }
	    return 0;
	}

	// Q&A 네비게이션
	public PageNaviDTO getQnaPageNavi(int currentPage, String loginId, String userCategory) throws Exception {
	    int recordTotalCount = this.getQnaRecordTotalCount(loginId, userCategory);
	    return getPageNavi(currentPage, recordTotalCount);
	}

}
