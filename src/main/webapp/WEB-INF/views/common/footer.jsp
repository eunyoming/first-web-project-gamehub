<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
 </main> <!-- main 종료 -->
    <footer class="footer site-footer">
    <div class="row footer-links w-100">
	    <div class="col-4 text-start">
	        <ul class="list-unstyled ">
	            <li><a href="/" class="text-decoration-none text-white">메인페이지</a></li>
	            <li><a href="/footer/terms" class="text-decoration-none text-white">이용약관</a></li>
	            <li><a href="/footer/privacy" class="text-decoration-none text-white">개인정보 처리방침</a></li>
	         
	        </ul>
	    </div>
	    <div class="col-4 text-start">
	        <ul class="list-unstyled">
	            <li><a href="/api/game/main?game_seq=1" class="text-decoration-none text-white">망각의 숲</a></li>
	            <li><a href="/api/game/main?game_seq=2" class="text-decoration-none text-white">스페이스 배틀</a></li>
	            <li><a href="/api/game/main?game_seq=3" class="text-decoration-none text-white">화살 피했냥</a></li>
	            <li><a href="/api/game/main?game_seq=4" class="text-decoration-none text-white">테트리스</a></li>
	            <li><a href="/api/game/main?game_seq=5" class="text-decoration-none text-white">플래피 버드</a></li>
	        </ul>
	    </div>
	    <div class="col-4 text-start">
	        <ul class="list-unstyled">
	    
	            <li><a href="/list.board" class="text-decoration-none text-white">커뮤니티</a></li>
	            <li><a href="/api/point/pointPage" class="text-decoration-none text-white">상점</a></li>
	            <c:if test="${loginId != null }">
	            <li><a href="/api/member/mypage?section=collection&userId=${loginId}" class="text-decoration-none text-white">마이페이지</a></li>
	            <li><a href="/chat/open" class="text-decoration-none text-white">채팅 </a></li>
	            </c:if>
	        </ul>
	    </div>
</div>
    <div class="row d-flex justify-content-center align-items-center " >
     <p>&copy; 2025 우리잘했죠. All Rights Reserved.</p>
    
    </div>
       
        
    </footer>
</body>
</html>