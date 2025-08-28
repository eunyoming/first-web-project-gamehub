<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 페이지</title>
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
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<style>
 * {
        box-sizing: border-box;
    }

    .login_box {
        margin-top: 100px;
        border: 1px solid gray;
        width: 600px;
        min-height: 1200px;
        padding: 40px;
    }

    h1 {
        margin-bottom: 30px;
        /* h1과 그 아래 요소 사이 간격 */
        text-align: center;
        /* h1 텍스트 가운데 정렬 */
    }

    .form-group {
        margin-bottom: 10px;
        width: 100%;
    }

    label {
        display: block;
        margin-left: 40px;
        margin-bottom: 4px;
        font-weight: bold;
    }

    input[type="text"],
    input[type="password"],
    input[type="email"] {
        display: block;
        /* 줄바꿈되게 블록 요소로 설정 */
        margin-left: 40px;
        padding: 10px 20px;
        width: 60%;
        border-radius: 8px;
        /* 둥근 모서리 */
        border: 1px solid #ccc;
        /* 테두리 스타일 통일 */
        cursor: pointer;
        /* 마우스 올리면 포인터로 변경 */
    }

    #address,
    #addressDetail {
        width: 80%;
    }


    button {
        margin-left: 20px;
        margin-bottom: 15px;
    }

    .input-button-wrap {
        display: flex;
        /* 내부 요소를 가로로 나란히 배치 */
        align-items: center;
        /* 세로 방향으로 가운데 정렬 */
        gap: 1px;
        /* 인풋과 버튼 사이 간격 */
    }

    .input-button-wrap button {
        white-space: nowrap;
        /* 버튼 텍스트 줄바꿈 방지 */
    }

    .information {
        margin-left: 40px;
        width: 80%;
        border: 1px solid grey;
        height: 100px;
        overflow-y: scroll;
    }

    .form-group .info-label {
        margin-left: 40px;
        font-weight: bold;
        margin-bottom: 8px;
    }

    .form-footer {
        margin-left: 40px;
        margin-top: 10px;
    }

    .form-footer label {
        margin-left: 0;
    }

    .button-group {
        display: flex;
        justify-content: flex-start;
        gap: 10px;
        margin-left: 130px;
        gap: 10px;
        margin-top: 40px;
    }

    /* 유효성 검사 에러 메시지 */
  .error-message {
  color: red;
  font-size: 14px;
  margin-top: 5px;
  margin-left: 40px;
  width: 60%;       
}
.success-message {
  color: green;
  font-size: 14px;
  margin-top: 5px;
  margin-left: 40px;
  width: 60%;
}
</style>
<body
	style="background-image: url('https://picsum.photos/1920/1080'); background-size: cover; background-position: center;">


	<main>
		<div
			class="container d-flex justify-content-center align-items-center vh-100 ">

			<div class="login_box shadow-lg p-5 mb-5 g-5 rounded blur-bg-login">
				<form action="/api/member/insert" method="post" id="joinForm"
					accept-charset="UTF-8">
					<h1>회원가입</h1>
					<div class="form-group">
                <label for="id">ID</label>
                <div class="input-button-wrap"><input type="text" name="id" id="id" placeholder="아이디를 입력하세요">
                    <button type="button" id="idcheckBtn" class="btn btn-outline-gray-main">중복확인</button>
                </div>
                <div class="success-message" id="checkResult"></div>
                <div class="error-message" id="idError"></div>
            </div>
            <div class="form-group">
                <label for="pw">PW</label> <input type="password" name="pw" id="pw" placeholder="비밀번호를 입력하세요">
            <div class="error-message" id="pwError"></div>
            </div>
            <div class="form-group">
                <label for="pwCheck">PW CHECK</label> <input type="password" name="pwCheck" id="pwCheck"
                    placeholder="비밀번호 한번 더 입력하세요">
                <div class="success-message" id="pwMessage"></div>
            </div>
            <div class="form-group">
                <label for="name">NAME</label> <input type="text" name="name" id="name" placeholder="이름을 입력하세요">
                <div class="error-message" id="nameError"></div>
            </div>
            <div class="form-group">
                <label for="phone">PHONE</label> <input type="text" name="phone" id="phone" placeholder="전화번호를 입력하세요">
                <div class="error-message" id="phoneNumberError"></div>
            </div>
            <div class="form-group">
                <label for="email">E-mail</label><input type="text" name="email" id="email" placeholder="이메일을 입력하세요">
                <div class="error-message" id="emailError"></div>
            </div>
            <div class="form-group">
                <label for="zipcode">ZIPCODE</label>
                <div class="input-button-wrap"><input type="text" name="zipcode" id="zipcode" placeholder="우편번호"
                        readonly>
                    <button type="button" id="zipcodeBtn" class="btn btn-outline-gray-main">찾기</button>
                </div>
            </div>
            <div class="form-group">
                <label for="address">ADDRESS</label><input type="text" name="address" id="address" placeholder="주소"
                    readonly>
            </div>
            <div class="form-group">
                <label for="addressDetail">ADDRESS DETAIL</label><input type="text" name="addressDetail"
                    id="addressDetail" placeholder="상세주소를 입력하세요">
            </div>
            <div class="form-group">
                <div class="info-label">개인정보 동의사항</div>
                <div class="information"></div>
                <div class="form-footer">
                    <label>
                        <input type="checkbox" name="privacy_agreed_at" value="Y" required>
                        동의여부 체크 </label>
                </div>
                <div class="button-group">
                    <button type="submit" id="joinBtn" class="btn btn-outline-gray-main">회원가입</button>
                    <button type="button" id="cancleBtn" class="btn btn-outline-gray-main">취소</button>
                </div>
            </div>
				</form>
			</div>
		</div>
		<script>
			// ID 중복 확인
			$(document).ready(function () {
			$("#idcheckBtn").on("click",function (){
				
				let id = $("#id").val();
				$.ajax({
					url:"/api/member/idCheck",
					data: {id:$("#id").val()},
					dataType : "json",
					success : function (response) {
						if (response.result) {
							$("#checkResult").text("이미 사용 중인 아이디 입니다.").css("color","red");
						} else {
							$("#checkResult").text("사용 가능한 아이디 입니다.").css("color","blue");
						}
					}
				})
			})
			});


			// 유효성 검사
			$(document)
					.ready(
							function() {

								// ID 검사
								$("#id")
										.on(
												"blur",
												function() {
													let id = $("#id").val();
													let regexId = /^(?=.*[a-z])(?=.*\d)[a-z0-9]{4,12}$/;

													if (!regexId.test(id)) {
														$("#idError")
																.text(
																		" 소문자+숫자 포함, 4~12자 이하 ");
													} else {
														$("#idError").text("");
													}
												})

								// PW 검사
								$("#pw")
										.on(
												"blur",
												function() {
													let pw = $("#pw").val();
													let regexPw = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[^\w\s])[^\s]{7,15}$/;

													if (!regexPw.test(pw)) {
														$("#pwError")
																.text(
																		" 영문자+숫자+특수문자 포함, 7~15자 이하 ");
													} else {
														$("#pwError").text("");
													}
												})
								// PW 일치 검사
								$("#pw,#pwCheck").on(
										"input",
										function() {
											let pw = $("#pw").val();
											let pwCheck = $("#pwCheck").val();

											if (pwCheck === "") {
												$("#pwMessage").text("");
												return;
											}

											if (pw === pwCheck) {
												$("#pwMessage").text(
														"비밀번호가 일치합니다.").css(
														'color', 'blue');
											} else {
												$("#pwMessage").text(
														"비밀번호가 일치하지 않습니다.")
														.css('color', 'red');
											}
										})
								// 이름 검사
								$("#name").on("blur", function() {
									let name = $("#name").val();
									let regexName = /^[가-힣]{1,6}$/;

									if (!regexName.test(name)) {
										$("#nameError").text(" 한글 1~6자 이하 ");
									} else {
										$("#nameError").text("");
									}
								})
								// 핸드폰 번호 검사
								$("#phone")
										.on(
												"blur",
												function() {
													let phoneNumber = $(
															"#phone")
															.val();
													let regexphoneNumber = /^010-\d{4}-\d{4}$/

													if (!regexphoneNumber
															.test(phoneNumber)) {
														$("#phoneNumberError")
																.text(
																		" 010-0000-000 숫자 형식으로 입력 ");
													} else {
														$("#phoneNumberError")
																.text("");
													}
												})
								// 이메일 검사
								$("#email")
										.on(
												"blur",
												function() {
													let email = $("#email")
															.val();
													let regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

													if (!regexEmail.test(email)) {
														$("#emailError")
																.text(
																		" 올바르지 않은 이메일 형식 ");
													} else {
														$("#emailError").text(
																"");
													}
												})
								

								// 최종 제출 시점 유효성 검사
								  // 최종 제출 시점 유효성 검사
					            $("#joinForm").on("submit", function (e) {
					    
					            	$(".error-message").text(""); // 에러메시지 초기화
					                let error = false;

					                $(".error-message").each(function(){

					                    if ($(this).text().trim() !== "") {
					                        error = true;
					                    }
					                });

					                if (error) {
					                    e.preventDefault();
					                    alert("입력값을 다시 확인해주세요.")
					                }
					            });
					        });
			// 우편번호 API
			$("#zipcodeBtn").on("click", function() {
				new daum.Postcode({
					oncomplete : function(data) {
						$("#zipcode").val(data.zonecode);
						$("#address").val(data.roadAddress);
					}
				}).open();
			});
		</script>

		<jsp:include page="/WEB-INF/views/common/footer.jsp" />