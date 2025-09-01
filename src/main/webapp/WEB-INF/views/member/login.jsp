<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
	type="text/javascript"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous" type="text/javascript"></script>
<link href="/css/main.css" rel="stylesheet" />
</head>
<style>
			/* 로그인 */
			#idInput {
				margin-top: 5px;
				margin-bottom: 15px;
			}

			#pwInput {
				margin-bottom: 15px;
			}
			.link-box {
    		font-size: 0.9rem;
   			 color: gray;
			}

			.link-box a {
   			 text-decoration: none;
   			 color: gray;
   			 margin: 0 8px;
			}

			.link-box a:hover {
  		   	 text-decoration: underline;
   			 color: #555;
			}

  			.link-box .divider {
    		color: #aaa;
  		    margin: 0 4px;
			}

			/* 아이디 찾기 */
			.modal-dialog {
				width: 600px;
			}

			.modal-content {
				min-height: 300px;
			}

			.fieldCheckMessage,
			.error-message,
			.success-message {
				font-size: 0.9rem;
				margin-top: 4px;
				margin-left: 2px;
				display: block;
				/* 줄바꿈 강제 */
				min-height: 18px;
				/* 공간 확보 */
			}
		</style>
<body
	style="background-image: url('https://picsum.photos/1920/1080'); background-size: cover; background-position: center;">


<main>
	<div
		class="container d-flex justify-content-center align-items-center vh-100 ">

			<div class="login_box shadow-lg p-5 mb-5 g-5 rounded blur-bg-login">
		<form action="/api/member/login" id="login_form" method="post" class="login form">
			<label for="formGroupExampleInput" class="form-label text-center">아이디</label>
			<input name="userId" type="text" class="form-control" id="idInput" placeholder="아이디 입력" required
				title="이 필드는 필수입니다."> <label for="formGroupExampleInput2" class="form-label text-center">패스워드</label>
			<input name="userPassword" type="password" class="form-control" id="pwInput" placeholder="패스워드 입력" required
				title="이 필드는 필수입니다.">
			<input type="checkbox" id="idCheckBox">ID 기억하기
			<button class="btn btn-light w-100 mb-3 mt-3">로그인</button>
			<a href="/api/member/join"><button type="button" class="btn btn-light w-100">회원가입</button></a>
			<div class="d-flex justify-content-center mt-3 link-box">
   			<a href="#" data-bs-toggle="modal" data-bs-target="#findIdModal">아이디 찾기</a>
    		<span class="divider">|</span>
   			<a href="#" data-bs-toggle="modal" data-bs-target="#findPwModal">비밀번호 찾기</a>
</div>
		</form>
	</div>

	<!-- 아이디 찾기 모달 창 -->
	<div class="modal fade" id="findIdModal" tabindex="-1" aria-labelledby="findIdLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">

				<!-- 모달 헤더 -->
				<div class="modal-header">
					<h5 class="modal-title" id="findIdLabel">아이디 찾기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
				</div>

				<!-- 모달 바디 -->
				<div class="modal-body">
					<form>
						<div class="mt-3 mb-3 d-flex align-items-center" style="gap: 16px;">
							<label for="find_Id" class="form-label mb-0"
								style="width: 100px; text-align: right;">이름</label>
							<input type="text" class="form-control" id="find_Id" name="find_idInput"
								style="max-width: 400px;" placeholder="이름을 입력하세요">
						</div>
						<div class="mb-3 d-flex align-items-center" style="gap: 16px;">
							<label for="find_emailInput" class="form-label mb-0"
								style="width: 100px; text-align: right;">이메일</label>
							<input type="email" class="form-control" id="find_emailInput" name="find_emailInput"
								style="max-width: 400px;" placeholder="이메일을 입력하세요">
						</div>
					</form>
				</div>

				<!-- 모달 푸터 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="find_id_btn">아이디 찾기</button>
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 비밀번호 찾기 모달 창 -->
	<div class="modal fade" id="findPwModal" tabindex="-1" aria-labelledby="findPwLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">

				<!-- 모달 헤더 -->
				<div class="modal-header">
					<h5 class="modal-title" id="findPwLabel">비밀번호 찾기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
				</div>

				<!-- 모달 바디 -->
				<div class="modal-body">
					<form>
					<div class="mt-3 mb-3 d-flex align-items-center" style="gap: 16px;">
							<label for="findPw_idInput" class="form-label mb-0"
								style="width: 100px; text-align: right;">아이디</label>
							<input type="text" class="form-control" id="findPw_idInput" name="findPw_idInput"
								style="max-width: 400px;" placeholder="아이디를 입력하세요">
						</div>
						<div class="mt-3 mb-3 d-flex align-items-center" style="gap: 16px;">
							<label for="findPw_nameInput" class="form-label mb-0"
								style="width: 100px; text-align: right;">이름</label>
							<input type="text" class="form-control" id="findPw_nameInput" name="findPw_nameInput"
								style="max-width: 400px;" placeholder="이름을 입력하세요">
						</div>
						<div class="mb-3 d-flex align-items-center" style="gap: 16px;">
							<label for="findPw_emailInput" class="form-label mb-0"
								style="width: 100px; text-align: right;">이메일</label>
							<input type="email" class="form-control" id="findPw_emailInput" name="findPw_emailInput"
								style="max-width: 400px;" placeholder="이메일을 입력하세요">
						</div>
					</form>
				</div>

				<!-- 모달 푸터 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="find_Pw_Btn">비밀번호 찾기</button>
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 비밀번호 변경 모달 창 -->
					<div class="modal fade" id="findUpdateModal" tabindex="-1" aria-labelledby="findUpdateLabel"
						aria-hidden="true">
						<div class="modal-dialog modal-lg">
							<div class="modal-content" style="min-height: 400px;">

								<!-- 모달 헤더 -->
								<div class="modal-header">
									<h5 class="modal-title" id="findUpdateLabel">비밀번호 변경</h5>
									<button type="button" class="btn-close" data-bs-dismiss="modal"
										aria-label="닫기"></button>
								</div>

								<!-- 모달 바디 -->
								<div class="modal-body">
									<!-- 비밀번호 입력 -->
									<div class="mb-3">
										<label for="findUpdate_PwInput" class="form-label">비밀번호</label>
										<input type="password" class="form-control" id="findUpdate_PwInput">
										<div class="fieldCheckMessage" id="findUpdatePwFieldCheck"></div>
										<div class="error-message" id="findUpdatePwError"></div>
									</div>

									<!-- 비밀번호 재입력 -->
									<div class="mb-3">
										<label for="findUpdate_PwCheckInput" class="form-label">비밀번호 재입력</label>
										<input type="password" class="form-control" id="findUpdate_PwCheckInput">
										<div class="fieldCheckMessage" id="findUpdatePwCheckFieldCheck"></div>
										<div class="error-message" id="findUpdatePwCheckError"></div>
										<div class="success-message" id="findUpdatePwMessage"></div>
									</div>
								</div>

								<!-- 모달 푸터 -->
								<div class="modal-footer">
									<button type="button" class="btn btn-primary" id="find_Update_Btn">비밀번호 변경</button>
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
								</div>
							</div>
						</div>
					</div>
	<script>
	// ID 기억하기
	$(document).ready(function () {
	    let savedId = localStorage.getItem("savedUserId");
	    if (savedId) {
	        $("#idInput").val(savedId);
	        $("#idCheckBox").prop("checked", true);
	    }
	    // 로그인 버튼 클릭 시 체크 여부 확인
	    $(".login_box form").on("submit", function () {
	        if ($("#idCheckBox").is(":checked")) {
	            localStorage.setItem("savedUserId", $("#idInput").val());
	        } else {
	            localStorage.removeItem("savedUserId");
	        }
	    });
	});
		// 아이디 찾기 버튼
		$("#find_id_btn").on("click", function () {
			let name = $("#find_Id").val();
			let email = $("#find_emailInput").val();

			$.ajax({
				url: "/api/member/findId",
				type: 'POST',
				data: { name: name, email: email },
				success: function (response) {
					if (response.id) {
						alert("회원님의 아이디는 " +"'"+ response.id + " ' 입니다.");
					} else {
						alert("일치하는 정보가 없습니다.");
					}
				},
				error: function () {
					alert("서버 오류가 발생했습니다.");
				}
			});
		});
		
		// 비밀번호 찾기 버튼
		$("#find_Pw_Btn").on("click", function () {
			
			let id = $("#findPw_idInput").val();
			let name = $("#findPw_nameInput").val();
			let email = $("#findPw_emailInput").val();
			
			$.ajax({
				url: "/api/member/findPw",
				type: 'POST',
				data: { id: id , name: name, email: email },
				success: function (response) {
					if (response.userId) {        
						userId = id;
						// 첫 번째 모달 창 닫기
						$("#findPwModal").modal('hide');
						
						// 두 번째 모달 창 열기 (비밀번호 변경)
						$("#findUpdateModal").modal('show');
					} else {
						alert("일치하는 정보가 없습니다.");
					}
				},
				error: function () {
					alert("서버 오류가 발생했습니다.");
				}
			});
		});
		
		let userId = null;

		$(document).ready(function () {
			
			let regex = {
				pw: /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[^\w\s])[^\s]{7,15}$/ // 영문+숫자+특수문자 7~15자
			};

			// 메시지 출력 함수
			function showMessage(field, type, message) {
				let $fieldCheck = $("#" + field + "FieldCheck");
				let $error = $("#" + field + "Error");
				let $success = $("#" + field + "Message");

				$fieldCheck.hide();
				$error.hide();
				$success && $success.hide();

				if (type === "info") {
					$fieldCheck.text(message).show();
				} else if (type === "error") {
					$error.text(message).css("color", "red").show();
				} else if (type === "success") {
					$success.text(message).css("color", "blue").show();
				}
			}
			// 비밀번호 입력 검사
			$("#findUpdate_PwInput").on("focus", function () {
				showMessage("findUpdatePw", "info", "영문자+숫자+특수문자 포함, 7~15자 이하");
			});
			$("#findUpdate_PwCheckInput").on("focus", function () {
				showMessage("findUpdatePwCheck", "info", "비밀번호를 다시 입력해주세요.");
			});

			$("#findUpdate_PwInput").on("blur", function () {
				let val = $(this).val();
				
				if (!val) {
					$("#findUpdatePwFieldCheck, #findUpdatePwError, #findUpdatePwMessage").hide();
					return;
				}
				
				if (!regex.pw.test(val)) {
					showMessage("findUpdatePw", "error", "비밀번호 형식이 올바르지 않습니다.");
				} else {
					showMessage("findUpdatePw", "success", "사용 가능한 비밀번호 입니다.");
				}
			});

			// 비밀번호 재입력 검사
			$("#findUpdate_PwCheckInput, #findUpdate_PwInput").on("input", function () {
				let pw = $("#findUpdate_PwInput").val();
				let pwCheck = $("#findUpdate_PwCheckInput").val();

				if (!pwCheck) {
					$("#findUpdatePwCheckFieldCheck, #findUpdatePwCheckError, #findUpdatePwMessage").hide();
					return;
				}
				if (pw === pwCheck) {
					showMessage("findUpdatePwCheck", "success", "비밀번호가 일치합니다.");
				} else {
					showMessage("findUpdatePwCheck", "error", "비밀번호가 일치하지 않습니다.");
				}
			});

			// 변경 버튼 클릭
			$("#find_Update_Btn").off("click").on("click", function () {
				let pw = $("#findUpdate_PwInput").val();
				let pwCheck = $("#findUpdate_PwCheckInput").val();

				if (!regex.pw.test(pw)) {
					alert("비밀번호 형식이 올바르지 않습니다.");
					return;
				}
				if (pw !== pwCheck) {
					alert("비밀번호가 일치하지 않습니다.");
					return;
				}

				$.ajax({
					url: "/api/member/findUpdatePw",
					type: "POST",
					data: { userId: userId, newPw: pw },
					success: function (res) {
						if (res.success) {
							alert("비밀번호가 성공적으로 변경되었습니다.");
							$("#findUpdateModal").modal("hide");
						} else {
							alert("비밀번호 변경에 실패했습니다. 입력 정보를 다시 확인해주세요");
						}
					},
					error: () => alert("서버 오류가 발생했습니다.")
				});
			});
		});

	</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />