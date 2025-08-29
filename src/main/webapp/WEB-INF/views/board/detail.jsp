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
<link href="/css/detail.css" rel="stylesheet" />
<!-- fontawesome icon -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<!-- kakao -->
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.6/kakao.min.js"
	integrity="sha384-WAtVcQYcmTO/N+C1N+1m6Gp8qxh+3NlnP7X1U7qP6P5dQY/MsRBNTh+e1ahJrkEm"
	crossorigin="anonymous"></script>
<script>
  Kakao.init('68c4c9de5864af60b8deea3885634e91');  // 사용하려는 앱의 JavaScript 키 입력
</script>


<div class="container g-0">
	<!-- 상단 헤더 -->
	<div class="row header-board g-0">
		<!-- 뒤로가기 -->
		<div class="col-1">
			<a href="javascript:history.back();" class="back-link"> <i
				class="bi bi-arrow-left"></i>
			</a>
		</div>
		<div class="col-3">[ ${boardDto.category} ] | [
			${boardDto.refgame} ]</div>
		<div class="col-4" id="board_title">${boardDto.title}</div>

		<div class="col-3">
			<fmt:formatDate value="${boardDto.created_at}"
				pattern="yyyy-MM-dd HH:mm:ss" />
		</div>
		<div class="col-1">${boardDto.viewCount}</div>
	</div>
	<!-- 상단 작성자 -->
	<div class="row header-writer g-0">
		<div class="col-8 writer">
			<div class="profile">
				<!-- 프로필 이미지 -->
				<img src="https://picsum.photos/100/100?random=1" alt="프로필"
					class="rounded-circle me-2" width="40" height="40">
				<!-- 아이디와 칭호 -->
				<div class="d-none d-md-block text-end">
					<div class="fw-bold text-purple">${boardDto.writer}</div>
					<div class="text-muted">🏆 초보 마스터</div>
				</div>
			</div>
		</div>
		<div class="col-4 header-btns">
			<div class="left-btn">
				<button class="btn" id="share_btn" data-bs-toggle="modal"
					data-bs-target="#shareModal">
					<i class="bi bi-share"></i> 공유하기
				</button>

			</div>
			<div class="right-btn">
				<button class="btn" id="report_btn" data-bs-toggle="modal"
					data-bs-target="#boardModal">
					<img src="/asset/img/siren.png"> 신고하기
				</button>
			</div>
		</div>
	</div>
	<!-- 글 내용 -->
	<div class="row contents">
		<div
			class="col-12 content d-flex justify-content-between align-items-center"
			id="board_content">${boardDto.contents}</div>
		<!-- 버튼들 -->
		<div
			class="col-12 btns d-flex justify-content-center align-items-center">
			<c:choose>
				<c:when test="${loginId != null}">
					<div class="d-flex justify-content-end gap-2">
						<div>
							<button class="btn btn-outline-red-main" id="like_btn">
								<i class="bi bi-heart"></i> 추천수
							</button>
						</div>
						<div>
							<button class="btn btn-outline-red-main" id="board-update_btn">수정</button>
							<button class="btn btn-outline-red-main" id="board-delete_btn">삭제</button>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="d-flex justify-content-center flex-grow-1 gap-2">
						<button class="btn btn-outline-red-main" id="like_btn">
							<i class="bi bi-heart"></i> 추천수
						</button>
						<button class="btn btn-outline-red-main" id="bookmark_btn">
							<i class="bi bi-bookmark"></i> 북마크
						</button>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<!-- 댓글 컨테이너 -->
	<div class="relys-container">
		<!-- 댓글 작성 -->
		<div class="replys-box">
			<!-- 댓글 header -->
			<div class="row replys-header g-0">
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
			<div class="row replys-contents g-0">
				<!-- 댓글 왼쪽 content -->
				<div class="col-8 reply-left_content" id="replyInput"
					contenteditable="${loginId != null}">${loginId != null ? "댓글을 입력하세요" : "로그인 후 이용해주세요"}
				</div>
				<!-- 댓글 오른쪽 content 버튼들 -->
				<div class="col-4 reply-right-content">
					<div class="reply-footer_btns">
						<button class="btn btn-outline-red-main" id="reply-input_btn">
							<i class="bi bi-heart"></i> 등록
						</button>
						<!-- 댓글 주인만 -->
						<c:if test="${loginId != null}">
							<button class="btn btn-outline-red-main" id="reply-update_btn">
								수정</button>
							<button class="btn btn-outline-red-main" id="reply-delete_btn">
								삭제</button>
						</c:if>
					</div>
				</div>
			</div>
		</div>

		<!-- 댓글 출력 -->
		<div class="replys-box">
			<!-- 댓글 header -->
			<div class="row replys-header g-0">
				<div class="col-8 reply-writer fw-bold text-navy">아이디</div>
				<div class="col-4 reply-header_btns">
					<button class="btn btn-outline-red-main" id="reply-like_btn">
						<i class="bi bi-heart"></i> 추천수
					</button>
					<button class="btn btn-outline-red-main" id="reply-report_btn"
						data-bs-toggle="modal" data-bs-target="#boardModal">
						<img src="/asset/img/siren.png"> 신고하기
					</button>
				</div>
			</div>
			<!-- 댓글 contents -->
			<div class="row replys-contents g-0">
				<!-- 댓글 왼쪽 content -->
				<div class="col-8 reply-left_content" contenteditable="false">댓글
					내용</div>
				<!-- 댓글 오른쪽 content 버튼들 -->
				<div class="col-4 reply-right-content">
					<div class="reply-footer_btns">
						<button class="btn btn-outline-red-main" id="like_btn">
							<i class="bi bi-heart"></i> 등록
						</button>
						<!-- 댓글 주인만 -->
						<c:if test="${loginId != null}">
							<button class="btn btn-outline-red-main" id="reply-update_btn">
								수정</button>
							<button class="btn btn-outline-red-main" id="reply-delete_btn">
								삭제</button>
						</c:if>
					</div>
					<!-- 댓글 오른쪽 작성 시간 -->
					<div class="reply-created_at">
						yyyy-mm-dd HH:mm:ss
						<!-- <fmt:formatDate value="${reply_dto.created_at}"
								pattern="yyyy-MM-dd HH:mm:ss" />  -->
					</div>
				</div>
			</div>
		</div>

		<!-- 댓글 출력 -->
		<div class="replys-box">
			<!-- 댓글 header -->
			<div class="row replys-header g-0">
				<div class="col-8 reply-writer fw-bold text-navy">아이디</div>
				<div class="col-4 reply-header_btns">
					<button class="btn btn-outline-red-main" id="reply-like_btn">
						<i class="bi bi-heart"></i> 추천수
					</button>
					<button class="btn btn-outline-red-main" id="reply-report_btn"
						data-bs-toggle="modal" data-bs-target="#boardModal">
						<img src="/asset/img/siren.png"> 신고하기
					</button>
				</div>
			</div>
			<!-- 댓글 contents -->
			<div class="row replys-contents g-0">
				<!-- 댓글 왼쪽 content -->
				<div class="col-8 reply-left_content" contenteditable="false">댓글
					내용</div>
				<!-- 댓글 오른쪽 content 버튼들 -->
				<div class="col-4 reply-right-content">
					<div class="reply-footer_btns">
						<button class="btn btn-outline-red-main" id="like_btn">
							<i class="bi bi-heart"></i> 등록
						</button>
						<!-- 댓글 주인만 -->
						<c:if test="${loginId != null}">
							<button class="btn btn-outline-red-main" id="reply-update_btn">
								수정</button>
							<button class="btn btn-outline-red-main" id="reply-delete_btn">
								삭제</button>
						</c:if>
					</div>
					<!-- 댓글 오른쪽 작성 시간 -->
					<div class="reply-created_at">
						yyyy-mm-dd HH:mm:ss
						<!-- <fmt:formatDate value="${reply_dto.created_at}"
								pattern="yyyy-MM-dd HH:mm:ss" />  -->
					</div>
				</div>
			</div>
		</div>

	</div>
	<!-- replys-container -->

</div>
<!-- container -->


<!-- update Form -->
<form id="board-updateFrm" action="/update.board" method="post">
	<input type="hidden" value="${boardDto.seq}" id="board_seq"
		name="board_seq"> <input type="hidden"
		value="${boardDto.title}" id="board_title" name="board_title">
	<input type="hidden" value="<c:out value='${boardDto.contents}'/>"
		id="board_contents" name="board_contents"> <input
		type="hidden" value="${boardDto.category}" id="board_category"
		name="board_category"> <input type="hidden"
		value="${boardDto.refgame}" id="board_refgame" name="board_refgame">
</form>

<!-- delete Form -->
<form id="board-deleteFrm" action="/delete.board" method="post">
	<input type="hidden" value="${boardDto.seq}" id="board_seq2"
		name="board_seq2">
</form>

<!-- 댓글 insert form -->
<form id="reply-insertFrm" action="/insert.reply" method="post">
	<input type="hidden" name="insert-reply_contents"
		id="insert-reply_contents"> <input type="hidden"
		value="${boardDto.seq}" name="insert-board_seq" id="insert-board_seq">
	<input type="hidden" name="insert-parent_seq" id="insert-parent_seq">
</form>

<!-- board Modal -->
<div class="modal fade" id="boardModal" tabindex="-1"
	aria-labelledby="boardModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title fw-bold" id="boardModalLabel">신고</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<form id="reportFrm">
					<p class="fw-bold mb-3">신고 사유를 선택해주세요:</p>

					<!-- 기본 신고 사유들 -->
					<div class="form-check">
						<input class="form-check-input" type="radio" name="reportReason"
							id="reason1" value="괴롭힘 또는 폭력"> <label
							class="form-check-label" for="reason1">괴롭힘 또는 폭력</label>
					</div>
					<div class="form-check">
						<input class="form-check-input" type="radio" name="reportReason"
							id="reason2" value="유해하거나 위험한 행위"> <label
							class="form-check-label" for="reason2">유해하거나 위험한 행위</label>
					</div>
					<div class="form-check">
						<input class="form-check-input" type="radio" name="reportReason"
							id="reason3" value="정신 건강에 해로운 콘텐츠"> <label
							class="form-check-label" for="reason3">정신 건강에 해로운 콘텐츠</label>
					</div>
					<div class="form-check">
						<input class="form-check-input" type="radio" name="reportReason"
							id="reason4" value="잘못된 정보"> <label
							class="form-check-label" for="reason4">잘못된 정보</label>
					</div>
					<div class="form-check">
						<input class="form-check-input" type="radio" name="reportReason"
							id="reason5" value="아동 학대"> <label
							class="form-check-label" for="reason5">아동 학대</label>
					</div>
					<div class="form-check">
						<input class="form-check-input" type="radio" name="reportReason"
							id="reason6" value="테러 조장"> <label
							class="form-check-label" for="reason6">테러 조장</label>
					</div>
					<div class="form-check">
						<input class="form-check-input" type="radio" name="reportReason"
							id="reason7" value="스팸 또는 혼동을 야기하는 콘텐츠"> <label
							class="form-check-label" for="reason7">스팸 또는 혼동을 야기하는 콘텐츠</label>
					</div>
					<div class="form-check mb-2">
						<input class="form-check-input" type="radio" name="reportReason"
							id="reason8" value="법적 문제"> <label
							class="form-check-label" for="reason8">법적 문제</label>
					</div>

					<!-- 기타 항목 -->
					<div class="form-check mb-2">
						<input class="form-check-input" type="radio" name="reportReason"
							id="reasonEtc" value="기타"> <label
							class="form-check-label" for="reasonEtc">기타</label>
					</div>

					<!-- 기타 입력창 (초기에는 숨김) -->
					<div class="mb-3" id="etcDetailBox" style="display: none;">
						<label for="etcDetail" class="form-label">세부 내용을 입력해주세요
							(선택사항)</label>
						<textarea class="form-control" id="etcDetail" name="etcDetail"
							rows="3" placeholder="세부정보 추가..."></textarea>
						<small class="text-muted">개인 정보나 질문은 포함하지 마세요.</small>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-red-main" id="modal-report_btn">신고</button>
			</div>
		</div>
	</div>
</div>

<!-- 공유 모달 -->
<div class="modal fade" id="shareModal" tabindex="-1"
	aria-labelledby="shareModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">

			<!-- 모달 헤더 -->
			<div class="modal-header">
				<h5 class="modal-title" id="shareModalLabel">공유하기</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="닫기"></button>
			</div>

			<!-- 모달 바디 -->
			<div class="modal-body">
				<!-- 다른 플랫폼으로 공유하기 -->
				<h6 class="mt-4">공유</h6>
				<div class="d-flex flex-wrap gap-2">
					<!-- 카카오톡 -->
					<a id="kakaotalk-sharing-btn" href="javascript:shareMessage()">
						<img
						src="https://developers.kakao.com/assets/img/about/logos/kakaotalksharing/kakaotalk_sharing_btn_medium.png"
						alt="카카오톡 공유 보내기 버튼" width="36" />
					</a>
					<!-- 페이스북 -->
					<a id="facebook-sharing-btn" href="/" target="_blank"
						aria-label="Facebook 공유"> <img
						src="/asset/img/facebook-icon.png" alt="Facebook" width="36">
					</a>
					<!-- X -->
					<a id="x-sharing-btn" href="/" target="_blank"> <img
						src="/asset/img/x-icon.png" alt="Facebook" width="36">
					</a>
				</div>

				<div class="mt-4">
					<input type="text" class="form-control" id="shareLink" value=""
						readonly>
					<button class="btn btn-primary mt-2 w-100" onclick="copyLink()">복사</button>
				</div>
			</div>

		</div>
	</div>
</div>

<!-- Toast 메시지 -->
<div class="position-fixed bottom-0 start-0 p-3" style="z-index: 1055">
	<div id="copyToast"
		class="toast align-items-center text-white bg-success border-0"
		role="alert" aria-live="assertive" aria-atomic="true">
		<div class="d-flex">
			<div class="toast-body">링크가 복사되었습니다!</div>
			<button type="button" class="btn-close btn-close-white me-2 m-auto"
				data-bs-dismiss="toast" aria-label="닫기"></button>
		</div>
	</div>
</div>

<script>

	// 글 추천 버튼 클릭시
	$("#like_btn").on("click", function() {
		const icon = $(this).find("i");
		icon.toggleClass("bi-heart bi-heart-fill");
		if (icon.hasClass("bi-heart-fill")) {
			icon.css("color", "#e74c3c !important");
		} else {
			icon.css("color", "");
		}
	});
	// 댓글 추천 버튼 클릭시
	$("#reply-like_btn").on("click", function() {
		const icon = $(this).find("i");
		icon.toggleClass("bi-heart bi-heart-fill");
		if (icon.hasClass("bi-heart-fill")) {
			icon.css("color", "#e74c3c !important");
		} else {
			icon.css("color", "");
		}
	});

	// 북마크 버튼 클릭시
	$("#bookmark_btn").on("click", function() {
		const icon = $(this).find("i");
		icon.toggleClass('bi-bookmark bi-bookmark-fill');
		if (icon.hasClass("bi-bookmark-fill")) {
			icon.css("color", "#e74c3c !important");
		} else {
			icon.css("color", "");
		}
	});
	
	// 공유하기 버튼 클릭시
	$("#share_btn").on("click", function() {
		// 아이콘 색 변경
		const icon = $(this).find("i");
		icon.toggleClass("bi-share bi-share-fill share-active");

		// 0.2초 후에 아이콘 색 변경 클래스 제거
		setTimeout(function() {
			icon.toggleClass("bi-share bi-share-fill share-active");
		}, 200); // 1000ms = 1초
	});
	
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
	  }
	
	// 페이스북, x.com 공유하기
	document.addEventListener('DOMContentLoaded', () => {
	    let currentUrl = window.location.href;
	    let pageTitle = $('#board_title').html() || '공유 게시물';
		
	 	// Facebook
	 	let encoded_fb = encodeURIComponent(currentUrl);
	    $('#facebook-sharing-btn').attr('href', `https://www.facebook.com/sharer/sharer.php?u=${encoded_fb}`);

	    // X (Twitter)
	    let xUrl = '${pageTitle} - ${currentUrl}';
	    let encoded_x = encodeURIComponent(xUrl);
	    $('#x-sharing-btn').attr('href', `https://twitter.com/intent/tweet?text=${encoded_x}`);
	 
		// 복사하기 버튼 위에 링크
		$("#shareLink").val(currentUrl);
	});
	
	// 공유하기 - 복사 function
	function copyLink() {
	    let linkInput = $("#shareLink");
	    navigator.clipboard.writeText(linkInput.value).then(() => {
	      let toastId = $("#copyToast");
	      let toast = new bootstrap.Toast(toastId);
	      toast.show();
	    });
	  }
	
	// 신고하기 버튼 클릭시
	$("#report_btn").on("click", function(e) {
	});

	// 신고하기 - 기타 선택시 입력창
	$(document).ready(function() {
		$('input[name="reportReason"]').on('change', function() {
			if ($(this).attr('id') === 'reasonEtc') {
				$('#etcDetailBox').show();
			} else {
				$('#etcDetailBox').hide();
			}
		});
	});
	
	// ----------------- 댓글 부분
	// 댓글 등록 버튼 클릭시
	const loginId = ${loginId};
	$("#reply-input_btn").on("click", function(){
		if (!loginId || loginId === "null") {
		      alert("로그인 후 댓글을 작성할 수 있습니다.");
		      return;
		    }
		
		const reply_content = $("#replyInput").text().trim();
	    if (content === "") {
	      alert("댓글 내용을 입력해주세요.");
	      return;
	    }

	    // AJAX로 댓글 등록 요청
	    $.ajax({
	      url: "/insert.reply",
	      method: "POST",
	      data: {
	        writer: loginId,
	        content: content,
	        boardSeq: ${boardDto.seq} // 현재 글 번호
	      }
	    )}.done(function (resp) {
	    	  console.log("댓글 등록 성공!", resp);
	      }).fail(function (error) {
	        console.error("댓글 등록 실패", error);
	      });
	  });
		
		
	})
	
	
	
</script>

// 댓글 아이콘
<i class="bi bi-arrow-return-right"></i>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />