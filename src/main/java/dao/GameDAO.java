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
	
	
	
//	[ 우리끼리의 DAO 메서드명 컨벤션 ]
	//			( select )
	//			- select * from 테이블명
	//			selectAll테이블명
	//
	//			- select * from 테이블명 where id = ?
	//			select테이블명By조건필드명
	//
	//			( insert )
	//			insert 테이블명
	//
	//			( delete )
	//			delete테이블명By조건필드명
	//
	//			( update )
	//			update테이블명By조건필드명
	//
	//			( Connection )
	//			getConnection();
	//
	//			( DAO instance )
	//			// 멤버필드
	//			private static DAO명 instance;
	//			// 기본 생성자 막기
	//			private DAO명(){};
	//			// DAO getter
	//			public synchronized static DAO명 getInstance(){};


	
}

