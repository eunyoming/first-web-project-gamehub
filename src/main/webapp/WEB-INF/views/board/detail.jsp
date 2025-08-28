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

<div class="container g-0">
	<!-- 상단 헤더 -->
	<div class="row header-board g-0">
		<div class="col-1">
			<i class="bi bi-arrow-left-circle"></i>
		</div>
		<div class="col-3">[${dto.category}] / [${dto.refgame}]</div>
		<div class="col-4">${dto.title}[댓글수]</div>

		<div class="col-3">
			<fmt:formatDate value="${dto.created_at}"
				pattern="yyyy-MM-dd HH:mm:ss" />
		</div>
		<div class="col-1">${dto.viewCount}</div>
	</div>
	<!-- 상단 작성자 -->
	<div class="row header-writer g-0">
		<div class="col-8 writer">
			<a
				class="d-flex align-items-center text-decoration-none dropdown-toggle"
				href="#" id="profileDropdown" data-bs-toggle="dropdown"
				aria-expanded="false"> <!-- 프로필 이미지 --> <img
				src="https://picsum.photos/100/100?random=1" alt="프로필"
				class="rounded-circle me-2" width="40" height="40"> <!-- 아이디와 칭호 -->
				<div class="d-none d-md-block text-end">
					<div class="fw-bold text-purple">${loginId}</div>
					<div class="text-muted">🏆 초보 마스터</div>
				</div>
			</a>
		</div>
		<div class="col-2">
			<button class="btn" id="copy_btn">
				<i class="bi bi-copy"></i> 글 복사하기
			</button>
		</div>
		<div class="col-2">
			<button class="btn" id="report_btn" data-bs-toggle="modal"
				data-bs-target="#exampleModal">
				<img src="/asset/img/siren.png"> 신고하기
			</button>
		</div>
	</div>
	<!-- 글 내용 -->
	<div class="row contents">
		<div class="col-12 content">${dto.contents}</div>
		<!-- 버튼들 -->
		<div class="col-12 btns">
			<button class="btn btn-outline-red-main" id="like_btn">
				<i class="bi bi-heart"></i> 추천수
			</button>
			<button class="btn btn-outline-red-main" id="bookmark_btn">
				<i class="bi bi-bookmark"></i> 북마크
			</button>
		</div>
	</div>

</div>
<!-- container -->

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1"
	aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body">
  <form id="reportForm">
    <p class="fw-bold mb-3">신고 사유를 선택해주세요:</p>

    <!-- 기본 신고 사유들 -->
    <div class="form-check">
      <input class="form-check-input" type="radio" name="reportReason" id="reason1" value="괴롭힘 또는 폭력">
      <label class="form-check-label" for="reason1">괴롭힘 또는 폭력</label>
    </div>
    <div class="form-check">
      <input class="form-check-input" type="radio" name="reportReason" id="reason2" value="유해하거나 위험한 행위">
      <label class="form-check-label" for="reason2">유해하거나 위험한 행위</label>
    </div>
    <div class="form-check">
      <input class="form-check-input" type="radio" name="reportReason" id="reason3" value="자살, 자해 또는 섭식 장애">
      <label class="form-check-label" for="reason3">자살, 자해 또는 섭식 장애</label>
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
      <input class="form-check-input" type="radio" name="reportReason" id="reason7" value="스팸 또는 혼동을 야기하는 콘텐츠">
      <label class="form-check-label" for="reason7">스팸 또는 혼동을 야기하는 콘텐츠</label>
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
      <label for="etcDetail" class="form-label">세부 내용을 입력해주세요 (선택사항)</label>
      <textarea class="form-control" id="etcDetail" name="etcDetail" rows="3" placeholder="세부정보 추가..."></textarea>
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



<script>
	// 추천 버튼 클릭시
	$("#like_btn").on("click", function() {
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
	// 복사하기 버튼 클릭시
	$("#copy_btn").on("click", function() {

	});

	// 신고하기 버튼 클릭시
	$("#report_btn").on("click", function(e) {
	});
	
	// 신고하기 - 기타 선택시 입력창
	$(document).ready(function () {
		  $('input[name="reportReason"]').on('change', function () {
		    if ($(this).attr('id') === 'reasonEtc') {
		      $('#etcDetailBox').show();
		    } else {
		      $('#etcDetailBox').hide();
		    }
		  });
		});

</script>

// 댓글 아이콘
<i class="bi bi-arrow-return-right"></i>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />