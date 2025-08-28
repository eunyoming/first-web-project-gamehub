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
import dao.BookmarkDAO;
import dao.ReplyDAO;
import dto.board.BoardDTO;
import dto.board.BookmarkDTO;
import dto.board.ReplyDTO;

/**
 * Servlet implementation class BookmarkController
 */
@WebServlet("/api/bookmark/*")
public class BookmarkController extends HttpServlet {


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo(); 
		String loginId = (String) request.getSession().getAttribute("loginId"); 

		Gson gson = new Gson();
		
		BoardDAO boardDAO = BoardDAO.getInstance();
		ReplyDAO replyDAO = ReplyDAO.getInstance();
		BookmarkDAO bookmarkDAO = BookmarkDAO.getInstance();
		
		try {
			if(path.equals("/view")) {
				System.out.println("여기까지옴");
				List<BoardDTO> boards = bookmarkDAO.selectBoardsByWriter(loginId);
				List<ReplyDTO> replies = bookmarkDAO.selectReplysByWriter(loginId);
				List<BoardDTO> bookmarks = bookmarkDAO.selectBookmarkJoinBoardsByUserId(loginId);

				// Map에 담기
				Map<String, Object> map = new HashMap<>();
				map.put("boards", boards);
				map.put("replys", replies);
				map.put("bookmarks", bookmarks);

				// JSON으로 변환
				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(gson.toJson(map));  // gson 사용
				
				System.out.println(gson.toJson(map));
				
			}
			else if(path.equals("/delete")) {
				System.out.println("delete 까지옴");
				int board_seq = Integer.parseInt(request.getParameter("board_seq"));
				
				int result = bookmarkDAO.deleteBookmarkByBoard_seqAndUserId(board_seq,loginId);
				
				
			}


		}	
		catch(Exception e) {

		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
