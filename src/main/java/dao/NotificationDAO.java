package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import dto.board.BoardDTO;
import dto.game.GameReviewDTO;
import dto.notification.NotificationDTO;

public class NotificationDAO {
	private static NotificationDAO instance;

	public synchronized static NotificationDAO getInstance() {
		if(instance==null)
		{
			instance = new NotificationDAO();
		}	
		return instance;
	}

	public Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	public boolean isSelectNotificationsByUserIdAndIsRead(String userId) throws Exception {
		String sql = "select * from notifications where userid = ? and isRead = 'N'";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setString(1, userId);
			try(
					ResultSet result = pstat.executeQuery();)
			{				
				return result.next();
			}
		}
	}

	public List<NotificationDTO> selectNotificationsByUserIdAndIsRead(String userId) throws Exception {
		String sql = "select * from notifications where userid = ? and isRead = 'N'";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setString(1, userId);
			try(
					ResultSet result = pstat.executeQuery();)
			{				
				List<NotificationDTO> list = new ArrayList<>();

				while(result.next())
				{
					int seq = result.getInt("seq");
					String type = result.getString("type");
					String message = result.getString("message");

					String isRead = result.getString("isRead");

					Timestamp timestamp =result.getTimestamp("created_at");
					String related_userId = result.getString("related_userId");
					String related_objectId = result.getString("related_objectId");

					//visibility 삭제를 안하고 신고가 들어오면 숨김처리 해주는 숨김표시
					NotificationDTO dto = new NotificationDTO(seq,userId,type,message,isRead,timestamp,related_userId,related_objectId);

					list.add(dto);
				}
				System.out.println("notification list");
				return list;		
			}
		}
	}

	public int updateNotificationsByUserId(String userId) throws Exception {
		String sql = "update notifications set isRead='Y' where userId = ? and isRead='N'";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setString(1, userId);

			int result = pstat.executeUpdate();
			return result;		
		}
	}
	
	public int insertNotifications(NotificationDTO notificationDTO) throws Exception{

		String sql = "insert into notifications values (NOTIFICATION_SEQ.nextval,?,?,?,'N',sysdate,null,null)";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setString(1, notificationDTO.getUserId());
			pstat.setString(2, notificationDTO.getType());
			pstat.setString(3, notificationDTO.getMessage());
			int result = pstat.executeUpdate();
			
			System.out.println("알림 db저장까지 왔어요");
			return result;
		}
	}
}

