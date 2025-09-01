package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MemberDAO;

@WebServlet("/api/point/*")
public class PointController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo(); 


		try {
			if(path.equals("/pointPage")) {
				
				
				
				request.getRequestDispatcher("/WEB-INF/views/store/selling.jsp").forward(request, response);
			}
		}catch(Exception e) {
				e.printStackTrace();
				response.sendRedirect("/error");
			}
		}
		protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

			doGet(request, response);
		}

	}
