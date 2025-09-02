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
import dao.StoreDAO;
import dto.pointStore.PointStoreDTO;

@WebServlet("/api/store/*")
public class StoreController extends HttpServlet {
	

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getPathInfo(); 
		String loginId = (String) request.getSession().getAttribute("loginId"); 
		Gson gson = new Gson();

		StoreDAO storeDAO = StoreDAO.getInstance();
		try {
			
			if(path.equals("/itemView"))
			{
				List<Map<String,Object>> pointStoreData = storeDAO.selectPointStoreLeftJoinPointpurchase(loginId);

				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(gson.toJson(pointStoreData));  // gson 사용

				System.out.println(gson.toJson(pointStoreData));
			}
			else if(path.equals("/itemDetail"))
			{
				// url : '/api/manage/signup-data?type='+type,
				String seq = request.getParameter("seq");
				request.setAttribute("seq", seq);  
				request.getRequestDispatcher("/WEB-INF/views/store/itemDetail.jsp").forward(request, response);
			}
			else if(path.equals("/itemDetailView"))
			{
				System.out.println(":111");
				int seq = Integer.parseInt(request.getParameter("seq"));
				PointStoreDTO pointStoreDTO = storeDAO.selectPointStoreBySeq(seq);
				boolean isPurchased = storeDAO.selectPointPurchaseBySeqAndUserId(seq,loginId);
				
				Map<String, Object> resultMap = new HashMap<>();
				resultMap.put("seq", pointStoreDTO.getSeq());
				resultMap.put("itemName", pointStoreDTO.getItemName());
				resultMap.put("contents", pointStoreDTO.getContents());
				resultMap.put("price", pointStoreDTO.getPrice());
				resultMap.put("url", pointStoreDTO.getUrl());
				resultMap.put("isPurchased", isPurchased);
				
				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(gson.toJson(resultMap));  // gson 사용

				System.out.println(gson.toJson(resultMap));
			}
			else if(path.equals("/itemDetailBuy"))
			{
				PointDAO pointDao = PointDAO.getInstance();
				
				int storeSeq = Integer.parseInt(request.getParameter("storeSeq"));
				
				boolean isPurchased = storeDAO.selectPointPurchaseBySeqAndUserId(storeSeq,loginId);
				if(!isPurchased)
				{
					int points = Integer.parseInt(request.getParameter("points"));
					
					String itemName = request.getParameter("itemName");
					String description = itemName + "을(를) 구매하였습니다.";
					
					String typeCode = "store";
					
					
					System.out.println("아이템 이름 :" + itemName);
					System.out.println("설명 :" + description);
					System.out.println("가격 :" + points);
					
					storeDAO.buyItem(loginId,points,description,typeCode,storeSeq);
					
					request.getSession().setAttribute("currentPoint", pointDao.getCurrentPoints(loginId));
				}
				
				response.setContentType("application/json; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				pw.append(gson.toJson(Map.of("result", "success")));
				
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("/error");
		}
	}


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
