<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="chat-container">

    <div class="chat-header">
        <h3><c:out value="${friendId}"/> 와의 채팅</h3>
    </div>

    <!-- 메시지 출력 영역 -->
    <div class="chat-messages" id="chatMessages" style="height:400px; overflow-y:auto; border:1px solid #ccc; padding:10px;">
        <c:forEach var="msg" items="${messages}">
            <div class="chat-message ${msg.sender_Id == sessionScope.loginId ? 'text-end' : 'text-start'}">
                <strong><c:out value="${msg.sender_Id}"/></strong>: <c:out value="${msg.content}"/>
                <span class="time"><c:out value="${msg.created_at}"/></span>
            </div>
        </c:forEach>
    </div>

    <!-- 입력 영역 -->
    <div class="chat-input mt-2">
        <input type="hidden" id="chatroomSeq" value="<c:out value='${chatroomSeq}'/>">
        <input type="text" id="messageInput" placeholder="메시지를 입력하세요" class="form-control">
        <button id="sendBtn" class="btn btn-primary mt-2">전송</button>
    </div>
</div>

<script>
$(document).ready(function() {
    const chatroomSeq = $("#chatroomSeq").val();
    const username = '${loginId}';

    // 웹소켓 연결


    const socket = new WebSocket("ws://localhost/ChatingServer");
    socket.onmessage = function(event) {
        const msg = JSON.parse(event.data);
        if(msg.chatroomSeq != chatroomSeq) return; // 다른 방 메시지 무시
        appendMessage(msg);
    };

    $("#sendBtn").click(function() {
        const content = $("#messageInput").val().trim();
        if(content === "") return;

        const msg = {
            chatroomSeq: chatroomSeq,
            sender_Id: username,
            content: content
        };

        socket.send(JSON.stringify(msg));
        $("#messageInput").val('');
    });

    $("#messageInput").keypress(function(e) {
        if(e.which === 13) $("#sendBtn").click();
    });

    function appendMessage(msg) {
        const alignment = msg.sender_Id === username ? 'text-end' : 'text-start';
        const msgDiv = $('<div>').addClass('chat-message ' + alignment)
            .html(`<strong>${msg.sender_Id}</strong>: ${msg.content} <span class="time">${msg.created_at}</span>`);
        $("#chatMessages").append(msgDiv);
        $("#chatMessages").scrollTop($("#chatMessages")[0].scrollHeight);
    }
});
</script>


<jsp:include page="/WEB-INF/views/common/footer.jsp" />