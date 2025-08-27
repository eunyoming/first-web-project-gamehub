<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
				<button class="btn btn-blue-purple" type="button" style="color:white">검색</button>
			</div>

		</div>
	</div>
	<div class="contents mt-5">
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		<div class="row listDiv g-0" style="border:none">
			<div class="col-1">번호</div>
			<div class="col-3">[카테고리] / [관련 게임]</div>
			<div class="col-3">게시글 제목[댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
	</div>
</div>



<jsp:include page="/WEB-INF/views/common/footer.jsp" />
