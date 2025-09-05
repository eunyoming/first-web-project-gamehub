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

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Safelist;

import com.google.gson.Gson;

import dao.BoardDAO;
import dao.RepliesLikesDAO;
import dao.ReplyDAO;
import dto.board.ReplyDTO;

@WebServlet("*.reply")
public class ReplyController extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String cmd = request.getRequestURI();
		BoardDAO board_dao = BoardDAO.getInstance();
		ReplyDAO reply_dao = ReplyDAO.getInstance();
		RepliesLikesDAO replies_likes_dao = RepliesLikesDAO.getInstance();

		try {
			if (cmd.equals("/insert.reply")) {
				String writer = request.getParameter("writer");
				String contents = request.getParameter("contents");
				int board_seq = Integer.parseInt(request.getParameter("board_seq"));
				int parent_seq = Integer.parseInt(request.getParameter("parent_seq"));
				
				// 댓글 태그 공격 방어
				Document doc = Jsoup.parseBodyFragment(contents);
				doc.select("script, style").unwrap(); // 태그만 제거, 내부 텍스트는 보존

				Safelist safelist = Safelist.none().addTags("b", "i", "u", "br");
				String cleanContents = Jsoup.clean(doc.body().html(), safelist);
				
				ReplyDTO dto = new ReplyDTO(0, writer, cleanContents, 0, board_seq, parent_seq, null, "public", null);
				int result = reply_dao.insertReplies(dto);

				response.setContentType("application/json; charset=UTF-8");
				try (PrintWriter pw = response.getWriter()) {
					Map<String, Object> resultMap = new HashMap<>();
					if (result != 0) {
						List<ReplyDTO> replies = reply_dao.selectRepliesByBoardSeq(board_seq);
						for (ReplyDTO reply : replies) {
							String path = reply.getPath();
							String parentWriter = reply_dao.getParentWriterByPath(path);
							reply.setParentWriter(parentWriter);
						}

						resultMap.put("replies", replies);
						resultMap.put("result", result);
						System.out.println("댓글등록완료");
					} else {
						resultMap.put("message", "댓글 등록 실패");
					}

					String json = new Gson().toJson(resultMap);
					pw.print(json);
				}

			}else if(cmd.equals("/update.reply")) {

				String contents = request.getParameter("contents");
				int seq = Integer.parseInt(request.getParameter("reply_seq"));

				// 수정
				int result = reply_dao.updateRepliesBySeq(contents, seq);

				// 응답 준비
				response.setContentType("application/json; charset=UTF-8");
				try (PrintWriter pw = response.getWriter()) {
					Map<String, Object> resultMap = new HashMap<>();
					resultMap.put("result", result);

					// 수정 성공 시 최신 댓글 목록도 내려주기
					if (result != 0) {
						int board_seq = reply_dao.getBoardSeqByReplySeq(seq);
						List<ReplyDTO> replies = reply_dao.selectRepliesByBoardSeq(board_seq);
						for (ReplyDTO reply : replies) {
							String path = reply.getPath();
							String parentWriter = reply_dao.getParentWriterByPath(path);
							reply.setParentWriter(parentWriter);
						}
						resultMap.put("replies", replies);
					}

					String json = new Gson().toJson(resultMap);
					pw.print(json);
				}

			}else if(cmd.equals("/delete.reply")) {
				int seq = Integer.parseInt(request.getParameter("reply_seq"));
				int board_seq = reply_dao.getBoardSeqByReplySeq(seq);
				// 삭제
				int result = reply_dao.deleteRepliesBySeq(seq);

				// 응답 준비
				response.setContentType("application/json; charset=UTF-8");
				try (PrintWriter pw = response.getWriter()) {
					Map<String, Object> resultMap = new HashMap<>();
					resultMap.put("result", result);

					if (result != 0) {
						List<ReplyDTO> replies = reply_dao.selectRepliesByBoardSeq(board_seq);
						for (ReplyDTO reply : replies) {
							String path = reply.getPath();
							String parentWriter = reply_dao.getParentWriterByPath(path);
							reply.setParentWriter(parentWriter);
						}
						resultMap.put("replies", replies);
						System.out.println("댓글 삭제 완료");
					} else {
						resultMap.put("message", "댓글 삭제 실패");
					}

					String json = new Gson().toJson(resultMap);
					pw.print(json);
				}
				
			}else if (cmd.equals("/like/toggle.reply")) {
			    // 로그인 정보 가져오기
			    String loginId = (String) request.getSession().getAttribute("loginId");
			    int reply_seq = Integer.parseInt(request.getParameter("reply_seq"));
			    System.out.println("댓글 추천 토글: reply_seq = " + reply_seq + ", userId = " + loginId);

			    boolean isLiked = replies_likes_dao.isLiked(reply_seq, loginId);

			    Map<String, Object> result = new HashMap<>();

			    if (isLiked) { // 이미 좋아요 눌렀으면 → 삭제
			        int deleted = replies_likes_dao.deleteLike(reply_seq, loginId);
			        result.put("success", deleted > 0);
			        result.put("action", "delete");
			    } else { // 아직 안 눌렀으면 → 추가
			        int inserted = replies_likes_dao.insertLike(reply_seq, loginId);
			        result.put("success", inserted > 0);
			        result.put("action", "insert");
			    }

			    // 최신 likeCount 가져오기
			    int likeCount = replies_likes_dao.countLikes(reply_seq);

			    // replies 테이블의 like_count 컬럼 업데이트
			    reply_dao.updateRepliesLikeCount(reply_seq, likeCount);

			    result.put("likeCount", likeCount);

			    response.setContentType("application/json; charset=UTF-8");
			    response.getWriter().write(new Gson().toJson(result));

			} else if (cmd.equals("/isLiked.reply")) {
			    String loginId = (String) request.getSession().getAttribute("loginId");
			    int reply_seq = Integer.parseInt(request.getParameter("reply_seq"));
			    response.setContentType("application/json; charset=UTF-8");

			    Map<String, Object> result = new HashMap<>();
			    try {
			        boolean isLiked = replies_likes_dao.isLiked(reply_seq, loginId);
			        int likeCount = replies_likes_dao.countLikes(reply_seq);

			        result.put("isLiked", isLiked);
			        result.put("likeCount", likeCount);
			        result.put("success", true);
			    } catch (Exception e) {
			        e.printStackTrace();
			        result.put("isLiked", false);
			        result.put("likeCount", 0);
			        result.put("success", false);
			        result.put("error", e.getMessage());
			    }

			    response.getWriter().write(new Gson().toJson(result));
			}

			
		}catch(Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
			response.setContentType("application/json; charset=UTF-8");

			try (PrintWriter pw = response.getWriter()) {
				Map<String, Object> errorMap = new HashMap<>();
				errorMap.put("error", e.getMessage());

				String json = new Gson().toJson(errorMap);
				pw.print(json);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
