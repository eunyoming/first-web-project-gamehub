package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Safelist;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import commons.SessionManager;
import dao.MemberDAO;
import dao.PointDAO;
import dto.member.MemberDTO;
import dto.member.MemberProfileDTO;
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
				
				System.out.println(loginDto != null);
				// 로그인 성공시
				if (loginDto != null) {
					// Session 에 userId 저장
					
					request.getSession().setAttribute("loginId", userId);
					request.getSession().setAttribute("simpleProfile", loginDto);
					request.getSession().setAttribute("currentPoint", PointDAO.getInstance().getCurrentPoints(userId));

					// 세션 메니저에 세션 등록
					SessionManager.getInstance().addSession(userId, request.getSession());

					// Ajax 응답 (JSON)
					response.setContentType("application/json;charset=UTF-8");
					response.getWriter().write("{\"success\": true}");

				}else {
					

					// Ajax 응답 (JSON) - 실패 처리
					response.setContentType("application/json;charset=UTF-8");
					response.getWriter().write("{\"success\": false, \"message\": \"아이디 또는 비밀번호가 올바르지 않습니다.\"}");
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
				String email = request.getParameter("email");
				String userId = (String) request.getSession().getAttribute("loginId"); // 세션에서 현재 로그인 아이디 가져옴

				boolean result = dao.isEmailExist(email, userId);

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

			}else if(path.equals("/getProfile")) {
				String userId = (String) request.getSession().getAttribute("loginId");
			    
			    MemberProfileDTO profile = dao.getProfileByUserId(userId);

			    if (profile == null) {
			        profile = new MemberProfileDTO();
			        profile.setUserID(userId);
			        profile.setProfileImage("/images/default-profile.png");
			        profile.setBio("자기소개를 입력해주세요.");
			        profile.setStatusMessage("상태메시지를 설정해주세요.");
			        profile.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
			        dao.insertDefaultProfile(profile);
			      }

			      response.setContentType("application/json");
			      response.setCharacterEncoding("UTF-8");
			      response.getWriter().write(new Gson().toJson(profile));
			      
			      
			    }else if(path.equals("/getProfileOthers")) {
					String userId = request.getParameter("userId");
					
					System.out.println("친구페이지:"+userId);
				    
				    MemberProfileDTO profile = dao.getProfileByUserId(userId);

				    if (profile == null) {
				        profile = new MemberProfileDTO();
				        profile.setUserID(userId);
				        profile.setProfileImage("/asset/img/default-profile.png");
				        profile.setBio("자기소개를 입력해주세요.");
				        profile.setStatusMessage("상태메시지를 설정해주세요.");
				        profile.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
				        dao.insertDefaultProfile(profile);
				      }

				      response.setContentType("application/json");
				      response.setCharacterEncoding("UTF-8");
				      response.getWriter().write(new Gson().toJson(profile));
				      
				      
				    }else if(path.equals("/updateProfileText")) {
			    	
			    	   request.setCharacterEncoding("UTF-8");
			           response.setContentType("application/json");
			           response.setCharacterEncoding("UTF-8");

			           // JSON 요청 파싱
			           Gson gson = new Gson();
			           JsonObject json = gson.fromJson(request.getReader(), JsonObject.class);

			           String bio = json.get("bio").getAsString();
			           String statusMessage = json.get("statusMessage").getAsString();

			           String userId = (String) request.getSession().getAttribute("loginId");
			           
			           Document docbio = Jsoup.parseBodyFragment(bio);
			           docbio.select("script, style").unwrap(); // 태그만 제거, 내부 텍스트는 보존

			            Safelist safelist = Safelist.none().addTags("b", "i", "u", "br");
			            String cleanBio = Jsoup.clean(docbio.body().html(), safelist);
			           
			            Document docStatusMessage = Jsoup.parseBodyFragment(statusMessage);
				           docbio.select("script, style").unwrap(); // 태그만 제거, 내부 텍스트는 보존

				    
				            String cleanStatusMessage = Jsoup.clean(docStatusMessage.body().html(), safelist);
			            
			           boolean updated = dao.updateProfileText(userId, cleanBio, cleanStatusMessage);

			           // 응답 JSON 생성
			           JsonObject result = new JsonObject();
			           result.addProperty("result", updated ? "success" : "fail");

			           response.getWriter().write(gson.toJson(result));

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

