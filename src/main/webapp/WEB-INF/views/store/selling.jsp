<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<!-- 
여기에 코드 입력
 -->


<style>
.card-img-top {
	width: auto;
	height: 300px; /* 비율 유지 */
	object-fit: cover;
}

.sellingCard {
	cursor: pointer; /* 손 모양 커서 */
}
</style>


<div class="container-fluid my-5">
	<h1 class="mb-4">포인트 상점</h1>
	<h3 class="mb-4">구매 가능한 아이템</h3>
	<div class="row g-4" id="selling-list-div">

		<!-- <div class="col-md-3 col-sm-6">
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
		</div> -->


	</div>


	<hr style="margin-top: 30px; margin-bottom: 80px;">
	<h3 class="mb-4" style="display: none" id=purchased-list-text>구매한
		아이템</h3>
	<div class="row g-4" id="purchased-list-div"></div>

</div>

<script>
	$(function(){
		$.ajax({
			url : "/api/store/itemView",
			type : "post"
			
		}).done(function(resp){
			console.log(resp+"응답 받음");
			
			$("#selling-list-div").html("");
			//리스트 내용 비워주고.
			
				  let isPurchasedBool=false;
				  
				  resp.forEach(function(list){
					  let colDiv = $("<div>").addClass("col-md-3 col-sm-6");

					  let cardDiv = $("<div>").addClass("card h-100 shadow-sm sellingCard");

					  let imgSrc = $("<img>").attr({
					      "src": list.url ,
					      "class": "card-img-top",
					  });

					  let cardBodyDiv = $("<div>").addClass("card-body");

					  let cardBodyH5Title = $("<h5>").addClass("card-title").html(list.itemName);

					  let cardBodyPText = $("<p>").addClass("card-text");

					  let span1 = $("<span>").addClass("text-warning fw-bold").html(list.price+" Point");
					  /* let span2 = $("<span>").addClass("text-info fw-bold").html(list.contents); */

					  cardBodyPText.append(span1).append("<br>");
					  /* .append(span2); */

					  cardBodyDiv.append(cardBodyH5Title).append(cardBodyPText);

					  cardDiv.append(imgSrc).append(cardBodyDiv);
					  colDiv.append(cardDiv);


					  if("${loginId}" != "") {
					  cardDiv.on("click", function() {
						    window.location.href = '/api/store/itemDetail?seq='+list.seq;
						});
					  }
					  else{
						  cardDiv.on("click", function() {
							    alert("로그인 후 이용해주세요.");
							});
						  
						}
					  
					  if(list.isPurchased=="false"){
					  	$("#selling-list-div").append(colDiv);
						  
					  }
					  else
					  {
						  imgSrc.css("filter", "grayscale(100%)");
						  $("#purchased-list-div").append(colDiv);
						  isPurchasedBool=true;
					  }
					  
					})
					
					if(isPurchasedBool)
					{ $("#purchased-list-text").css("display", "block");}
				  
			  
			
		});
	}); 
	
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />