<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 
여기에 코드 입력
 -->

<style>
h5 {
	font-weight: bolder;
}

.gamePlayTime, .lastPlayed {
	text-align: right;
}

@media ( max-width : 768px) {
	.gamePlayTime, .lastPlayed {
		display: none;
	}
}
</style>


<h5>최근 플레이한 게임</h5>
<div class="card">
	<div class="card-body">
		<div class="container" id="recentlyPlayedGamesList"></div>



	</div>

</div>

<script>
$.ajax({
	  url: "/api/collection/recentlyPlayedGames",
	  type: "post",
	  dataType: "json"
	}).done(function(resp) {
	  console.log(resp, "/recentlyPlayedGames 응답 받음");
	  let $container = $("#recentlyPlayedGamesList").empty();

	  resp.forEach(function(game) {
	    let $row = $(
	      '<div class="row mb-3">' +
	        '<div class="col-3"><img src="' + game.url + '/thumbnail.png " width="150" height="150" class="img-fluid" /></div>' +
	        '<div class="col-9">' +
	          '<div class="row">' +
	            '<div class="col-6"><h5>' + game.title + '</h5></div>' +
	            '<div class="col-2"></div>' +
	            '<div class="col-4">' +
	              '<div class="row">' +
	                '<div class="col-12 gamePlayTime">총 플레이 시간' + game.totalplaytime + '</div>' +
	                '<div class="col-12 lastPlayed">최근 플레이 날짜' + game.recentPlayedDate + '</div>' +
	              '</div>' +
	            '</div>' +
	            
	          '</div>' +
	        '</div>' +
	      '</div>'
	    );

	    $container.append($row);
	  });
	}).fail(function(xhr, status, error) {
	  console.error("AJAX 실패:", status, error);
	});

	
	
</script>

