package dao;

import java.sql.Connection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class GameDAO {
//대상 DTO : GameDTO, GameRecordDTO, 
	/*
	 * 테이블에 대한 데이터 접근 및 조작. 
	 * 게임 정보 조회, 
	 * 게임 기록 저장/조회, 
	 * 랭킹 조회 등을 담당합니다.
	 * 
	 */
	private static GameDAO instance;

	public synchronized static GameDAO getInstance() {
		if(instance==null)
		{
			instance = new GameDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
}
