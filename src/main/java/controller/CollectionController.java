package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.util.List;

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

import dao.GameDAO;
import dao.GameRecordDAO;
import dto.game.GameDTO;
import dto.game.GameRecentDTO;
import dto.game.GameRecordDTO;

@WebServlet("/api/collection/*")
public class CollectionController extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getPathInfo();
		System.out.println(path);
		Gson g = new GsonBuilder().disableHtmlEscaping()
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
				}).create();
		
		String loginId = (String) request.getSession().getAttribute("loginId"); // 로그인 아이디
		GameRecordDAO gameRecordDAO = GameRecordDAO.getInstance();
		GameDAO gameDAO = GameDAO.getInstance();
		System.out.println("요청 path: " + path);
		try {
			if (path == null || path.equals("/recentlyPlayedGames")) {
				System.out.println("들어옴");
				List<GameRecentDTO> gameRecentDTOList = gameRecordDAO.selectGameRecordsByLoginId(loginId);
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter pw = response.getWriter();
				
				pw.append(g.toJson(gameRecentDTOList));
				
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("에러!!");
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
