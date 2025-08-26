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
	height:136px;
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

.review-card .col-3, .review-card .col-6, .review-card .col-3 {
	display: flex;
	flex-direction: column;
	justify-content: center;
}
</style>

	<div class="container reviewJsp">
		<!-- 리뷰 작성 카드 -->
		<div class="card">
			<form class="review-form" method="post" action="/submitReview">

				<div class="col-3 star-rating">
					<input type="radio" id="5-stars" name="rating" value="5"><label
						for="5-stars">&#9733;</label> <input type="radio" id="4-stars"
						name="rating" value="4"><label for="4-stars">&#9733;</label>
					<input type="radio" id="3-stars" name="rating" value="3"><label
						for="3-stars">&#9733;</label> <input type="radio" id="2-stars"
						name="rating" value="2"><label for="2-stars">&#9733;</label>
					<input type="radio" id="1-star" name="rating" value="1"><label
						for="1-star">&#9733;</label>
				</div>
				<div class="col-7 reviewInput">
					<input type="text" id="title" name="title" placeholder="리뷰 제목"
						required>
					<textarea id="review-content" name="review-content"
						placeholder="리뷰 내용을 작성해주세요." required></textarea>
				</div>
				<div class="col-2 reviewInput">
					<button type="submit">리뷰 등록</button>
				</div>

			</form>
		</div>

		<!-- 기존 리뷰 -->
		<c:forEach var="gameReview" items="${gameReviewList}">
			<div class="card review-card">
				<div class="row">
					<div class="col-3 stars">★★★★★</div>
					<div class="col-6">
						<h3>${gameReview.title}</h3>
						<div>${gameReview.content}</div>
					</div>
					<div class="col-3">
						<div>${gameReview.writer}</div>
						<div>${gameReview.created_at}</div>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
</div>