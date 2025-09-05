package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dao.PointDAO;
import dao.PointLogDAO;
import dto.point.PointLogDTO;

@WebServlet("/api/pointLog/*")
public class PointLogController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo(); 

		Gson gson = new Gson();
		
		PointDAO pointDAO = PointDAO.getInstance();
		PointLogDAO pointLogDAO = PointLogDAO.getInstance();

		try {
			if(path == null || path.equals("/view")) {
				String loginId = (String) request.getSession().getAttribute("loginId");
				
				
				int cpage = 0;
				String cpageStr = request.getParameter("cpage");
				
				if(cpageStr != null) {
					cpage = Integer.parseInt(cpageStr);
				}
				else
				{
					cpage = 1;
				}
				int recordCountPerPage = 5;
				int start = (cpage - 1) * recordCountPerPage + 1;
				int end = cpage * recordCountPerPage;

				List<PointLogDTO> lists = pointLogDAO.selectPoint_LogsByFromTo(loginId,start, end);
				
				int userLogCount = pointLogDAO.countPoint_LogsByUserId(loginId);
				
				
				//일단 멤버의 포인트 값 가져오기.
				int pointValue = pointDAO.getCurrentPoints(loginId);
				
				// Map에 담기
				Map<String, Object> map = new HashMap<>();
				map.put("pointValue", pointValue);
				map.put("currentPage", cpage);
				map.put("lists", lists);
				map.put("userLogCount", userLogCount);
				
				// JSON으로 변환
				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(gson.toJson(map));  // gson 사용
				
				System.out.println(gson.toJson(map));
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
