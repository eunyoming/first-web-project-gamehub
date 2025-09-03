package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardsLikesDAO {
	private static BoardsLikesDAO instance;

	private BoardsLikesDAO() {}

	// getInstance
	public synchronized static BoardsLikesDAO getInstance() {
		if(instance == null) {
			instance = new BoardsLikesDAO();
		}
		return instance;
	}

	// getConnection
	public Connection getConnection() throws Exception{
		Context cxt = new InitialContext();

		DataSource ds = (DataSource)cxt.lookup("java:comp/env/jdbc/oracle");

		return ds.getConnection();
	}
	
	// 게시글 추천 추가
    public int insertLike(int board_seq, String user_id) throws Exception {
        String sql = "INSERT INTO boards_likes (seq, board_seq, user_id, created_at) " +
                     "VALUES (boards_likes_seq.NEXTVAL, ?, ?, SYSTIMESTAMP)";
        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, board_seq);
            ps.setString(2, user_id);
            return ps.executeUpdate();
        }
    }

    // 게시글 추천 취소
    public int deleteLike(int board_seq, String user_id) throws Exception {
        String sql = "DELETE FROM boards_likes WHERE board_seq = ? AND user_id = ?";
        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, board_seq);
            ps.setString(2, user_id);
            return ps.executeUpdate();
        }
    }

    // 추천 여부 확인
    public boolean isLiked(int board_seq, String user_id) throws Exception {
        String sql = "SELECT COUNT(*) FROM boards_likes WHERE board_seq = ? AND user_id = ?";
        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, board_seq);
            ps.setString(2, user_id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // 해당 게시글의 추천 수
    public int countLikes(int board_seq) throws Exception {
        String sql = "SELECT COUNT(*) FROM boards_likes WHERE board_seq = ?";
        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, board_seq);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // 추천 토글 (있으면 삭제, 없으면 추가)
    public Map<String, Object> toggleLike(int board_seq, String user_id) throws Exception {
        Map<String, Object> result = new HashMap<>();
        if (isLiked(board_seq, user_id)) {
            deleteLike(board_seq, user_id);
            result.put("liked", false);
        } else {
            insertLike(board_seq, user_id);
            result.put("liked", true);
        }
        result.put("count", countLikes(board_seq));
        return result;
    }
    
}
