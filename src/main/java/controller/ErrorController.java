package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/error/*")
public class ErrorController extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo(); 
		if(path == null) {
			
			
		}
		else if(path.equals("/noneIdRequest")) {
			request.setAttribute("errorType" , "존재하지 않는 회원의 ID입니다.");
		}else if(path.equals("/alreadyFriend")) {
			request.setAttribute("errorType" , "이미 친구요청을 보낸 회원의 ID 입니다.");
		}else if(path.equals("/friendError")) {
			request.setAttribute("errorType" , "친구 요청 기능 중에 에러가 발생했습니다.");
		}else if(path.equals("/gameReviewError")) {
			request.setAttribute("errorType" , "게임 리뷰를 불러 오거나 수정,삭제를 진행하는데 에러가 발생했습니다.");
		}else if(path.equals("/gameRecordError")) {
			request.setAttribute("errorType" , "게임기록을 저장하거나 불러오는데 에러가 발생했습니다.");
		}
			
		
		request.getRequestDispatcher("/error.jsp").forward(request, response);
		
	
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
