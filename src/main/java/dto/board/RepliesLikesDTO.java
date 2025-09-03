package dto.board;

import java.sql.Timestamp;

public class RepliesLikesDTO {
    private int seq;              // PK
    private int reply_seq;        // 댓글 번호 (FK)
    private String user_id;       // 추천한 유저 ID
    private Timestamp created_at; // 생성일

    public RepliesLikesDTO() {}

    public RepliesLikesDTO(int seq, int reply_seq, String user_id, Timestamp created_at) {
        this.seq = seq;
        this.reply_seq = reply_seq;
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

    public int getReply_seq() {
        return reply_seq;
    }
    public void setReply_seq(int reply_seq) {
        this.reply_seq = reply_seq;
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
