<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!-- JSTL 날짜 포맷 라이브러리 -->
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!-- JSTL Functions 라이브러리 -->
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<script src="https://cdn.jsdelivr.net/npm/dompurify@3/dist/purify.min.js"></script>
<!-- bootstrap icon -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.css">

<!-- Summernote cdn -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>

<!-- css -->
<link href="/css/detail.css" rel="stylesheet" />

<!-- fontawesome icon -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
    integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ=="
    crossorigin="anonymous" referrerpolicy="no-referrer" />

<!-- kakao -->
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.6/kakao.min.js"
    integrity="sha384-WAtVcQYcmTO/N+C1N+1m6Gp8qxh+3NlnP7X1U7qP6P5dQY/MsRBNTh+e1ahJrkEm"
    crossorigin="anonymous"></script>
<!-- kakao key -->
<script>
    Kakao.init('68c4c9de5864af60b8deea3885634e91');  // 사용하려는 앱의 JavaScript 키 입력
    console.log(Kakao.isInitialized());
</script>


<div class="container g-0">
    <!-- 상단 헤더 -->
    <div class="row header-board g-0">
        <!-- 뒤로가기 -->
        <div class="col-1">
            <a href="/list.board" class="back-link">
                <i class="bi bi-arrow-left"></i>
            </a>
        </div>
        <div class="col-3 d-flex justify-content-between align-items-center" id="board_category_refgame">
        	<span class="badge btn-gradient btn-yellow-green me-1">자유</span>
    		<span class="badge btn-gradient btn-red-peach">전체</span>
        </div>
        <div class="col-4" contenteditable="false" id="board_title"></div>
        <div class="col-3" id="board_created_at">
            <fmt:formatDate value="${boardDto.created_at}" pattern="yyyy-MM-dd HH:mm:ss" />
        </div>
        <div class="col-1" id="board_viewCount"></div>
    </div>
    <!-- 상단 작성자 -->
    <div class="row header-writer g-0">
        <div class="col-8 writer">
            <div class="profile">
                <!-- 프로필 이미지 -->
                <img id="writer_profile_img" class="rounded-circle me-2" width="40" height="40">
                <!-- 아이디와 칭호 -->
                <div class="d-none d-md-block text-end">
                    <div class="fw-bold text-purple" id="writer_userId"></div>
                    <div class="text-muted" id="writer_achiev"></div>
                </div>
            </div>
        </div>
        <div class="col-4 header-btns">
            <div class="left-btn">
                <!-- 공유 버튼 -->
				<button class="btn" id="share_btn" data-bs-toggle="modal" data-bs-target="#shareModal">
				    <i class="bi bi-share"></i> 공유하기
				</button>
            </div>
            <div class="right-btn">
                <button class="btn" id="report_btn" data-bs-toggle="modal" data-bs-target="#boardModal">
                    <img src="/asset/img/siren.png"> 신고하기
                </button>
            </div>
        </div>
    </div>
    <!-- 글 내용 -->
    <div class="row contents">
        <div class="col-12 content" id="board_content"></div>
        <!-- 버튼들 -->
        <div class="col-12 board_btns d-flex justify-content-center align-items-center">
        </div>
    </div>
    <div class="reply-count">댓글 ${dto.replyCount}개</div>
    <!-- 댓글 컨테이너 -->
    <div class="replies-container">
        <!-- 댓글 작성 -->
        <div class="reply-box">
            <!-- 댓글 header -->
            <div class="row reply-header g-0">
                <c:choose>
                    <c:when test="${loginId == null}">
                        <div class="col-8 reply-writer fw-bold text-navy">비회원</div>
                    </c:when>
                    <c:otherwise>
                        <div class="col-8 reply-writer fw-bold text-navy">${loginId}</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- 댓글 contents -->
            <div class="row reply-contents g-0">
                <!-- 댓글 왼쪽 content -->
                <div class="col-8 reply-left_content" id="replyInput" contenteditable="${loginId != null}">${loginId !=
                    null ? "댓글을 입력하세요" : "로그인 후
                    이용해주세요"}
                </div>
                <!-- 댓글 오른쪽 content 버튼들 -->
                <div class="col-4 reply-right-content">
                    <div class="reply-footer_btns">
                        <button class="btn btn-outline-red-main" id="reply-input_btn">
                            등록</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 댓글 출력 -->
        <div id="replyListArea"></div>
    </div>
    <!-- replies-container -->

</div>
<!-- container -->

<!-- 신고 Modal -->
<div class="modal fade" id="boardModal" tabindex="-1" aria-labelledby="boardModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="boardModalLabel">신고</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="reportFrm">
                    <p class="fw-bold mb-3">신고 사유를 선택해주세요:</p>

                    <!-- 기본 신고 사유들 -->
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportReason" id="reason1" value="괴롭힘 또는 폭력">
                        <label class="form-check-label" for="reason1">괴롭힘 또는
                            폭력</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportReason" id="reason2"
                            value="유해하거나 위험한 행위"> <label class="form-check-label" for="reason2">유해하거나
                            위험한 행위</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportReason" id="reason3"
                            value="정신 건강에 해로운 콘텐츠"> <label class="form-check-label" for="reason3">정신 건강에
                            해로운 콘텐츠</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportReason" id="reason4" value="잘못된 정보">
                        <label class="form-check-label" for="reason4">잘못된 정보</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportReason" id="reason5" value="아동 학대">
                        <label class="form-check-label" for="reason5">아동 학대</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportReason" id="reason6" value="테러 조장">
                        <label class="form-check-label" for="reason6">테러 조장</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="reportReason" id="reason7"
                            value="스팸 또는 혼동을 야기하는 콘텐츠"> <label class="form-check-label" for="reason7">스팸
                            또는 혼동을 야기하는 콘텐츠</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="reportReason" id="reason8" value="법적 문제">
                        <label class="form-check-label" for="reason8">법적 문제</label>
                    </div>

                    <!-- 기타 항목 -->
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="reportReason" id="reasonEtc" value="기타">
                        <label class="form-check-label" for="reasonEtc">기타</label>
                    </div>

                    <!-- 기타 입력창 (초기에는 숨김) -->
                    <div class="mb-3" id="etcDetailBox" style="display: none;">
                        <label for="etcDetail" class="form-label">세부 내용을 입력해주세요
                            (선택사항)</label>
                        <textarea class="form-control" id="etcBoardDetail" name="etcDetail" rows="3"
                            placeholder="세부정보 추가..."></textarea>
                        <small class="text-muted">개인 정보나 질문은 포함하지 마세요.</small>
                    </div>
                    
                    <!-- 그 외 필수 정보들 -->
                    <input type="hidden" name="board_seq" id="board_seq">
                    <input type="hidden" name="writer" id="writer">
                    <input type="hidden" name="reply_seq" id="reply_seq">
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-red-main" id="modal-boardReport_btn">신고</button>
            </div>
        </div>
    </div>
</div>

<!-- 공유 모달 -->
<div class="modal fade" id="shareModal" tabindex="-1" aria-labelledby="shareModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <!-- 모달 헤더 -->
            <div class="modal-header">
                <h5 class="modal-title" id="shareModalLabel">공유하기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>

            <!-- 모달 바디 -->
            <div class="modal-body">
                <!-- 다른 플랫폼으로 공유하기 -->
                <h6 class="mt-4">공유</h6>
                <div class="d-flex flex-wrap gap-5 justify-content-center align-items-center">
                    <!-- 카카오톡 -->
                    <a id="kakaotalk-sharing-btn" href="#" onclick="shareMessage(); return false;">
					    <img src="https://developers.kakao.com/assets/img/about/logos/kakaotalksharing/kakaotalk_sharing_btn_medium.png" alt="카카오톡 공유 보내기 버튼" width="36" />
					</a>

                    <!-- 페이스북 -->
                    <a id="facebook-sharing-btn" target="_blank" aria-label="Facebook 공유"> <img
                            src="/asset/img/facebook-icon.png" alt="Facebook" width="36">
                    </a>
                    <!-- X -->
                    <a id="x-sharing-btn" target="_blank"> <img src="/asset/img/x-icon.png" alt="Facebook"
                            width="36">
                    </a>
                </div>

                <div class="mt-4">
                    <input type="text" class="form-control" id="shareLink" value="" readonly>
                    <button class="btn btn-primary mt-2 w-100" onclick="copyLink()">복사</button>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Toast 메시지 -->
<div class="position-fixed bottom-0 start-0 p-3" style="z-index: 1055">
    <div id="copyToast" class="toast align-items-center text-white bg-success border-0" role="alert"
        aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">링크가 복사되었습니다!</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                aria-label="닫기"></button>
        </div>
    </div>
</div>

<script>
    // 사용할 전역변수 모음
    let loginId = '${loginId}';
    console.log("loginId : " + loginId);
	
    let currentTitle = '';
    let currentCategory = "";
    let currentRefgame = "";

    //문서(페이지)가 로딩 완료 됐을 때 이 코드를 실행하겠다.
    $(function () {
        // board_seq url에서 가져오기
        const params = new URLSearchParams(window.location.search);
        const board_seq = params.get("seq");
        const url = "/detail.board?seq=" + board_seq;

        // detail 값 출력
        $.ajax({
            url: url,
            method: "GET",
            dataType: "json"
        }).done(function (resp) { // board detail 값 채워주는 function
            
        	loginId = resp.loginId;
        
            // 게시글 정보
            $("#board_category_refgame").text("[ " + resp.boardDto.category + " ] | [ " + resp.boardDto.refgame + " ]");
            $("#board_title").text(resp.boardDto.title);
            $("#board_content").html(resp.boardDto.contents);
            $("#board_viewCount").text(resp.boardDto.viewCount);
			
         	// 북마크 버튼 상태 반영
            if (resp.bookmarked) {
                $("#bookmark_btn").data("bookmarked", true);
                $("#bookmark_btn").html('<i class="bi bi-bookmark-fill" style="color:#e74c3c"></i> 북마크');
            } else {
                $("#bookmark_btn").data("bookmarked", false);
                $("#bookmark_btn").html('<i class="bi bi-bookmark"></i> 북마크');
            }
         
            // 카테고리, 관련 게임 세팅
            currentCategory = resp.boardDto.category;
            currentRefgame = resp.boardDto.refgame;
            currentTitle = resp.boardDto.title;
            
            // 날짜 포맷팅
            const created_at = resp.boardDto.created_at;
            const date = new Date(created_at);
            const formatted = date.toLocaleString("ko-KR", {
                year: "numeric", month: "2-digit", day: "2-digit",
                hour: "2-digit", minute: "2-digit", second: "2-digit"
            });
            $("#board_created_at").text(formatted);
			
         	// --- 여기에서 카테고리/게임 뱃지 출력 ---
            let $badges = $("#board_category_refgame");
            $badges.empty();

            let categoryBadge = '<span class="badge btn-gradient btn-navy-blue">' + currentCategory + '</span>';
            let refgameBadge = '<span class="badge btn-gradient btn-red-peach">' + currentRefgame + '</span>';

            $badges.html(categoryBadge + refgameBadge);
            
            // 작성자 프로필
            $("#writer_profile_img").attr("src", resp.writerProfile.profileImage); // 이미지 없을 경우 대비
            $("#writer_userId").text(resp.writerProfile.userId);
            $("#writer_achiev").text(resp.writerProfile.equipedAchiev);

         // 버튼 조합
            const isWriter = loginId === resp.writerProfile.userId;
            const board_btns = $(".board_btns");
            board_btns.empty();

            if (loginId) {
                let buttons = "";

                // 공통 버튼 (좋아요 + 추천수)
                buttons += '<button class="btn btn-outline-red-main me-2 board_like_btn" data-board-id="' + board_seq + '">';
                buttons += '<i class="bi bi-heart"></i> <span class="like-count">' + resp.likeCount + '</span>';
                buttons += '</button>';

                if (isWriter) {
                    buttons += '<button class="btn btn-outline-red-main me-2" id="board-update_btn">수정</button>';
                    buttons += '<button class="btn btn-outline-red-main" id="board-delete_btn">삭제</button>';
                } else {
                    buttons += '<button class="btn btn-outline-red-main" id="bookmark_btn" data-board-id="' + board_seq + '" data-bookmarked="false">';
                    buttons += '<i class="bi bi-bookmark"></i> 북마크</button>';
                }

                board_btns.html(buttons);
            }

            // 하트 상태 반영
            let $icon = $(".board_like_btn i");
            if (resp.isLiked) {
                $icon.removeClass("bi-heart").addClass("bi-heart-fill").css("color", "#e74c3c");
            } else {
                $icon.removeClass("bi-heart-fill").addClass("bi-heart").css("color", "");
            }
            
			// 댓글 개수 표시
            $(".reply-count").text("댓글 " + resp.replyCount + "개");

            // 댓글 렌더링
            renderReplies(resp.repliesList);
        });

        // - 글 삭제
		$(document).on('click', '#board-delete_btn', function () {
		    if (!confirm('정말 삭제하시겠습니까?')) {
		        return;
		    }
		
		    $.ajax({
		        url: '/delete.board',
		        method: 'POST',
		        dataType: 'json',
		        data: {
		            board_seq: board_seq
		        }
		    }).done(function (resp) {
		        if (resp.result != 0) {
		            alert('게시글이 삭제되었습니다.');
		            // 삭제 후 목록 페이지로 이동 (예: list.board)
		            window.location.href = '/list.board';
		        } else {
		            alert('삭제 실패');
		        }
		    }).fail(function () {
		        alert('서버와 통신 중 오류가 발생했습니다.');
		    });
		});


        // 본글 수정 버튼 클릭
        $(document).on('click', '#board-update_btn', function () {
        	// 원본 글 제목
            const titleDiv = $('#board_title');
            const originalTitle = titleDiv.text();
            
        	// 원본 글 내용
            const contentDiv = $('#board_content');
            const originalContent = contentDiv.html(); 
            
         	// 제목 contenteditable 활성화
			titleDiv.attr('contenteditable', 'true');

			const el = titleDiv[0];
			const range = document.createRange();
			const sel = window.getSelection();
			
			range.selectNodeContents(el);
			range.collapse(false); // 끝에 커서 두기
			sel.removeAllRanges();
			sel.addRange(range);
			el.focus();

            // 이미 summernote 켜져 있으면 중복 실행 방지
            if ($('#summernote').length > 0) return;

            // div 비우고 id 변경
            contentDiv.empty().attr('id', 'summernote');

            // 상단 공유하기, 신고하기 버튼 교체 -> select로
            $('.header-btns').html(
                '<div class="row g-3 align-items-end w-100 mt-2">' +
                '<div class="col-6">' +
                '<label for="category" class="form-label">카테고리</label>' +
                '<select id="category" name="category" class="form-select">' +
                '<option value="자유">자유</option>' +
                '<option value="공략">공략</option>' +
                '<option value="기타">기타</option>' +
                '<option value="Q&A">Q&A</option>' +
                '</select>' +
                '</div>' +
                '<div class="col-6">' +
                '<label for="refgame" class="form-label">관련 게임</label>' +
                '<select id="refgame" name="refgame" class="form-select">' +
                '<option value="">선택</option>' +
                '<option value="Game A">Game A</option>' +
                '<option value="Game B">Game B</option>' +
                '<option value="Game C">Game C</option>' +
                '</select>' +
                '</div>' +
                '</div>'
            );

            // select 기존 값 기본 세팅 (resp.boardDto 값 사용)
            $('#category').val(currentCategory);
            $('#refgame').val(currentRefgame);

            // 높이 계산
            let contentsHeight = $('.contents').height();

            // summernote 실행
            $('#summernote').summernote({
                placeholder: '내용을 작성하세요.',
                tabsize: 2,
                height: contentsHeight,
                disableResizeEditor: true,
                fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', '맑은 고딕', '궁서', '굴림체', '굴림', '돋움체', '바탕체'],
                fontSizes: ['8', '9', '10', '11', '12', '14', '16', '18', '20', '22', '24', '28', '30', '36', '50', '72'],
                lang: 'ko-KR',
                toolbar: [
                    ['style', ['bold', 'italic', 'underline', 'clear']],
                    ['font', ['fontname', 'fontsize', 'strikethrough', 'superscript', 'subscript']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['insert', ['link', 'picture', 'video']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ],
                callbacks: {
                    onImageUpload: function (files) {
                        for (var i = 0; i < files.length; i++) {
                            uploadImage(files[i]);
                        }
                    },
                    onDrop: function (e) {
                        e.preventDefault();
                        var dataTransfer = e.originalEvent.dataTransfer;
                        if (dataTransfer && dataTransfer.files.length) {
                            for (var i = 0; i < dataTransfer.files.length; i++) {
                                uploadImage(dataTransfer.files[i]);
                            }
                        }
                    }
                }
            });

            // 툴바 높이 반영해서 본문 높이 조정
            let toolbarHeight = $('.note-toolbar').outerHeight(true);
            let editableHeight = contentsHeight - toolbarHeight;
            $('.note-editable').css('height', editableHeight + 'px');
            $('.note-resize').css('display', 'none');

            // 원본 내용을 에디터 안으로 넣기
            $('#summernote').summernote('code', originalContent);

            // 버튼 교체
            const boardBtns = $('.board_btns');
            boardBtns.html(
                '<button class="btn btn-outline-red-main me-2" id="board-save_btn">저장</button>' +
                '<button class="btn btn-outline-secondary" id="board-cancel_btn">취소</button>'
            );

            // 본글 수정 - 취소 버튼
            $(document).off('click', '#board-cancel_btn').on('click', '#board-cancel_btn', function () {
                // id 바꿔치기 + 썸머노트 종료
            	$('#summernote').summernote('destroy');
                $('#summernote').attr('id', 'board_content').html(originalContent);
				
             	// 제목 원복 (중요!)
                $('#board_title').text(originalTitle).attr('contenteditable', 'false');

                // header-btns ( 공유, 신고 버튼 복구 )
                $('.header-btns').html(
                    '<div class="left-btn">' +
                    '<button class="btn" id="share_btn" data-bs-toggle="modal" data-bs-target="#shareModal">' +
                    '<i class="bi bi-share"></i> 공유하기' +
                    '</button>' +
                    '</div>' +
                    '<div class="right-btn">' +
                    '<button class="btn" id="report_btn" data-bs-toggle="modal" data-bs-target="#boardModal">' +
                    '<img src="/asset/img/siren.png"> 신고하기' +
                    '</button>' +
                    '</div>'
                );

	             // ( 추천수, 수정, 삭제 버튼 복구 )
	             // 기존 추천수 유지 (resp.likeCount 활용)
	             boardBtns.html(
	                 '<button class="btn btn-outline-red-main me-2 board_like_btn" data-board-id="' + board_seq + '">' +
	                     '<i class="bi bi-heart"></i> <span class="like-count"></span>' +
	                 '</button>' +
	                 '<button class="btn btn-outline-red-main me-2" id="board-update_btn">수정</button>' +
	                 '<button class="btn btn-outline-red-main" id="board-delete_btn">삭제</button>'
	             );

	          	// ⭐ 최신 추천수 반영
	            checkBoardLikeStatus(board_seq);
            });

            // 본글 수정 - 저장 버튼
            $(document).off('click', '#board-save_btn').on('click', '#board-save_btn', function () {
            	const updatedTitle = titleDiv.text();
            	const updatedContent = $('#summernote').summernote('code');
            	let updatedCategory = $('#category').val();
            	let updatedRefgame = $('#refgame').val();
	            
            	// 유효성 검사
            	if (updatedTitle === '') {    
	                alert('제목을 입력하세요.');
	                titleDiv.focus();
	                return;
	            }
	            if (updatedContent === '' || updatedContent === '<p><br></p>') {
	                alert('내용을 입력하세요.');
	                $('#summernote').summernote('focus');
	                return;
	            }
	            if (!updatedRefgame || updatedRefgame === '') {
	            	updatedRefgame = '전체';
	            }
	            if (!updatedCategory || updatedCategory === '') {
	                updatedCategory = '자유'; // 기본값
	            }
            
                $.ajax({
                    url: '/update.board',
                    method: 'POST',
                    dataType: 'json',
                    data: {
                    	board_seq: board_seq,
                    	title: updatedTitle,
                        contents: updatedContent,
                        category: updatedCategory,
                        refgame: updatedRefgame
                    }
                }).done(function (resp) {
                    if (resp.result != 0) {
						// id 복구
                        $('#summernote').summernote('destroy');
                        $('#summernote').attr('id', 'board_content').html(updatedContent);
						
                     	// 제목 수정 종료
                        titleDiv.text(updatedTitle).attr('contenteditable', 'false');
                     
                        // ( 공유, 신고 버튼 ) header-btns 원상복구
                        $('.header-btns').html(
                            '<div class="left-btn">' +
                            '<button class="btn" id="share_btn" data-bs-toggle="modal" data-bs-target="#shareModal">' +
                            '<i class="bi bi-share"></i> 공유하기' +
                            '</button>' +
                            '</div>' +
                            '<div class="right-btn">' +
                            '<button class="btn" id="report_btn" data-bs-toggle="modal" data-bs-target="#boardModal">' +
                            '<img src="/asset/img/siren.png"> 신고하기' +
                            '</button>' +
                            '</div>'
                        );

                     	// ( 추천수, 수정, 삭제 버튼 복구 )
                     	// 기존 추천수 유지 (resp.likeCount 활용)
                     	boardBtns.html(
	                         '<button class="btn btn-outline-red-main me-2 board_like_btn" data-board-id="' + board_seq + '">' +
	                             '<i class="bi bi-heart"></i> <span class="like-count"></span>' +
	                         '</button>' +
	                         '<button class="btn btn-outline-red-main me-2" id="board-update_btn">수정</button>' +
	                         '<button class="btn btn-outline-red-main" id="board-delete_btn">삭제</button>'
                     	);
						
                     	// ⭐ 최신 추천수 반영
                        checkBoardLikeStatus(board_seq);
                    } else {
                        alert('수정 실패');
                    }
                }).fail(function () {
                    alert('서버와 통신 중 오류가 발생했습니다.');
                });
            });
        });

        // ----------------- 댓글
        // 부모 댓글 입력창 placeholder 효과
        $(document).on("focus", "#replyInput", function () {
            if ($(this).text().trim() === "댓글을 입력하세요") {
                $(this).text("");
            }
        });

        $(document).on("blur", "#replyInput", function () {
            if ($(this).text().trim() === "") {
                $(this).text("댓글을 입력하세요");
            }
        });

        // 부모 댓글 등록 버튼 클릭 시
        $(document).on("click", "#reply-input_btn", function () {
            const parent_seq = $(this).data("parent-seq") || 0;
            const reply_content = $("#replyInput").text().trim();

            // 로그인 안 된 경우
            if (!loginId) {
                alert("로그인 후 이용해주세요.");
                return;
            }

            // 내용이 비어있거나 안내 문구 그대로면 막기
            if (!reply_content || reply_content === "댓글을 입력하세요" || reply_content === "로그인 후 이용해주세요") {
                alert("내용을 입력하세요!");
                $("#replyInput").focus();
                return;
            }

            $.ajax({
                url: "/insert.reply",
                method: "POST",
                dataType: "json", // 서버 응답이 JSON이면 꼭 넣어줘야 함
                data: {
                    writer: loginId,
                    contents: reply_content,
                    board_seq: board_seq,
                    parent_seq: parent_seq
                }
            }).done(function (resp) {
                if (resp.result != 0) {
                    // 댓글 다시 렌더링
                    renderReplies(resp.replies);
                    // 댓글 개수 갱신
                    $(".reply-count").text("댓글 " + resp.replyCount + "개");
                    $("#replyInput").text("댓글을 입력하세요"); // 입력창 초기화 + 안내문구 복원
                } else {
                    alert("댓글 등록 실패");
                }
            }).fail(function () {
                alert("서버와 통신 중 오류가 발생했습니다.");
            });
        });



        // 답글 더보기/접기 토글 이벤트
        $(document).on('click', '.reply-more-btn', function () {
            let $btn = $(this);
            let targetId = $btn.data('target');
            let count = parseInt($btn.data('count'), 10) || 0;
            let expanded = $btn.attr('data-expanded') === 'true';
            let $target = $('#' + targetId);

            if (expanded) {
                // 접기
                $target.slideUp(150);
                $btn.attr('data-expanded', 'false');
                $btn.html('<span class="icon">▼</span> 답글 ' + count + '개 더보기');
            } else {
                // 펼치기
                $target.slideDown(150);
                $btn.attr('data-expanded', 'true');
                $btn.html('<span class="icon">▲</span> 답글 접기');
            }
        });


        // 답글 버튼 클릭시
        $(document).on("click", ".subReply-input_btn", function () {
            const parentSeq = $(this).data("parent-seq");
            const parentWriter = $(this).data("writer");

            // 답글 입력창 띄우기
            showreplyInputDiv(this, parentSeq, parentWriter);
        });

        // 답글 입력창 포커스 / 입력 처리
        $(document).on("focus", "#replyInputDiv", function () {
            const text = $(this).text().trim();
            if (text === "답글을 입력하세요" || text === "로그인 후 이용해주세요") {
                $(this).text(""); // 안내 문구 제거
            }
        });

        // 포커스가 빠졌을 때 아무것도 입력 안 하면 다시 안내 문구 복원
        $(document).on("blur", "#replyInputDiv", function () {
            const text = $(this).text().trim();
            if (text === "") {
                const isLoggedIn = loginId && loginId.trim() !== "";
                $(this).text(isLoggedIn ? "답글을 입력하세요" : "로그인 후 이용해주세요");
            }
        });

        // 답글 - 등록 버튼 클릭
        $(document).on("click", ".reply-submit_btn", function () {
            const parent_seq = $(this).data("parent-seq"); // 부모 댓글 번호
            const reply_content = $("#replyInputDiv").text().trim();

            // 로그인 여부 확인
            if (!loginId || loginId.trim() === "") {
                alert("로그인 후 이용해주세요.");
                return;
            }

            // 답글 내용 있는지 확인
            if (!reply_content || reply_content === "답글을 입력하세요" || reply_content === "로그인 후 이용해주세요") {
                alert("내용을 입력하세요!");
                return;
            }

            $.ajax({
                url: "/insert.reply",
                method: "POST",
                dataType: "json",
                data: {
                    writer: loginId,
                    contents: reply_content,
                    board_seq: board_seq,
                    parent_seq: parent_seq
                }
            }).done(function (resp) {
                if (resp.result != 0) {
                    renderReplies(resp.replies);  // 댓글 새로 렌더링
                    $(".subReplyBox").remove(); // 입력창 닫기
                } else {
                    alert("댓글 등록 실패");
                }
            }).fail(function () {
                alert("서버와 통신 중 오류가 발생했습니다.");
            });
        });



        // 답글 - 취소 버튼 클릭
        $(document).on("click", ".reply-cancel_btn", function () {
            $(this).closest(".subReplyBox").remove();
        });


     // 댓글 추천 버튼 클릭 시
        $(document).on("click", ".reply-like_btn", function () {
            const $btn = $(this);
            const reply_seq = $btn.data("reply-seq");
            const icon = $btn.find("i");

            $.ajax({
                url: "/like/toggle.reply",
                method: "POST",
                dataType: "json",
                data: { reply_seq: reply_seq }
            }).done(function (resp) {
                if (resp.success) {
                    // 아이콘 상태 갱신
                    if (resp.action === "insert") {
                        icon.removeClass("bi-heart").addClass("bi-heart-fill").css("color", "#e74c3c");
                    } else {
                        icon.removeClass("bi-heart-fill").addClass("bi-heart").css("color", "");
                    }

                    // 버튼 텍스트에 추천 수 반영
                    $btn.contents().last()[0].textContent = " " + resp.likeCount;
                } else {
                    alert("추천 처리 실패");
                }
            }).fail(function () {
                alert("서버 오류 발생");
            });
        });

        // 댓글 삭제 버튼 클릭
        $(document).on("click", ".reply-delete_btn", function () {
            const reply_seq = $(this).data("reply-seq");

            if (!confirm("정말 삭제하시겠습니까?")) return;

            $.ajax({
                url: "/delete.reply",
                method: "POST",
                dataType: "json",
                data: { reply_seq: reply_seq }
            }).done(function (resp) {
                if (resp.result != 0) {
                    // 댓글 다시 렌더링
                    renderReplies(resp.replies);
                    // 댓글 개수 갱신
                    $(".reply-count").text("댓글 " + resp.replyCount + "개");
                } else {
                    alert("댓글 삭제 실패");
                }
            }).fail(function () {
                alert("서버와 통신 중 오류가 발생했습니다.");
            });
        });

        // 댓글 수정 버튼 클릭
        $(document).on("click", ".reply-update_btn", function () {
            const replyBox = $(this).closest(".reply-box");
            const reply_seq = $(this).data("reply-seq");
            const replyContentDiv = replyBox.find(".reply-left_content");
            const originalText = replyContentDiv.text().trim();

            // 이미 수정 모드면 무시
            if (replyBox.find(".reply-save_btn").length > 0) return;

            // 수정 가능하게 변경
            replyContentDiv.attr("contenteditable", "true").focus();

            // 버튼 영역 교체
            let btnArea = replyBox.find(".reply-header_btns");
            btnArea.data("backup", btnArea.html()); // 원래 버튼 백업
            btnArea.html(
                '<button class="btn btn-outline-red-main reply-save_btn" data-reply-seq="' + reply_seq + '">저장</button>' +
                '<button class="btn btn-outline-secondary reply-cancelEdit_btn" data-reply-seq="' + reply_seq + '">취소</button>'
            );

            // 댓글 수정 - 취소 버튼 누르면 원상 복구
            $(document).on("click", ".reply-cancelEdit_btn", function () {
                replyContentDiv.attr("contenteditable", "false").text(originalText);
                btnArea.html(btnArea.data("backup"));
            });
        });

        // 댓글 수정 - 저장 버튼 클릭 → update.reply 요청
        $(document).on("click", ".reply-save_btn", function () {
            const replyBox = $(this).closest(".reply-box");
            const reply_seq = $(this).data("reply-seq");
            const replyContentDiv = replyBox.find(".reply-left_content");
            const newText = replyContentDiv.text().trim();

            if (!newText) {
                alert("내용을 입력하세요!");
                return;
            }

            $.ajax({
                url: "/update.reply",
                method: "POST",
                dataType: "json",
                data: {
                    reply_seq: reply_seq,
                    contents: newText
                }
            }).done(function (resp) {
                if (resp.result != 0) {
                    // 댓글 다시 렌더링
                    renderReplies(resp.replies);
                    // 댓글 개수 갱신
                    $(".reply-count").text("댓글 " + resp.replyCount + "개");
                } else {
                    alert("댓글 수정 실패");
                }
            }).fail(function () {
                alert("서버와 통신 중 오류가 발생했습니다.");
            });
        });


        // ----------------- 버튼들 클릭시
        // 글 추천 버튼 클릭시
		$(document).on("click", ".board_like_btn", function () {
		    const btn = $(this);
		    const icon = btn.find("i");
		    const board_seq = btn.data("board-id");

	    // 즉시 토글 효과 (사용자 경험 ↑)
	    icon.toggleClass("bi-heart bi-heart-fill");
	    icon.css("color", icon.hasClass("bi-heart-fill") ? "#e74c3c" : "");
	
	    // 서버에 추천 요청 보내기
	    $.ajax({
	        url: "/like/toggle.board",
	        method: "POST",
	        dataType: "json",
	        data: { board_seq: board_seq }
		    }).done(function (resp) {
		        if (resp.success) {
		            // 서버 응답에 맞춰 최종 보정
		            if (resp.action === "insert") {
		                icon.removeClass("bi-heart").addClass("bi-heart-fill").css("color", "#e74c3c");
		            } else if (resp.action === "delete") {
		                icon.removeClass("bi-heart-fill").addClass("bi-heart").css("color", "");
		            }
		
		            // 추천수 갱신
		            if (typeof resp.likeCount !== "undefined") {
		                btn.html('<i class="' + icon.attr("class") + '" style="' + icon.attr("style") + '"></i> ' + resp.likeCount);
		            }
		        } else {
		            alert("추천 처리 실패");
		        }
		    }).fail(function () {
		        alert("서버 오류로 추천 처리에 실패했습니다.");
		    });
		});

		
     	// ----------------- 북마크 관련   
     	// 북마크 버튼 클릭
		$(document).on("click", "#bookmark_btn", function () {
		    const btn = $(this);
		    const icon = btn.find("i");
		    
		    const board_seq = btn.data("board-id");
		
		    $.ajax({
		        url: "/api/bookmark/toggle",
		        type: "POST",
		        data: { board_seq: board_seq },
		        dataType: "json"
		    }).done(function (resp) {
		        if (resp.success) {
		            if (resp.action === "insert") {
		                btn.addClass("active")
		                   .data("bookmarked", true) // ✅ 상태 업데이트
		                   .html('<i class="bi bi-bookmark-fill"></i> 북마크 해제');
		            } else {
		                btn.removeClass("active")
		                   .data("bookmarked", false) // ✅ 상태 업데이트
		                   .html('<i class="bi bi-bookmark"></i> 북마크');
		            }
		        } else {
		            alert("북마크 처리 실패!");
		        }
		    }).fail(function () {
		        alert("서버 오류 발생");
		    });
		});


        // ----------------- 공유하기 관련
        // 공유하기 버튼 클릭시
        $("#share_btn").on("click", function () {
            // 아이콘 색 변경
            const icon = $(this).find("i");
            icon.toggleClass("bi-share bi-share-fill share-active");

            // 0.2초 후에 아이콘 색 변경 클래스 제거
            setTimeout(function () {
                icon.toggleClass("bi-share bi-share-fill share-active");
            }, 200); // 1000ms = 1초
        });

     	// 페이스북, X(Twitter) 공유하기
        let currentUrl = window.location.href;
    let pageTitle = $('#board_title').html() || '공유 게시물';

 	// Facebook
    $('#facebook-sharing-btn').on('click', function (e) {
        e.preventDefault();
        let encoded_fb = encodeURIComponent(currentUrl);
        window.open(
            'https://www.facebook.com/sharer/sharer.php?u=' + encoded_fb,
            '_blank'
        );
    });

    // Twitter (X)
    $('#x-sharing-btn').on('click', function (e) {
        e.preventDefault();
        let xText = encodeURIComponent(pageTitle + ' - ' + currentUrl);
        window.open(
            'https://twitter.com/intent/tweet?text=' + xText,
            '_blank'
        );
    });

    // 복사하기 버튼 위에 현재 페이지 링크 넣기
    $("#shareLink").val(currentUrl);

     	// 공유 모달이 열릴 때 이벤트
        $('#shareModal').on('show.bs.modal', function () {
            // 현재 페이지 URL 가져오기
            let currentUrl = window.location.href;

            // input value에 넣기
            $('#shareLink').val(currentUrl);
        });


        // ----------------- 신고하기 관련
        // 게시글 신고 버튼 클릭 → 모달 hidden input 채우기
	    $("#report_btn").on("click", function () {
	        $("#writer").val($("#boardWriter").text().trim());
	    });

	    // 기타 선택 시 입력창 표시
	    $(document).on("change", "input[name='reportReason']", function () {
	        if ($(this).val() === "기타") {
	            $("#boardEtcDetailBox").show();
	        } else {
	            $("#boardEtcDetailBox").hide();
	        }
	    });
	
	 	// 게시글 신고 제출 버튼 클릭 → Ajax
	    $("#modal-boardReport_btn").on("click", function () {
	        const reason = $("input[name='reportReason']:checked").val();
	        const etcDetail = $("#etcBoardDetail").val();
	        const writer = $("#writer").val(); // 작성자 가져오기

	        if (!reason) {
	            alert("신고 사유를 선택해주세요.");
	            return;
	        }

	        $.ajax({
	            url: "/report/submit/board",
	            type: "POST",
	            data: {
	                board_seq: board_seq,
	                writer: writer,
	                reason: reason,
	                etcDetail: etcDetail
	            },
	           
	        }).done(function (resp) {
	            if (resp.result) {
	                alert("게시글 신고가 접수되었습니다.");
	                $("#boardModal").modal("hide");
	            } else {
	                alert("신고 처리 실패. 다시 시도해주세요.");
	            }
	        }).fail(function () {
	            alert("서버와 통신 중 오류가 발생했습니다.");
	        });
	    });
        
     	// 댓글 신고
        // 신고 버튼 눌렀을 때 → 모달에 reply_seq, writer, board_seq 채우기
		$(document).on("click", ".reply-report_btn", function () {
			const replyBox = $(this).closest(".reply-box");
			 
			const replySeq = $(this).data("reply-seq");
		    const replyWriter = $(this).closest(".reply-box").find(".reply-writer").text().trim();
		    
		    $("#reply_seq").val(replySeq);
		    $("#board_seq").val(board_seq);
		    $("#writer").val(replyWriter);
		    
		    
		});

		// 댓글 신고 제출 버튼 클릭 → Ajax 전송
		$(document).on("click", "#modal-report_btn", function () {
		    const reply_seq = $("#reply_seq").val();
		    const replyWriter = $(this).closest(".reply-box").find(".reply-writer").text().trim();
		    const writer = $("#writer").val();
		    const reason = $("input[name='reportReason']:checked").val();
		    const etcDetail = $("#etcDetail").val();
		
		    if (!reason) {
		        alert("신고 사유를 선택해주세요.");
		        return;
		    }
		
		    $.ajax({
		        url: "/report/submit/reply",
		        type: "POST",
		        data: {
		            reply_seq: reply_seq,
		            board_seq: board_seq,
		            writer:writer,
		            reason: reason,
		            etcDetail: etcDetail
		        },
		        dataType: "json"
		    }).done(function (resp) {
		        if (resp.result) {
		            alert("댓글 신고가 접수되었습니다.");
		            $("#boardModal").modal("hide");
		        } else {
		            alert("신고 처리 실패. 다시 시도해주세요.");
		        }
		    }).fail(function () {
		        alert("서버와 통신 중 오류가 발생했습니다.");
		    });
		});
    
        // 신고하기 - 기타 선택 시 입력창 띄우기
        $(document).on("change", 'input[name="reportReason"]', function () {
            if ($(this).attr('id') === 'reasonEtc') {
                $('#etcDetailBox').show();
            } else {
                $('#etcDetailBox').hide();
            }
        });
        
    }); // $(function(){});
    
    // ===== 댓글 전체 렌더링 =====
    function renderReplies(replies) {
        let replyListArea = $('#replyListArea');
        replyListArea.empty();

        // 부모들 최신순
        let parents = replies.filter(r => r.parent_seq === 0);
        parents.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));

        parents.forEach(function (parent) {
            // 부모 출력
            replyListArea.append(drawReply(parent, 1, false, replies));

            // 부모의 자식 그룹 렌더링
            renderChildrenGroup(replies, parent.seq, 2, replyListArea);
        
         	// 부모 댓글 좋아요 상태 체크
            checkReplyLikeStatus(parent.seq);
        });
        
     	// (안전망) 전부 렌더 후 한 번 더 일괄 체크
        setTimeout(() => {
            $('.reply-like_btn').each(function () {
                const seq = $(this).data('reply-seq');
                checkReplyLikeStatus(seq);
            });
        }, 0);
    }

    // 특정 parentSeq 아래 모든 자식 개수 구하기
    function countAllDescendants(replies, parentSeq) {
        let count = 0;
        let stack = [parentSeq];
        while (stack.length > 0) {
            let current = stack.pop();
            let children = replies.filter(r => r.parent_seq === current);
            count += children.length;
            children.forEach(c => stack.push(c.seq));
        }
        return count;
    }

    // ===== 자식 "묶음" 렌더링 =====
    function renderChildrenGroup(replies, parentSeq, depth, container) {
        
    	if (!container || !container.find) {
            console.error("renderChildrenGroup: container가 유효하지 않음", container);
            return;
        }
    	
    	let children = replies.filter(r => r.parent_seq === parentSeq);
        children.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));

        if (children.length === 0) return;

        let groupId = 'children-group-' + parentSeq;
        let groupHtml = '<div class="children-group" id="' + groupId + '"></div>';
        container.append(groupHtml);

        let $group = $('#' + groupId);

        children.forEach(child => {
            // 댓글 HTML 그리기
            $group.append(drawReply(child, depth, false, replies));

            // 자식 댓글 좋아요 상태 체크
            checkReplyLikeStatus(child.seq);

            // 재귀 호출로 손자/증손 댓글까지 처리
            renderChildrenGroup(replies, child.seq, depth + 1, $group);
        });

        // "답글 n개 더보기"
        let allDescendantsCount = countAllDescendants(replies, parentSeq);

        if (allDescendantsCount >= 3) {
            $group.hide();

            // 버튼을 따로 만드는 대신 부모 footer 영역에 같이 출력되도록
            let moreBtnHtml =
                '<button class="btn btn-link text-navy small reply-more-btn" ' +
                'data-target="' + groupId + '" data-count="' + allDescendantsCount + '" data-expanded="false">' +
                '답글 ' + allDescendantsCount + '개 더보기 <span class="icon">▼</span>' +
                '</button>';

            // 부모 댓글 박스의 footer에 버튼 추가
            let parentBox = container.find('.reply-box[data-reply-seq="' + parentSeq + '"]');
            parentBox.find('.reply-footer .reply-footer-left').append(moreBtnHtml);
        }
    }

    // ===== 댓글 박스 HTML =====
    function drawReply(reply, depth, hidden = false, replies) {
        let isWriter = loginId === reply.writer;

        let mention = '';
        if (depth >= 3) {
            let parent = replies.find(r => r.seq === reply.parent_seq);
            if (parent) {
                mention = '<span class="mention text-green">@' + parent.writer + '</span> ';
            }
        }

        let created_at = new Date(reply.created_at);
        let formatted = created_at.toLocaleString('ko-KR', {
            year: 'numeric', month: '2-digit', day: '2-digit',
            hour: '2-digit', minute: '2-digit', second: '2-digit'
        });

        let likeCount = isNaN(parseInt(reply.likeCount)) ? 0 : reply.likeCount;
		
     	// 처음에는 무조건 빈 하트
        let likeIcon = "bi-heart";
        
        // 작성자 일 때 수정, 삭제 버튼
        let controlBtns = '';
        if (isWriter) {
            controlBtns += '<button class="btn btn-outline-red-main reply-update_btn" data-reply-seq="' + reply.seq + '">수정</button>';
            controlBtns += '<button class="btn btn-outline-red-main reply-delete_btn" data-reply-seq="' + reply.seq + '">삭제</button>';
        }
		
     	// 신고 버튼은 작성자가 아닐 때만 표시
        let reportBtn = '';
        if (!isWriter) {
            reportBtn =
                '<button class="btn btn-outline-red-main reply-report_btn" data-bs-toggle="modal" data-bs-target="#boardModal" data-reply-seq="' + reply.seq + '">' +
                '<img src="/asset/img/siren.png" style="width:16px; height:16px;">' +
                '</button>';
        }
        
        let inputBtn = '<button class="btn btn-outline-red-main subReply-input_btn" data-reply-seq="' + reply.seq + '" data-parent-seq="' + reply.seq + '" data-writer="' + reply.writer + '">답글</button>';

        let style = '';
        if (depth >= 2) {
            style = 'width: calc(100% - 60px); margin-left: auto;';
        }

        let hiddenClass = hidden ? ' d-none' : '';

        let replyHtml =
            '<div class="reply-box mb-2' + hiddenClass + '" data-depth="' + depth + '" data-reply-seq="' + reply.seq + '" style="' + style + '">' +
            '<div class="row reply-header g-0">' +
            '<div class="col-8 reply-writer fw-bold text-navy">' +
            mention + reply.writer +
            '</div>' +
            '<div class="col-4 reply-header_btns text-end">' +
            '<button class="btn btn-outline-red-main reply-like_btn" data-reply-seq="' + reply.seq + '">' +
            '<i class="bi ' + likeIcon + '"></i> ' + likeCount +
            '</button>' +
            reportBtn +
            controlBtns +
            '</div>' +
            '</div>' +
            '<div class="row reply-contents g-0 mt-1">' +
            '<div class="col-8 reply-left_content" contenteditable="false">' +
            reply.contents +
            '</div>' +
            '<div class="col-4 reply-right-content text-end">' +
            inputBtn +
            '</div>' +
            '</div>' +
            '<div class="row reply-footer g-0 justify-content-between align-items-center mt-1">' +
            '<div class="col-auto reply-footer-left"></div>' +
            '<div class="col-auto reply-footer-right text-muted small">' + formatted + '</div>' +
            '</div>' +
            '</div>';

        return replyHtml;
    }
	
    // like 추천한 글인지 확인하는 함수
    function checkBoardLikeStatus(board_seq) {
    $.ajax({
        url: "/isLiked.board",
        method: "GET",
        data: { board_seq: board_seq },
        dataType: "json"
    }).done(function(resp) {
        let button = $(".board_like_btn[data-board-id='" + board_seq + "']");

        if (!button || button.length === 0) {
            console.warn("board_like_btn 버튼을 못 찾음. board_seq:", board_seq);
            return;
        }

        let icon = button.find("i");
        let count = button.find(".like-count");

        if (resp.isLiked) {
            icon.removeClass("bi-heart").addClass("bi-heart-fill").css("color", "#e74c3c");
        } else {
            icon.removeClass("bi-heart-fill").addClass("bi-heart").css("color", "");
        }

        // 추천수 업데이트
        count.text(resp.likeCount);

    }).fail(function(xhr) {
        console.error("isLiked 체크 실패:", xhr);
    });
}
	
 	// 댓글 추천 상태 확인 함수
    function checkReplyLikeStatus(reply_seq) {
        $.ajax({
            url: "/isLiked.reply",   // ← 서버에서 댓글 좋아요 상태 확인용 API 필요
            method: "GET",
            data: { reply_seq: reply_seq },
            dataType: "json"
        }).done(function(resp) {
            let button = $(".reply-like_btn[data-reply-seq='" + reply_seq + "']");

            if (!button || button.length === 0) {
                console.warn("reply-like_btn 버튼을 못 찾음. reply_seq:", reply_seq);
                return;
            }

            let icon = button.find("i");

            if (resp.isLiked) {
                icon.removeClass("bi-heart").addClass("bi-heart-fill").css("color", "#e74c3c");
            } else {
                icon.removeClass("bi-heart-fill").addClass("bi-heart").css("color", "");
            }

            // 추천수 업데이트
            button.find(".like-count").text(resp.likeCount);

        }).fail(function(xhr) {
            console.error("isLiked.reply 체크 실패:", xhr);
        });
    }

    
    function appendReply(reply, depth, hidden, replies) {
        let replyHtml = drawReply(reply, depth, hidden, replies);
        $("#reply-container").append(replyHtml);

        // 추가된 요소에서 버튼 찾아서 좋아요 상태 확인
        let button = $("#reply-container .reply-box[data-reply-seq='" + reply.seq + "'] .reply-like_btn");
        checkReplyLikeStatus(reply.seq, button);
    }

	// 부모 시퀀스끼리 그룹화
    function groupByParent(replies) {
        const grouped = {};
        replies.forEach(reply => {
            const parent = reply.parent_seq;
            if (!grouped[parent]) grouped[parent] = [];
            grouped[parent].push(reply);
        });
        return grouped;
    }
	
    // 답글 입력창 띄우는 함수
    function showreplyInputDiv(button, parentSeq, parentWriter) {
        // 기존 열려있는 입력창 제거
        $('.subReplyBox').remove();

        var isLoggedIn = loginId && loginId.trim() !== "";

        var replyInputHtml = ''
            + '<div class="subReplyBox reply-box mb-3" style="width: calc(100% - 60px); margin-left:auto;">'
            + '    <div class="row reply-header g-0">'
            + '        <div class="col-8 reply-writer fw-bold text-navy">'
            + (isLoggedIn ? loginId : '비회원')
            + '        </div>'
            + '        <div class="col-4 text-end text-muted small">'
            + '            → ' + parentWriter + ' 님께 답글'
            + '        </div>'
            + '    </div>'
            + '    <div class="row reply-contents g-0 mt-2">'
            + '        <div class="col-12 reply-left_content" '
            + '             id="replyInputDiv" '
            + '             contenteditable="' + isLoggedIn + '">'
            + (isLoggedIn ? '답글을 입력하세요' : '로그인 후 이용해주세요')
            + '        </div>'
            + '    </div>'
            + '    <div class="row mt-2">'
            + '        <div class="col text-end">'
            + '            <button class="btn btn-outline-red-main reply-submit_btn" '
            + '                    data-parent-seq="' + parentSeq + '">등록</button>'
            + '            <button class="btn btn-outline-secondary reply-cancel_btn">취소</button>'
            + '        </div>'
            + '    </div>'
            + '</div>';

        // 버튼 기준으로 가장 가까운 .reply-box 찾아서 바로 뒤에 삽입
        let parentReplyBox = $(button).closest('.reply-box');
        parentReplyBox.after(replyInputHtml);

        // 포커스
        if (isLoggedIn) {
            $('#replyInputDiv').focus();
        }
    }
    
 	// kakao 공유하기
    function shareMessage() {
        // board_content 가져오기
        let content = $("#board_title").html();

        // 현재 페이지 URL 가져오기
        let currentUrl = window.location.href;
        Kakao.Share.sendDefault({
            objectType: 'text',
            text: content,
            link: {
                mobileWebUrl: currentUrl,
                webUrl: currentUrl,
            },
        });
    };
    
 	// 공유 - 복사 함수
    function copyLink() {
	    let copyText = document.getElementById("shareLink").value;
	    navigator.clipboard.writeText(copyText).then(() => {
	        alert("링크가 복사되었습니다!");
	    }).catch(err => {
	        console.error("복사 실패:", err);
	    });
	}
    
 	// 게시글 추천 상태 확인 함수
    function checkBoardLikeStatus(board_seq) {
    $.ajax({
        url: "/isLiked.board",
        method: "GET",
        data: { board_seq: board_seq },
        dataType: "json"
    }).done(function(resp) {
        console.log("isLiked.board 응답:", resp);

        const $btn = $(".board_like_btn");
        const $icon = $btn.find("i");
        const $count = $btn.find(".like-count");

        // 하트 상태 반영
        if (resp.isLiked) {
            $icon.removeClass("bi-heart").addClass("bi-heart-fill").css("color", "#e74c3c");
        } else {
            $icon.removeClass("bi-heart-fill").addClass("bi-heart").css("color", "");
        }

        // 추천수 업데이트 (여기!)
        $count.text(resp.likeCount);

	    }).fail(function(xhr) {
	        console.error("isLiked 체크 실패:", xhr);
	    });
	}




</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />