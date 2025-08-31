package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BoardDAO;
import dao.ReplyDAO;
import dto.board.ReplyDTO;

@WebServlet("*.reply")
public class ReplyController extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String cmd = request.getRequestURI();
		BoardDAO board_dao = BoardDAO.getInstance();
		ReplyDAO reply_dao = ReplyDAO.getInstance();

		try {
			if(cmd.equals("/insert.reply")) {
				
				// 값 받아오기
				String writer = request.getParameter("writer");
				String contents = request.getParameter("contents");
				int board_seq = Integer.parseInt(request.getParameter("board_seq"));
				int parent_seq = Integer.parseInt(request.getParameter("parent_seq"));
				
				// insert 요청
				ReplyDTO dto = new ReplyDTO(0, writer, contents, 0, board_seq, parent_seq, null, null, null);
				int result = reply_dao.insertReplies(dto);
				
				if(result != 0) {
					response.sendRedirect("/detail.board?seq=" + board_seq);
				}else {
					response.sendRedirect("/error.jsp");
				}
				
			}else if(cmd.equals("/update.reply")) {

			}else if(cmd.equals("/delete.reply")) {

			}else if(cmd.equals("")) {

			}else if(cmd.equals("")) {

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
