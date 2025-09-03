package commons;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpSession;

public class SessionManager {
	
	 private static volatile SessionManager instance;

	    public static SessionManager getInstance() {
	        if (instance == null) {
	            synchronized (SessionManager.class) {
	                if (instance == null) {
	                    instance = new SessionManager();
	                }
	            }
	        }
	        return instance;
	    }

	

    private Map<String, HttpSession> sessionMap = new ConcurrentHashMap<>();

    // 로그인 시 세션 등록
    public  void addSession(String userId, HttpSession session) {
        sessionMap.put(userId, session);
    }

    // 로그아웃 시 세션 제거
    public void removeSession(String userId) {
        sessionMap.remove(userId);
    }
    
    //중복 로그인 체커
    public boolean isLoggedIn(String userId) {
        return sessionMap.containsKey(userId);
    }


    // 세션 무효화를 위한 함수
    public void invalidateSession(String userId) {
        HttpSession session = sessionMap.get(userId);
        if (session != null) {
            session.invalidate();
            sessionMap.remove(userId);
        }
    }
    
    public int getActiveSessionCount() {
        return sessionMap.size();
    }
}