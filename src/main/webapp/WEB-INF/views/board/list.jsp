<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- JSTL 날짜 포맷 라이브러리 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
request.setAttribute("pageTitle", "게시판 리스트");
%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- bootstrap icon -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.css">
<!-- css -->
<link href="/css/list.css" rel="stylesheet" />

<div class="container g-0">
	<div class="row g-3 align-items-end mt-2">
		<!-- 카테고리 -->
		<div class="col-12 col-md-2">
			<label for="category" class="form-label">카테고리</label> <select
				id="category" class="form-select">
				<option value="">전체</option>
				<option value="자유" ${categoryParam == '자유' ? 'selected' : ''}>자유</option>
				<option value="공략" ${categoryParam == '공략' ? 'selected' : ''}>공략</option>
				<option value="기타" ${categoryParam == '기타' ? 'selected' : ''}>기타</option>
				<option value="Q&A" ${categoryParam == 'Q&A' ? 'selected' : ''}>Q&amp;A</option>
			</select>
		</div>
		<!-- 관련 게임 -->
		<div class="col-12 col-md-2">
			<label for="relatedGame" class="form-label">관련 게임</label> <select
				id="relatedGame" class="form-select">
				<option value="">전체</option>
			</select>
		</div>
		<div class="col-2 col-md-none"></div>
		<div class="col-12 col-md-6 pe-3">
			<label for="searchInput" class="form-label">게시물 검색 내용</label>
			<div class="input-group">
				<input id="searchInput" type="text" class="form-control"
					placeholder="검색어를 입력하세요." value="${param.search}">
				<button class="btn btn-blue-purple" type="button" id="searchBtn"
					style="color: white">검색</button>
			</div>

		</div>
	</div>
	<div class="contents mt-5">
		<div class="row board-item board-header g-0 ">
			<div class="col-1">번호</div>
			<div class="col-1">[카테고리]</div>
			<div class="col-2">[ 관련 게임 ]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<c:choose>
			<c:when test="${list == null}">
				<div>표시할 내용이 없습니다.</div>
			</c:when>

			<c:otherwise>
				<c:forEach var="dto" items="${list}">
					<div class="row board-item g-0">
						<div class="col-1">${dto.seq}</div>
						<div class="col-1">[ ${dto.category} ]</div>
						<div class="col-2">
							<c:choose>
							    <c:when test="${dto.refgame == '스페이스 배틀'}">
							        <span class="badge btn-gradient btn-blue-purple text-dark">${dto.refgame}</span>
							    </c:when>
							    <c:when test="${dto.refgame == '테트리스'}">
							        <span class="badge btn-gradient btn-red-blue text-dark">${dto.refgame}</span>
							    </c:when>
							    <c:when test="${dto.refgame == '망각의 숲'}">
							        <span class="badge btn-gradient btn-navy-blue text-dark">${dto.refgame}</span>
							    </c:when>
							    <c:when test="${dto.refgame == '플래피 버드'}">
							        <span class="badge btn-gradient btn-green-peach text-dark">${dto.refgame}</span>
							    </c:when>
							      <c:when test="${dto.refgame == '화살 피했냥'}">
							        <span class="badge btn-gradient btn-red-peach text-dark">${dto.refgame}</span>
							    </c:when>
							    <c:otherwise>
							        <span class="badge btn-gradient">${dto.refgame}</span>
							    </c:otherwise>
							</c:choose>
						</div>
						<div class="col-3">
							<a href="/detailPage.board?seq=${dto.seq}" class="title-ellipsis"
								style="text-decoration: none; color: inherit;"> ${dto.title}</a>
							<!-- 댓글수 -->
							<span class="ms-1">[${dto.replyCount}]</span>
						</div>
						<div class="col-1">${dto.writer}</div>
						<div class="col-2">
							<fmt:formatDate value="${dto.created_at}" pattern="yyyy-MM-dd" />
						</div>
						<div class="col-1">${dto.viewCount}</div>
						<div class="col-1">${dto.likeCount}</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="board-footer row">
		<div class="pageNavi col-10">
			<c:if test="${navi.jumpPrev}">
				<a href="/list.board?cpage=${navi.currentPage - naviCountPerPage}">≪</a>
			</c:if>
			<c:if test="${navi.needPrev}">
				<a href="/list.board?cpage=${navi.currentPage - 1}">&lt;</a>
			</c:if>

			<c:forEach var="i" begin="${navi.startNavi}" end="${navi.endNavi}">
				<a href="/list.board?cpage=${i}"
					class="${i == navi.currentPage ? 'active' : ''}">${i}</a>
			</c:forEach>

			<c:if test="${navi.needNext}">
				<a href="/list.board?cpage=${navi.currentPage + 1}">&gt;</a>
			</c:if>
			<c:if test="${navi.jumpNext}">
				<a href="/list.board?cpage=${navi.currentPage + naviCountPerPage}">≫</a>
			</c:if>
		</div>
		<div class="board-footer-btn col-2">
			<c:if test="${loginId != null}">
				<a href="/write.board">
					<button class="btn btn-dark" id="write_btn">글 작성하기</button>
				</a>
			</c:if>
		</div>
	</div>
</div>

<script>
	
	$(document).ready(function() {
		// 관련 게임 채워넣기
		$.ajax({
		    url: "/api/game/gameList",
		    type: "GET",
		    dataType: "json",
		    success: function(data) {
		        let $select = $("#relatedGame");
		        $select.empty();
		        $select.append('<option value="">전체</option>');

		        data.forEach(function(game) {
		            let selected = "";
		            if ("${refgameParam}" === game.title) {
		                selected = "selected";
		            }
		            $select.append(
		                '<option value="' + game.title + '" data-seq="' + game.seq + '" ' + selected + '>' 
		                + game.title + 
		                '</option>'
		            );
		        });
		    },
		    error: function(xhr, status, error) {
		        console.error("게임 목록 불러오기 실패:", error);
		    }
		});

	    	// ------------ 필터링
	        // 카테고리 변경
	        $("#category").on("change", doSearch);

	        // 관련 게임 변경
	        $("#relatedGame").on("change", doSearch);

	        // 검색 버튼 클릭
	        $("#searchBtn").on("click", doSearch);

	        // 검색창 엔터 입력
	        $("#searchInput").on("keypress", function (e) {
	            if (e.which === 13) { // 엔터키
	                doSearch();
	            }
	        });

	        // 공통 함수
	        function doSearch() {
	            let category = $("#category").val();
	            let game = $("#relatedGame").val();
	            let search = $("#searchInput").val().trim();

	            let url = "/list.board?cpage=1";
	            if (category) url += "&category=" + encodeURIComponent(category);
	            if (game) url += "&refgame=" + encodeURIComponent(game);
	            if (search) url += "&search=" + encodeURIComponent(search);

	            location.href = url;
	        }
	    }); // function(){}

</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />