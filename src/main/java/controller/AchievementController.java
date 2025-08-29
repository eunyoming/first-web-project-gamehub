package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Timestamp;

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
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;

import dao.AchievementDAO;
import dto.game.AchievementDTO;
import dto.game.UserAchievementDTO;


@WebServlet("/api/achievement/*")
public class AchievementController extends HttpServlet {
	

  
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		
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
	    
	    AchievementDAO achieveDao = AchievementDAO.getInstance();

		String path = request.getPathInfo(); 
		String loginId = (String) request.getSession().getAttribute("loginId");

		try {
			if(path.equals("/unlock")) {
				
			
				//클라이언트가 보낸 json 가져옴.
				BufferedReader reader = request.getReader();
				JsonObject json = JsonParser.parseReader(reader).getAsJsonObject();
				
				String userId = json.get("userId").getAsString();
				String achievementId = json.get("achievementId").getAsString();
				JsonElement unlocked_json = json.get("unlocked_at");
				Timestamp unlocked_at= gson.fromJson(unlocked_json, Timestamp.class);

				
				//업적 아이디를 기반으로 업적 검색
				AchievementDTO achievDto = achieveDao.selectAchievementByID(achievementId);
				if(achievDto == null) {
					System.out.println("해당 업적이 존재하지 않습니다.");
					
				}else {
					
					//해당 업적의 seq를 기반으로 이미 달성한 업적인지 확인

					System.out.println(loginId+":"+ achievDto.getSeq());
					boolean alreadyUnlocked = achieveDao.hasUserUnlocked(loginId, achievDto.getSeq());
				    JsonObject result = new JsonObject();
	   
				    if (!alreadyUnlocked) {
				    	
				    	//최종적으로 db 삽입
				    	
				        boolean success = achieveDao.insertUserAchievement(userId,achievDto.getSeq(), unlocked_at);
				      
				        //그다음 ,achievDto에 적힌 point_seq에 따른 pointDTO 가져오고
				        
				        //point_dto의 값만큼 point_log에 기록 후, 사용자의 point 증가
				        

				        result.addProperty("status", success ? "success" : "fail");
				        
				      
				        if(success) {
				        	result.addProperty("title",achievDto.getTitle());
				        	result.addProperty("description",achievDto.getDescription());
				        	
				        	
				        }else {
				        	
				        }
				    
				    } else {
				    	
				    	System.out.println("업적 기록 이미 달성됨");
				        result.addProperty("status", "already");
				        result.addProperty("message", "이미 달성한 업적입니다.");
				    }

				    response.setContentType("application/json");
				    response.getWriter().print(result.toString());
				}
				
	        }	
		}catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("/error.jsp");
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		doGet(request, response);
	}

}
