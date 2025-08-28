package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.gson.Gson;

import dao.GameRecordDAO;

import dao.GameReviewDAO;
import dto.game.GameRecordDTO;
import dto.game.GameReviewDTO;

@WebServlet("/api/game/*")
public class GameController extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo(); 		
		Gson g = new Gson();
		String loginId = (String) request.getSession().getAttribute("loginId"); //로그인 아이디

		GameReviewDAO gameReviewDAO = GameReviewDAO.getInstance();
		GameRecordDAO gameRecordDAO = GameRecordDAO.getInstance();
		if(path == null || path.equals("/main")) {

			
			int game_seq = Integer.parseInt(request.getParameter("game_seq")); //게시글 번호

			System.out.println("파렌트 시퀀스=" +game_seq);

			try{
				List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectGameReviewsByGame_seq(game_seq); 
				GameReviewDTO wroteGameReviewDTO = gameReviewDAO.selectGameReviewsBygame_seqAndWriter(game_seq,loginId);
				request.setAttribute("game_seq", game_seq);
				//game_seq 에 따른 gamedto 가져오는 메소드 제작하기 ex) gamedto.???
				request.setAttribute("gameReviewList", gameReviewDTOList);
				
				request.setAttribute("wroteGameReviewDTO", wroteGameReviewDTO);

				request.getRequestDispatcher("/WEB-INF/views/game/main.jsp").forward(request, response);
			}
			catch(Exception e) {
				e.printStackTrace();
				System.out.println("에러!!");
			}


			//request.getRequestDispatcher("/WEB-INF/views/game/main.jsp").forward(request, response);
		}

		else if(path == null || path.equals("/main/reviewInsert")) {
			//ajax로 리뷰 등록하기 처리.
			try{
				String title = request.getParameter("title");
				String content = request.getParameter("content");
				int game_seq = Integer.parseInt(request.getParameter("game_seq"));
				int rating = Integer.parseInt(request.getParameter("rating"));

				GameReviewDTO gameReviewDTO = new GameReviewDTO(0,loginId,title,content,game_seq,rating,null);
				int result =  gameReviewDAO.insertGameReviews(gameReviewDTO);


				List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectGameReviewsByGame_seq(game_seq); 

				response.setContentType("text/html; charset=UTF-8");
				PrintWriter pw = response.getWriter();

				pw.append(g.toJson(gameReviewDTOList));
				System.out.println(g.toJson(gameReviewDTOList));
			}
			catch(Exception e) {
				e.printStackTrace();
				System.out.println("에러!!");
			}


			//	            request.getRequestDispatcher("/WEB-INF/views/game/main.jsp").forward(request, response);
		}else if(path.equals("/main/record")) { //상위5등까지 기록한 점수 보기
			
			int game_seq = Integer.parseInt(request.getParameter("game_seq")); //게시글 번호
			
			
			
			try{
				List<GameRecordDTO> gameRecordDTOList = gameRecordDAO.selectGameRecordsByRank(game_seq);
				
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter pw = response.getWriter();

				pw.append(g.toJson(gameRecordDTOList));
				System.out.println(g.toJson(gameRecordDTOList));
			}
			catch(Exception e) {
				e.printStackTrace();
				System.out.println("에러!!");
			}
		}else if(path.equals("/recordInsert")) { // 내 점수 기록하기
			// GameDataDto dto = gson.fromJson(sb.toString(), GameDataDto.class);
			 BufferedReader reader = request.getReader();
			  StringBuilder sb = new StringBuilder();
			  String line;
			  while ((line = reader.readLine()) != null) {
			      sb.append(line);
			  }

			GameRecordDTO dto = g.fromJson(sb.toString(), GameRecordDTO.class);
			// 인서트 하고  
			
			try {
				
				
				int result = gameRecordDAO.insertGameRecords(dto);
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter pw = response.getWriter();

				pw.append(g.toJson(result));
				
			
			
			}
			catch(Exception e) {
				e.printStackTrace();
				System.out.println("에러!!");
			}
			
			//insertGameRecords
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
