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
	
	public List<NotificationDTO> selectNotificationsByUserId(String userId)  throws Exception{
		String sql = "select * from	(select * from notifications where userid = ? order by  created_at desc) where rownum < 51";
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
					System.out.println("notification들어옴");
					int seq = result.getInt("seq");
					String type = result.getString("type");
					String message = result.getString("message");
					String isRead = result.getString("isRead");
					Timestamp created_at = result.getTimestamp("created_at");
					String related_userId = result.getString("related_userId");
					String related_objectId = result.getString("related_objectId");

					Timestamp timestamp =result.getTimestamp("created_at");
					//visibility 삭제를 안하고 신고가 들어오면 숨김처리 해주는 숨김표시
					NotificationDTO dto = new NotificationDTO(seq,userId,type,message,isRead,created_at,related_userId,related_objectId);

					list.add(dto);
				}
				System.out.println("notification list");
				return list;		
			}

		}
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
		String sql = "select * from notifications where userid = ? and isRead = 'N' order by created_at desc";

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

		String sql = "insert into notifications values (NOTIFICATION_SEQ.nextval,?,?,?,'N',sysdate,?,?)";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			pstat.setString(1, notificationDTO.getUserId());
			pstat.setString(2, notificationDTO.getType());
			pstat.setString(3, notificationDTO.getMessage());
			
			if(notificationDTO.getRelated_userId()!=null)
			{
				pstat.setString(4, notificationDTO.getRelated_userId());
			}
			else
			{
				pstat.setString(4, null);
			}
			if(notificationDTO.getRelated_objectId()!=null)
			{
				pstat.setString(5, notificationDTO.getRelated_objectId());
			}
			else
			{
				pstat.setString(5, null);
			}
			
			int result = pstat.executeUpdate();
			
			System.out.println("알림 db저장까지 왔어요");
			return result;
		}
	}
	
	public int deleteNotificationsBySeqAndUserId(int notification_seq, String userId) throws Exception{
		String sql = "delete from notifications where seq = ? and userId = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			
			pstat.setInt(1, notification_seq);
			pstat.setString(2, userId);
			
			int result = pstat.executeUpdate();
			System.out.println("알림 제거까지 왔어요");
			return result;
		}
		
	}
	
	public int deleteAllNotifications(String userId) throws Exception{
		String sql = "delete from notifications where userId = ?";

		try(	Connection con = getConnection();
				PreparedStatement pstat = con.prepareStatement(sql); )
		{
			
			pstat.setString(1, userId);
			
			int result = pstat.executeUpdate();
			System.out.println("알림 제거까지 왔어요");
			return result;
		}
		
	}
}

