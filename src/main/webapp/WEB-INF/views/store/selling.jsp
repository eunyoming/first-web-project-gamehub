<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<!-- 
여기에 코드 입력
 -->
<div class="container-fluid my-5">
	<h2 class="mb-4">포인트 상점</h2>

	<div class="row g-4" id="selling-list-div">
		<!-- 상품 카드 1 -->
		<div class="col-md-3 col-sm-6">
			<div class="card h-100 shadow-sm">
				<img src="assets/champion1.jpg" class="card-img-top" alt="유나라">
				<div class="card-body">
					<h5 class="card-title">유나라</h5>
					<p class="card-text">
						<span class="text-warning fw-bold">975 RP</span> <br> <span
							class="text-info fw-bold">3150 BE</span>
					</p>
				</div>
			</div>
		</div>

		<!-- 상품 카드 2 -->
		<div class="col-md-3 col-sm-6">
			<div class="card h-100 shadow-sm">
				<img src="assets/champion2.jpg" class="card-img-top" alt="멜">
				<div class="card-body">
					<h5 class="card-title">멜</h5>
					<p class="card-text">
						<span class="text-warning fw-bold">975 RP</span> <br> <span
							class="text-info fw-bold">3150 BE</span>
					</p>
				</div>
			</div>
		</div>

		<!-- 상품 카드 3 -->
		<div class="col-md-3 col-sm-6">
			<div class="card h-100 shadow-sm">
				<img src="assets/champion3.jpg" class="card-img-top" alt="엠베사">
				<div class="card-body">
					<h5 class="card-title">엠베사</h5>
					<p class="card-text">
						<span class="text-warning fw-bold">975 RP</span> <br> <span
							class="text-info fw-bold">3150 BE</span>
					</p>
				</div>
			</div>
		</div>

		<!-- 상품 카드 4 -->
		<div class="col-md-3 col-sm-6">
			<div class="card h-100 shadow-sm">
				<img src="assets/champion3.jpg" class="card-img-top" alt="엠베사">
				<div class="card-body">
					<h5 class="card-title">엠베사</h5>
					<p class="card-text">
						<span class="text-warning fw-bold">975 RP</span> <br> <span
							class="text-info fw-bold">3150 BE</span>
					</p>
				</div>
			</div>
		</div>

		<!-- 상품 카드 5 -->
		<div class="col-md-3 col-sm-6">
			<div class="card h-100 shadow-sm">
				<img src="assets/champion3.jpg" class="card-img-top" alt="엠베사">
				<div class="card-body">
					<h5 class="card-title">엠베사</h5>
					<p class="card-text">
						<span class="text-warning fw-bold">975 RP</span> <br> <span
							class="text-info fw-bold">3150 BE</span>
					</p>
				</div>
			</div>
		</div>
	</div>
</div>

<script>

	$(function(){
		$.ajax({
			url : "/api/point",
			type : "post"
			
		})
	}).done(function(resp){
		console.log(resp+"응답 받음");
		
		$("#selling-list-div").html("");
		//리스트 내용 비워주고.
		
		  if("${loginId}" != null) {
			  resp.forEach(function(list){
					let colDiv = $("<div>");
					colDiv.attr({"class":"col-md-3 col-sm-6"});
					
					let cardDiv = $("<div>");
					cardDiv.attr({"class":"card h-100 shadow-sm"});
					
					let imgSrc = $("<img>");
					imgSrc.attr({"src":"assets/champion1.jpg","class":"card-img-top"});
					
					let cardBodyDiv = $("<div>");
					cardBodyDiv.attr({"class":"card-body"});
					
					let cardBodyH5Title = $("<h5>");
					cardBodyH5Title.attr=({"class":"card-title"});
					cardBodyH5Title.html("유나라");
					
					cardBodyDiv.append(cardBodyH5Title);
					
					let cardBodyPText = $("<p>");
					cardBodyPText.attr=({"class":"card-text"});
					
					let cardBodyPTextSpan = $("<span>");
					cardBodyPTextSpan.attr=({"class":"text-warning fw-bold"})
					cardBodyPTextSpan.html("975RP");
				})
				
		  }
		
	})
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />