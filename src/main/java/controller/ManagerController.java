package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import commons.SessionManager;
import dao.ManagerDAO;


@WebServlet("/api/manage/*")
public class ManagerController extends HttpServlet {


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String path = request.getPathInfo(); 
		String loginId = (String) request.getSession().getAttribute("loginId");


		ManagerDAO managerDAO = ManagerDAO.getInstance();
		Gson gson = new Gson();
		try {
			if(path == null || path.equals("/main")) {

				request.getRequestDispatcher("/WEB-INF/views/manage/chart.jsp").forward(request, response);
			} else if(path.equals("/mypage")) {

				request.getRequestDispatcher("/api/friends/mypage?clickedUserID"+loginId).forward(request, response);
			}else if(path.equals("/user")) {

				request.getRequestDispatcher("/WEB-INF/views/manage/user.jsp").forward(request, response);
			}else if(path.equals("/board")) {

				request.getRequestDispatcher("/WEB-INF/views/manage/board.jsp").forward(request, response);
			}else if(path.equals("/game")) {

				request.getRequestDispatcher("/WEB-INF/views/manage/game.jsp").forward(request, response);
			}else if(path.equals("/store")) {

				request.getRequestDispatcher("/WEB-INF/views/manage/store.jsp").forward(request, response);
			}else if(path.equals("/signup-data")) {
				// url : '/api/manage/signup-data?type='+type,
				String type = request.getParameter("type");
				
				List<Map<String,String>> list = managerDAO.selectSignUp_Data(type);

				Map<String,Object> jsonMap = new HashMap<>();
				List<String> label = new ArrayList<>();
				List<Integer> data = new ArrayList<>();

				for(Map<String,String> row : list){
					label.add(row.get("label"));
					data.add(Integer.parseInt(row.get("data")));
				}

				jsonMap.put("label", label);
				jsonMap.put("data", data);

				String json = gson.toJson(jsonMap);

				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(json);  
				System.out.println(json);


			}else if(path.equals("/post-data")) {
				// url: '/api/manage/post-data?type='+type,
				String type = request.getParameter("type");

				List<Map<String,String>> list = managerDAO.selectPost_Data(type);

				Map<String,Object> jsonMap = new HashMap<>();
				List<String> label = new ArrayList<>();
				List<Integer> data = new ArrayList<>();

				for(Map<String,String> row : list){
					label.add(row.get("label"));
					data.add(Integer.parseInt(row.get("data")));
				}

				jsonMap.put("label", label);
				jsonMap.put("data", data);

				String json = gson.toJson(jsonMap);

				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(json);  
				System.out.println(json);


			}else if(path.equals("/top-players")) {
				//게임 횟수 많은 순 차트
				//url: '/api/manage/top-players?game='+gameseq, // 서버에서 gameType에 따라 데이터 분기
				int game_seq = Integer.parseInt(request.getParameter("game"));
				
				List<Map<String,String>> list = managerDAO.selectTop_Players(game_seq);

				Map<String,Object> jsonMap = new HashMap<>();
				List<String> label = new ArrayList<>();
				List<Integer> data = new ArrayList<>();

				for(Map<String,String> row : list){
					label.add(row.get("label"));
					data.add(Integer.parseInt(row.get("data")));
				}

				jsonMap.put("label", label);
				jsonMap.put("data", data);

				String json = gson.toJson(jsonMap);

				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(json);  
				System.out.println(json);


			}else if(path.equals("/gamePlayChart")) {
				//총게임 플레이 횟수 차트
				//url: '/api/manage/gamePlayChart',

				List<Map<String,String>> list = managerDAO.selectGamePlayCount();  // game_seq 예시

				Map<String,Object> jsonMap = new HashMap<>();
				List<String> titles = new ArrayList<>();
				List<Integer> data = new ArrayList<>();

				for(Map<String,String> row : list){
					titles.add(row.get("title"));
					data.add(Integer.parseInt(row.get("count")));
				}

				jsonMap.put("title", titles);
				jsonMap.put("data", data);

				String json = gson.toJson(jsonMap);

				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(json);  
				System.out.println(json);

				//세션에 남아있는 banned된 유저의 세션 만료 시키기
			}else if(path.equals("/bannedUser")) {
				String bannedUserId = request.getParameter("bannedUserId");
				SessionManager.getInstance().invalidateSession(bannedUserId);
				
				//현재 로그인 상태의 유저 수를 파악하는 api
			}else if(path.equals("/getSessionUserCount")) {
				int count = SessionManager.getInstance().getActiveSessionCount();
				response.setContentType("application/json;charset=UTF-8");
			    response.setCharacterEncoding("UTF-8");

			    String json = "{ \"activeUserCount\": " + count + " }";

			    response.getWriter().write(json);
			    response.getWriter().flush();
			}
		}catch(Exception e) {
			
			e.printStackTrace();
			request.getRequestDispatcher("/error").forward(request, response);
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
