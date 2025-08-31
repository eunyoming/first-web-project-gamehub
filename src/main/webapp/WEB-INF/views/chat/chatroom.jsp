<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container-fluid">
    <div class="row vh-100">

        <!-- 친구 목록 -->
        <div class="col-md-3 border-end p-3 bg-light" style="overflow-y:auto;">
            <h5>친구 목록</h5>
            <ul class="list-group" id="friendList">
                <c:forEach var="friend" items="${friends}">
                    <li class="list-group-item list-group-item-action" 
                        data-friendid="${friend}">
                        ${friend}
                    </li>
                </c:forEach>
            </ul>
        </div>

        <!-- 채팅 영역 -->
        <div class="col-md-9 d-flex flex-column p-3">
            <div class="chat-header mb-2">
			    <h5 id="chatWith">
			        <c:choose>
			            <c:when test="${not empty friendId}">
			                ${friendId}님과 채팅
			            </c:when>
			            <c:otherwise>
			                친구를 선택하세요
			            </c:otherwise>
			        </c:choose>
			    </h5>
			</div>

            <div class="chat-messages" id="chatMessages" style="overflow-y:auto; border:1px solid #ccc; padding:10px; flex:1;">
                <c:forEach var="msg" items="${messages}">
                    <div class="chat-message ${msg.sender_Id == sessionScope.loginId ? 'text-end' : 'text-start'}">
                        <strong><c:out value="${msg.sender_Id}"/></strong>: <c:out value="${msg.content}"/>
                        <span class="time"><c:out value="${msg.created_at}"/></span>
                    </div>
                </c:forEach>
            </div>

            <div class="chat-input d-flex mt-2">
                <input type="hidden" id="chatroomSeq" value="<c:out value='${chatroomSeq}'/>">
                <input type="text" id="messageInput" class="form-control me-2" placeholder="메시지 입력">
                <button id="sendBtn" class="btn btn-primary">전송</button>
            </div>
        </div>

    </div>
</div>

<script>
$(document).ready(function() {
    let socket;
    let currentChatroomSeq = $('#chatroomSeq').val();
    const username = '${loginId}';

    // -----------------------------
    // 친구 클릭 → 채팅방 열기
    
    $('#friendList').on('click', 'li', function() {
   
    const friendId = $(this).data('friendid');
    
    window.location.href = "/chat/open?friendId=" + friendId;


});


    // -----------------------------
    // 메시지 전송
    // -----------------------------
    $('#sendBtn').click(function() {
        const content = $('#messageInput').val().trim();
        if(!content || !currentChatroomSeq) return;

        const msg = {
            chatroom_seq:  Number(currentChatroomSeq),
            sender_Id: username,
            content: content
        };

        socket.send(JSON.stringify(msg));
        $('#messageInput').val('');
    });

    $('#messageInput').keypress(function(e) {
        if(e.which === 13) $('#sendBtn').click();
    });

    // -----------------------------
    // 메시지 추가 함수
    // -----------------------------
    function appendMessage(msg) {
    	console.log("메시지 추가");
    	
    	
    	const loginId = '${loginId}'

        const alignment = msg.sender_Id === loginId ? 'text-end' : 'text-start';
        const msgDiv = $('<div>')
        .addClass('chat-message ' + alignment)
        .html('<strong>' + msg.sender_Id + '</strong>: ' + msg.content +
              '<span class="time"> ' + msg.created_at + ' </span>');

        $('#chatMessages').append(msgDiv);
        $('#chatMessages').scrollTop($('#chatMessages')[0].scrollHeight);
    }

    // -----------------------------
    // WebSocket 연결
    // -----------------------------
    function connectWebSocket(chatroom_seq) {
        const protocol = location.protocol === 'https:' ? 'wss' : 'ws';
        const wsUrl = protocol + "://" + window.location.host + "<c:url value='/ChatingServer'/>";
        socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log("웹소켓 연결: " + chatroom_seq);
        };

        socket.onmessage = function(event) {
        	
            const msg = JSON.parse(event.data);
            if(msg.chatroom_seq != chatroom_seq) return;
            appendMessage(msg);
        };

        socket.onerror = function(e) { console.error("웹소켓 오류", e); };
        socket.onclose = function() { console.log("웹소켓 종료"); };
    }

    // -----------------------------
    // 페이지 로드 시 이미 chatroomSeq가 있다면 WebSocket 연결
    // -----------------------------
    if(currentChatroomSeq) {
        connectWebSocket(currentChatroomSeq);
    }
});
</script>



<jsp:include page="/WEB-INF/views/common/footer.jsp" />