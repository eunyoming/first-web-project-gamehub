package controller;

import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;

import dao.ChatDAO;
import dao.FriendDAO;
import dto.chat.MessageDTO;


@WebServlet("/chat/*")
public class ChatController extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 String path = request.getPathInfo();
		 ChatDAO chatDAO = ChatDAO.getInstance();
		 FriendDAO friendDAO = FriendDAO.getInstance();
		 String loginId = (String) request.getSession().getAttribute("loginId");
		 Gson gson = new GsonBuilder()
				 .setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES)
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
		 
		 try {
			 if(path.equals("/open")) {

				    String friendId = request.getParameter("friendId");

				    // 1. 로그인 사용자의 친구 목록 조회
				    List<String> friends = friendDAO.getAllFriendIds(loginId);
				    request.setAttribute("friends", friends);

				    if(friendId != null && !friendId.isEmpty()) {
				        // 2. 1:1 채팅방 조회/생성
				        int chatroomSeq = chatDAO.findOrCreateChatroom(loginId, friendId);

				        // 3. 최근 메시지 로딩
				        List<MessageDTO> messages = chatDAO.getMessages(chatroomSeq, 30);

				        request.setAttribute("chatroomSeq", chatroomSeq);
				        request.setAttribute("friendId", friendId);
				        request.setAttribute("messages", messages);
				    } else {
				        // friendId 없으면 기본값
				        request.setAttribute("chatroomSeq", null);
				        request.setAttribute("friendId", null);
				        request.setAttribute("messages", Collections.emptyList());
				    }

				    request.getRequestDispatcher("/WEB-INF/views/chat/chatroom.jsp").forward(request, response);
				}
			 else if(path.equals("/loadMessages")) {
				 int chatroomSeq = Integer.parseInt(request.getParameter("chatroomSeq"));

		            List<MessageDTO> messages = chatDAO.getMessages(chatroomSeq,30);

		            response.setContentType("application/json; charset=UTF-8");
		            response.getWriter().write(gson.toJson(messages));
			 }else if(path.equals("/sendMessage")) {
				 
				 
				 int chatroomSeq = Integer.parseInt(request.getParameter("chatroomSeq"));
		            String content = request.getParameter("content");
		            String senderId = (String) request.getSession().getAttribute("loginId");

		            MessageDTO message=  chatDAO.saveMessage(chatroomSeq, senderId, content);
		            String json = gson.toJson(message);

		            response.setContentType("application/json");
		            response.setCharacterEncoding("UTF-8");
		            response.getWriter().write(json);
		            response.setStatus(HttpServletResponse.SC_OK);
			 }
			 
			 
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("/error/");
		}
		
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
