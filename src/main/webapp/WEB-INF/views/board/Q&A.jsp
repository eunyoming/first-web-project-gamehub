<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
request.setAttribute("pageTitle", "Q&A 게시판");
%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- bootstrap icon -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.css">
<link href="/css/list.css" rel="stylesheet" />

<div class="container g-0">
	<div class="contents mt-4">
		<div class="row board-item board-header g-0">
			<div class="col-1">번호</div>
			<div class="col-2">[ 관련 게임 ]</div>
			<div class="col-4">질문 제목 [댓글수]</div>
			<div class="col-1">작성자</div>
			<div class="col-2">작성시간</div>
			<div class="col-1">조회수</div>
			<div class="col-1">추천수</div>
		</div>
		
		<c:choose>
			<c:when test="${empty qnaList}">
				<div class="row board-item g-0">
					<div class="col-12 text-center py-3">등록된 Q&A 게시글이 없습니다.</div>
				</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="dto" items="${qnaList}">
					<div class="row board-item g-0">
						<div class="col-1">${dto.seq}</div>
						<div class="col-1">[ ${dto.category} ]</div>
						<div class="col-2">
							<span class="badge btn-gradient btn-red-peach">${dto.refgame}</span>
						</div>
						<div class="col-3">
							<a href="/detailPage.board?seq=${dto.seq}"
								style="text-decoration: none; color: inherit;"> ${dto.title}
							</a>
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
				<a
					href="/QnA_list.board?cpage=${navi.currentPage - naviCountPerPage}">≪</a>
			</c:if>
			<c:if test="${navi.needPrev}">
				<a href="/QnA_list.board?cpage=${navi.currentPage - 1}">&lt;</a>
			</c:if>

			<c:forEach var="i" begin="${navi.startNavi}" end="${navi.endNavi}">
				<a href="/QnA_list.board?cpage=${i}"
					class="${i == navi.currentPage ? 'active' : ''}">${i}</a>
			</c:forEach>

			<c:if test="${navi.needNext}">
				<a href="/QnA_list.board?cpage=${navi.currentPage + 1}">&gt;</a>
			</c:if>
			<c:if test="${navi.jumpNext}">
				<a
					href="/QnA_list.board?cpage=${navi.currentPage + naviCountPerPage}">≫</a>
			</c:if>
		</div>
		<div class="board-footer-btn col-2">
			<c:if test="${loginId != null}">
				<a href="/write.board?category=Q&A">
					<button class="btn btn-dark" id="write_btn">Q&amp;A 작성하기</button>
				</a>
			</c:if>
		</div>
		<pre>${qnaList}</pre>
	</div>
</div>

<script>
var qnaList = "${qnaList}";
console.log("qnaList =", qnaList);


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
    $("#category").on("change", doSearch);
    $("#relatedGame").on("change", doSearch);
    $("#searchBtn").on("click", doSearch);
    $("#searchInput").on("keypress", function (e) {
        if (e.which === 13) { // 엔터키
            doSearch();
        }
    });

    function doSearch() {
        let category = $("#category").val();
        let game = $("#relatedGame").val();
        let search = $("#searchInput").val().trim();

        // Q&A 전용 URL
        let url = "/QnA_list.board?cpage=1";
        if (category) url += "&category=" + encodeURIComponent(category);
        if (game) url += "&refgame=" + encodeURIComponent(game);
        if (search) url += "&search=" + encodeURIComponent(search);

        location.href = url;
    }
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
