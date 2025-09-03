<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 
여기에 코드 입력
-->


<style>
h3 {
	font-weight: bolder;
	margin-left: 10px;
}

.gamePlayTime, .lastPlayed, .unlocked_at {
	text-align: right;
}

@media ( max-width : 768px) {
	.gamePlayTime, .lastPlayed {
		display: none;
	}
	.gameTitle {
		
	}
}

.achimg img {
	border-radius: 50%; /* 원형 이미지 */
}
.progress{
	height : 30px;

}
.progress-bar {
	background: linear-gradient(to right, var(--main-color) 0%,
		var(--accent-color) 100%);
	
}

.locked {
	color: #6c757d; /* 기존 text-muted 효과 */
}

.locked img {
	filter: brightness(50%) !important; /* 이미지 어둡게 */
}
</style>


<h4>최근 플레이한 게임</h4>

<div class="container">

	<div class="card">
		<div class="card-body recentList" id="recentlyPlayedGamesList"></div>



	</div>

</div>
<h4>내 업적</h4>

<div class="container">
	<div class="card">
		<div class="card-body userAchiList" id="userAchievementList"></div>

	</div>

</div>

<script>
	$
			.ajax({
				url : "/api/collection/recentlyPlayedGames",
				type : "post",
				dataType : "json"
			})
			.done(
					function(resp) {
						console.log(resp, "/recentlyPlayedGames 응답 받음");
						let $recentList = $("#recentlyPlayedGamesList").empty();

						//		this.currentAchievement = currentAchievement;
						//		this.totalAchievement = totalAchievement;
						resp
								.forEach(function(game) {
									// 프로그레스바 HTML
									let percent = Math
											.round(game.currentAchievement
													/ game.totalAchievement
													* 100);
									let progressBar = '<div class="progress mt-1">'
											+ '<div class="progress-bar" role="progressbar" '
											+ 'style="width:'
											+ percent
											+ '%;" '
											+ 'aria-valuenow="'
											+ percent
											+ '" '
											+ 'aria-valuemin="0" aria-valuemax="100">'
											+ percent
											+ '%'
											+ '</div>'
											+ '</div>';

									let $row = $('<div class="row mb-3">'
											+ '<div class="col-3">'
											+ '<img src="' + game.url + '/thumbnail.png" class="img-fluid" />'
											+ '</div>'
											+ '<div class="col-9">'
											+ '<div class="row">'
											+ '<div class="col-12 col-md-4 gameTitle">'
											+ '<h5>'
											+ game.title
											+ '</h5>'
											+ '</div>'
											+ '<div class="col-2"> </div>'
											+ '<div class="col-6"> </div>'
											+ '<div class="row">'
											+ '<div class="col-12 gamePlayTime">총 플레이 시간: '
											+ game.totalplaytime
											+ '</div>'
											+ '<div class="col-12 lastPlayed">최근 플레이: '
											+ game.recentPlayedDate + '</div>'
											+ '</div>' + '</div>'
											+ '<div class="col-12">업적 진척도'
											+ progressBar + '</div>'
											+ '<div class="col-12">' + '</div>'
											+ '</div>' + '</div>');

									$recentList.append($row);
								});
					}).fail(function(xhr, status, error) {
				console.error("AJAX 실패:", status, error);
			});

	$
			.ajax({
				url : "/api/collection/userAchievement",
				type : "post",
				dataType : "json"
			})
			.done(
					function(data) {
						// 게임별로 그룹핑
						var grouped = {}; // key: gameSeq, value: list of achievements
						data.forEach(function(item) {
							if (!grouped[item.gameSeq]) {
								grouped[item.gameSeq] = {
									gameTitle : item.gameTitle,
									achievements : []
								};
							}
							grouped[item.gameSeq].achievements.push(item);
						});

						// HTML 생성
						for ( var gameSeq in grouped) {
							var gameBlock = grouped[gameSeq];
							var html = "";

							// 게임 제목 딱 한 번
							html += "<div class='row mb-2'><div class='col-12'><h3>"
									+ gameBlock.gameTitle + "</h3></div></div>";

							// 업적 반복
							gameBlock.achievements
									.forEach(function(item) {

										let lockedClass = item.unlockedAt ? ""
												: "locked";

										html += "<div class='row mb-3 " + lockedClass + "'>";
										html += "  <div class='col-2 achimg'><img src='" + item.iconUrl + "' alt='이미지' class='img-fluid'></div>";
										html += "  <div class='col-6'><div class='row'>";
										html += "      <div class='col-12'><h5>"
												+ item.achievementTitle
												+ "</h5></div>";
										html += "      <div class='col-12'>"
												+ item.description + "</div>";
										html += "  </div></div>";
										html += "  <div class='col-4 unlocked_at'>"
												+ (item.unlockedAt ? item.unlockedAt
														: "") + "</div>";
										html += "</div>";
									});

							$("#userAchievementList").append(html);
						}
					});
</script>