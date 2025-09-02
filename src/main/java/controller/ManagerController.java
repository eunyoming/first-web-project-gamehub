package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import commons.SessionManager;
import dao.GameDAO;
import dao.ManagerDAO;
import dao.MemberDAO;
import dao.RoleDAO;
import dto.game.GameDTO;
import dto.member.ManagerMemberDTO;
import dto.member.RoleDTO;
import dto.member.SimpleUserProfileDTO;


@WebServlet("/api/manage/*")
public class ManagerController extends HttpServlet {


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String path = request.getPathInfo(); 
		
		String loginId = (String) request.getSession().getAttribute("loginId");

		request.setCharacterEncoding("UTF-8");
		

		ManagerDAO managerDAO = ManagerDAO.getInstance();
		Gson gson = new GsonBuilder().disableHtmlEscaping().registerTypeAdapter(Timestamp.class, new JsonDeserializer<Timestamp>() {
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

				//해당 유저를 banned 시키고, 세션에 남아있는 banned된 유저의 세션 만료 시키기
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
			    
			    //현재 밴된 유저만 뽑아오기
			}else if(path.equals("/bannedUserList")) {
				
				response.setContentType("application/json;charset=UTF-8");
			    response.setCharacterEncoding("UTF-8");
				
				List<RoleDTO> bannedUserList = RoleDAO.getInstance().selectBannedUser();
				List<SimpleUserProfileDTO> bannedUserListResult = new ArrayList<SimpleUserProfileDTO>();
				for(RoleDTO bannedUser: bannedUserList) {
					SimpleUserProfileDTO userDto= MemberDAO.getInstance().getSimpleUserProfile(bannedUser.getId());
					bannedUserListResult.add(userDto);
				}
				
				
				
				String json = gson.toJson(bannedUserListResult);
				System.out.println(json);
				response.getWriter().write(json);
				response.getWriter().flush();
				
			}else if(path.equals("/unban")) {
				String bannedId = request.getParameter("bannedId");
				
				System.out.println("언밴 요청 아이디: "+bannedId);
				
				if(RoleDAO.getInstance().unbanUser(bannedId)) {
					 response.setStatus(HttpServletResponse.SC_OK);
	                response.getWriter().write("{\"status\":\"success\", \"message\":\"언밴 요청이 성공했습니다..\"}");
					
				}else {
		            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write("{\"status\":\"fail\", \"message\":\"언밴 요청이 실패했습니다..\"}");
					
				}
			}else if(path.equals("/memberList")) {
				 int page = Integer.parseInt(request.getParameter("page"));
			        int pageSize = 10;

			        int startRow = (page - 1) * pageSize + 1;
			        int endRow = page * pageSize;

			        List<ManagerMemberDTO> list = MemberDAO.getInstance().getMemberList(startRow, endRow);
			        int totalCount = MemberDAO.getInstance().getTotalMemberCount();

			        
			        
			        Map<String, Object> result = new HashMap<>();
			        result.put("members", list);
			        result.put("totalCount", totalCount);

			        // Gson 으로 JSON 변환
			        String json = gson.toJson(result);

			        response.setContentType("application/json; charset=UTF-8");
			        response.getWriter().write(json);
			        //입력이 들어온 전체 유저의 role을 변경
			}else if(path.equals("/updateRole")) {
				
					String[] ids = request.getParameterValues("ids");
			        String role =request.getParameter("role");
			        
			        System.out.println(ids);
			        System.out.println(role);

			        ManagerDAO.getInstance().updateMemberRoles(Arrays.asList(ids), role);

			        String json = gson.toJson(Collections.singletonMap("status", "success"));
			        response.setContentType("application/json; charset=UTF-8");
			        response.getWriter().write(json);
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
