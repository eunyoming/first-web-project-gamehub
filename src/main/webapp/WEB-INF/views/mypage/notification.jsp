<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 
여기에 코드 입력
 -->

<style>
.notification-section {
	margin-bottom: 40px;
}

.notification-container h5, .notification-container h6 {
	font-weight: bold;
	/* 굵게 = 700 */
}

.notification-card {
	margin-bottom: 2px;
}

.notification-card .card-col-btn button {
	height: 100%;
	width: 100%;
}

.card-text-time {
	/* padding: 3px; */
	font-size: 12px;
}

.notification-card-body-cursor {
	cursor: pointer;
}
</style>
<div class="container notification-container">
	<!-- 알림내역 섹션 -->



	<div class="section notification-section"
		id="notification-notification-section">

		<div class="row">
			<div class="col-10 d-flex align-items-start">
				<h5 style="font-weight:bold;padding-top: 15px; padding-bottom:15px;">알림 내역</h5>
			</div>
			<c:choose>
				<c:when test="${loginId == param.userId}">



					<div class="col-2  d-flex justify-content-end align-items-center">
						<button id="delete-all-btn"
							class="btn btn-gradient btn-blue-purple"
							style="height:70%;padding-right:10px;display:none">전체 삭제</button>
					</div>

				</c:when>
			</c:choose>

		</div>
		
		<div class="row" id="emptyNotificationRow">
			<div class="col-12 d-flex justify-content-center">
				알림이 존재하지 않습니다.
			</div>
		</div>



		<!-- ajax요청 받은 후 생성하는 형태 확인용 -->
		<!-- <div class="card notification-card">
			<div class="card-body">
				<div class="row">
					<div class="col-11 card-col-val notification-card-body-cursor">
						<h6 class="card-title">Html체크용 버튼 동작 안함.</h6>
						<p class="card-text">Body text for whatever you'd like to say.
							Add main takeaway points, quotes, anecdotes, or even a very very
							short story.</p>
					</div>
					<div class="col-1 card-col-btn">
						<button class="btn btn-outline-gray-main ">제거</button>
					</div>
				</div>
			</div>
		</div> -->
	</div>
</div>
<script>
	let timeFormat =  function(timeStamp) {
	    let date = new Date(timeStamp);
	
	    let year =  String(date.getFullYear()).slice(-2); // 2025 → "25"
	    let month = (date.getMonth() + 1).toString().padStart(2, "0");
	    let day = date.getDate().toString().padStart(2, "0");
	
	    let formatted = year + "년 " + month + "월 " + day + "일";
	    return formatted;
	};

	<c:choose>
		<c:when test="${loginId == param.userId}">
			
		
			$(function(){
				$.ajax({
					url : "/notification/view",
					type : "post",
					dataType:"json"
				}).done(function(resp){
					
					
					if(resp.length==0)
					{
						$("#delete-all-btn").hide();
						
					}
					else
					{
						$("#emptyNotificationRow").hide();
						$("#delete-all-btn").show();
					}
					
					
					
				    // bookmarks 배열 순회
				    resp.forEach(function(item){
				        console.log(item.seq, item.type, item.message);
				        let bookmark = $("<div>");
				        bookmark.attr({"class":"card notification-card"});
				        
				        let bookmarkBody = $("<div>");
				        bookmarkBody.attr({"class":"card-body"});
				        
				        let bookmarkRow = $("<div>");
				        bookmarkRow.attr({"class":"row"});
				        
				        let bookmarkCol_11 = $("<div>");
				        bookmarkCol_11.attr({"class":"col-11 card-col-val notification-card-body-cursor"});
				        
					        let bookmarkTitle = $("<h6>");
					        
						    bookmarkTitle.html(item.message);
					       
					        bookmarkTitle.attr({"class":"card-title"});
					        
					        bookmarkCol_11.append(bookmarkTitle);
					        
					        let bookmarkContent = $("<p>");
					        
					        
					        bookmarkContent.html(item.created_At);
					       
					        bookmarkContent.attr({"class":"card-text"});
					        
					        bookmarkCol_11.append(bookmarkContent);
				        	
					        bookmarkCol_11.on("click", function() {
					        	
					        	switch(item.type) {
			        		    case "store":
			        		        console.log('store입니다.');
			        		        window.location.href = "/api/point/pointPage";
			        		        break;
			        		    case "friend":
			        		        console.log('friend입니다.'); 
			        		        window.location.href = "/api/member/mypage?userId=${loginId}&section=friend";
			        		        break;
			        		    case "achievement":
			        		        console.log('achievement입니다.'); 
			        		        window.location.href = "/api/member/mypage?userId=${loginId}&section=collection";
			        		        break;
			        		    case "point":
			        		        console.log('point입니다.'); 
			        		        window.location.href = "/api/member/mypage?userId=${loginId}&section=point";
			        		        break;
			        		    case "chat":
				        		    console.log('chat입니다.'); 
				        		    window.location.href = "/chat/open?friendId="+item.related_userId;
				        		    break;
			        		    case "reply":
				        		    console.log('reply입니다.'); 
				        		    window.location.href = "/detailPage.board?seq="+item.related_objectId;
				        		    break;
			        		    default:
			        		    	dropa.attr({"class":"dropdown-item","href":"#"})
			        		        console.log('잘못된 타입입니다.');
			        		}
					        	/* window.location.href = "/detailPage.board?seq=" + item.seq; */
					            
					        });
					        
					    bookmarkRow.append(bookmarkCol_11);    
					    let bookmarkCol_1 = $("<div>");
					    bookmarkCol_1.attr({"class":"col-1 card-col-btn"});
					    
					    	let bookmarkBtn = $("<button>");
					    	bookmarkBtn.html("제거");
					    	bookmarkBtn.attr({"class":"btn btn-gradient btn-blue-purple"});
					        bookmarkBtn.on("click",function(){
					        	console.log(item.seq);

					        	bookmark.hide();
					        	
					        	$.ajax({
					        		url: "/notification/delete",
					        		type : "post",
					        		data : {
					        			notification_seq:item.seq
					        		}
					        	});
					        	
					        	location.reload();
					        });
					        bookmarkCol_1.append(bookmarkBtn);    
					        
					    bookmarkRow.append(bookmarkCol_1);
					    	
					    bookmarkBody.append(bookmarkRow);	
					    	
				        bookmark.append(bookmarkBody);
				        
				        $("#notification-notification-section").append(bookmark);
				    });

				    
				   
				})
				.fail(function(xhr, status, error){
				    console.log("AJAX 실패:", status, error);
				    console.log(xhr.responseText);
				});
				
				
				
				$("#delete-all-btn").on("click",function(){
					$.ajax({
		        		url: "/notification/deleteAll",
		        		type : "post",
		        		
		        	}).done(function(resp){
		        		location.reload();
		        	}).fail(function(xhr, status, error){
		        	    console.log("알림 전체 삭제 실패: " + error);
		        	});
				});
			});
			
		 
		</c:when>
		
		<c:otherwise>
		
	<p>친구 ${param.userId}의 페이지</p>
		
		</c:otherwise>
	</c:choose>

</script>