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
				res.sendRedirect(req.getContextPath() + "/login.jsp");
				return;
			}
		}

		// 로그인 한 상태라면 category 검사
		if (loginUser != null) {
			if ("Banned".equalsIgnoreCase(loginUser.getCategory())) {
				// 밴 유저 → 로그아웃 처리 + 안내 페이지로 이동

				session.invalidate();
				SessionManager.getInstance().removeSession(loginUser.getUserId());

				res.sendRedirect(req.getContextPath() + "/banned.jsp");
				return;
			}
		}

		// 밴이 아니면 정상 진행
		chain.doFilter(request, response);
	}


}