package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.GameReviewDAO;
import dto.game.GameReviewDTO;

@WebServlet("/api/game/*")
public class GameController extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 String path = request.getPathInfo(); 
		 
	        if(path == null || path.equals("/main")) {
	        	GameReviewDAO gameReviewDAO = GameReviewDAO.getInstance();
	        	
				int game_seq = Integer.parseInt(request.getParameter("game_seq")); //게시글 번호

				System.out.println("파렌트 시퀀스=" +game_seq);
				
				try{
				List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectAllGameReviews(game_seq); 
				
				request.setAttribute("gameReviewList", gameReviewDTOList);
				
				request.getRequestDispatcher("/WEB-INF/views/game/main.jsp").forward(request, response);
				}
				catch(Exception e) {
					e.printStackTrace();
					System.out.println("에러!!");
				}
				
	        	
//	            request.getRequestDispatcher("/WEB-INF/views/game/main.jsp").forward(request, response);
	        } 
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
