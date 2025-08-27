package dao;

import java.sql.Connection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

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
}
