<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- JSTL 날짜 포맷 라이브러리 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- bootstrap icon -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.css">
<!-- css -->
<link href="/css/list.css" rel="stylesheet" />

<div class="container g-0">
	<div class="row g-3 align-items-end mt-2">
		<div class="col-12 col-md-2">
			<label for="category" class="form-label">카테고리</label> <select
				id="category" class="form-select">
				<option value="">전체</option>
				<option>자유</option>
				<option>공략</option>
				<option>기타</option>
			</select>
		</div>
		<div class="col-12 col-md-2">
			<label for="relatedGame" class="form-label">관련 게임</label> <select
				id="relatedGame" class="form-select">
				<option value="">전체</option>
				<option>Game A</option>
				<option>Game B</option>
				<option>Game C</option>
			</select>
		</div>
		<div class="col-2 col-md-none"></div>
		<div class="col-12 col-md-6 pe-3">
			<label for="searchInput" class="form-label">게시물 검색 내용</label>
			<div class="input-group">
				<input id="searchInput" type="text" class="form-control"
					placeholder="검색어를 입력하세요.">
				<button class="btn btn-blue-purple" type="button"
					style="color: white">검색</button>
			</div>

		</div>
	</div>
	<div class="contents mt-5">
		<div class="row board-item board-header g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
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
						<div class="col-3">[ ${dto.category} ] / [ ${dto.refgame} ]</div>
						<div class="col-3">
							<a href="/detail.board?seq=${dto.seq}"
								style="text-decoration: none; color: inherit;">
								${dto.title}[댓글수]</a>
						</div>
						<div class="col-1">${dto.writer}</div>
						<div class="col-2">
							<fmt:formatDate value="${dto.created_at}"
								pattern="yyyy-MM-dd" />
						</div>
						<div class="col-1">${dto.viewCount}</div>
						<div class="col-1">${dto.likeCount}</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="pageNavi">
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
</div>



<jsp:include page="/WEB-INF/views/common/footer.jsp" />
