<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 
여기에 코드 입력
-->


<style type="text/css">
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

.progress {
	height: 30px;
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
<div class="card p-4" >
  <div class="row">
    <!-- 왼쪽: 프로필 이미지 + 사용자 정보 -->
    <div class="col-md-4 text-center">
      <img id="profileImage" src="/images/default-profile.png"
           alt="프로필 이미지"
           class="rounded-circle mb-3"
           width="180" height="180"
           style="cursor: pointer;">
      <input type="file" id="imageUploadInput" style="display: none;">

      <div class="fw-bold fs-5 text-purple" id="loginId">사용자아이디</div>
      <div class="text-muted" id="equipedAchiev">장착 업적</div>
    </div>

    <!-- 오른쪽: BIO + 상태메시지 -->
    <div class="col-md-8">
      <div class="mb-3">
        <label for="bioInput" class="form-label">자기소개</label>
        <textarea id="bioInput" class="form-control" rows="4"></textarea>
      </div>

      <div class="mb-3">
        <label for="statusInput" class="form-label">상태메시지</label>
        <input type="text" id="statusInput" class="form-control">
      </div>

      <div class="text-end">
        <button id="saveProfileBtn" class="btn btn-gradient btn-blue-purple">프로필 저장</button>
      </div>
    </div>
  </div>
</div>
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

<script type="text/javascript">
	$
			.ajax({
				url : "/api/collection/recentlyPlayedGames",
				type : "post",
				data: {
					  userId: "${loginId}"
					},
				dataType : "json"
			})
			.done(
					function(resp) {
					
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
				data: {
					  userId: "${loginId}"
					},
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
										let isEquipedClass = item.isequip != "Y" ? "<br><br><button class='btn btn-gradient btn-blue-purple btn-sm mt-2 equip-btn' data-achiev-seq='" + item.achievSeq + "'>칭호 장착</button>"
												: "<br><br><button class='btn btn-gradient btn-red-peach btn-sm mt-2 equip-btn' data-achiev-seq='" + item.achievSeq + "' disabled>장착된 칭호</button>"
										
										
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
												+ (item.unlockedAt ? item.unlockedAt +isEquipedClass
														
														
														: "") + "</div>";
										html += "</div>";
										
										   

									});
							
							

							$("#userAchievementList").append(html);
						}
					});
	
	$(document).on("click", ".equip-btn", function() {
	    const achievSeq = $(this).data("achiev-seq");
	   

	    $.ajax({
	        url: "/api/achievement/equipAchiev", // 서블릿 매핑 주소
	        type: "POST",
	        data: {
	          
	            achievSeq: achievSeq
	        },
	        success: function() {
	        	if (confirm("칭호 이미지를 프로필 사진으로 설정하시겠습니까?")) {
	        	    $.ajax({
	        	        url: "/api/achievement/setEquipImage",
	        	        type: "POST",
	        	        success: function(response) {
	        	            alert("교체에 성공했습니다.");
	        	        },
	        	        error: function() {
	        	            alert("프로필 이미지 교체에 실패했습니다.");
	        	        }
	        	    });
	        	}

	        	 else{   //취소

	        	 }
	        	
	            // 필요 시 UI 업데이트
	            location.reload(); // 페이지 새로고침
            
	        },
	        error: function(xhr, status, error) {
	            console.error("칭호 장착 실패:", error);
	            alert("칭호 장착에 실패했습니다.");
	        }
	    });
	});
	
	$(document).ready(function() {
		  // 프로필 정보 불러오기
		  $.ajax({
		    url: "/api/member/getProfile",
		    method: "GET",
		    dataType: "json",
		    success: function(data) {
		    	console.log(data);
		      $("#profileImage").attr("src", data.profileImage);
		      $("#loginId").text(data.userID);
		      $("#equipedAchiev").text("${simpleProfile.achievDTO.title}" || "장착 업적 없음");
		      
		      $("#bioInput").val(data.bio);
		      $("#statusInput").val(data.statusMessage);
		    }
		  });

		  // 이미지 클릭 → 파일 선택
		  $("#profileImage").on("click", function() {
		    $("#imageUploadInput").click();
		  });

		  // 이미지 업로드 처리
		  $("#imageUploadInput").on("change", function() {
		    const formData = new FormData();
		    formData.append("file", this.files[0]);

		    $.ajax({
		      url: "/api/member/profileUploadImage",
		      method: "POST",
		      data: formData,
		      processData: false,
		      contentType: false,
		      success: function(res) {
		        $("#profileImage").attr("src", res.url);
		        location.reload(); 
		      },
		      error: function() {
		        alert("이미지 업로드 실패");
		      }
		    });
		  });

		  // 텍스트 저장 처리
		  $("#saveProfileBtn").on("click", function() {
		    const bio = $("#bioInput").val();
		    const statusMessage = $("#statusInput").val();

		    $.ajax({
		      url: "/api/member/updateProfileText",
		      method: "POST",
		      contentType: "application/json",
		      data: JSON.stringify({ bio, statusMessage }),
		      success: function() {
		        alert("프로필이 저장되었습니다!");
		      },
		      error: function() {
		        alert("저장 중 오류가 발생했습니다.");
		      }
		    });
		  });
		});

</script>