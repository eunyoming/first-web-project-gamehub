package controller;

import java.io.IOException;
import java.io.PrintWriter;
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

import dao.NotificationDAO;
import dto.board.BoardDTO;
import dto.board.ReplyDTO;
import dto.chat.MessageDTO;
import dto.notification.NotificationDTO;

@WebServlet("/notification/*")
public class NotificationController extends HttpServlet {


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo();

		String loginId = (String) request.getSession().getAttribute("loginId");
		Gson gson = new Gson();
		NotificationDAO notificationDao = NotificationDAO.getInstance();
		
		try {
			if(path.equals("/checkNotification")) {
				boolean selectResult = notificationDao.isSelectNotificationsByUserIdAndIsRead(loginId);
				
				PrintWriter pw = response.getWriter();
				pw.append(""+selectResult);
			}
			else if(path.equals("/viewNotification")) {
				List<NotificationDTO> result = notificationDao.selectNotificationsByUserIdAndIsRead(loginId);
				
				notificationDao.updateNotificationsByUserId(loginId);
				
				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(gson.toJson(result));  // gson 사용
			}
			else if(path.equals("/view")) {
				notificationDao.updateNotificationsByUserId(loginId);
				
				List<NotificationDTO> result = notificationDao.selectNotificationsByUserId(loginId);
				
				// JSON으로 변환
				response.setContentType("application/json; charset=UTF-8");
				
				PrintWriter pw = response.getWriter();
				pw.append(gson.toJson(result));  // gson 사용
				
				System.out.println(gson.toJson(result));
				
			}
			else if(path.equals("/delete")) {
				int seq = Integer.parseInt(request.getParameter("notification_seq"));
				
				int result = notificationDao.deleteNotificationsBySeqAndUserId(seq,loginId);	
			}
			
			else if(path.equals("/deleteAll")) {
				int result = notificationDao.deleteAllNotifications(loginId);	
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("/error/");
		}
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
