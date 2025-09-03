package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class RepliesLikesDAO {
	private static RepliesLikesDAO instance;

	private RepliesLikesDAO() {}

	// getInstance
	public synchronized static RepliesLikesDAO getInstance() {
		if(instance == null) {
			instance = new RepliesLikesDAO();
		}
		return instance;
	}

	// getConnection
	public Connection getConnection() throws Exception{
		Context cxt = new InitialContext();

		DataSource ds = (DataSource)cxt.lookup("java:comp/env/jdbc/oracle");

		return ds.getConnection();
	}
	
	// 댓글 추천 추가
    public int insertLike(int reply_seq, String user_id) throws Exception {
        String sql = "INSERT INTO replies_likes (seq, reply_seq, user_id, created_at) " +
                     "VALUES (replies_likes_seq.NEXTVAL, ?, ?, SYSTIMESTAMP)";
        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reply_seq);
            ps.setString(2, user_id);
            return ps.executeUpdate();
        }
    }

    // 댓글 추천 취소
    public int deleteLike(int reply_seq, String user_id) throws Exception {
        String sql = "DELETE FROM replies_likes WHERE reply_seq = ? AND user_id = ?";
        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reply_seq);
            ps.setString(2, user_id);
            return ps.executeUpdate();
        }
    }

    // 추천 여부 확인
    public boolean isLiked(int reply_seq, String user_id) throws Exception {
        String sql = "SELECT COUNT(*) FROM replies_likes WHERE reply_seq = ? AND user_id = ?";
        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reply_seq);
            ps.setString(2, user_id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // 해당 댓글의 추천 수
    public int countLikes(int reply_seq) throws Exception {
        String sql = "SELECT COUNT(*) FROM replies_likes WHERE reply_seq = ?";
        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reply_seq);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // 추천 토글
    public Map<String, Object> toggleLike(int reply_seq, String user_id) throws Exception {
        Map<String, Object> result = new HashMap<>();
        if (isLiked(reply_seq, user_id)) {
            deleteLike(reply_seq, user_id);
            result.put("liked", false);
        } else {
            insertLike(reply_seq, user_id);
            result.put("liked", true);
        }
        result.put("count", countLikes(reply_seq));
        return result;
    }
    
}
