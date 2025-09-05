<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 
여기에 코드 입력
 -->

<style>
.myPagePoint-section {
	margin-bottom: 40px;
}

.myPagePoint-container h5, .myPagePoint-container h6 {
	font-weight: bold;
	/* 굵게 = 700 */
}

.myPagePoint-card {
	margin-bottom: 2px;
}

.myPagePoint-card .card-col-btn button {
	height: 100%;
	width: 100%;
}

.card-text-time {
	/* padding: 3px; */
	font-size: 12px;
}

/* 여기부터 페이지네이션 */
.mypage-pagination-container {
	display: flex;
	justify-content: center;
	gap: 6px;
	padding: 10px;
}

.mypage-page-btn {
	display: inline-block;
	padding: 6px 12px;
	border: 1px solid #ddd;
	border-radius: 6px;
	text-decoration: none;
	color: #333;
	font-size: 14px;
	background-color: #fff;
	transition: all 0.2s;
}

.mypage-page-btn:hover {
	background-color: #f0f0f0;
}

.mypage-page-btn.active {
	background-color: #007bff;
	color: white;
	border-color: #007bff;
	font-weight: bold;
}

@import url('https://fonts.googleapis.com/css2?family=Jua&display=swap')
	;
/* 여기까지 페이지네이션 */
</style>
<div class="container myPagePoint-container">
	<!-- 알림내역 섹션 -->



	<div class="section myPagePoint-section"
		id="myPagePoint-myPagePoint-section">

		<div class="row">
			<div class="col-10 d-flex align-items-start">
				<h5
					style="font-weight: bold; padding-top: 15px; padding-bottom: 15px;">포인트
					내역</h5>
			</div>

			<c:choose>
				<c:when test="${loginId == param.userId}">


					<div class="col-2  d-flex justify-content-end align-items-center"
						id="totalPointText" 
						style="font-weight: bold;">
					</div>

				</c:when>
			</c:choose>
		</div>
		<div class="row" id="emptymyPagePointRow">
			<div class="col-12 d-flex justify-content-center">포인트 내역이 존재하지
				않습니다.</div>
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
				const urlParams = new URLSearchParams(window.location.search);
				let cpage = urlParams.get("cpage") || 1; // 없으면 기본값 1
				
				
				$.ajax({
					url : "/api/pointLog/view",
					type : "post",
					data :{
						cpage: cpage
					},
					dataType:"json"
				}).done(function(resp){
					console.log(resp, "/view 응답 받음");
					
					
					
					$("#totalPointText").html("Total Point : " +  resp.pointValue);
					
				    // lists 배열 순회
				    resp.lists.forEach(function(item){
				        console.log(item.seq, item.type, item.message);
				        let bookmark = $("<div>");
				        bookmark.attr({"class":"card myPagePoint-card"});
				        
				        let bookmarkBody = $("<div>");
				        bookmarkBody.attr({"class":"card-body"});
				        
				        let bookmarkRow = $("<div>");
				        bookmarkRow.attr({"class":"row"});
				        
				        let bookmarkCol_11 = $("<div>");
				        bookmarkCol_11.attr({"class":"col-11 card-col-val myPagePoint-card-body-cursor"});
				        
					        let bookmarkTitle = $("<h6>");
					        
						    bookmarkTitle.html( item.description);
					       
					        bookmarkTitle.attr({"class":"card-title"});
					        
					        bookmarkCol_11.append(bookmarkTitle);
					        
					        let bookmarkContent = $("<p>");
					        
					        
					        bookmarkContent.html("Point : " + item.value + "<br>" +  item.created_at);
					       
					        bookmarkContent.attr({"class":"card-text"});
					        
					        bookmarkCol_11.append(bookmarkContent);
				        	
					        bookmarkCol_11.on("click", function() {
					        	
					        	
					        	/* window.location.href = "/detailPage.board?seq=" + item.seq; */
					            
					        });
					        
					    bookmarkRow.append(bookmarkCol_11);    
					    
					    	
					    bookmarkBody.append(bookmarkRow);	
					    	
				        bookmark.append(bookmarkBody);
				        
				        $("#myPagePoint-myPagePoint-section").append(bookmark);
				    });

				 
					
					/* let pagingDiv = $("<div style=display:flex;justify-content:center; padding:5px>");
					
					
					
					if(needPrev) {
						pagingDiv.append("<a href='/api/member/mypage?section=point&cpage="+(startNavi-1)+"&userId=${loginId}" +"'>< </a> ");
					}
					for(let i=startNavi;i<=endNavi;i++) {
						pagingDiv.append("<a href='/api/member/mypage?section=point&cpage="+i +"&userId=${loginId}" + "'>" + i +  "</a> ");
					}
					if(needNext) {

						pagingDiv.append("<a href='/api/member/mypage?section=point&cpage="+(endNavi+1)+"&userId=${loginId}" + "'>> </a>");
					}
					
					 $("#myPagePoint-myPagePoint-section").append(pagingDiv); */
					 
					 if(resp.lists.length>0)
						{
							$("#emptymyPagePointRow").hide();
							// 여기부터 페이징 자바스크립트.
							// 게시글 총개수
							// 한 페이지에 출력할 개수
							// 한 페이지에 출력할 네비 개수
							// 페이지 총 개수
							let recordTotalCount = resp.userLogCount;
							let recordCountPerPage = 5;  //상수로 줌
							let naviCountPerPage = 5;    //상수로 줌
							let pageTotalCount = 0;
							
							//나머지가 있으면 +1을 해줘야함. 10개씩 출력할때 147개의 글이 있으면 15페이지가 나와야해서
							if(recordTotalCount % recordCountPerPage > 0) { 
								pageTotalCount = Math.ceil(recordTotalCount / recordCountPerPage);
							}
							else
							{
								pageTotalCount = Math.ceil(recordTotalCount / recordCountPerPage)
							}
							
							let currentPage = resp.currentPage;
							
							if(currentPage < 1) {	//currentPage값 보정
								currentPage = 1;
							}else if(currentPage > pageTotalCount)
							{
								currentPage = pageTotalCount;
							}
							
							let startNavi = Math.floor((currentPage-1) / naviCountPerPage) * naviCountPerPage + 1 ;
							let endNavi = startNavi + (naviCountPerPage - 1); 
							
							if(endNavi > pageTotalCount)
							{
								endNavi = pageTotalCount;
							}
							
							let needPrev = true;
							let needNext = true;

							if(startNavi == 1) {needPrev = false;}
							if(endNavi == pageTotalCount) { needNext = false;}
							
							
							
							
							
							let pagingDiv = $("<div class='mypage-pagination-container'></div>");

							// 이전 버튼
							if (needPrev) {
							    pagingDiv.append("<a class='mypage-page-btn prev' href='/api/member/mypage?section=point&cpage=" + (startNavi - 1) + "&userId=${loginId}'>&lt;</a>");
							}

							// 페이지 번호
							for (let i = startNavi; i <= endNavi; i++) {
							    let activeClass = (i === currentPage) ? " active" : "";
							    pagingDiv.append("<a class='mypage-page-btn num" + activeClass + "' href='/api/member/mypage?section=point&cpage=" + i + "&userId=${loginId}'>" + i + "</a>");
							}

							// 다음 버튼
							if (needNext) {
							    pagingDiv.append("<a class='mypage-page-btn next' href='/api/member/mypage?section=point&cpage=" + (endNavi + 1) + "&userId=${loginId}'>&gt;</a>");
							}

							$("#myPagePoint-myPagePoint-section").append(pagingDiv);
						}
				})
				.fail(function(xhr, status, error){
				    console.log("AJAX 실패:", status, error);
				    console.log(xhr.responseText);
				});
				
				
				
				
				//여기까지가 페이징 네이션
			});
			
		 
		</c:when>
		
		<c:otherwise>
		
	<p>친구 ${param.userId}의 페이지</p>
		
		</c:otherwise>
	</c:choose>

	
	
</script>