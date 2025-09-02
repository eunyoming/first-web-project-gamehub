<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 
여기에 코드 입력
 -->

<style>
h5 {
	font-weight: bolder;
	margin-left: 10px;
}

.gamePlayTime, .lastPlayed {
	text-align: right;
}

@media ( max-width : 768px) {
	.gamePlayTime, .lastPlayed {
		display: none;
	}
	.gameTitle{
	
	
	}
}

.progress-bar {
  background: linear-gradient(to right, var(--main-color) 0%, var(--accent-color) 100%);
}

</style>


<h5>최근 플레이한 게임</h5>
<div class="card">
	<div class="card-body">
		<div class="container" id="recentlyPlayedGamesList"></div>



	</div>

</div>
<h5>내 업적</h5>
	<div class="card">
	<div class="card-body">
		<div class="container" id="userAchievementList"></div>



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
		
//		this.currentAchievement = currentAchievement;
//		this.totalAchievement = totalAchievement;
	  resp.forEach(function(game) {
		    // 프로그레스바 HTML
		    let percent = Math.round(game.currentAchievement/game.totalAchievement * 100);
		    let progressBar =
		      '<div class="progress mt-1">' +
		        '<div class="progress-bar" role="progressbar" ' +
		             'style="width:' + percent + '%;" ' +
		             'aria-valuenow="' + percent + '" ' +
		             'aria-valuemin="0" aria-valuemax="100">' +
		          percent + '%' +
		        '</div>' +
		      '</div>';

		    let $row = $(
		      '<div class="row mb-3">' +
		        '<div class="col-3">' +
		          '<img src="' + game.url + '/thumbnail.png" class="img-fluid" />' +
		        '</div>' +
		        '<div class="col-9">' +
		        '<div class="row">'+
		        '<div class="col-12 col-md-4 gameTitle">' +'<h5>' + game.title + '</h5>' + '</div>' +
		        '<div class="col-2"> </div>' +
		        '<div class="col-6"> </div>' +
		        '<div class="row">'+
		        '<div class="col-12 gamePlayTime">총 플레이 시간: ' + game.totalplaytime +  '</div>' +
		        '<div class="col-12 lastPlayed">최근 플레이: ' + game.recentPlayedDate + '</div>' +
		        '</div>' +
		        '</div>' +
		         '<div class="col-12">업적 진척도'+ progressBar +'</div>'+
		         '<div class="col-12">'+'</div>'+
		        '</div>' +
		      '</div>'
		    );
	

	    $container.append($row);
	  });
	}).fail(function(xhr, status, error) {
	  console.error("AJAX 실패:", status, error);
	});

$.ajax({
	  url: "/api/collection/userAchievement",
	  type: "post",
	  dataType: "json"
	}).done(function(resp) {
	  console.log(resp, "/userAchievement 응답 받음");
	  let $container = $("#userAchievementList").empty();
		

	  resp.forEach(function(icon) {
		    // 프로그레스바 HTML
		    let percent = Math.round(game.currentAchievement/game.totalAchievement * 100);
		    let progressBar =
		      '<div class="progress mt-1">' +
		        '<div class="progress-bar" role="progressbar" ' +
		             'style="width:' + percent + '%;" ' +
		             'aria-valuenow="' + percent + '" ' +
		             'aria-valuemin="0" aria-valuemax="100">' +
		          percent + '%' +
		        '</div>' +
		      '</div>';

		    let $row = $(
		      '<div class="row mb-3">' +
		        '<div class="col-3">' +
		          '<img src="' + game.url + '/thumbnail.png" class="img-fluid" />' +
		        '</div>' +
		        '<div class="col-9">' +
		        '<div class="row">'+
		        '<div class="col-12 col-md-4 gameTitle">' +'<h5>' + game.title + '</h5>' + '</div>' +
		        '<div class="col-2"> </div>' +
		        '<div class="col-6"> </div>' +
		        '<div class="row">'+
		        '<div class="col-12 gamePlayTime">총 플레이 시간: ' + game.totalplaytime +  '</div>' +
		        '<div class="col-12 lastPlayed">최근 플레이: ' + game.recentPlayedDate + '</div>' +
		        '</div>' +
		        '</div>' +
		         '<div class="col-12">업적 진척도'+ progressBar +'</div>'+
		         '<div class="col-12">'+'</div>'+
		        '</div>' +
		      '</div>'
		    );
	

	    $container.append($row);
	  });
	}).fail(function(xhr, status, error) {
	  console.error("AJAX 실패:", status, error);
	});

	
	
</script>

