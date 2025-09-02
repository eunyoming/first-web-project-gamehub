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

import com.google.gson.Gson;

import commons.SessionManager;
import dao.MemberDAO;
import dao.PointDAO;
import dto.member.MemberDTO;
import dto.member.SimpleUserProfileDTO;


@WebServlet("/api/member/*")
public class MemberController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String path = request.getPathInfo(); 
		MemberDAO dao = MemberDAO.getInstance();
		Gson g = new Gson ();
		
		try {
			if(path.equals("/loginPage")) {
				request.getRequestDispatcher("/WEB-INF/views/member/login.jsp").forward(request, response);


			}else if(path.equals("/login")){
				// userId, Pw 가져오기
				String userId = request.getParameter("userId");
				String userPassword = encrypt(request.getParameter("userPassword"));

				System.out.println(userId + ":" + userPassword);

				SimpleUserProfileDTO loginDto = dao.login(userId, userPassword);

				// 로그인 성공시
				if(loginDto != null) {
					// Session 에 userId 저장
					if ("Banned".equalsIgnoreCase(loginDto.getCategory())) {
						// 로그인 자체 차단
						response.sendRedirect("/banned.jsp");
						return;
					}
					request.getSession().setAttribute("loginId", userId);

					request.getSession().setAttribute("simpleProfile", loginDto);
					request.getSession().setAttribute("loginId", userId);
					request.getSession().setAttribute("currentPoint", PointDAO.getInstance().getCurrentPoints(userId));

					//세션 메니저에 세션 등록
					SessionManager.getInstance().addSession(userId, request.getSession());	

					// index.jsp 로 다시 보내기
					response.sendRedirect("/");

				}else { // 실패시
					System.out.println("로그인 실패");
					response.sendRedirect("/api/member/loginPage");
				}
			}
			// 아이디 찾기
			else if (path.equals("/findId")) {

				String name = request.getParameter("name");
				String email = request.getParameter("email");

				String id = dao.matchedId(name, email);

				response.setContentType("application/json");
				PrintWriter pw = response.getWriter();

				if (id != null) {
					pw.write("{\"id\": \"" + id + "\"}");
				}else {
					pw.write("{\"id\": null}");
				}
			}
			// 비밀번호 찾기
			else if (path.equals("/findPw")) {

				String id = request.getParameter("id");
				String name = request.getParameter("name");
				String email = request.getParameter("email");

				String userId = dao.matchedUser(id, name, email);

				response.setContentType("application/json");
				PrintWriter pw = response.getWriter();

				if (userId != null) {
					pw.write("{\"userId\": \"" + userId + "\"}");
				}else {
					pw.write("{\"userId\": null}");
				}
			}
			// 비밀번호 변경 
			else if(path.equals("/findUpdatePw")) {

				String userId = request.getParameter("userId");
				String newPw = encrypt(request.getParameter("newPw"));

				MemberDTO dto = new MemberDTO();
				dto.setId(userId);
				dto.setPw(newPw);

				int result = dao.updateMembersById(dto);

				response.setContentType("application/json");
				PrintWriter pw = response.getWriter();

				if (result > 0) {
					pw.write("{\"success\": true}");
				} else {
					pw.write("{\"success\": false}");
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
			// 이메일 중복 체크
			else if (path.equals("/emailCheck")) {
				
				String email  = request.getParameter("email");

				boolean result = dao.isEmailExist (email);

				PrintWriter pw = response.getWriter();
				pw.write("{\"result\": " + result + "}");
			}
			// 회원가입
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
			// 마이페이지 회원정보
			else if (path.equals("/userInpo")) {
					
				String loginId =(String)request.getSession().getAttribute("loginId");
				System.out.println(loginId);
				
				MemberDTO dto = dao.selectAllMemberId(loginId);
				
				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				
				String result = g.toJson(dto);
				pw.append(result);
				
			}
			// 마이페이지 회원정보 수정
			else if (path.equals("/userInpoUpdate")) {
			    
			    String loginId = (String) request.getSession().getAttribute("loginId");
			    
			    String name = request.getParameter("name");
			    String phone = request.getParameter("phone");
			    String email = request.getParameter("email");
			    String zipcode = request.getParameter("zipcode");
			    String address = request.getParameter("address");
			    String addressDetail = request.getParameter("addressDetail");
			    
			    // 로그인 아이디 포함해서 DTO 생성
			    MemberDTO dto = new MemberDTO(loginId, name, phone, email, zipcode, address, addressDetail);
			    
			    dao.updateMemberById(dto);
			    
			    // 업데이트 후 다시 DB 조회해서 최신 데이터 가져오기
			    MemberDTO updatedDto = dao.selectAllMemberId(loginId);
			    
			    // JSON 응답
			    response.setContentType("application/json; charset=UTF-8");
			    PrintWriter pw = response.getWriter();
			    String result = g.toJson(updatedDto); 
			    pw.append(result);
			}
			// 회원탈퇴
			else if (path.equals("/userSecession")) {
				
				 String loginId = (String) request.getSession().getAttribute("loginId");

		            if (loginId == null) {
		                response.sendRedirect("/login.jsp"); // 로그인 안 된 경우
		                return;
		            }

		            // 회원 탈퇴 처리
		            dao.withdrawMember(loginId);

		            // 세션 만료 (로그아웃 처리)
		            request.getSession().invalidate();

		            // 탈퇴 완료 페이지 or 메인으로 이동
		            response.sendRedirect("/");
			}
			// 로그아웃
			else if(path.equals("/logout")) {

				//세션 매니저에서 제거
				SessionManager.getInstance().removeSession((String) request.getSession().getAttribute("loginId"));
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

