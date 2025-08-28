package controller;

import java.io.BufferedReader;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.AchievementDAO;
import dto.game.UserAchievementDTO;


@WebServlet("/api/achievement/*")
public class AchievementController extends HttpServlet {
	

  
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		
		BufferedReader reader = request.getReader();
	    Gson gson = new Gson();
	    
	    AchievementDAO achieveDao = AchievementDAO.getInstance();

		String path = request.getPathInfo(); 
		String loginId = (String) request.getSession().getAttribute("loginId");

		try {
			if(path.equals("/unlock")) {
				
				UserAchievementDTO userAchievDto = gson.fromJson(reader, UserAchievementDTO.class);

				
				
				boolean alreadyUnlocked = achieveDao.hasUserUnlocked(loginId, userAchievDto.getAchievementId());
			    JsonObject result = new JsonObject();

			    
			    //이미 달성한 업적인지 체크
			    if (!alreadyUnlocked) {
			        boolean success = achieveDao.insertUserAchievement(userAchievDto);
			        result.addProperty("status", success ? "success" : "fail");
			    } else {
			        result.addProperty("status", "already");
			        result.addProperty("message", "이미 달성한 업적입니다.");
			    }

			    response.setContentType("application/json");
			    response.getWriter().print(result.toString());
	        	
	           
	        }	
		}catch(Exception e) {
			
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		doGet(request, response);
	}

}
