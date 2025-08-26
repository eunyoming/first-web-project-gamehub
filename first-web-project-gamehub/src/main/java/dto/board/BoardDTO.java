package dto.board;

import java.sql.Timestamp;

public class BoardDTO {
    private int seq;
    private String writer;
    private String title;
    private String contents;
    private String category;
    private String refgame;
    private int viewCount;
    private int likeCount;
    private String visibility;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    // Getters and Setters
}