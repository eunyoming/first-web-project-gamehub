package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/footer/*")
public class FooterController extends HttpServlet {
	
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String path = request.getPathInfo();
		 
		 if(path.equals("/privacy")) {
			 
			 request.getRequestDispatcher("/WEB-INF/views/common/userPrivacy.jsp").forward(request, response);
		 }else if(path.equals("/terms")) {
			 
			 request.getRequestDispatcher("/WEB-INF/views/common/userTerms.jsp").forward(request, response);
		 }
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		doGet(request, response);
	}

}
