package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Safelist;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;

import dao.GameDAO;
import dao.GameInfoDAO;
import dao.GameRecordDAO;
import dao.GameReviewDAO;
import dao.MemberDAO;
import dto.game.GameDTO;
import dto.game.GameInfoDTO;
import dto.game.GameRecordDTO;
import dto.game.GameReviewDTO;
import dto.member.SimpleUserProfileDTO;

@WebServlet("/api/game/*")
public class GameController extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getPathInfo();
		Gson g = new GsonBuilder().disableHtmlEscaping().registerTypeAdapter(Timestamp.class, new JsonDeserializer<Timestamp>() {
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
				}).create();
		String loginId = (String) request.getSession().getAttribute("loginId"); // 로그인 아이디

		GameReviewDAO gameReviewDAO = GameReviewDAO.getInstance();
		GameRecordDAO gameRecordDAO = GameRecordDAO.getInstance();
		GameDAO gameDAO = GameDAO.getInstance();
		GameInfoDAO gameInfoDAO = GameInfoDAO.getInstance();

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		

		try {
			
		
			if (path == null || path.equals("/main")) {
	
				int game_seq = Integer.parseInt(request.getParameter("game_seq")); // 게시글 번호
	
				System.out.println("파렌트 시퀀스=" + game_seq);
	
				try {
					List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectGameReviewsByGame_seq(game_seq);
					GameReviewDTO wroteGameReviewDTO = gameReviewDAO.selectGameReviewsBygame_seqAndWriter(game_seq,
							loginId);
					request.setAttribute("game_seq", game_seq);
	
					request.setAttribute("gameReviewList", gameReviewDTOList);
					GameDTO gameDTO = gameDAO.selectGamesBySeq(game_seq);
					GameInfoDTO gameInfoDTO = gameInfoDAO.selectGameInfoBySeq(game_seq);
					request.setAttribute("infoList", gameInfoDTO);
					request.setAttribute("gameList", gameDTO);
					// game_seq 에 따른 gamedto 가져오는 메소드 제작하기 ex) gamedto.???
	
					request.setAttribute("wroteGameReviewDTO", wroteGameReviewDTO);
					request.getRequestDispatcher("/WEB-INF/views/game/main.jsp").forward(request, response);
				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("에러!!");
				}
	
				// request.getRequestDispatcher("/WEB-INF/views/game/main.jsp").forward(request,
				// response);
			}else if(path.equals("/gameList")) {
				
				List<GameDTO> games;
				
					
					games = gameDAO.getAllGames();
					String json = g.toJson(games);
			        response.getWriter().write(json);
				
	
	
			}else if(path.equals("/gameInfo")) {
				int seq = Integer.parseInt(request.getParameter("seq"));
	
		        GameInfoDTO info;
			
				info = GameInfoDAO.getInstance().selectGameInfoBySeq(seq);
				response.getWriter().write(g.toJson(info));
	
				
			}
	
			else if (path == null || path.equals("/main/reviewInsert")) {
				// ajax로 리뷰 등록하기 처리.
				try {
					String title = request.getParameter("title");
					String content = request.getParameter("content");
					int game_seq = Integer.parseInt(request.getParameter("game_seq"));
					int rating = Integer.parseInt(request.getParameter("rating"));
					
					Document docTitle = Jsoup.parseBodyFragment(title);
					 docTitle.select("script, style").unwrap(); // 태그만 제거, 내부 텍스트는 보존

			        Safelist safelist = Safelist.none().addTags("b", "i", "u", "br");
			         String cleanTitle = Jsoup.clean(docTitle.body().html(), safelist);
	
			         Document docContent = Jsoup.parseBodyFragment( content);
					 docTitle.select("script, style").unwrap(); // 태그만 제거, 내부 텍스트는 보존
					 String cleanContent  = Jsoup.clean(docContent.body().html(), safelist);
			         
			         
					GameReviewDTO gameReviewDTO = new GameReviewDTO(0, loginId, cleanTitle, cleanContent, game_seq, rating, null);
					int result = gameReviewDAO.insertGameReviews(gameReviewDTO);
	
					List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectGameReviewsByGame_seq(game_seq);
	
					response.setContentType("text/html; charset=UTF-8");
					PrintWriter pw = response.getWriter();
	
					pw.append(g.toJson(gameReviewDTOList));
					System.out.println(g.toJson(gameReviewDTOList));
				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("에러!!");
				}
			} else if (path.equals("/main/reviewView")) {
				// ajax로 리뷰 리스트 전달 처리.
				try {
					int game_seq = Integer.parseInt(request.getParameter("game_seq"));
	
					List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectGameReviewsByGame_seq(game_seq);
	
					response.setContentType("text/html; charset=UTF-8");
					PrintWriter pw = response.getWriter();
	
					pw.append(g.toJson(gameReviewDTOList));
					System.out.println(g.toJson(gameReviewDTOList));
				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("에러!!");
				}
	
			} else if (path.equals("/main/reviewUpdate")) {
				// ajax로 리뷰 업데이트 처리.
				try {
					String title = request.getParameter("title");
					String content = request.getParameter("content");
					int game_seq = Integer.parseInt(request.getParameter("game_seq"));
					int rating = Integer.parseInt(request.getParameter("rating"));
					GameReviewDTO gameReviewDTO = new GameReviewDTO(0, loginId, title, content, game_seq, rating, null);
	
					int updateResult = gameReviewDAO.updateGameReviewsBygame_seqAndWriter(gameReviewDTO);
	
					List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectGameReviewsByGame_seq(game_seq);
	
					response.setContentType("text/html; charset=UTF-8");
					PrintWriter pw = response.getWriter();
	
					pw.append(g.toJson(gameReviewDTOList));
	
				} catch (Exception e) {
					e.printStackTrace();
					request.getRequestDispatcher("/error/gameReviewError").forward(request, response);
				}
	
			} else if (path.equals("/main/record")) { // 상위5등까지 기록한 점수 보기
	
				int game_seq = Integer.parseInt(request.getParameter("game_seq")); // 게시글 번호
	
				try {
					List<GameRecordDTO> gameRecordDTOList = gameRecordDAO.selectGameRecordsByRank(game_seq);
					List<SimpleUserProfileDTO> simpleUserProfiles = new ArrayList<>();
					for (GameRecordDTO gameRecordDTO : gameRecordDTOList) {
						SimpleUserProfileDTO dto = MemberDAO.getInstance().getSimpleUserProfile(gameRecordDTO.getUserId());
						simpleUserProfiles.add(dto);
					}
					Map<String, Object> result = new HashMap<>();
					result.put("records", gameRecordDTOList);
					result.put("profiles", simpleUserProfiles);
					
					response.setContentType("text/html; charset=UTF-8");
					PrintWriter pw = response.getWriter();
	
					pw.append(g.toJson(result));
					
	
				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("에러!!");
				}
			} else if (path.equals("/recordInsert")) { // 내 점수 기록하기
				// GameDataDto dto = gson.fromJson(sb.toString(), GameDataDto.class);
	
	//			 BufferedReader reader = request.getReader();
	//			  StringBuilder sb = new StringBuilder();
	//			  String line;
	//			  while ((line = reader.readLine()) != null) {
	//			      sb.append(line);
	//			  } 이게 아래에 이거임
	
				GameRecordDTO gameRecordDTO = g.fromJson(request.getReader(), GameRecordDTO.class); // ajax 받고
				try {
					int result = gameRecordDAO.insertGameRecords(gameRecordDTO);
					response.setContentType("text/html; charset=UTF-8");
					PrintWriter pw = response.getWriter();
					pw.append(g.toJson(result)); // ajax 보내기
	
				} catch (Exception e) {
					e.printStackTrace();
					request.getRequestDispatcher("/error/gameRecordError").forward(request, response);
				}
	
				// insertGameRecords
			} else if (path.equals("/main/reviewDelete")) {
				// ajax로 리뷰 삭제 처리.
				try {
					int game_seq = Integer.parseInt(request.getParameter("game_seq"));
	
					int delResult = gameReviewDAO.deleteGameReviewsBygame_seqAndWriter(game_seq, loginId);
	
					List<GameReviewDTO> gameReviewDTOList = gameReviewDAO.selectGameReviewsByGame_seq(game_seq);
	
					response.setContentType("text/html; charset=UTF-8");
					PrintWriter pw = response.getWriter();
	
					pw.append(g.toJson(gameReviewDTOList));
				} catch (Exception e) {
					e.printStackTrace();
					request.getRequestDispatcher("/error/gameReviewError").forward(request, response);
				}
	
			} else if (path.equals("/info")) {
				// ajax로 게임제목, 배경, 사진들
	
				// try{
				// int game_seq = Integer.parseInt(request.getParameter("game_seq"));
	
				// request.getRequestDispatcher("/WEB-INF/views/game/main.jsp").forward(request,
				// response);
	
				// }catch(Exception e) {
				// e.printStackTrace();
				// System.out.println("에러!!");
				// }
	
			} else if (path.equals("/guide")) {
				System.out.println("잘들어오잖아");
				GameInfoDTO gameInfoDTO = g.fromJson(request.getReader(), GameInfoDTO.class); // ajax로 작성된 데이터 받아와서 dto에 저장
				
				int game_seq = gameInfoDTO.getSeq();
				try {
				
						GameInfoDTO result = gameInfoDAO.selectGameInfoBySeq(game_seq); // 문장들 다 뽑고
						response.setContentType("application/json; charset=UTF-8");
						PrintWriter pw = response.getWriter();
						System.out.println(result);
						System.out.println("직렬화 테스트: " + g.toJson(result));
						pw.append(g.toJson(result)); // ajax 보내기
					
	
				} catch (Exception e) {
				    e.printStackTrace();
				    response.setContentType("application/json; charset=UTF-8");
				    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				    PrintWriter pw = response.getWriter();
				    pw.append("{\"error\":\"서버 오류 발생\"}");
				}
	
	
				// ajax로 게시판 내용들 가져오기
	
			}
		}catch(Exception e) {
			e.printStackTrace();
			request.getRequestDispatcher("/error").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
