package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.sql.SQLException;
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
import dao.FriendDAO.FriendshipStatus;
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
			        request.getRequestDispatcher("/api/member/mypage?section=collection&userId="+toUser).forward(request, response);
		        }else {
		        	if(friendDAO.isAlreadyRequested(fromUser, toUser)) {
		        		response.sendRedirect("/error?alreadyFriend");
		        	}else {
		        		response.sendRedirect("/error?friendError");
		        	}
		        	
		        	
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
                
                //친구 요청을 승낙하는 api
            }else if(path.equals("/received-requests-accept")){
            	
            	System.out.println("친구 수락 요청");
            	String targetId= request.getParameter("targetID");
            	if (currentUserId == null || targetId == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"사용자 정보가 누락되었습니다.\"}");
                    return;
                }
            	
            	boolean success = friendDAO.acceptFriendship(targetId, currentUserId);

            	if (success) {
                    // 성공 응답
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"status\":\"success\", \"message\":\"친구 요청이 수락되었습니다.\"}");
                } else {
                    // 실패 응답 (DB 업데이트 실패 등)
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"status\":\"fail\", \"message\":\"친구 요청 수락에 실패했습니다.\"}");
                }
            	
            	//친구 요청 취소 api
            }else if(path.equals("/sent-requests-cancel")) {
            	
            	System.out.println("친구 요청 취소");
            	
            	String targetId= request.getParameter("targetID");
            	
            	if (currentUserId == null || targetId == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"사용자 정보가 누락되었습니다.\"}");
                    return;
                }
            	
            	boolean success = friendDAO.cancelOrDeleteFriendship(currentUserId, targetId);
            	if (success) {
                    // 성공 응답
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"status\":\"success\", \"message\":\"친구 요청이 취소 되었습니다.\"}");
                } else {
                    // 실패 응답 (DB 업데이트 실패 등)
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"status\":\"fail\", \"message\":\"친구 요청 취소에 실패했습니다.\"}");
                }
            	//친구 삭제
            }else if(path.equals("/delete")) {
            	
            	System.out.println("친구 삭제");
            	
            	String targetId= request.getParameter("targetID");
            	
            	if (currentUserId == null || targetId == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"사용자 정보가 누락되었습니다.\"}");
                    return;
                }
            	
            	boolean success = friendDAO.cancelOrDeleteFriendship(currentUserId, targetId);
            	if (success) {
                    // 성공 응답
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"status\":\"success\", \"message\":\"친구 삭제가 완료 되었습니다.\"}");
                } else {
                    // 실패 응답 (DB 업데이트 실패 등)
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"status\":\"fail\", \"message\":\"친구 삭제에 실패했습니다.\"}");
                }
            	
            }
            //친구 상태 체크 메소드
            else if (path.equals("/friendsCheck")) {
                String targetId = request.getParameter("targetID"); 
               

                // 친구 상태 확인
                FriendshipStatus status = friendDAO.checkFriendshipStatus(currentUserId, targetId);

                // JSON 반환
                response.setContentType("application/json;charset=UTF-8");
                PrintWriter out = response.getWriter();
                
                String json = "{}";

                switch (status) {
                    case NONE:
                        json = "{\"status\":\"none\"}"; // 아무 관계 없음
                        break;
                    case FRIEND:
                        json = "{\"status\":\"friend\"}"; // 이미 친구
                        break;
                    case REQUEST_SENT:
                        json = "{\"status\":\"request_sent\"}"; // 내가 보낸 요청 대기
                        break;
                    case REQUEST_RECEIVED:
                        json = "{\"status\":\"request_received\"}"; // 상대가 보낸 요청 대기
                        break;
                }

                out.print(json);
                out.flush();
            }

		}catch(SQLException e) {
			e.printStackTrace();
			int errorCode = e.getErrorCode();
			System.out.println(errorCode);
			if(errorCode == 20001 || errorCode==1) {
				response.sendRedirect("/error?alreadyFriend");
			}else {
				response.sendRedirect("/error?friendError");
			}
			
		}catch(Exception e) {
			response.sendRedirect("/error?friendError");
		}
		
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
