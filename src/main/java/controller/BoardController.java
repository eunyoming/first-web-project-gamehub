package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

import com.google.gson.Gson;

import commons.Config;
import dao.BoardDAO;
import dao.BoardsLikesDAO;
import dao.BookmarkDAO;
import dao.MemberDAO;
import dao.ReplyDAO;
import dto.board.BoardDTO;
import dto.board.PageNaviDTO;
import dto.board.ReplyDTO;
import dto.member.SimpleUserProfileDTO;

@WebServlet("*.board")
public class BoardController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		response.setCharacterEncoding("UTF-8");

		String cmd = request.getRequestURI();

		BoardDAO board_dao = BoardDAO.getInstance();
		ReplyDAO reply_dao = ReplyDAO.getInstance();
		BoardsLikesDAO boards_likes_dao = BoardsLikesDAO.getInstance();
		BookmarkDAO bookmark_dao = BookmarkDAO.getInstance();
		
		System.out.println(cmd);

		try {
			if (cmd.equals("/list.board")) {

				// 선택한 페이지 가져오기
				int cpage = 0;
				String cpageStr = request.getParameter("cpage");

				if (cpageStr != null) { // 선택한 페이지가 있다면
					cpage = Integer.parseInt(cpageStr);
				} else { // 선택한 페이지가 없다면 기본 1페이지
					cpage = 1;
				}

				// ✅ 카테고리, 관련 게임, 검색어 파라미터 추가
				String category = request.getParameter("category");
				String refgame = request.getParameter("refgame");
				String search = request.getParameter("search");

				// DAO 호출 시 조건 전달
				List<BoardDTO> list = board_dao.selectFromToBoards(
						cpage * Config.RECORD_COUNT_PER_PAGE - (Config.RECORD_COUNT_PER_PAGE - 1),
						cpage * Config.RECORD_COUNT_PER_PAGE,
						category,
						refgame,
						search
						);

				// Navi 정보 담아오기 (필터 반영된 총 글 수 필요)
				int totalCount = board_dao.getRecordTotalCount(category, refgame, search);
				PageNaviDTO navi = board_dao.getPageNavi(cpage, totalCount);

				// request 에 담기
				request.setAttribute("list", list);
				request.setAttribute("recordTotalCount", totalCount); // 총 글개수
				request.setAttribute("recordCountPerPage", Config.RECORD_COUNT_PER_PAGE); // 페이지당 글개수
				request.setAttribute("naviCountPerPage", Config.NAVI_COUNT_PER_PAGE); // 페이지당 페이지 번호
				request.setAttribute("cpage", cpage); // 선택한 페이지
				request.setAttribute("navi", navi); // navi 정보

				// 선택된 필터 유지하기 위해 다시 JSP에 넘김
				request.setAttribute("categoryParam", category);
				request.setAttribute("refgameParam", refgame);
				request.setAttribute("searchParam", search);

				request.getRequestDispatcher("/WEB-INF/views/board/list.jsp").forward(request, response);



			}else if(cmd.equals("/detailPage.board")) {

				int seq = Integer.parseInt(request.getParameter("seq"));

				// 조회수 1 증가
				board_dao.updateBoardsViewCount(seq);

				// 글 정보 불러오기
				BoardDTO dto = board_dao.selectBoardsBySeq(seq);

				// request에 담기
				request.setAttribute("dto", dto);

				request.setAttribute("seq", seq);
				request.getRequestDispatcher("/WEB-INF/views/board/detail.jsp").forward(request, response);

			}else if(cmd.equals("/detail.board")) {
				// 인코딩
				response.setContentType("application/json; charset=UTF-8");
				// 로그인 정보 가져오기
				String loginId = (String)request.getSession().getAttribute("loginId");

				// 글 seq 가져오기
				int board_seq = Integer.parseInt(request.getParameter("seq"));
				BoardDTO boardDto = board_dao.selectBoardsBySeq(board_seq);

				System.out.println(board_seq);

				// 게시글 좋아요 상태 확인
				boolean isLiked = false;
				if(loginId != null) {
					isLiked = boards_likes_dao.isLiked(board_seq, loginId);
				}
				
				// 게시글 추천 상태 확인
				boolean isBookmarked = false;
				if (loginId != null) {
				    isBookmarked = bookmark_dao.isBookmarked(loginId, board_seq);
				}

				// 해당 페이지 댓글 List 가져오기
				List<ReplyDTO> repliesList = reply_dao.selectRepliesByBoardSeq(board_seq);
				// 댓글 path 로 부모 댓글 작성자 가져오기
				for (ReplyDTO reply : repliesList) {
					String path = reply.getPath();
					String parentWriter = reply_dao.getParentWriterByPath(path);
					reply.setParentWriter(parentWriter); // DTO에 저장
				}

				// 댓글 개수
				int replyCount = repliesList.size();

				// 작성자 프로필 용 dto 
				SimpleUserProfileDTO simpleUserProfileDTO = MemberDAO.getInstance().getSimpleUserProfile(boardDto.getWriter());

				// 로그인한 유저 프로필 dto
				String userCategory = "undefined";
				if(loginId != null) {
					SimpleUserProfileDTO loginUserProfileDTO = (SimpleUserProfileDTO)request.getSession().getAttribute("simpleProfile");
					userCategory = loginUserProfileDTO.getCategory();
				}
				// JSON 직렬화 준비
				try (PrintWriter pw = response.getWriter()) {

					Map<String, Object> result = new HashMap<>();
					result.put("loginId", loginId);
					result.put("boardDto", boardDto);
					result.put("writerProfile", simpleUserProfileDTO);
					result.put("repliesList", repliesList);
					result.put("replyCount", replyCount);
					result.put("likeCount", boards_likes_dao.countLikes(board_seq));
					result.put("isLiked", isLiked);
					result.put("isBookmarked", isBookmarked);
					
					if(loginId != null) {
						result.put("userCategory", userCategory);
					}

					String json = new Gson().toJson(result);
					pw.print(json);
				}

			}else if(cmd.equals("/write.board")) {
				// 로그인 정보 가져오기
				String loginId = (String)request.getSession().getAttribute("loginId");

				request.setAttribute("loginId", loginId);
				request.getRequestDispatcher("/WEB-INF/views/board/write.jsp").forward(request, response);

			}else if(cmd.equals("/insert.board")) {
				response.setContentType("application/json; charset=UTF-8");

				String loginId = (String)request.getSession().getAttribute("loginId");
				String title = request.getParameter("title");
				String category = request.getParameter("category");
				String refgame = request.getParameter("refgame");
				String contents = request.getParameter("contents");

				// 썸머노트 전체 허용 Safelist
				Safelist safelist = Safelist.relaxed()
						// 모든 태그에 공통적으로 style/class 허용
						.addAttributes(":all", "style", "class", "id")

						// 이미지 관련 (썸머노트에서 기본적으로 씀)
						.addAttributes("img", "src", "alt", "width", "height", "data-filename")

						// iframe (유튜브, 비메오, 지도 등 삽입 가능)
						.addTags("iframe")
						.addAttributes("iframe", "src", "width", "height", "frameborder", "allow", "allowfullscreen")

						// 표 관련 (table, thead, tbody, tr, th, td)
						.addTags("table", "thead", "tbody", "tr", "th", "td")
						.addAttributes("table", "border", "cellspacing", "cellpadding", "width", "height", "style", "class")
						.addAttributes("td", "colspan", "rowspan", "style", "class")
						.addAttributes("th", "colspan", "rowspan", "style", "class")

						// 코드 블록
						.addTags("pre", "code")

						// 인용구
						.addTags("blockquote")

						// 추가로 썸머노트에서 쓰는 div/p/span 보강
						.addTags("div", "span", "section", "article");


				String cleanContents = Jsoup.clean(contents,"http://localhost/", safelist);


				BoardDTO dto = new BoardDTO(0, loginId, title, cleanContents, category, refgame, 0, 0, null, null);
				int seq = board_dao.insertBoards(dto);

				// 카테고리가 Q&A라면
				if(category.equals("Q&A")) {

					board_dao.qnaInsertBoards(seq);
				}

				Map<String, Object> result = new HashMap<>();
				result.put("seq", seq);
				result.put("success", seq != 0);

				try(PrintWriter pw = response.getWriter()){
					pw.print(new Gson().toJson(result));
				}

			}else if(cmd.equals("/update.board")) {
				// 글 seq 가져오기
				int board_seq = Integer.parseInt(request.getParameter("board_seq"));

				// 수정 내용 받아오기
				String title = request.getParameter("title");
				String contents = request.getParameter("contents");
				String category = request.getParameter("category");
				String refgame = request.getParameter("refgame");

				// 상대경로 허용 (insert와 동일한 safelist)
				Safelist safelist = Safelist.basicWithImages()
						.addAttributes("img", "src", "style", "class")
						.removeProtocols("img", "src", "http", "https", "data");

				String cleanContents = Jsoup.clean(contents, safelist);

				// 수정 하기
				int result = board_dao.updateBoardsBySeq(board_seq, title, cleanContents, category, refgame);

				if(result != 0) {
					// 수정된 최신 데이터 다시 조회
					BoardDTO boardDto = board_dao.selectBoardsBySeq(board_seq);

					// 보내줄 내용 묶기
					Map<String, Object> responseMap = new HashMap<>();
					responseMap.put("result", result);
					responseMap.put("boardDto", boardDto);

					// 직렬화 준비 
					response.setContentType("application/json; charset=UTF-8");
					try(PrintWriter pw = response.getWriter()) {
						pw.print(new Gson().toJson(responseMap));
					}

				} else {
					response.sendRedirect("/error.jsp");
				}

			}else if(cmd.equals("/delete.board")) {

				// 글 seq 가져오기
				int seq = Integer.parseInt(request.getParameter("board_seq"));

				int result = board_dao.deleteBoardsBySeq(seq);

				if(result != 0) {

					// 보내줄 내용 묶기
					Map<String, Object> responseMap = new HashMap<>();
					responseMap.put("result", result);

					// 직렬화 준비 
					response.setContentType("application/json; charset=UTF-8");
					try(PrintWriter pw = response.getWriter()) {
						pw.print(new Gson().toJson(responseMap));
					}

				} else {
					response.sendRedirect("/error.jsp");
				}
			}else if(cmd.equals("/like/toggle.board")) {
				String loginId = (String)request.getSession().getAttribute("loginId");
				int board_seq = Integer.parseInt(request.getParameter("board_seq"));
				System.out.println("게시글 추천 토글: board_seq = " + board_seq + ", userId = " + loginId);

				boolean isLiked = boards_likes_dao.isLiked(board_seq, loginId);

				Map<String, Object> result = new HashMap<>();

				if (isLiked) { // 삭제
					int deleted = boards_likes_dao.deleteLike(board_seq, loginId);
					result.put("success", deleted > 0);
					result.put("action", "delete");
				} else { // 추가
					int inserted = boards_likes_dao.insertLike(board_seq, loginId);
					result.put("success", inserted > 0);
					result.put("action", "insert");
				}

				// 최신 likeCount 가져오기
				int likeCount = boards_likes_dao.countLikes(board_seq);

				// boards 테이블의 like_count 컬럼 업데이트
				board_dao.updateBoardsLikeCount(board_seq, likeCount);

				result.put("likeCount", likeCount);

				response.setContentType("application/json; charset=UTF-8");
				response.getWriter().write(new Gson().toJson(result));
			}else if(cmd.equals("/isLiked.board")) {

				int board_seq = Integer.parseInt(request.getParameter("board_seq"));
				response.setContentType("application/json; charset=UTF-8");
				Map<String, Object> result = new HashMap<>();

				try {
					String loginId = (String)request.getSession().getAttribute("loginId");
					boolean isLiked = boards_likes_dao.isLiked(board_seq, loginId);
					int likeCount = boards_likes_dao.countLikes(board_seq);

					result.put("isLiked", isLiked);
					result.put("likeCount", likeCount);
					result.put("success", true);
				} catch (Exception e) {
					e.printStackTrace();
					result.put("isLiked", false);
					result.put("likeCount", 0);
					result.put("success", false);
					result.put("error", e.getMessage());
				}

				response.getWriter().write(new Gson().toJson(result));
			}else if (cmd.equals("/QnA_list.board")) {
				// 로그인한 사용자 권한 가져오기
				SimpleUserProfileDTO profile =
						(SimpleUserProfileDTO) request.getSession().getAttribute("simpleProfile");

				String loginId = (String) request.getSession().getAttribute("loginId"); // 로그인 아이디 가져오기
				if (loginId == null) {
					response.sendRedirect("/login.jsp");
					return;
				}

				// 기본값은 user, null 방지
				String userCategory = (profile != null) ? profile.getCategory() : "user";

				int cpage = 1;
				try {
					cpage = Integer.parseInt(request.getParameter("cpage"));
				} catch (Exception e) {
					// 파라미터가 없거나 잘못 들어오면 기본 1페이지
				}

				int recordCountPerPage = Config.RECORD_COUNT_PER_PAGE;
				int start = (cpage - 1) * recordCountPerPage;
				int end = recordCountPerPage;

				BoardDAO dao = BoardDAO.getInstance();
				List<BoardDTO> qnaList = dao.selectQnaList(loginId, userCategory, start, end);
				PageNaviDTO navi = dao.getQnaPageNavi(cpage, loginId, userCategory);

				request.setAttribute("qnaList", qnaList);
				request.setAttribute("navi", navi);

				request.getRequestDispatcher("/WEB-INF/views/board/Q&A.jsp").forward(request, response);
			}else if(cmd.equals("/total-board-count.board")) {


				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");

				response.getWriter().write("{\"count\":" + BoardDAO.getInstance().getRecordTotalCount() + "}");

			}


		}catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("/error.jsp");
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}