package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/api/manage/*")
public class ManagerController extends HttpServlet {
	
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		String path = request.getPathInfo(); 

        if(path == null || path.equals("/main")) {
            request.getRequestDispatcher("/WEB-INF/views/manage/chart.jsp").forward(request, response);
        } else if(path.equals("/mypage")) {
        	  request.getRequestDispatcher("/WEB-INF/views/mypage/main.jsp").forward(request, response);
        }else if(path.equals("/user")) {
      	  request.getRequestDispatcher("/WEB-INF/views/manage/user.jsp").forward(request, response);
        }else if(path.equals("/board")) {
        	  request.getRequestDispatcher("/WEB-INF/views/manage/board.jsp").forward(request, response);
          }else if(path.equals("/game")) {
        	  request.getRequestDispatcher("/WEB-INF/views/manage/game.jsp").forward(request, response);
          }else if(path.equals("/store")) {
        	  request.getRequestDispatcher("/WEB-INF/views/manage/store.jsp").forward(request, response);
          }
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
