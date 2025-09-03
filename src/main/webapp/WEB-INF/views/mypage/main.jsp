<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setAttribute("pageTitle", "마이페이지");
%>

<jsp:include page="/WEB-INF/views/common/header.jsp" />



 <c:choose>
    <c:when test="${loginId == paramUserId}">
        <ul class="nav nav-tabs d-flex justify-content-center align-items-center">
            <li class="nav-item">
                <a href="/api/member/mypage?section=collection&userId=${paramUserId}" 
                   class="nav-link ${active=='collection' ? 'active' : ''}">Collection</a>
            </li>
            <li class="nav-item">
                <a href="/api/member/mypage?section=bio&userId=${paramUserId}" 
                   class="nav-link ${active=='bio' ? 'active' : ''}">Bio</a>
            </li>
            <li class="nav-item">
                <a href="/api/member/mypage?section=bookmark&userId=${paramUserId}" 
                   class="nav-link ${active=='bookmark' ? 'active' : ''}">Bookmark</a>
            </li>
            <li class="nav-item">
                <a href="/api/member/mypage?section=friend&userId=${paramUserId}" 
                   class="nav-link ${active=='friend' ? 'active' : ''}">Friend</a>
            </li>
        </ul>

        <div class="mt-3">
            <jsp:include page="/WEB-INF/views/mypage/${active}.jsp" />
        </div>
    </c:when>

    <c:otherwise>
        <div class="container">
            <p>${paramUserId}의 페이지</p>
            <div class="card p-4" >
  <div class="row">
    <!-- 왼쪽: 프로필 이미지 + 사용자 정보 -->
    <div class="col-md-4 text-center">
      <img id="profileImage" src="/images/default-profile.png"
           alt="프로필 이미지"
           class="rounded-circle mb-3"
           width="180" height="180"
           >

      <div class="fw-bold fs-5 text-purple" id="loginId">사용자아이디</div>
      <div class="text-muted" id="equipedAchiev">장착 업적</div>
    </div>

    <!-- 오른쪽: BIO + 상태메시지 -->
    <div class="col-md-8">
      <div class="mb-3">
        <label for="bioInput" class="form-label">자기소개</label>
        <div id="bioInput" class="form-control" rows="4"></div>
      </div>

      <div class="mb-3">
        <label for="statusInput" class="form-label">상태메시지</label>
        <div id="statusInput" ></div>
      </div>

     
    </div>
  </div>
</div>
            
            <form action="/api/friends/request" method="post">
                <input type="hidden" name="toUser" value="${paramUserId}">
                <input type="hidden" name="fromUser" value="${loginId}">
  				 <button id="friendBtn" class="btn btn-blue-main">로딩중...</button>
      
            </form>
        </div>
        <script>
function showSection(id) {
    const sections = ['collection', 'bio', 'bookmark', 'friend'];
    sections.forEach(s => {
        document.getElementById(s).style.display = (s === id) ? 'block' : 'none';
    });
}

$(document).ready(function() {
    var targetId = '${paramUserId}'; // 확인할 상대 ID
    var currentUserId = '${loginId}'; // 로그인 사용자 ID, 서버에서 가져올 수도 있음

    
    $.ajax({
	    url: "/api/member/getProfileOthers?userId="+targetId ,
	    method: "GET",
	    dataType: "json",
	    success: function(data) {
	    	console.log(data);
	      $("#profileImage").attr("src", data.profileImage);
	      $("#loginId").text(data.userID);
	      $("#bioInput").text(data.bio);
	      $("#statusInput").text(data.statusMessage);
	    }
	  });
    
    $.ajax({
    	  url: "/api/achievement/findEquipAchiev?userId=" + targetId,
    	  method: "GET",
    	  dataType: "json",
    	  success: function(response) {
    	    console.log(response);
    	    $("#equipedAchiev").text(response.data); // 업적 텍스트 삽입
    	  },
    	  error: function(xhr, status, error) {
    	    console.error("업적 불러오기 실패:", error);
    	    $("#equipedAchiev").text("업적 정보를 불러올 수 없습니다.");
    	  }
    	});
    
    console.log(targetId +":"+ currentUserId);
    
    
    function updateFriendButton() {
        $.ajax({
            url: "/api/friends/friendsCheck",
            type: "GET",
            data: { targetID: targetId },
            dataType: "json",
            success: function(data) {
                var btn = $("#friendBtn");
                btn.off("click"); // 기존 이벤트 제거

                switch(data.status) {
                    case "none":
                        btn.text("친구 요청");
                        btn.prop("disabled", false);
                        btn.on("click", function() {
                            sendFriendRequest(targetId);
                        });
                        break;

                    case "friend":
                        btn.text("친구 삭제");
                        btn.prop("disabled", false);
                        btn.on("click", function() {
                            deleteFriend(targetId);
                        });
                        break;

                    case "request_sent":
                        btn.text("요청 취소");
                        btn.prop("disabled", false);
                        btn.on("click", function() {
                            cancelFriendRequest(targetId);
                        });
                        break;

                    case "request_received":
                        btn.text("수락 / 거절");
                        btn.prop("disabled", false);
                        btn.on("click", function() {
                            // 모달 또는 confirm으로 처리
                            if(confirm("친구 요청을 수락하시겠습니까?")) {
                                acceptFriendRequest(targetId);
                            } else {
                                declineFriendRequest(targetId);
                            }
                        });
                        break;
                }
            },
            error: function(err) {
                console.error("친구 상태 확인 오류", err);
            }
        });
    }

    // 친구 요청 보내기
    function sendFriendRequest(friendId) {
        $.post("/api/friends/sent-requests", { targetID: friendId }, function(res) {
            updateFriendButton();
        });
    }

    // 친구 요청 취소
    function cancelFriendRequest(friendId) {
        $.post("/api/friends/sent-requests-cancel", { targetID: friendId }, function(res) {
            updateFriendButton();
        });
    }

    // 친구 요청 수락
    function acceptFriendRequest(friendId) {
        $.post("/api/friends/received-requests-accept", { targetID: friendId }, function(res) {
            updateFriendButton();
        });
    }

    // 친구 요청 거절
    function declineFriendRequest(friendId) {
        $.post("/api/friends/friendDecline", { targetID: friendId }, function(res) {
            updateFriendButton();
        });
    }
    
    //친구 삭제
    function deleteFriend(friendId){
    	$.post("/api/friends/delete", { targetID: friendId }, function(res) {
            updateFriendButton();
        });
    }

    // 초기 상태 로딩
    updateFriendButton();
});
</script>
    </c:otherwise>
</c:choose>

  
  
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
