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
			if (cmd.equals("/insert.reply")) {
				String writer = request.getParameter("writer");
				String contents = request.getParameter("contents");
				int board_seq = Integer.parseInt(request.getParameter("board_seq"));
				int parent_seq = Integer.parseInt(request.getParameter("parent_seq"));

				ReplyDTO dto = new ReplyDTO(0, writer, contents, 0, board_seq, parent_seq, null, null, null);
				int result = reply_dao.insertReplies(dto);

				response.setContentType("application/json; charset=UTF-8");
				try (PrintWriter pw = response.getWriter()) {
					Map<String, Object> resultMap = new HashMap<>();
					if (result != 0) {
						List<ReplyDTO> replies = reply_dao.selectRepliesByBoardSeq(board_seq);
						for (ReplyDTO reply : replies) {
							String path = reply.getPath();
							String parentWriter = reply_dao.getParentWriterByPath(path);
							reply.setParentWriter(parentWriter);
						}

						resultMap.put("replies", replies);
						System.out.println("댓글등록완료");
					} else {
						resultMap.put("message", "댓글 등록 실패");
					}

					String json = new Gson().toJson(resultMap);
					pw.print(json);
				}

			}else if(cmd.equals("/update.reply")) {

			}else if(cmd.equals("/delete.reply")) {

			}else if(cmd.equals("/like.reply")) {

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
