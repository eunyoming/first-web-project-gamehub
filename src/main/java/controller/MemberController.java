package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MemberDAO;


@WebServlet("/api/member/*")
public class MemberController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String path = request.getPathInfo(); 
		MemberDAO dao = MemberDAO.getInstance();
		try {
			if(path.equals("/loginPage")) {
				request.getRequestDispatcher("/WEB-INF/views/member/login.jsp").forward(request, response);
				
				
			}else if(path.equals("/login")){
				// userId, Pw 가져오기
				String userId = request.getParameter("userId");
				String userPassword = request.getParameter("userPassword");

				// 중복 로그인 
				boolean checkLogin = dao.selectMembersByIdAndPW(userId, userPassword);

				// 로그인 성공시
				if(checkLogin) {
					// Session 에 userId 저장
					request.getSession().setAttribute("userId", userId);
					// index.jsp 로 다시 보내기
					response.sendRedirect("/");

				}else { // 실패시
					System.out.println("로그인 실패");
				}

			}else if(path.equals("/joinPage")) {
				response.sendRedirect("/WEB-INF/views/member/join.jsp");
			}else if(path.equals("/join")) {
				request.getRequestDispatcher("/WEB-INF/views/member/join.jsp").forward(request, response);
			}
		}catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("/error.jsp");
		}
	
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
