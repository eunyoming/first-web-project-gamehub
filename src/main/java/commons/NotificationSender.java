package commons;

import dao.NotificationDAO;
import dto.notification.NotificationDTO;
import websocket.NotificationServer;

public class NotificationSender {

    private static final String MESSAGE = "notification";

    // 공용 알림 전송 메서드
    // 전송하고 싶은 userId와 type, 디비에 저장할 message를 매개변수로 받음.
    public static void send(String loginId,String type, String message) {
    	try {
        NotificationDAO.getInstance().insertNotifications(
            new NotificationDTO(0, loginId, type, message, "n", null, null, null)
        );

        NotificationServer.sendToUser(loginId, MESSAGE);
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
    		System.out.println("에러");
    	}
    }
    
    
    // 친구 알림 전송 메서드
    public static void send(String loginId,String type, String message,String related_userId) {
    	try {
        NotificationDAO.getInstance().insertNotifications(
            new NotificationDTO(0, loginId, type, message, "n", null, related_userId, null)
        );

        NotificationServer.sendToUser(loginId, MESSAGE);
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
    		System.out.println("에러");
    	}
    }
}