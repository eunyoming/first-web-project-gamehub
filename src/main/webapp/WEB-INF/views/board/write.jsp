<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- main header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Summernote cdn -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>

<!-- css -->
<link href="/css/write.css" rel="stylesheet" />

<div class="container">
	<!-- 제목 -->
	<form id="insert-Frm" action="/insert.board" method="post">
		<div class="row">
			<div class="col-12 col-md-6 pe-3">
				<label for="searchInput" class="form-label">제목</label>
				<div class="title-group">
					<input type="text" class="form-control" id="title" name="title"
						placeholder="Value">
				</div>
			</div>
		</div>

		<!-- 카테고리 / 관련 게임 -->
		<div class="row g-3 align-items-end mt-2">
			<div class="col-6">
				<label for="category" class="form-label">카테고리</label> <select
					id="category" name="category" class="form-select">
					<option value="">전체</option>
					<option>자유</option>
					<option>공략</option>
					<option>기타</option>
				</select>
			</div>
			<div class="col-6">
				<label for="relatedGame" class="form-label">관련 게임</label> <select
					id="refgame" name="refgame" class="form-select">
					<option value="">없음</option>
					<option>Game A</option>
					<option>Game B</option>
					<option>Game C</option>
				</select>
			</div>
		</div>

		<!-- 에디터 -->
		<div class="row contents">
			<div class="col contentsDiv" id="summernote"></div>
			<input type="hidden" id="contents" name="contents">
		</div>
		<div class="row footer-btns">
			<!-- 버튼 -->
			<div class="col">
				<button class="btn btn-gradient btn-navy-blue" id="okBtn">완료</button>
				<a href="/list.board">
					<button class="btn btn-gradient btn-navy-blue">취소</button>
				</a>
			</div>
		</div>
	</form>
</div>

<script>
	//썸머노트 API 실행
	$(document)
			.ready(
					function() {
						// 1. contents 영역 높이 가져오기
						let contentsHeight = $(".contents").height();

						// 2. Summernote 임시 초기화
						$("#summernote").summernote({
							height : 100, // 임시값
							disableResizeEditor : true
						});

						// 3. 툴바 높이 측정
						let toolbarHeight = $(".note-toolbar")
								.outerHeight(true);

						// 4. 에디터 전체 높이 설정
						let editorHeight = contentsHeight;

						// 에디터 본문 영역 높이 설정
						let editableHeight = contentsHeight - toolbarHeight;

						// 5. Summernote 다시 초기화
						$("#summernote").summernote("destroy");
						$("#summernote")
								.summernote(
										{
											placeholder : "내용을 작성하세요.",
											tabsize : 2,
											// height : 에디터 전체 높이
											height : editorHeight,
											disableResizeEditor : true,
											fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체'],
								            fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
								            height: 300,
								            lang: "ko-KR",
								            toolbar:[
								                    ['style', ['bold', 'italic', 'underline', 'clear']],
								                    ['font', ['fontname', 'fontsize', 'strikethrough', 'superscript', 'subscript']],
								                    ['color', ['color']],
								                    ['para', ['ul', 'ol', 'paragraph']],
								                    ['insert', ['link', 'picture', 'video']],
								                    ['view', ['fullscreen', 'codeview', 'help']]
								                  ],
										});
						// note-editable 영역 (에디터 본문) 높이 조정
						$(".note-editable")
								.css("height", editableHeight + "px");

						// 초기화 후 강제로 숨기기
						$(".note-resize").css("display", "none");
					});

	// 작성완료 버튼 눌렀을 때
	$("#okBtn").on("click", function(e) {
		e.preventDefault(); // 기본 submit 막기
		// 제목 값
	    let title = $("#title").val().trim();

	    // 에디터 내용
	    let contents = $("#summernote").summernote("code");
	    let contentsText = $("<div>").html(contents).text().trim(); 
	    // summernote는 <p><br></p> 같은 태그가 들어있을 수 있어서 텍스트만 비교

	    // 제목 유효성 검사
	    if (title === "") {
	        alert("제목을 입력하세요.");
	        $("#title").focus();
	        return;
	    }

	    // 내용 유효성 검사
	    if (contentsText === "") {
	        alert("내용을 입력하세요.");
	        $("#summernote").summernote("focus"); // summernote 내부 focus
	        return;
	    }
		$("#contents").val(contents);
		$("#insert-Frm").submit();
	});
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />