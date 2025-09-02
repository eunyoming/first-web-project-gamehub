<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/manage_header.jsp" />
<div class="container-fluid mt-5">
	<h2 class="mb-4">게임 관리 대시보드</h2>
	
	<div class="row">
	<div class="col-4">
		    <h4>게임 목록</h4>
		    <ul id="gameList" class="list-group">게임 목록을 불러오는 중입니다...</ul>
		  </div>
		  <div class="col-8">
		    <h4>게임 상세</h4>
		    <div id="gameDetail"> 게임 상세 페이지를 불러오는 중입니다...</div>
		  </div>
		</div>
</div>

<script>
$(document).ready(function(){
    $.ajax({
        url: "/api/game/gameList",
        type: "GET",
        dataType: "json",
        success: function(data){
            let listHtml = "";
            data.forEach(game => {
            	listHtml += '<li class="list-group-item" onclick="loadGameInfo(' + game.seq + ')">'
                + '<div><strong>' + game.title + '</strong></div>'
                + '<small class="text-muted">' + (game.description ? game.description: "설명 없음") + '</small>'
                + '</li>';
            });
            $("#gameList").html(listHtml);
        }
    });
});

function loadGameInfo(seq){
    $.ajax({
        url: "/api/game/gameInfo?seq=" + seq,
        type: "GET",
        dataType: "json",
        success: function(info){
        	let html = 
        	    '<h5>' + info.creator + ' 님의 코멘트</h5>' +
        	    '<p>' + (info.creatorComment || '없음') + '</p>' +
        	    '<h5>가이드</h5>' +
        	    '<div>' + (info.guide || '작성된 가이드 없음') + '</div>' +
        	    '<button onclick="editGuide(' + seq + ')" class="btn btn-primary mt-2">가이드 수정</button>';
            $("#gameDetail").html(html);
        }
    });
}
</script>

 
<jsp:include page="/WEB-INF/views/common/footer.jsp" />