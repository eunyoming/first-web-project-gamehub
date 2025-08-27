package dto.game;

import java.sql.Timestamp;

public class GameRecordDTO {
    private int seq;
    private String userId;
    private int game_seq;
    private int gameScore;
    private Timestamp gameStartTime;
    private Timestamp gameEndTime;
    // Getters and Setters
    
    
    public GameRecordDTO(int seq, String userId, int game_seq, int gameScore, Timestamp gameStartTime,
			Timestamp gameEndTime) {
		super();
		this.seq = seq;
		this.userId = userId;
		this.game_seq = game_seq;
		this.gameScore = gameScore;
		this.gameStartTime = gameStartTime;
		this.gameEndTime = gameEndTime;
	}
    
    
	public int getSeq() {
		return seq;
	}
	
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getGame_seq() {
		return game_seq;
	}
	public void setGame_seq(int game_seq) {
		this.game_seq = game_seq;
	}
	public int getGameScore() {
		return gameScore;
	}
	public void setGameScore(int gameScore) {
		this.gameScore = gameScore;
	}
	public java.sql.Timestamp getGameStartTime() {
		return gameStartTime;
	}
	public void setGameStartTime(java.sql.Timestamp gameStartTime) {
		this.gameStartTime = gameStartTime;
	}
	public java.sql.Timestamp getGameEndTime() {
		return gameEndTime;
	}
	public void setGameEndTime(java.sql.Timestamp gameEndTime) {
		this.gameEndTime = gameEndTime;
	}
    
   
    
    
}