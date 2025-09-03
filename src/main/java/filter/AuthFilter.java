package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.SessionManager;
import dao.ReportDAO;
import dao.RoleDAO;
import dto.member.SimpleUserProfileDTO;

@WebFilter("/*") // 모든 요청 필터링, 필요하면 /secure/* 이런 식으로 좁힐 수도 있음
public class AuthFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		HttpSession session = req.getSession(false);
		// 세션에서 로그인 정보 가져오기
		SimpleUserProfileDTO loginUser = null;
		
		if (session != null) {
			loginUser = (SimpleUserProfileDTO) session.getAttribute("simpleProfile");
		}
		
		// 로그인 여부 체크
		if (loginUser == null) {
			String uri = req.getRequestURI();

			// 비회원 > 글 CUD, 댓글 CUD 페이지들 제한
			if (uri.endsWith("/write.board") || uri.endsWith("/insert.board") ||
					uri.endsWith("/update.board") || uri.endsWith("/delete.board") ||
					uri.endsWith("/insert.reply") || uri.endsWith("/update.reply") ||
					uri.endsWith("/delete.reply")) {
				res.sendRedirect("/");
				return;
			}
		}
		
	    String uri = req.getRequestURI();


		try {
			// 로그인 한 상태라면 category 검사
			if (loginUser != null) {
		        String category = loginUser.getCategory();

		        if ("Banned".equalsIgnoreCase(category)) {
		            // DB에서 최신 차단 정보 조회
		            java.util.Date bannedUntil = ReportDAO.getInstance().getLatestBannedUntil(loginUser.getUserId());

		            boolean stillBanned = true;
		            if (bannedUntil != null) {
		                java.util.Date now = new java.util.Date();
		                if (now.after(bannedUntil)) {
		                    // 차단 기간 종료 -> category 원복
		                    loginUser.setCategory("User"); // 세션 갱신
		                    RoleDAO.getInstance().unbanUser(loginUser.getUserId()); // DB 갱신
		                    stillBanned = false;
		                }
		            }

		            if (stillBanned) {
		                // 세션 완전 제거
		                if (session != null) {
		                    session.invalidate();
		                }
		                SessionManager.getInstance().removeSession(loginUser.getUserId());

		                // banned.jsp로 redirect, URL 파라미터로 bannedUntil 전달 가능
		                String redirectUrl = req.getContextPath() + "/banned.jsp";
		                if (bannedUntil != null) {
		                    redirectUrl += "?bannedUntil=" + bannedUntil.getTime(); // timestamp로 전달
		                }
		                res.sendRedirect(redirectUrl);
		                return;
		            }
		        }


		        // Manager가 아닌 경우 /api/manage/* 접근 제한
		        if (uri.startsWith(req.getContextPath() + "/api/manage/") &&
		            !"Manager".equalsIgnoreCase(category)) {
		            res.sendError(HttpServletResponse.SC_FORBIDDEN, "관리자만 접근 가능합니다.");
		            return;
		        }
		    }
		}catch(Exception e) {
			e.printStackTrace();
			
		}



		// 밴이 아니면 정상 진행
		chain.doFilter(request, response);
	}


}