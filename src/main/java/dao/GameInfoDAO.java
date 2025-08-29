package dao;

import java.sql.Connection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class GameInfoDAO {

	
	private static GameInfoDAO instance;

	public synchronized static GameInfoDAO getInstance() {
		if (instance == null) {
			instance = new GameInfoDAO();
		}
		return instance;
	}

	public Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}
	
	public void selectGameInfoByGuide() {}
}
