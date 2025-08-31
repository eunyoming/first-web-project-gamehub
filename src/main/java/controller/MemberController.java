package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.jasper.tagplugins.jstl.core.If;

import dao.MemberDAO;
import dto.member.MemberDTO;


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
				String userPassword = encrypt(request.getParameter("userPassword"));

				System.out.println(userId + ":" + userPassword);

				MemberDTO loginDto = dao.selectMembersByIdAndPW(userId, userPassword);

				// 로그인 성공시
				if(loginDto != null) {
					// Session 에 userId 저장
					request.getSession().setAttribute("loginId", userId);
					request.getSession().setAttribute("currentPoint", loginDto.getPoint());


					// index.jsp 로 다시 보내기
					response.sendRedirect("/");

				}else { // 실패시
					System.out.println("로그인 실패");
					response.sendRedirect("/api/member/loginPage");
				}
			}
			// 아이디 중복 체크 
			else if(path.equals("/idCheck")) {

				String id  = request.getParameter("id");

				boolean result = dao.isIdExist (id);

				PrintWriter pw = response.getWriter();
				pw.write("{\"result\": " + result + "}");
			}
			else if(path.equals("/join")) {
				request.getRequestDispatcher("/WEB-INF/views/member/join.jsp").forward(request, response);
			}
			// 회원가입 insert
			else if(path.equals("/insert")) {
				request.setCharacterEncoding("UTF-8");

				String id = request.getParameter("id");
				String pw = encrypt(request.getParameter("pw"));
				String name = request.getParameter("name");
				String phone = request.getParameter("phone");
				String email = request.getParameter("email");
				String zipcode = request.getParameter("zipcode");
				String address = request.getParameter("address");
				String addressDetail = request.getParameter("addressDetail");
				String privacy_agreed_at = request.getParameter("privacy_agreed_at");

				MemberDTO dto = new MemberDTO (id,pw,name,phone,email,zipcode,address,addressDetail,0,'Y',null,null);

				int result = dao.insertMembers(dto);
				
				if(result != 0) {
				response.sendRedirect("/api/member/loginPage");
				}
			}
			else if(path.equals("/logout")) {
				request.getSession().invalidate();

				response.sendRedirect("/");
			}else if(path.equals("/mypage")) {

				
				String userId = request.getParameter("userId");
				
			if(dao.isIdExist(userId)){
				String loginId = (String) request.getSession().getAttribute("loginId");
				 String section = request.getParameter("section");
			        if (section == null || section.isEmpty()) {
			            section = "collection"; // 기본 탭
			        }


			        request.setAttribute("active", section);
			        request.setAttribute("paramUserId", userId);
			        request.setAttribute("loginId", loginId );


				request.getRequestDispatcher("/WEB-INF/views/mypage/main.jsp").forward(request, response);
			}else {
				//존재하지 않는 id 페이지로의 요청
				response.sendRedirect("/error/noneIdRequest");
			}
				
			}
		}catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("/error");
		}

	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	//암호화
	public static String encrypt(String text) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-512");
			byte[] bytes = text.getBytes(StandardCharsets.UTF_8);
			byte[] digest = md.digest(bytes);

			StringBuilder builder = new StringBuilder();
			for (byte b : digest) {
				builder.append(String.format("%02x", b));
			}
			return builder.toString();

		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("SHA-512 암호화 실패", e);
		}
	}
}

