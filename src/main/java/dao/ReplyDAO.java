package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.board.ReplyDTO;

public class ReplyDAO {
	private static ReplyDAO instance;

	private ReplyDAO() {}

	// getInstance
	public synchronized static ReplyDAO getInstance() {
		if(instance == null) {
			instance = new ReplyDAO();
		}
		return instance;
	}

	// getConnection
	public Connection getConnection() throws Exception{
		Context cxt = new InitialContext();

		DataSource ds = (DataSource)cxt.lookup("java:comp/env/jdbc/oracle");

		return ds.getConnection();
	}


	// 부모 path 조회 - con 호출하는 이유 : 같은 트랜잭션 유지
	private String selectRepliesPathBySeq(int parent_seq, Connection con) throws SQLException {
		String sql = "select path from replies where seq = ?";
		try (PreparedStatement pst = con.prepareStatement(sql)) {

			pst.setInt(1, parent_seq);

			try (ResultSet rs = pst.executeQuery()) {
				if (rs.next()) {
					return rs.getString("path");
				}
			}
		}
		return ""; // 부모 path 못 찾으면 빈 문자열
	}

	// insert
	public int insertReplies(ReplyDTO dto) throws Exception{
		String insertSql = "INSERT INTO replies VALUES(replies_seq.nextval, ?, ?, 0, ?, ?, '', 'public', sysdate)";
		String updateSql = "UPDATE replies SET path = ? WHERE seq = ?";
		
		int result = 0;
	    int mySeq = 0;
	    
		// 트랜잭션 시작
		try (Connection con = this.getConnection()) {
			// AutoCommit 기능 끄기
	        con.setAutoCommit(false);

	        try (PreparedStatement insertPst = con.prepareStatement(insertSql, new String[] {"seq"});) {
	            insertPst.setString(1, dto.getWriter());
	            insertPst.setString(2, dto.getContents());
	            insertPst.setInt(3, dto.getBoard_seq());
	            insertPst.setInt(4, dto.getParent_seq());

	            result = insertPst.executeUpdate();

	            try (ResultSet rs = insertPst.getGeneratedKeys()) {
	                if (rs.next()) {
	                    mySeq = rs.getInt(1);
	                }
	            }

	            String path;
	            if (dto.getParent_seq() == 0) {
	                path = String.valueOf(mySeq);
	            } else {
	                path = selectRepliesPathBySeq(dto.getParent_seq(), con) + "/" + mySeq;
	            }

	            try (PreparedStatement updatePst = con.prepareStatement(updateSql)) {
	                updatePst.setString(1, path);
	                updatePst.setInt(2, mySeq);
	                updatePst.executeUpdate();
	            }

	            con.commit(); // 성공 시 커밋
	        } catch (Exception e) {
	            con.rollback(); // 실패 시 롤백
	            throw e;
	        }
	    }

	    return result;
		
	}

	// "select * from replies";
	public List<ReplyDTO> selectReplies() throws Exception{
		String sql = "select * from replies";

		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql);
				ResultSet rs = pst.executeQuery();){

			List<ReplyDTO> list = new ArrayList<>();
			while(rs.next()) {
				int seq = rs.getInt("seq");
				String writer = rs.getString("writer");
				String contents = rs.getString("contents");
				int likeCount = rs.getInt("likeCount");
				int board_seq = rs.getInt("board_seq");
				int parent_seq = rs.getInt("parent_seq");
				String path = rs.getString("path");
				String visibility = rs.getString("visibility");
				Timestamp created_at = rs.getTimestamp("created_at");

				ReplyDTO dto = new ReplyDTO(seq, writer, contents, likeCount, board_seq, parent_seq, path, visibility, created_at);
				list.add(dto);
			}
			return list;
		}
	}

	// select * from replies where board_seq = ?
	public List<ReplyDTO> selectRepliesByBoardSeq(int board_seq) throws Exception{
		String sql = "select * from replies where board_seq = ? order by path";

		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql);){
			pst.setInt(1, board_seq);

			try(ResultSet rs = pst.executeQuery();){

				List<ReplyDTO> replies_list = new ArrayList<>();

				while(rs.next()) {
					ReplyDTO dto = new ReplyDTO(
							rs.getInt("seq"),
		                    rs.getString("writer"),
		                    rs.getString("contents"),
		                    rs.getInt("likeCount"),
		                    rs.getInt("board_seq"),
		                    rs.getInt("parent_seq"),
		                    rs.getString("path"),
		                    rs.getString("visibility"),
		                    rs.getTimestamp("created_at")
							);
					
					replies_list.add(dto);
				}
				return replies_list;
			}
		}
	}

	// delete
	public int deleteRepliesBySeq(int seq) throws Exception{
		String sql = "delete from replies where seq = ?";

		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql)){
			pst.setInt(1, seq);

			return pst.executeUpdate();
		}
	}

	// update
	public int updateRepliesBySeq(String contents, int seq) throws Exception{
		String sql = "update replies set contents = ? where seq = ?";

		try(Connection con = this.getConnection();
				PreparedStatement pst = con.prepareStatement(sql)){
			pst.setString(1, contents);
			pst.setInt(2, seq);

			return pst.executeUpdate();
		}
	}




}
