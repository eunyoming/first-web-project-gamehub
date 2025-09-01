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

import com.google.gson.Gson;

import commons.Config;
import dao.BoardDAO;
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


		try {
			if(cmd.equals("/list.board")) {

				// 선택한 페이지 가져오기
				int cpage = 0;
				String cpageStr = request.getParameter("cpage");

				if(cpageStr != null) { // 선택한 페이지가 있다면
					cpage = Integer.parseInt(cpageStr);
				}else { // 선택한 페이지가 없다면 기본 1페이지
					cpage = 1;
				}

				// 해당 페이지 글 List 가져오기
				List<BoardDTO> list = board_dao.selectFromToBoards(cpage*Config.RECORD_COUNT_PER_PAGE-(Config.RECORD_COUNT_PER_PAGE-1),
						cpage*Config.RECORD_COUNT_PER_PAGE);

				// Navi 정보 담아오기
				PageNaviDTO navi = board_dao.getPageNavi(cpage);

				// request 에 담기
				request.setAttribute("list", list);
				request.setAttribute("recordTotalCount", board_dao.getRecordTotalCount()); // 총 글개수
				request.setAttribute("recordCountPerPage", Config.RECORD_COUNT_PER_PAGE); // 페이지당 글개수
				request.setAttribute("naviCountPerPage", Config.NAVI_COUNT_PER_PAGE); // 페이지당 페이지 번호
				request.setAttribute("cpage", cpage); // 선택한 페이지
				request.setAttribute("navi", navi); // navi 정보
				request.getRequestDispatcher("/WEB-INF/views/board/list.jsp").forward(request, response);

			}else if(cmd.equals("/detailPage.board")) {
				
				request.getRequestDispatcher("/WEB-INF/views/board/detail.jsp").forward(request, response);
			
			}else if(cmd.equals("/detail.board")) {
				// 인코딩
				response.setContentType("application/json; charset=UTF-8");
				// 로그인 정보 가져오기
				String loginId = (String)request.getSession().getAttribute("loginId");

				// 글 seq 가져오기
				int board_seq = Integer.parseInt(request.getParameter("seq"));
				BoardDTO boardDto = board_dao.selectBoardsBySeq(board_seq);

				// 해당 페이지 댓글 List 가져오기
				List<ReplyDTO> repliesList = reply_dao.selectRepliesByBoardSeq(board_seq);
				// 댓글 path 로 부모 댓글 작성자 가져오기
				for (ReplyDTO reply : repliesList) {
					String path = reply.getPath();
					String parentWriter = reply_dao.getParentWriterByPath(path);
					reply.setParentWriter(parentWriter); // DTO에 저장
				}

				//작성자 프로필 용 dto 
				SimpleUserProfileDTO simpleUserProfileDTO = MemberDAO.getInstance().getSimpleUserProfile(boardDto.getWriter());

				// JSON 직렬화 준비
				try (PrintWriter pw = response.getWriter()) {

					Map<String, Object> result = new HashMap<>();
					result.put("loginId", loginId);
					result.put("boardDto", boardDto);
					result.put("writerProfile", simpleUserProfileDTO);
					result.put("repliesList", repliesList);

					String json = new Gson().toJson(result);
					pw.print(json);
				}

			}else if(cmd.equals("/update.board")) {

				// 글 seq 가져오기
				int board_seq = Integer.parseInt(request.getParameter("board_seq"));

				// 수정 내용 받아오기
				String title = request.getParameter("title");
				String contents = request.getParameter("contents");
				String category = request.getParameter("category");
				String refgame = request.getParameter("refgame");

				// 수정 하기
				int result = board_dao.updateBoardsBySeq(board_seq, title, contents, category, refgame);

				if(result != 0) {
					response.sendRedirect("/detail.board?seq=" + board_seq);
				}else {
					response.sendRedirect("/error.jsp");
				}

			}else if(cmd.equals("/delete.board")) {

				// 글 seq 가져오기
				int seq = Integer.parseInt(request.getParameter("seq"));



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
