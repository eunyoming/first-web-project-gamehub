<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- main header -->
<%
request.setAttribute("pageTitle", "게시글 작성하기");
%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Summernote cdn -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css"
	rel="stylesheet">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>

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
					<option value="자유" selected>자유</option>
					<option value="공략">공략</option>
					<option value="기타">기타</option>
				</select>
			</div>
			<div class="col-6">
				<label for="relatedGame" class="form-label">관련 게임</label> <select
					id="refgame" name="refgame" class="form-select">
					<option value="">선택</option>
					<option value="Game A">Game A</option>
					<option value="Game B">Game B</option>
					<option value="Game C">Game C</option>
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
				<button type="button" class="btn btn-gradient btn-navy-blue"
					id="okBtn">완료</button>
				<a href="/list.board" class="btn btn-gradient btn-navy-blue">취소</a>
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
								                  callbacks: {
								                	    onImageUpload: function(files) {
								                	        for (var i = 0; i < files.length; i++) {
								                	            uploadImage(files[i]);
								                	        }
								                	    },
								                	    onDrop: function(e) {
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
						// note-editable 영역 (에디터 본문) 높이 조정
						$(".note-editable")
								.css("height", editableHeight + "px");

						// 초기화 후 강제로 숨기기
						$(".note-resize").css("display", "none");
					});
	
	// 파일 업로드 함수
	function uploadImage(file) {
	    var data = new FormData();
	    data.append("file", file);

	    $.ajax({
	        url: '/api/board/UploadImage',
	        type: 'POST',
	        data: data,
	        cache: false,
	        contentType: false,
	        processData: false,
	        success: function(resp) {
	            $('#summernote').summernote('insertImage', resp.url);
	        }
	    });
	};
	    
	// 작성완료 버튼 눌렀을 때
	$("#okBtn").on("click", function (e) {
	    e.preventDefault();

	    let title = $("#title").val().trim();
	    let category = $("#category").val();
	    let refGame = $("#refgame").val();

	    // summernote 내용 (HTML 전체)
	    let contents = $("#summernote").summernote("code");

	    // 제목 검사
	    if (title === "") {
	        alert("제목을 입력하세요.");
	        $("#title").focus();
	        return;
	    }

	    // 내용 검사 (사진만 있어도 등록 가능하도록)
	    if (contents === "" || contents === "<p><br></p>") {
	        alert("내용을 입력하세요.");
	        $("#summernote").summernote("focus");
	        return;
	    }

	    // 관련 게임 검사
	    if (!refGame || refGame === "") {
	        alert("관련 게임을 선택하세요.");
	        $("#refgame").focus();
	        return;
	    }

	    $("#contents").val(contents);

	    // 폼 데이터 직렬화
	    let formData = $("#insert-Frm").serialize();

	    $.ajax({
	        url: "/insert.board",
	        method: "POST",
	        data: formData,
	        dataType: "json", 
	        success: function (resp) {
	            if (resp.success) {
	                location.href = "/detailPage.board?seq=" + resp.seq;
	            } else {
	                alert("글 작성에 실패했습니다.");
	            }
	        },
	        error: function () {
	            alert("서버 오류가 발생했습니다.");
	        }
	    });
	});
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />