<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setAttribute("pageTitle", "관리자 게시판 관리 페이지");
%>
<jsp:include page="/WEB-INF/views/common/manage_header.jsp" />

<div class="container-fluid mt-5">
	<h2 class="mb-4">게시판 관리 대시보드</h2>
	  <h4>Q&A 게시글 목록</h4>
    <ul class="list-group" id="qna-list"></ul>
    <div class="mt-3" id="pagination"></div>
	  <h4>전체 게시글 목록</h4>
	 <ul class="list-group" id="all-list"></ul>
	 <div class="mt-3" id="all-pagination"></div>
</div>

  


 <script>
 
 function loadAllPost(page){
	 
	 $.ajax({
		    url: '/api/manage/boardAll?page=' + page + '&size=10',
		    method: 'GET',
		    success: function(res) {
		        var posts = res.posts;
		        $('#all-list').empty();
		        
		        if (!posts || posts.length === 0) {
	                $('#all-list').append(
	                    '<li class="list-group-item text-center text-muted">등록되 게시글이 없습니다..</li>'
	                );
	            } else {
		        
			        for (var i = 0; i < posts.length; i++) {
			        	
			            var post = posts[i];
			            var bgClass = post.visibility === 'private' ? 'card-header-gray' : '';

			            var toggleBtnLabel = post.visibility === 'private' ? '공개' : '비공개';
			            var toggleBtnAction = post.visibility === 'private' ? 'openPost' : 'hidePost';

			            var item = '<li class="list-group-item d-flex justify-content-between align-items-center ' + bgClass + '">'
			                     + '<a href="/detailPage.board?seq=' + post.seq + '" ><div>'
			                     + '<strong>' + post.title + '</strong><br>'
			                     + '<small class="text-muted">작성자: ' + post.writer + ' | 작성일: ' + new Date(post.created_at).toLocaleString() + '</small>'
			                     + '</div></a>'
			                     + '<span class="badge bg-secondary me-2">' + post.refgame + '</span>'
			                     + '<span class="badge bg-secondary me-2">' + post.visibility + '</span>'
			                     + '<div class="btn-group">'
			                     + '<button class="btn btn-sm btn-outline-success" onclick="' + toggleBtnAction + '(' + post.seq + ')">' + toggleBtnLabel + '</button>'
			                     + '<button class="btn btn-sm btn-outline-danger" onclick="deletePost(' + post.seq + ')">삭제</button>'
			                     + '</div>'
			                     + '</li>';
			            $('#all-list').append(item);
			        }
	            }
		        renderPaginationBlock(res.total, res.page, res.size, 'all-pagination', 'loadAllPost');

		    }
		});
 }
 
 function hidePost(boardSeq){
	 
	 if (!confirm("해당 게시글을 숨김 처리하시겠습니까?")) return;

	    $.ajax({
	        url: '/api/manage/hidePost',
	        type: 'POST',
	        data: { boardSeq: boardSeq }, 
	        success: function(response) {
	            alert("처리 완료!");
	            location.reload();
	        },
	        error: function(xhr) {
	            alert("처리 실패: " + xhr.status);
	        }
	    });
 }
 
 function openPost(boardSeq){
	 
	 if (!confirm("해당 게시글을 공개 처리하시겠습니까?")) return;

	    $.ajax({
	        url: '/api/manage/openPost',
	        type: 'POST',
	        data: { boardSeq: boardSeq }, 
	        success: function(response) {
	            alert("처리 완료!");
	            location.reload();
	        },
	        error: function(xhr) {
	            alert("처리 실패: " + xhr.status);
	        }
	    });
 }
 
 function deletePost(boardSeq){
	 if (!confirm("해당 게시글을 삭제 처리하시겠습니까?")) return;

	    $.ajax({
	        url: '/api/manage/deletePost',
	        type: 'POST',
	        data: { boardSeq: boardSeq }, 
	        success: function(response) {
	            alert("처리 완료!");
	            location.reload();
	        },
	        error: function(xhr) {
	            alert("처리 실패: " + xhr.status);
	        }
	    });
	 
 }
 
 
 function loadQnaPosts(page){
	 $.ajax({
		    url: '/api/manage/boardQnA?page=' + page + '&size=10',
		    method: 'GET',
		    success: function(res) {
		        var posts = res.posts;
		        $('#qna-list').empty();
		        
		        if (!posts || posts.length === 0) {
	                $('#qna-list').append(
	                    '<li class="list-group-item text-center text-muted">처리해야 할 Q&A가 없습니다.</li>'
	                );
	            } else {
		        
			        for (var i = 0; i < posts.length; i++) {
			            var post = posts[i];
			            var item = '<li class="list-group-item d-flex justify-content-between align-items-center">'
			                + '<a href="/detailPage.board?seq=' + post.seq + '" ><div>'
			                + '<strong>' + post.title + '</strong><br>'
			                + '<small class="text-muted">작성자: ' + post.writer + ' | 작성일: ' + new Date(post.created_at).toLocaleString() + '</small>'
			                + '</div></a>'
			                + '<span class="badge bg-secondary">' + post.refgame + '</span>'
			                + '<button class="btn btn-sm btn-outline-success ms-2" onclick="processQna(' + post.seq + ')">처리</button>'
			                + '</li>';
			            $('#qna-list').append(item);
			        }
	            }
		        renderPaginationBlock(res.total, res.page, res.size, 'pagination', 'loadQnaPosts');

		    }
		});
 }
 


 function renderPaginationBlock(totalItems, currentPage, pageSize, targetId, callbackFnName) {
	    const totalPages = Math.ceil(totalItems / pageSize);
	    const blockSize = 10;
	    const currentBlock = Math.floor((currentPage - 1) / blockSize);
	    const startPage = currentBlock * blockSize + 1;
	    const endPage = Math.min(startPage + blockSize - 1, totalPages);

	    let html = '';

	    // 이전 블록 버튼
	    if (startPage > 1) {
	        html += '<button type="button" class="btn btn-sm btn-outline-secondary me-1" onclick="' + callbackFnName + '(' + (startPage - 1) + ')">&laquo;</button>';
	    }

	    // 페이지 번호 버튼
	    for (let i = startPage; i <= endPage; i++) {
	        html += '<button type="button" class="btn btn-sm '
	              + (i === currentPage ? 'btn-purple-main' : 'btn-outline-primary')
	              + '" onclick="' + callbackFnName + '(' + i + ')">' + i + '</button> ';
	    }

	    // 다음 블록 버튼
	    if (endPage < totalPages) {
	        html += '<button type="button" class="btn btn-sm btn-outline-secondary ms-1" onclick="' + callbackFnName + '(' + (endPage + 1) + ')">&raquo;</button>';
	    }

	    $('#' + targetId).html(html);
	}
 function processQna(boardSeq) {
	 
	 console.log(boardSeq);


    if (!confirm("해당 Q&A를 처리하시겠습니까?")) return;

    $.ajax({
        url: '/api/manage/qnaprocess',
        type: 'POST',
        data: { boardSeq: boardSeq }, 
        success: function(response) {
            alert("처리 완료!");
            location.reload();
        },
        error: function(xhr) {
            alert("처리 실패: " + xhr.status);
        }
    });


 }


$(document).ready(function() {
    loadQnaPosts(1);
    loadAllPost(1);
});
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />