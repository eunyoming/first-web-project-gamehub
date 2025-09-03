package controller;

import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.util.ArrayList;
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
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;

import commons.SessionManager;
import dao.BoardDAO;
import dao.MemberDAO;
import dao.ReplyDAO;
import dao.ReportDAO;
import dto.member.SimpleUserProfileDTO;
import dto.report.ReportDTO;


@WebServlet("/report/*")
public class ReportController extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String path = request.getPathInfo(); 
		
		request.setCharacterEncoding("UTF-8");

		
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		 Gson gson = new GsonBuilder()
				    .registerTypeAdapter(Timestamp.class, new JsonDeserializer<Timestamp>() {
				        @Override
				        public Timestamp deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
				                throws JsonParseException {
				            JsonPrimitive primitive = json.getAsJsonPrimitive();
				            if (primitive.isNumber()) {
				                return new Timestamp(primitive.getAsLong());
				            } else if (primitive.isString()) {
				                try {
				                    return new Timestamp(Long.parseLong(primitive.getAsString()));
				                } catch (NumberFormatException e) {
				                    throw new JsonParseException("Invalid timestamp format", e);
				                }
				            } else {
				                throw new JsonParseException("Unsupported timestamp format");
				            }
				        }
				    })
				    .create();
		 
		try {
			//리포트 출력
			if(path.equals("/list")) {
				
				
				
				ReportDAO reportDao = ReportDAO.getInstance();
				List<ReportDTO> reportList = reportDao.selectAllReportsNoneProcessed();
				
				if(reportList.size() == 0) {
					System.out.println("신고 리포트 개수 0");
					 Map<String, Object> responseMap = new HashMap<>();
					    responseMap.put("reports", new ArrayList<ReportDTO>());
					    responseMap.put("users", new ArrayList<SimpleUserProfileDTO>());

					    String json = gson.toJson(responseMap);
					    response.getWriter().write(json);
					    return;

				}else {
					
					List<SimpleUserProfileDTO> targetUserList = new ArrayList<>();
					for(ReportDTO report: reportList){
						
						if(report.getTargetType().equals("User")) {
							
							//targetSeq 가 곧 userId
							String targetUserId = report.getTargetSeq();
							
							targetUserList.add(MemberDAO.getInstance().getSimpleUserProfile(targetUserId));
						}else if(report.getTargetType().equals("Board")) {
							
							//board의 writer 아이디를 검색 후 저장.

							String targetUserId = BoardDAO.getInstance().selectBoardsBySeq(Integer.parseInt(report.getTargetSeq())).getWriter();
							targetUserList.add(MemberDAO.getInstance().getSimpleUserProfile(targetUserId));
							
						}else if(report.getTargetType().equals("reply")) {
							
							//해당 댓글의 writer 아이디를 검색 후 저장.
							//아직 미구현
							
							String targetUserId =ReplyDAO.getInstance().selectRepliesBySeq(Integer.parseInt(report.getTargetSeq())).getWriter();
							targetUserList.add(MemberDAO.getInstance().getSimpleUserProfile(targetUserId));
						}

						
					};
					

					Map<String, Object> responseMap = new HashMap<>();
					responseMap.put("reports", reportList);
					responseMap.put("users", targetUserList);

					String json = gson.toJson(responseMap);
					response.getWriter().write(json);	
				    
				}
				
				
			     //리포트 전송
			}else if(path.startsWith("/submit/")) {
				
				System.out.println("신고접수");
				
				String reporterId = (String) request.getSession().getAttribute("loginId");
				
				
				String targetType = path.substring("/submit/".length()); 
				String target_seq = null;
				String targetUserID = null;
				if(targetType.equals("board")) {
					target_seq = request.getParameter("board_seq");
					targetUserID = request.getParameter("writer");

				}else if(targetType.equals("reply")) {
					target_seq = request.getParameter("reply_seq");
					 targetUserID = request.getParameter("writer");
				}else if(targetType.equals("user")) {
					target_seq= request.getParameter("userID");
				 targetUserID =target_seq;
				}
				
				String reason = request.getParameter("reason");
				
				

				boolean success = ReportDAO.getInstance().insertReports(reporterId ,targetUserID, targetType, target_seq, reason);
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write("{\"success\":" + success + "}");

				
				//리포트 처리
			}else if(path.equals("/proceed")) {
				
				String adminId = (String) request.getSession().getAttribute("loginId");
				
				String[] report_seq = request.getParameterValues("report_seq");
				
				
				String proceedReason = request.getParameter("proceedReason");
				int bannedDays = Integer.parseInt(request.getParameter("bannedDays"));

				System.out.println("밴 사유"+proceedReason);

					for (int i = 0; i < report_seq.length; i++) {
						 String seq = report_seq[i];

						
						//리포트 처리 로직
						 // 1. 신고 대상 찾기
						ReportDTO report = ReportDAO.getInstance().findReportTarget(Integer.parseInt(seq) );
			            if (report == null) {
			                response.sendError(HttpServletResponse.SC_NOT_FOUND, "신고 내역이 존재하지 않습니다.");
			                return;
			            }

			            // 2. 대상 유저 찾기
			            String targetUserId = ReportDAO.getInstance().findTargetUserId(report.getTargetType(), report.getTargetSeq());
			            System.out.println("대상 유저 아이디: "+targetUserId);
			            // 3. 유저 차단
			            if (targetUserId != null) {
			            	
			            	//유저의 type을 banned로 바꿈
			            	ReportDAO.getInstance().banUser(targetUserId);
			            	
			            	//세션에서도 차단
			            	SessionManager.getInstance().invalidateSession(targetUserId);
			            }

			            // 4. 컨텐츠 숨김 처리 (Board/Reply일 경우만)
			            ReportDAO.getInstance().hideContent(report.getTargetType(), report.getTargetSeq());

			            // 5. REPORT 상태 갱신
			            ReportDAO.getInstance().updateReportStatus(Integer.parseInt(seq), adminId, proceedReason, bannedDays );
						
						
					
					}
				

				response.sendRedirect("/api/manage/user");
				
				
				//리포트 캔슬 (그냥 reject 상태로 만듬)
			}else if(path.equals("/reject")) {
				
				String adminId = (String) request.getSession().getAttribute("loginId");
				
				String[] report_seq = request.getParameterValues("report_seq");
				
				
				for (String seq : report_seq) {
		
				   ReportDAO.getInstance().rejectReport(adminId,Integer.parseInt(seq),"이미 처리된 안건이므로 rejected 되었습니다.");
				}

				request.getRequestDispatcher("/api/manage/user").forward(request, response);
				
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			request.getRequestDispatcher("/error/report").forward(request, response);
		}
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
