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
	text-align: center;
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

input[type="text"], input[type="password"], input[type="email"] {
	margin-left: 40px;
	padding: 10px 20px;
	width: 60%;
	border-radius: 8px;
	border: 1px solid #ccc;
	cursor: pointer;
}

#address, #addressDetail {
	width: 80%;
}

button {
	margin-left: 20px;
	margin-bottom: 15px;
}

.input-button-wrap {
	display: flex;
	align-items: center;
	gap: 1px;
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
.fieldCheckMessage {
  display: none;
  font-size: 0.9rem;
  margin-top: 5px;
  margin-left: 40px; 
  width: 60%;        
  color: gray;
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
            <div class="input-button-wrap">
                <input type="text" name="id" id="id" placeholder="아이디를 입력하세요">
                <button type="button" id="idCheckBtn" class="btn btn-outline-gray-main">중복확인</button>
            </div>
            <div class="fieldCheckMessage" id="idFieldCheck">소문자+숫자 포함, 4~12자 이하</div>
            <div class="success-message" id="checkResult"></div>
            <div class="error-message" id="idError"></div>
        </div>
        <div class="form-group">
            <label for="pw">PW</label> <input type="password" name="pw" id="pw" placeholder="비밀번호를 입력하세요">
            <div class="fieldCheckMessage" id="pwFieldCheck">영문자+숫자+특수문자 포함, 7~15자 이하</div>
            <div class="error-message" id="pwError"></div>
        </div>
        <div class="form-group">
            <label for="pwCheck">PW CHECK</label> <input type="password" name="pwCheck" id="pwCheck"
                placeholder="비밀번호 한번 더 입력하세요">
            <div class="fieldCheckMessage" id="pwCheckFieldCheck">비밀번호를 다시 입력해주세요</div>
            <div class="error-message" id="pwCheckError"></div>
            <div class="success-message" id="pwMessage"></div>
        </div>
        <div class="form-group">
            <label for="name">NAME</label> <input type="text" name="name" id="name" placeholder="이름을 입력하세요">
            <div class="fieldCheckMessage" id="nameFieldCheck">한글 1~6자 이하</div>
            <div class="error-message" id="nameError"></div>
        </div>
        <div class="form-group">
            <label for="phone">PHONE</label> <input type="text" name="phone" id="phone" placeholder="전화번호를 입력하세요">
            <div class="fieldCheckMessage" id="phoneFieldCheck">예 : 010-0000-0000 숫자 형식으로 입력</div>
            <div class="error-message" id="phoneError"></div>
        </div>
        <div class="form-group">
            <label for="email">E-mail</label>
            <div class="input-button-wrap">
            <input type="text" name="email" id="email" placeholder="이메일을 입력하세요">
            <button type="button" id="emailCheckBtn" class="btn btn-outline-gray-main">중복확인</button>
  			</div>
            <div class="fieldCheckMessage" id="emailFieldCheck">올바르지 않은 이메일 형식</div>
            <div class="success-message" id="emailCheckResult"></div>
            <div class="error-message" id="emailError"></div>
        </div>
        <div class="form-group">
            <label for="zipcode">ZIPCODE</label>
            <div class="input-button-wrap">
                <input type="text" name="zipcode" id="zipcode" placeholder="우편번호" readonly>
                <button type="button" id="zipcodeBtn" class="btn btn-outline-gray-main">찾기</button>
            </div>
        </div>
        <div class="form-group">
            <label for="address">ADDRESS</label><input type="text" name="address" id="address" placeholder="주소"
                readonly>
        </div>
        <div class="form-group">
            <label for="addressDetail">ADDRESS DETAIL</label><input type="text" name="addressDetail" id="addressDetail"
                placeholder="상세주소를 입력하세요">
        </div>
        <div class="form-group">
            <div class="info-label">개인정보 동의사항</div>
            <div class="information"></div>
            <div class="form-footer">
                <label> <input type="checkbox" name="privacy_agreed_at" value="Y" required> 동의여부 체크
                </label>
            </div>
            <div class="button-group">
                <button type="button" id="joinBtn" class="btn btn-outline-gray-main">회원가입</button>
                <button type="button" class="btn btn-outline-gray-main">
                    <a href="/" style="text-decoration: none; color: inherit;">취소</a>
                </button>
            </div>
        </div>
    </form>
			</div>
		</div>
		<script>
		$(document).ready(function () {
			
		    let idChecked = false;
		    let emailChecked = false;

		    // 정규식
		    let regex = {
		        id: /^(?=.*[a-z])(?=.*\d)[a-z0-9]{4,12}$/,
		        pw: /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[^\w\s])[^\s]{7,15}$/,
		        name: /^[가-힣]{1,6}$/,
		        phone: /^010-\d{4}-\d{4}$/,
		        email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/
		    };

		    let regexMessage = {
		        id: "소문자+숫자 포함, 4~12자 이하",
		        pw: "영문자+숫자+특수문자 포함, 7~15자 이하",
		        pwCheck: "비밀번호를 다시 입력해주세요",
		        name: "한글 1~6자 이하",
		        phone: "예 : 010-0000-0000 숫자 형식으로 입력",
		        email: "이메일 형식으로 입력해주세요 ",
		    };

		    let fields = ["id", "pw", "pwCheck", "name", "phone", "email"];

		    // 공통 메시지 출력 함수
		    function showMessage(fieldId, type, message) {
		    	
		        let $fieldCheck = $("#" + fieldId + "FieldCheck");
		        let $errorMessage = $("#" + fieldId + "Error");

		        if (type === "info") {
		            $fieldCheck.text(message).css({ "color": "gray", "display": "block" });
		            $errorMessage.hide();
		        } else if (type === "error") {
		            $fieldCheck.hide();
		            $errorMessage.text(message).css({ "color": "red", "display": "block" });
		        } else if (type === "success") {
		            $fieldCheck.hide();
		            $errorMessage.hide();
		        }
		    }

		    // 필드 유효성 검사
		    function validateField(fieldId, value) {
		        if (!value.trim()) {
		            showMessage(fieldId, "error", "필수 입력 항목입니다.");
		            return false;
		            
		        } if (regex[fieldId] && !regex[fieldId].test(value)) {
		            showMessage(fieldId, "error", regexMessage[fieldId]);
		            return false;
		        }

		        showMessage(fieldId, "success");
		        return true;
		    }

		    // 포커스 / 블러 이벤트
		    fields.forEach(function(fieldId) {
		        $("#" + fieldId).on("focus", function () {
		            showMessage(fieldId, "info", regexMessage[fieldId]);
		        });

		        $("#" + fieldId).on("blur", function () {
		            validateField(fieldId, $(this).val());
		        });
		    });

		    // ID 중복확인
		    $("#idCheckBtn").on("click", function () {
		        let id = $("#id").val().trim();
		        if (!regex.id.test(id)) {
		            alert("아이디 형식이 올바르지 않습니다.");
		            return;
		        }

		        $.ajax({
		            url: "/api/member/idCheck",
		            data: { id },
		            dataType: "json",
		            success: function (response) {
		                if (response.result) {
		                    $("#checkResult").text("이미 사용 중인 아이디입니다.").css("color", "red");
		                    idChecked = false;
		                } else {
		                    $("#checkResult").text("사용 가능한 아이디입니다.").css("color", "blue");
		                    idChecked = true;
		                }
		            }
		        });
		    });
		 // 이메일 중복확인
		    $("#emailCheckBtn").on("click", function () {
		        let email = $("#email").val().trim();
		        if (!regex.email.test(email)) {
		            alert("이메일 형식이 올바르지 않습니다.");
		            return;
		        }
		        $.ajax({
		            url: "/api/member/emailCheck",
		            data: { email },
		            dataType: "json",
		            success: function (response) {
		                if (response.result) {
		                    $("#emailCheckResult").text("이미 사용 중인 이메일입니다.").css("color", "red");
		                    emailChecked = false;
		                } else {
		                    $("#emailCheckResult").text("사용 가능한 이메일입니다.").css("color", "blue");
		                    emailChecked = true;
		                }
		            }
		        });
		    });
		 // ID 값이 바뀌면 중복확인 상태 초기화
		    $("#id").on("input", function () {
		        idChecked = false;
		        $("#checkResult").text("");
		    });
		    $("#email").on("input", function () {
		        emailChecked = false;
		        $("#emailCheckResult").text("");
		    });
		 // 비밀번호 일치 실시간 체크
		    $("#pw, #pwCheck").on("input", function () {
		        let pwVal = $("#pw").val();
		        let pwCheckVal = $("#pwCheck").val();

		        if (!pwCheckVal) {
		            $("#pwMessage").hide();
		            $("#pwCheckError").hide();
		            return;
		        }

		        if (pwVal === pwCheckVal) {
		            $("#pwMessage").text("비밀번호가 일치합니다.").css("color", "blue").show();
		            $("#pwCheckError").hide();
		        } else {
		            $("#pwMessage").hide();
		            $("#pwCheckError").text("비밀번호가 일치하지 않습니다.").css("color", "red").show();
		        }
		    });

		    // 우편번호 API
		    $("#zipcodeBtn").on("click", function () {
		        new daum.Postcode({
		            oncomplete: function (data) {
		                $("#zipcode").val(data.zonecode);
		                $("#address").val(data.roadAddress);
		            }
		        }).open();
		    });

		    // 회원가입 버튼
		    $("#joinBtn").on("click", function () {
		    	
		        let allValid = true;
		        let firstInvalidField = null;

		        fields.forEach(function(fieldId) {
		            let valid = validateField(fieldId, $("#" + fieldId).val());
		            if (!valid && !firstInvalidField) {
		                firstInvalidField = fieldId;
		            }
		            if (!valid) allValid = false;
		        });

		        if (!idChecked) {
		            alert("아이디 중복 확인을 해주세요.");
		            $("#id").focus();
		            return;
		        }
		        if (!emailChecked) {
		            alert("이메일 중복 확인을 해주세요.");
		            $("#email").focus();
		            return;
		        }

		        if (allValid) {
		        	 document.getElementById("joinForm").requestSubmit(); 
		        } else {
		            alert("입력값을 다시 확인해주세요.");
		            if (firstInvalidField) {
		                $("#" + firstInvalidField).focus();
		            }
		        }
		    });
		});
    </script>

		<jsp:include page="/WEB-INF/views/common/footer.jsp" />