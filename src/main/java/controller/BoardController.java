package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BoardDAO;
import dao.ReplyDAO;
import dto.board.BoardDTO;

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

				if(cpageStr != null) {
					cpage = Integer.parseInt(cpageStr);
				}else {
					cpage = 1;
				}
				// List 가져오기
				List<BoardDTO> list = board_dao.selectAllBoards();
				
				request.setAttribute("list", list);
//				request.setAttribute("recordTotalCount", dao.getRecordTotalCount());
//				request.setAttribute("recordCountPerPage", Config.RECORD_COUNT_PER_PAGE);
//				request.setAttribute("naviCountPerPage", Config.NAVI_COUNT_PER_PAGE);
//				request.setAttribute("currentPage", cpage);
				request.getRequestDispatcher("/WEB-INF/views/board/list.jsp").forward(request, response);

			}else if(cmd.equals("/detail.board")) {

				
				request.getRequestDispatcher("/WEB-INF/views/board/list.jsp").forward(request, response);

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
