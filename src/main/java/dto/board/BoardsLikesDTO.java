package dto.board;

import java.sql.Timestamp;

public class BoardsLikesDTO {
    private int seq;              // PK
    private int board_seq;        // 게시글 번호 (FK)
    private String user_id;       // 추천한 유저 ID
    private Timestamp created_at; // 생성일

    public BoardsLikesDTO() {}

    public BoardsLikesDTO(int seq, int board_seq, String user_id, Timestamp created_at) {
        this.seq = seq;
        this.board_seq = board_seq;
        this.user_id = user_id;
        this.created_at = created_at;
    }

    // Getter & Setter
    public int getSeq() {
        return seq;
    }
    public void setSeq(int seq) {
        this.seq = seq;
    }

    public int getBoard_seq() {
        return board_seq;
    }
    public void setBoard_seq(int board_seq) {
        this.board_seq = board_seq;
    }

    public String getUser_id() {
        return user_id;
    }
    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }
    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }
}
