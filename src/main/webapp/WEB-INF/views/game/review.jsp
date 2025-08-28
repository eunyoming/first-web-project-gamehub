<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-center align-items-center">

	<!-- 
여기에 코드 입력
 -->

	<style>
.container {
	max-width: 800px;
	margin: 30px auto;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	margin: 30px auto;
}

/* 카드 스타일 */
.card {
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	border-radius: 10px;
	margin-bottom: 20px;
	padding: 15px;
	background-color: #fff;
}

/* 리뷰 작성 폼 */
.review-form {
	display: flex;
	align-items: flex-start;
	gap: 15px;
}

.star-rating {
	display: flex;
	flex-direction: row-reverse;
	font-size: 2em;
	justify-content: center;
	gap: 5px;
}

.star-rating input {
	display: none;
}

.star-rating label {
	color: #ccc;
	cursor: pointer;
	transition: color 0.2s;
}

.star-rating :checked ~ label, .star-rating label:hover, .star-rating label:hover 
	 ~ label {
	color: #ffc107;
}

.reviewInput {
	flex: 1;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.reviewInput input[type="text"], .reviewInput textarea {
	padding: 10px;
	border-radius: 6px;
	border: 1px solid #ccc;
	font-size: 1em;
	width: 400px;
	resize: none;
}

.reviewInput textarea {
	height: 80px;
}

.reviewInput button {
	padding: 10px;
	border: none;
	border-radius: 6px;
	background-color: #ff9800;
	color: white;
	cursor: pointer;
	font-weight: bold;
	transition: background-color 0.2s;
	width: 100%;
	height: 136px;
}

.reviewInput #reviewUpdateClearBtn {
	padding: 4px;
	border: none;
	border-radius: 6px;
	background-color: #ff9800;
	color: white;
	cursor: pointer;
	font-weight: bold;
	transition: background-color 0.2s;
	width: 100%;
	height: 63px;
}

.reviewInput #reviewcancelBtn {
	padding: 4px;
	border: none;
	border-radius: 6px;
	background-color: #ff9800;
	color: white;
	cursor: pointer;
	font-weight: bold;
	transition: background-color 0.2s;
	width: 100%;
	height: 63px;
}

.reviewInput button:hover {
	background-color: #e68900;
}

/* 기존 리뷰 카드 */
.review-card .stars {
	color: #ffc107;
	font-size: 1.5em;
}

.review-card h3 {
	margin: 0 0 5px 0;
}

.review-card div {
	font-size: 0.95em;
	color: #555;
}

.review-card .col-3, .review-card .col-6, .review-card .col-3,
	.review-card .col-2 {
	display: flex;
	flex-direction: column;
	justify-content: center;
}

.review-edit-btn, .review-editclear-btn {
	margin-bottom: 4px;
}
</style>

	<div class="container reviewJsp">
		<!-- 리뷰 작성 카드 -->
		<c:if test="${loginId!=null}">
			<div id="gameReviewWriteBox">
				<div class="card">
					<div class="row review-form">

						<div class="col-3 star-rating">
							<input type="radio" id="5-stars" name="rating" value="5" checked><label
								for="5-stars">&#9733;</label> <input type="radio" id="4-stars"
								name="rating" value="4"><label for="4-stars">&#9733;</label>
							<input type="radio" id="3-stars" name="rating" value="3"><label
								for="3-stars">&#9733;</label> <input type="radio" id="2-stars"
								name="rating" value="2"><label for="2-stars">&#9733;</label>
							<input type="radio" id="1-stars" name="rating" value="1"><label
								for="1-stars">&#9733;</label>
						</div>
						<div class="col-7 reviewInput">
							<input type="text" id="review-title" name="title"
								placeholder="리뷰 제목" required>
							<textarea id="review-content" name="review-content"
								placeholder="리뷰 내용을 작성해주세요." required></textarea>
						</div>
						<div class="col-2 reviewInput">
							<button type="button" id="reviewBtn">리뷰 등록</button>
							<button type="button" id="reviewUpdateClearBtn"
								style="display: none">리뷰 수정</button>
							<button type="button" id="reviewcancelBtn" style="display: none">취소</button>
						</div>
					</div>
				</div>


			</div>

		</c:if>
		<!-- 기존 리뷰 -->
		<div id="gameReviewBox"></div>
	</div>
	<script>
	//$("input[name='rating']:checked").val();
	// input 중에 name이 rating인 것들을 전부 가져오고 거기서 checked 상태인거의 값
		let reviewCard;
		let userReviewRating=Number(5);
	
		$(document).on("click", ".review-edit-btn", function() {
		    $(this).closest(".review-card").hide();
		    reviewCard = $(this).closest(".review-card");
		    
		    let title = $(this).closest(".review-card").find(".col-6 h3").text();
		    let content = $(this).closest(".review-card").find(".col-6 div").text();
		    
		    $("#review-title").val(title);
		    $("#review-content").val(content);
		    		    
		    console.log(userReviewRating);
		    $("#"+userReviewRating+"-stars").prop("checked", true);
		    
		    $("#reviewBtn").hide();
		    $("#reviewUpdateClearBtn").show();
		    $("#reviewcancelBtn").show();
		    $("#gameReviewWriteBox").show();
		});

		$(document).on("click", ".review-delete-btn", function() {
			$.ajax({
				url : "/api/game/main/reviewDelete",
				type : "post",
				data : {
					game_seq : "${game_seq}",
				},
				 dataType: "json" 
			}).done(function(resp){
				console.log(resp + "응답받음");
				$("#gameReviewWriteBox").show();
				$("#review-title").val("");
				$("#review-content").val("");
				$("#5-stars").prop("checked", true);
				
				$("#reviewBtn").show();
			    $("#reviewUpdateClearBtn").hide();
			    $("#reviewcancelBtn").hide();
				
				$("#gameReviewBox").html("");
				//리뷰 작성 내용 지워주고
				//리뷰 칸 전부 비우고 다시 채우기.
				
				resp.forEach(function(reviewItem){
					
					let stars = "";
				    for (let i = 0; i < reviewItem.rating; i++) {
				        stars += "★ ";
				    }
				    for (let i = reviewItem.rating; i < 5; i++) {
				        stars += "☆ ";
				    }
				    
				    let reviewHtml="";
				    
				    if(reviewItem.writer === "${loginId}") {
				    	userReviewRating = reviewItem.rating;
				    		
						$("#gameReviewWriteBox").hide();
				    	reviewHtml = `
							<div class="card review-card">
								<div class="row">
									<div class="col-3 stars">`+stars+`</div>
									<div class="col-6">
										<h3>`+reviewItem.title +`</h3>
										<div>`+ reviewItem.content +`</div>
									</div>
									<div class="col-2">
										<div>`+reviewItem.writer+`</div>
										<div class="reviewCreated_at">`+reviewItem.created_at+`</div>
									</div>

									<div class="col-1" style="padding: 0px">
										<div class="review-buttons">
											<button class="btn btn-outline-gray-main review-edit-btn" >수정</button>
											<button class="btn btn-outline-gray-main review-delete-btn">삭제</button>

										</div>
									</div>
								</div>
							</div>
						`;

						$("#gameReviewBox").prepend(reviewHtml);
				    }
				    else
				    {
				    	reviewHtml = `
							<div class="card review-card">
								<div class="row">
									<div class="col-3 stars">`+stars+`</div>
									<div class="col-6">
										<h3>`+reviewItem.title +`</h3>
										<div>`+ reviewItem.content +`</div>
									</div>
									<div class="col-3">
										<div>`+reviewItem.writer+`</div>
										<div class="reviewCreated_at">`+reviewItem.created_at+`</div>
									</div>
								</div>
							</div>
						`;

						$("#gameReviewBox").append(reviewHtml);
				    }
				    
				    
				});
				
				$(".reviewCreated_at").each(function() {
				    let raw = $(this).text(); // "2025-08-27 14:35:20"
				    let date = new Date(raw);
				
				    let year =  String(date.getFullYear()).slice(-2); // 2025 → "25"
				    let month = (date.getMonth() + 1).toString().padStart(2, "0");
				    let day = date.getDate().toString().padStart(2, "0");
				
				    let formatted = year + "년 " + month + "월 " + day + "일";
				    $(this).text(formatted);
				});
				
				$("#reviewcancelBtn").on("click",function(){
					$("#reviewBtn").show();
					$("#reviewUpdateClearBtn").hide();
					$("#reviewcancelBtn").hide();
					$("#gameReviewWriteBox").hide();
					reviewCard.show();
				});
			});
		});
		
		$(function(){
			$.ajax({
				url : "/api/game/main/reviewView",
				type : "post",
				data : {
					game_seq : "${game_seq}",
					
				},
				 dataType: "json" 
			}).done(function(resp){
				console.log(resp + "응답받음");
				$("#gameReviewBox").html("");
				//리뷰 작성 내용 지워주고
				$("#review-title").val("");
				$("#review-content").val("");
				$("#5-stars").prop("checked", true);
				//리뷰 칸 전부 비우고 다시 채우기.
				
				resp.forEach(function(reviewItem){
					let stars = "";
				    for (let i = 0; i < reviewItem.rating; i++) {
				        stars += "★ ";
				    }
				    for (let i = reviewItem.rating; i < 5; i++) {
				        stars += "☆ ";
				    }
				    
				    let reviewHtml="";
				    
				    if(reviewItem.writer === "${loginId}") {
				    	userReviewRating = reviewItem.rating;
						$("#gameReviewWriteBox").hide();
				    	reviewHtml = `
							<div class="card review-card">
								<div class="row">
									<div class="col-3 stars">`+stars+`</div>
									<div class="col-6">
										<h3>`+reviewItem.title +`</h3>
										<div>`+ reviewItem.content +`</div>
									</div>
									<div class="col-2">
										<div>`+reviewItem.writer+`</div>
										<div class="reviewCreated_at">`+reviewItem.created_at+`</div>
									</div>

									<div class="col-1" style="padding: 0px">
										<div class="review-buttons">
											<button class="btn btn-outline-gray-main review-edit-btn" >수정</button>
											<button class="btn btn-outline-gray-main review-delete-btn">삭제</button>

										</div>
									</div>
								</div>
							</div>
						`;

						$("#gameReviewBox").prepend(reviewHtml);
				    }
				    else
				    {
				    	reviewHtml = `
							<div class="card review-card">
								<div class="row">
									<div class="col-3 stars">`+stars+`</div>
									<div class="col-6">
										<h3>`+reviewItem.title +`</h3>
										<div>`+ reviewItem.content +`</div>
									</div>
									<div class="col-3">
										<div>`+reviewItem.writer+`</div>
										<div class="reviewCreated_at">`+reviewItem.created_at+`</div>
									</div>
								</div>
							</div>
						`;

						$("#gameReviewBox").append(reviewHtml);
				    }
				});
				
				$(".reviewCreated_at").each(function() {
				    let raw = $(this).text(); // "2025-08-27 14:35:20"
				    let date = new Date(raw);
				
				    let year =  String(date.getFullYear()).slice(-2); // 2025 → "25"
				    let month = (date.getMonth() + 1).toString().padStart(2, "0");
				    let day = date.getDate().toString().padStart(2, "0");
				
				    let formatted = year + "년 " + month + "월 " + day + "일";
				    $(this).text(formatted);
				});
				
				$("#reviewcancelBtn").on("click",function(){
					$("#reviewBtn").show();
					$("#reviewUpdateClearBtn").hide();
					$("#reviewcancelBtn").hide();
					$("#gameReviewWriteBox").hide();
					reviewCard.show();
				});
			});
		})

		let textLengthMax = 200;
		
		$("#reviewBtn").on("click",function(){
			if( $("#review-title").val()=="" ||  $("#review-content").val()=="")
			{
				alert("제목과 내용을 입력해주세요.");
				return false;
			}
			
			if($("#review-title").val().length > 33 ||  $("#review-content").val().length > 99)
			{
				//글자수로 인한 db 저장 오류 방지를 위해 제한을 걸어둠.
			    alert("제목은 33자, 내용은 99자 이하로 작성해주세요.");
				return false;
			}
			
			
			$.ajax({
				url : "/api/game/main/reviewInsert",
				type : "post",
				data : {
					game_seq : "${game_seq}",
					rating : $("input[name='rating']:checked").val(),
					title : $("#review-title").val(),
					content : $("#review-content").val(),
				},
				 dataType: "json" 
			}).done(function(resp){
				console.log(resp + "응답받음");
				$("#gameReviewBox").html("");
				//리뷰 작성 내용 지워주고
				$("#review-title").val("");
				$("#review-content").val("");
				$("#5-stars").prop("checked", true);
				//리뷰 칸 전부 비우고 다시 채우기.
				
				resp.forEach(function(reviewItem){
					let stars = "";
				    for (let i = 0; i < reviewItem.rating; i++) {
				        stars += "★ ";
				    }
				    for (let i = reviewItem.rating; i < 5; i++) {
				        stars += "☆ ";
				    }
				    
				    let reviewHtml="";
				    
				    if(reviewItem.writer === "${loginId}") {
				    	userReviewRating = reviewItem.rating;
				    	reviewHtml = `
							<div class="card review-card">
								<div class="row">
									<div class="col-3 stars">`+stars+`</div>
									<div class="col-6">
										<h3>`+reviewItem.title +`</h3>
										<div>`+ reviewItem.content +`</div>
									</div>
									<div class="col-2">
										<div>`+reviewItem.writer+`</div>
										<div class="reviewCreated_at">`+reviewItem.created_at+`</div>
									</div>

									<div class="col-1" style="padding: 0px">
										<div class="review-buttons">
											<button class="btn btn-outline-gray-main review-edit-btn" >수정</button>
											<button class="btn btn-outline-gray-main review-delete-btn">삭제</button>

										</div>
									</div>
								</div>
							</div>
						`;

						$("#gameReviewBox").prepend(reviewHtml);
				    }
				    else
				    {
				    	reviewHtml = `
							<div class="card review-card">
								<div class="row">
									<div class="col-3 stars">`+stars+`</div>
									<div class="col-6">
										<h3>`+reviewItem.title +`</h3>
										<div>`+ reviewItem.content +`</div>
									</div>
									<div class="col-3">
										<div>`+reviewItem.writer+`</div>
										<div class="reviewCreated_at">`+reviewItem.created_at+`</div>
									</div>
								</div>
							</div>
						`;

						$("#gameReviewBox").append(reviewHtml);
				    }
				});
				
				$("#gameReviewWriteBox").hide();
				
				$(".reviewCreated_at").each(function() {
				    let raw = $(this).text(); // "2025-08-27 14:35:20"
				    let date = new Date(raw);
				
				    let year =  String(date.getFullYear()).slice(-2); // 2025 → "25"
				    let month = (date.getMonth() + 1).toString().padStart(2, "0");
				    let day = date.getDate().toString().padStart(2, "0");
				
				    let formatted = year + "년 " + month + "월 " + day + "일";
				    $(this).text(formatted);
				});
				
				
				
				
				
				$("#reviewcancelBtn").on("click",function(){
					$("#reviewBtn").show();
					$("#reviewUpdateClearBtn").hide();
					$("#reviewcancelBtn").hide();
					$("#gameReviewWriteBox").hide();
					reviewCard.show();
				});
			});
			
		});
		
		$("#reviewUpdateClearBtn").on("click",function(){
			if( $("#review-title").val()=="" ||  $("#review-content").val()=="")
			{
				alert("제목과 내용을 입력해주세요.");
				return false;
			}
			
			if($("#review-title").val().length > 33 ||  $("#review-content").val().length > 99)
			{
				//글자수로 인한 db 저장 오류 방지를 위해 제한을 걸어둠.
			    alert("제목은 33자, 내용은 99자 이하로 작성해주세요.");
				return false;
			}
			
			$.ajax({
				url : "/api/game/main/reviewUpdate",
				type : "post",
				data : {
					game_seq : "${game_seq}",
					rating : $("input[name='rating']:checked").val(),
					title : $("#review-title").val(),
					content : $("#review-content").val(),
				},
				 dataType: "json" 
			}).done(function(resp){
				console.log(resp + "응답받음");
				$("#gameReviewBox").html("");
				//리뷰 작성 내용 지워주고
				$("#review-title").val("");
				$("#review-content").val("");
				$("#5-stars").prop("checked", true);
				//리뷰 칸 전부 비우고 다시 채우기.
				
				resp.forEach(function(reviewItem){
					let stars = "";
				    for (let i = 0; i < reviewItem.rating; i++) {
				        stars += "★ ";
				    }
				    for (let i = reviewItem.rating; i < 5; i++) {
				        stars += "☆ ";
				    }
				    
				    let reviewHtml="";
				    
				    if(reviewItem.writer === "${loginId}") {
				    	userReviewRating = reviewItem.rating;
				    	reviewHtml = `
							<div class="card review-card">
								<div class="row">
									<div class="col-3 stars">`+stars+`</div>
									<div class="col-6">
										<h3>`+reviewItem.title +`</h3>
										<div>`+ reviewItem.content +`</div>
									</div>
									<div class="col-2">
										<div>`+reviewItem.writer+`</div>
										<div class="reviewCreated_at">`+reviewItem.created_at+`</div>
									</div>

									<div class="col-1" style="padding: 0px">
										<div class="review-buttons">
											<button class="btn btn-outline-gray-main review-edit-btn" >수정</button>
											<button class="btn btn-outline-gray-main review-delete-btn">삭제</button>

										</div>
									</div>
								</div>
							</div>
						`;

						$("#gameReviewBox").prepend(reviewHtml);
				    }
				    else
				    {
				    	reviewHtml = `
							<div class="card review-card">
								<div class="row">
									<div class="col-3 stars">`+stars+`</div>
									<div class="col-6">
										<h3>`+reviewItem.title +`</h3>
										<div>`+ reviewItem.content +`</div>
									</div>
									<div class="col-3">
										<div>`+reviewItem.writer+`</div>
										<div class="reviewCreated_at">`+reviewItem.created_at+`</div>
									</div>
								</div>
							</div>
						`;

						$("#gameReviewBox").append(reviewHtml);
				    }
				});
				
				$("#gameReviewWriteBox").hide();
				
				$(".reviewCreated_at").each(function() {
				    let raw = $(this).text(); // "2025-08-27 14:35:20"
				    let date = new Date(raw);
				
				    let year =  String(date.getFullYear()).slice(-2); // 2025 → "25"
				    let month = (date.getMonth() + 1).toString().padStart(2, "0");
				    let day = date.getDate().toString().padStart(2, "0");
				
				    let formatted = year + "년 " + month + "월 " + day + "일";
				    $(this).text(formatted);
				});
				
				
				
			});
			
		});
		
		
		
	</script>
</div>