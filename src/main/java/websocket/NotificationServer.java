package websocket;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/NotificationServer")
public class NotificationServer {

    // userId ↔ Session 매핑
    private static Map<String, Session> userSessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("연결됨: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // 최초 한 번만 userId 등록
        if (message.startsWith("REGISTER:")) {
            String userId = message.substring("REGISTER:".length());
            if (!userSessions.containsKey(userId)) {
                userSessions.put(userId, session);
                System.out.println("사용자 등록됨: " + userId);
            }
        } else {
            System.out.println("수신 메시지: " + message);
        }
    }

    @OnClose
    public void onClose(Session session) {
        userSessions.entrySet().removeIf(entry -> entry.getValue().equals(session));
        System.out.println("연결 종료: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("웹소켓 에러: " + session.getId());
        throwable.printStackTrace();
    }

    // 특정 사용자에게 알림 보내기
    public static void sendToUser(String userId, String message) {
        Session session = userSessions.get(userId);
        if (session != null && session.isOpen()) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    public static void sendToAllUsers(String message) {
        for (Map.Entry<String, Session> entry : userSessions.entrySet()) {
            Session session = entry.getValue();
            if (session != null && session.isOpen()) {
                try {
                    session.getBasicRemote().sendText(message);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}