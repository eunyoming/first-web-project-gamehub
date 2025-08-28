<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 
여기에 코드 입력
 -->

<style>
.bookmark-section {
	margin-bottom: 40px;
}

.bookmark-container h5, .bookmark-container h6 {
	font-weight: bold;
	/* 굵게 = 700 */
}

.bookmark-card {
	margin-bottom: 15px;
}

.bookmark-card .card-col-btn button {
	height: 100%;
	width: 100%;
}

.card-text-time{
	padding:3px;
	font-size:12px;
}

.bookmark-card-body-cursor{
	cursor:pointer;
}
</style>
<div class="container bookmark-container">
	<!-- 북마크 섹션 -->
	<div class="section bookmark-section" id="bookmark-bookmark-section">
		<h5>북마크</h5>
		<p class="text-muted">Subheading</p>


		<div class="card bookmark-card">
			<div class="card-body">
				<div class="row">
					<div class="col-11 card-col-val">
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
		</div>
	</div>

	<!-- 내가 작성한 게시글 섹션 -->
	<div class="section bookmark-section" id="bookmark-board-section">
		<h5>내가 작성한 게시글</h5>
		<p class="text-muted">Subheading</p>

		<div class="card bookmark-card">
			<div class="card-body bookmark-card-body-cursor">
				<h6 class="card-title">Title</h6>
				<p class="card-text">Body text for whatever you'd like to say.
					Add main takeaway points, quotes, anecdotes, or even a very very
					short story.</p>
			</div>
		</div>

		<div class="card bookmark-card">
			<div class="card-body">
				<h6 class="card-title">Title</h6>
				<p class="card-text">Body text for whatever you'd like to say.
					Add main takeaway points, quotes, anecdotes, or even a very very
					short story.</p>
			</div>
		</div>

	</div>

	<!-- 내가 작성한 댓글 섹션 -->
	<div class="section bookmark-section" id="bookmark-reply-section">

		<h5>내가 작성한 댓글</h5>
		<p class="text-muted">Subheading</p>

		<div class="card bookmark-card">
			<div class="card-body">
				<h6 class="card-title">Title</h6>
				<p class="card-text">Body text for whatever you'd like to say.
					Add main takeaway points, quotes, anecdotes, or even a very very
					short story.</p>
			</div>
		</div>

		<div class="card bookmark-card">
			<div class="card-body">
				<h6 class="card-title">Title</h6>
				<p class="card-text">Body text for whatever you'd like to say.
					Add main takeaway points, quotes, anecdotes, or even a very very
					short story.</p>
			</div>
		</div>

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
					url : "/api/bookmark/view",
					type : "post",
					dataType:"json"
				}).done(function(resp){
					console.log(resp, "/view 응답 받음");

				    // bookmarks 배열 순회
				    resp.bookmarks.forEach(function(item){
				        console.log(item.seq, item.title, item.contents);
				        let bookmark = $("<div>");
				        bookmark.attr({"class":"card bookmark-card"});
				        
				        let bookmarkBody = $("<div>");
				        bookmarkBody.attr({"class":"card-body"});
				        
				        let bookmarkRow = $("<div>");
				        bookmarkRow.attr({"class":"row"});
				        
				        let bookmarkCol_11 = $("<div>");
				        bookmarkCol_11.attr({"class":"col-11 card-col-val"});
				        
					        let bookmarkTitle = $("<h6>");
					        bookmarkTitle.html(item.title);
					        bookmarkTitle.attr({"class":"card-title"});
					        
					        bookmarkCol_11.append(bookmarkTitle);
					        
					        let bookmarkContent = $("<p>");
					        bookmarkContent.html(item.contents);
					        bookmarkContent.attr({"class":"card-text"});
					        
					        bookmarkCol_11.append(bookmarkContent);
				        
					        
					    bookmarkRow.append(bookmarkCol_11);    
					    let bookmarkCol_1 = $("<div>");
					    bookmarkCol_1.attr({"class":"col-1 card-col-btn"});
					    
					    	let bookmarkBtn = $("<button>");
					    	bookmarkBtn.html("제거");
					    	bookmarkBtn.attr({"class":"btn btn-outline-red-main"});
					        bookmarkBtn.on("click",function(){
					        	console.log(item.seq);

					        	bookmark.hide();
					        	
					        	$.ajax({
					        		url: "/api/bookmark/delete",
					        		type : "post",
					        		data : {
					        			board_seq:item.seq
					        		}
					        	});
					        });
					        bookmarkCol_1.append(bookmarkBtn);    
					        
					    bookmarkRow.append(bookmarkCol_1);
					    	
					    bookmarkBody.append(bookmarkRow);	
					    	
				        bookmark.append(bookmarkBody);
				        
				        $("#bookmark-bookmark-section").append(bookmark);
				    });

				    
				    // boards 배열 순회
				    resp.boards.forEach(function(item){
				        console.log(item.seq, item.content, item.title);
				        
				        let bookmark = $("<div>");
				        bookmark.attr({"class":"card bookmark-card"});
				        
				        let bookmarkBody = $("<div>");
				        bookmarkBody.attr({"class":"card-body bookmark-card-body-cursor"});
				        				        
				        let bookmarkTitle = $("<h6>");
				        bookmarkTitle.html(item.title);
				        bookmarkTitle.attr({"class":"card-title"});
				        
				        bookmarkBody.append(bookmarkTitle);
				        
				        let bookmarkContent = $("<div>");
				        bookmarkTitle.html(item.contents);
				        bookmarkContent.attr({"class":"card-text"});
				        
				        bookmarkBody.append(bookmarkContent);
						
				        let bookmarkTime = $("<div>");
				        bookmarkTime.html(timeFormat(item.created_at));
				        bookmarkTime.attr({"class":"card-text-time"});
				        
				        bookmarkBody.append(bookmarkTime);
				        
				        bookmark.append(bookmarkBody);
				        
				        bookmark.on("click", function() {
				            window.location.href = "#";
				            console.log(item.seq + ":seq")
				            
				        });
				        
				        $("#bookmark-board-section").append(bookmark);
				    });
				    
					 // replys 배열 순회
				    resp.replys.forEach(function(item){
				        console.log(item.seq, item.contents, item.created_at);
				        
				        let bookmark = $("<div>");
				        bookmark.attr({"class":"card bookmark-card"});
				        
				        let bookmarkBody = $("<div>");
				        bookmarkBody.attr({"class":"card-body bookmark-card-body-cursor"});
				        				        
				        let bookmarkTitle = $("<h6>");
				        bookmarkTitle.html(item.title);
				        bookmarkTitle.attr({"class":"card-title"});
				        
				        bookmarkBody.append(bookmarkTitle);
				        
				        let bookmarkContent = $("<div>");
				        bookmarkContent.html(item.contents);
				        bookmarkContent.attr({"class":"card-text"});
				        
				        bookmarkBody.append(bookmarkContent);
				        
				        let bookmarkTime = $("<div>");
				        bookmarkTime.html(timeFormat(item.created_at));
				        bookmarkTime.attr({"class":"card-text-time"});
				        
				        bookmarkBody.append(bookmarkTime);

				        bookmark.append(bookmarkBody);
				        
				        bookmark.on("click", function() {
				            window.location.href = "#";
				            console.log(item.board_seq + ":board.seq")
				        });
				        
				        $("#bookmark-reply-section").append(bookmark);
				    });
				})
				
				.fail(function(xhr, status, error){
				    console.log("AJAX 실패:", status, error);
				    console.log(xhr.responseText);
				});
				
			});
			
		 
		</c:when>
		
		<c:otherwise>
		
	<p>친구 ${param.userId}의 페이지</p>
		
		</c:otherwise>
	</c:choose>

</script>