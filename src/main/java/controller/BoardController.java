package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import commons.Config;
import dao.BoardDAO;
import dao.ReplyDAO;
import dto.board.BoardDTO;
import dto.board.PageNaviDTO;

@WebServlet("*.board")
public class BoardController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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

				// 해당 페이지 List 가져오기
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

			}else if(cmd.equals("/detail.board")) {
				
				// 로그인 정보 가져오기
				String userId = (String)request.getSession().getAttribute("loginId");
				
				// 글 seq 가져오기
				int seq = Integer.parseInt(request.getParameter("seq"));
				BoardDTO dto = board_dao.selectBoardsBySeq(seq);
				
				// request 에 담기
				request.setAttribute("dto", dto);
				
				request.getRequestDispatcher("/WEB-INF/views/board/detail.jsp").forward(request, response);
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
