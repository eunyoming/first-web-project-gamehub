package commons;

import dao.NotificationDAO;
import dto.notification.NotificationDTO;
import websocket.NotificationServer;

//header.jsp 구현 상태.
//switch(item.type) {
//case "store":
//    console.log('store입니다.');
//    "href":"/api/point/pointPage"})
//    break;
//case "friend":
//    console.log('friend입니다.'); // a는 2입니다.
//    dropa.attr({"class":"dropdown-item","href":"/api/member/mypage?section=friend"})
//    break;
//case "achievement":
//    console.log('achievement입니다.'); // a는 2입니다.
//    dropa.attr({"class":"dropdown-item","href":"/api/member/mypage?section=collection"})
//    break;
//case "point":
//    console.log('point입니다.'); // a는 2입니다.
//    dropa.attr({"class":"dropdown-item","href":"#"})
//    break;
//case "chat":
//    console.log('chat입니다.'); // a는 2입니다.
//    dropa.attr({"class":"dropdown-item","href":"/chat/open"})
//    break;
//case "reply":
//    console.log('chat입니다.'); // a는 2입니다.
//    dropa.attr({"class":"dropdown-item","href":"/chat/open"})
//    break;
//default:
//	dropa.attr({"class":"dropdown-item","href":"#"})
//    console.log('잘못된 타입입니다.');


// 타입은 store,friend,achievement,point,chat,reply 이고 notifications 
// 테이블에 들어가는 type입니다.

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