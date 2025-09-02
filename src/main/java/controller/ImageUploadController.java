package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;



@WebServlet(urlPatterns = {
	    "/api/board/UploadImage",
	    "/api/manage/gameGuideUploadImage",
	    "/api/manage/storeUploadImage"
	})

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10,  // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ImageUploadController extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String basePath = "C:/first-web-project-gamehub/uploads";
		String subFolder = ""; // 초기화

		String uri = request.getRequestURI();
		
		System.out.println(uri);
		if (uri.contains("board")) {
		    subFolder = "board";
		} else if (uri.contains("gameGuide")) {
		    subFolder = "guide";
		} else if (uri.contains("store")) {
		    subFolder = "store";
		}

		// 최종 저장 경로
		String uploadPath = basePath + "/" + subFolder;
		System.out.println(uploadPath);
		
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) uploadDir.mkdirs();


        // 파일 저장
        Part filePart = request.getPart("file");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String savedName = UUID.randomUUID() + "_" + fileName;
        filePart.write(uploadPath + "/" + savedName);

        // 이미지 URL 반환
        String imageUrl = "/uploads/" + subFolder + "/" + savedName;
        
        System.out.println(imageUrl);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"url\":\"" + imageUrl + "\"}");

	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		doGet(request, response);
	}

}
