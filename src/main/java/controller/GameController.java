package controller;


import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;
import java.lang.reflect.Type;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;

import dao.GameDAO;
import dao.GameRecordDAO;

import dao.GameReviewDAO;
import dto.game.GameDTO;
import dto.game.GameRecordDTO;
import dto.game.GameReviewDTO;

@WebServlet("/api/game/*")
public class GameController extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo(); 		
		Gson g = new GsonBuilder()
			    .registerTypeAdapter(Timestamp.class, new JsonDeserializer<Timestamp>() {
			        @Override
			        public Timestamp deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
			                throws JsonParseException {
			            JsonPrimitive primitive = json.getAsJsonPrimitive();
			            if (primitive.isNumber()) {
			                return new Timestamp(primitive.getAsLong());
			            } else if (primitive.isString()) {
			                try {
			                    return new Timestamp(Long.parseLong(primitive.getAsString()));
			                } catch (NumberFormatException e) {
			                    throw new JsonParseException("Invalid timestamp format", e);
			                }
			            } else {
			                throw new JsonParseException("Unsupported timestamp format");
			            }
			        }
			    })
			    .create();
		String loginId = (String) request.getSession().getAttribute("loginId"); //로그인 아이디

		GameReviewDAO gameReviewDAO = GameReviewDAO.getInstance();
		GameRecordDAO gameRecordDAO = GameRecordDAO.getInstance();
		GameDAO gameDAO = GameDAO.getInstance();
		
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
		}
		else if(path.equals("/main/reviewView")) {
			//ajax로 리뷰 리스트 전달 처리.
			try{
				int game_seq = Integer.parseInt(request.getParameter("game_seq"));

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

		}
		else if(path.equals("/main/reviewUpdate")) {
			//ajax로 리뷰 업데이트 처리.
			try{
				String title = request.getParameter("title");
				String content = request.getParameter("content");
				int game_seq = Integer.parseInt(request.getParameter("game_seq"));
				int rating = Integer.parseInt(request.getParameter("rating"));
				GameReviewDTO gameReviewDTO = new GameReviewDTO(0,loginId,title,content,game_seq,rating,null);


				int updateResult = gameReviewDAO.updateGameReviewsBygame_seqAndWriter(gameReviewDTO);

				List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectGameReviewsByGame_seq(game_seq); 

				response.setContentType("text/html; charset=UTF-8");
				PrintWriter pw = response.getWriter();

				pw.append(g.toJson(gameReviewDTOList));

			}
			catch(Exception e) {
				e.printStackTrace();
				System.out.println("에러!!");
			}

		}
		else if(path.equals("/main/record")) { //상위5등까지 기록한 점수 보기
			
			int game_seq = Integer.parseInt(request.getParameter("game_seq")); //게시글 번호
			
			
			
			try{
				List<GameRecordDTO> gameRecordDTOList = gameRecordDAO.selectGameRecordsByRank(game_seq);
				
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter pw = response.getWriter();

				pw.append(g.toJson(gameRecordDTOList));
				
			}
			catch(Exception e) {
				e.printStackTrace();
				System.out.println("에러!!");
			}
		}else if(path.equals("/recordInsert")) { // 내 점수 기록하기
			// GameDataDto dto = gson.fromJson(sb.toString(), GameDataDto.class);
			
//			 BufferedReader reader = request.getReader();
//			  StringBuilder sb = new StringBuilder();
//			  String line;
//			  while ((line = reader.readLine()) != null) {
//			      sb.append(line);
//			  } 이게 아래에 이거임
			  
			GameRecordDTO dto = g.fromJson(request.getReader(), GameRecordDTO.class); // ajax 받고
			try {
				int result = gameRecordDAO.insertGameRecords(dto);
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(g.toJson(result)); // ajax 보내기
				
			
			
			}
			catch(Exception e) {
				e.printStackTrace();
				System.out.println("에러!!");
			}
			
			//insertGameRecords
		}
		else if(path.equals("/main/reviewDelete")) {
			//ajax로 리뷰 삭제 처리.
			try{
				int game_seq = Integer.parseInt(request.getParameter("game_seq"));

				int delResult = gameReviewDAO.deleteGameReviewsBygame_seqAndWriter(game_seq,loginId);

				List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectGameReviewsByGame_seq(game_seq); 

				response.setContentType("text/html; charset=UTF-8");
				PrintWriter pw = response.getWriter();

				pw.append(g.toJson(gameReviewDTOList));
			}
			catch(Exception e) {
				e.printStackTrace();
				System.out.println("에러!!");
			}


		}else if(path.equals("/info")) {
			//ajax로 게임제목, 배경, 사진들
			try{
				int game_seq = Integer.parseInt(request.getParameter("game_seq"));
				
				GameDTO gameDTO = gameDAO.selectGamesBySeq(game_seq);
				
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				
				pw.append(g.toJson(gameDTO)); // 여기서 객체 보냈습니다.
				
				
			}catch(Exception e) {
				e.printStackTrace();
				System.out.println("에러!!");
			}
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
