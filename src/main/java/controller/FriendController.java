package controller;

import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.util.List;

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

import dao.FriendDAO;
import dto.friend.FriendshipDTO;


@WebServlet("/api/friends/*")
public class FriendController extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String path = request.getPathInfo(); 
		FriendDAO friendDAO = FriendDAO.getInstance();
		String currentUserId = (String) request.getSession().getAttribute("loginId");
		List<FriendshipDTO> resultList = null;
		
		Gson gson = new GsonBuilder()
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
		
		 response.setContentType("application/json");
	        response.setCharacterEncoding("UTF-8");
		
		try {
			if(path.equals("/mypage")) {
				
				String clickedUserID = request.getParameter("clickedUserID");
				
				request.getRequestDispatcher("/WEB-INF/views/mypage/main.jsp?userId="+clickedUserID).forward(request, response);
				
				//친구 요청 버튼으로 전송되었을 때 - > 이 둘이 서로 친구가 아니라면, 친구 테이블에 신규 데이터 삽입
			}else if(path.equals("/request")) {
				
			    String fromUser = request.getParameter("fromUser");
		        String toUser = request.getParameter("toUser");
		        
		        System.out.println("fromUser : "+fromUser +"toUser: " +toUser);
		        
		        if(fromUser.equals(toUser)) {
		        	//자기 자신에게 요청을 보낸다면
		        	response.sendRedirect("/error.jsp");
		        }

		        // DB에 INSERT (LEAST/GREATEST 정렬해서 넣는 로직 포함)
		        
		        boolean success =friendDAO.requestFriend(fromUser, toUser);
		        if(success) {
			        request.getRequestDispatcher("/WEB-INF/views/mypage/main.jsp?userId="+toUser).forward(request, response);
		        }else {
		        	response.sendRedirect("/error.jsp");
		        }

			}else if ("/sent-requests".equals(path)) {
                resultList = friendDAO.selectFriendShipRequestsByID(currentUserId);
                String jsonResult = gson.toJson(resultList);
                response.getWriter().write(jsonResult);
            } else if ("/received-requests".equals(path)) {
                resultList = friendDAO.selectFriendShipResponsesByID(currentUserId);
                String jsonResult = gson.toJson(resultList);
                response.getWriter().write(jsonResult);
            } else if ("/list".equals(path)) {
                resultList = friendDAO.selectAllMyFriendships(currentUserId);
                String jsonResult = gson.toJson(resultList);
                response.getWriter().write(jsonResult);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Endpoint not found.\"}");
                return;
            }


		}catch(Exception e) {
			e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An internal error occurred.\"}");
		}
		
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
