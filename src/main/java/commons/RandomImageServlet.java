package commons;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
@WebServlet("/randomImages")
public class RandomImageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String basePath = getServletContext().getRealPath("/asset/collection");
        File baseFolder = new File(basePath);

        List<String> allImages = new ArrayList<>();

        // game01 ~ game05 폴더 순회
        for (int i = 1; i <= 5; i++) {
            File gameFolder = new File(baseFolder, "game0" + i);
            if (gameFolder.exists() && gameFolder.isDirectory()) {
                File[] imageFiles = gameFolder.listFiles((dir, name) -> name.matches(".*\\.(jpg|jpeg|png|gif)$"));
                if (imageFiles != null) {
                    for (File img : imageFiles) {
                        String relativePath = "asset/collection/game0" + i + "/" + img.getName();
                        allImages.add(relativePath);
                    }
                }
            }
        }

        // 이미지 섞고 4장 선택
        Collections.shuffle(allImages);
        List<String> selectedImages = allImages.stream().limit(4).collect(Collectors.toList());

        // JSON 응답
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.write(new Gson().toJson(selectedImages));
        out.close();
    }
}

