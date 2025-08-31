package websocket;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;

import dao.ChatDAO;
import dto.chat.MessageDTO;

@ServerEndpoint("/ChatingServer")
public class ChatServer {

    private static Map<Integer, Set<Session>> chatRooms = Collections.synchronizedMap(new HashMap<>());
    private static ChatDAO chatDAO = ChatDAO.getInstance();
    private static Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("웹소켓 연결: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) throws Exception {
        try {
            // 클라이언트에서 JSON으로 전송: {chatroomSeq, sender_Id, content}
            MessageDTO dto = gson.fromJson(message, MessageDTO.class);

            // DB 저장
            MessageDTO savedMsg = chatDAO.saveMessage(dto.getChatroom_seq(), dto.getSender_Id(), dto.getContent());

            // 채팅방 세션 등록
            chatRooms.putIfAbsent(savedMsg.getChatroom_seq(), Collections.synchronizedSet(new HashSet<>()));
            Set<Session> roomSessions = chatRooms.get(savedMsg.getChatroom_seq());
            roomSessions.add(session);

            // JSON으로 다시 클라이언트에 전송
            String jsonMsg = gson.toJson(savedMsg);

            synchronized (roomSessions) {
                for (Session s : roomSessions) {
                    if (s.isOpen()) {
                        s.getBasicRemote().sendText(jsonMsg);
                    }
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        chatRooms.values().forEach(sessions -> sessions.remove(session));
        System.out.println("웹소켓 종료: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable e) {
        System.out.println("웹소켓 에러 발생: " + session.getId());
        e.printStackTrace();
    }
}
