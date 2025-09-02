package controller;

import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Timestamp;
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


import dao.PointDAO;
import dto.point.PointDTO;

@WebServlet("/api/point/*")
public class PointController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo(); 

		
		Gson gson =  new GsonBuilder().disableHtmlEscaping().registerTypeAdapter(Timestamp.class, new JsonDeserializer<Timestamp>() {
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
		}).create();
		
		PointDAO pointDao = PointDAO.getInstance();

		try {
			if(path == null ||path.equals("/pointPage")) {
					
				request.getRequestDispatcher("/WEB-INF/views/store/selling.jsp").forward(request, response);
			
				//여러명에게 동시 지급(관리자 권한)
			}else if(path.equals("/addPointsUsersByManager")) {
				
				
		            String[] ids = request.getParameterValues("ids");
		            
		            int points = Integer.parseInt(request.getParameter("points"));
		          
		            String typeCode = request.getParameter("typeCode");
		            String description = request.getParameter("description");

		            pointDao.addPointsWithLogUsers(ids, points,typeCode, description);

		            response.getWriter().write("{\"status\":\"success\"}");
				
				//ajax로 호출
			}else if(path.equals("/gameOver")) {
				
				String loginId = (String) request.getSession().getAttribute("loginId");
				int seq = Integer.parseInt(request.getParameter("seq"));
			    int pointValue = Integer.parseInt(request.getParameter("pointValue"));

				
				PointDTO pointDto= pointDao.selectPointBySeq( seq );
				if(pointDto.equals(null)) {
					response.getWriter().write("{\"status\":\"fail\"}");
					return;
				}
				
				if(pointDto.getValue() ==0) {
					pointDto.setValue( pointValue);
				}
				
				//한 회원에게 포인트 지급 순서대로 아이디, 포인트, 설명, 타입코드
				pointDao.addPoint(loginId, pointDto.getValue(), pointDto.getTitle()+pointDto.getDescription(), pointDto.getType());
				
				//세션의 point에 최신화
				request.getSession().setAttribute("currentPoint", pointDao.getCurrentPoints(loginId));
			
				response.getWriter().write("{\"status\":\"success\"}");
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
