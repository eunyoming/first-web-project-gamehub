<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
.game-card {
	background-color: #e0e0e0;
	padding: 20px;
	text-align: center;
	border-radius: 5px;
}
</style>
<div class="d-flex justify-content-center align-items-center">

	<!-- 
여기에 코드 입력
 -->
	<div class="container">
		<!-- 게임 조작법 카드 2열 -->
		<div class="row">
			<div class="col-12">
				<div class="game-card" id="guide-container">
		
					<!-- 여기에 무수한 데이터들이 올거야 -->
					
				</div>
			</div>

		</div>
	</div>

</div>


<script>
$.ajax({
	url : "/api/game/guide",
	type:"post",
	contentType: "application/json",
	data : JSON.stringify({ seq : "${game_seq}" }),
	dataType : "json"
	
}).done(function(resp) {
	console.log("업데이트 후 시퀀스", ${game_seq});
    console.log("업데이트 후 데이터:", resp);

    // 예시: 화면 갱신
     if (resp.guide) {
        $("#guide-container").html(resp.guide);
    } else {
        $("#guide-container").text("데이터가 없습니다.");
    }

    
})
.fail(function(xhr, status, err) {
    console.error("업데이트 실패:", err);
});





</script>