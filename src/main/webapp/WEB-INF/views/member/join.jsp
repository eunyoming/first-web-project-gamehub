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
	align-items: stretch;
	gap: 1px;
}

.input-button-wrap button {
	white-space: nowrap;
	/* 버튼 텍스트 줄바꿈 방지 */
	height: 42px; /* input과 동일하게 */
	padding: 0 16px;
	line-height: normal; /* 버튼 텍스트 세로 가운데 정렬 */
}


.input-button-wrap input[type="text"], .input-button-wrap input[type="email"]
	{
	height: 42px; /* input 높이 고정 */
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
							<button type="button" id="idCheckBtn"
								class="btn btn-outline-gray-main">중복확인</button>
						</div>
						<div class="fieldCheckMessage" id="idFieldCheck">소문자+숫자 포함,
							4~12자 이하</div>
						<div class="success-message" id="checkResult"></div>
						<div class="error-message" id="idError"></div>
					</div>
					<div class="form-group">
						<label for="pw">PW</label> <input type="password" name="pw"
							id="pw" placeholder="비밀번호를 입력하세요">
						<div class="fieldCheckMessage" id="pwFieldCheck">영문자+숫자+특수문자
							포함, 7~15자 이하</div>
						<div class="error-message" id="pwError"></div>
					</div>
					<div class="form-group">
						<label for="pwCheck">PW CHECK</label> <input type="password"
							name="pwCheck" id="pwCheck" placeholder="비밀번호 한번 더 입력하세요">
						<div class="fieldCheckMessage" id="pwCheckFieldCheck">비밀번호를
							다시 입력해주세요</div>
						<div class="error-message" id="pwCheckError"></div>
						<div class="success-message" id="pwMessage"></div>
					</div>
					<div class="form-group">
						<label for="name">NAME</label> <input type="text" name="name"
							id="name" placeholder="이름을 입력하세요">
						<div class="fieldCheckMessage" id="nameFieldCheck">한글 1~6자
							이하</div>
						<div class="error-message" id="nameError"></div>
					</div>
					<div class="form-group">
						<label for="phone">PHONE</label> <input type="text" name="phone"
							id="phone" placeholder="전화번호를 입력하세요">
						<div class="fieldCheckMessage" id="phoneFieldCheck">예 :
							010-0000-0000 숫자 형식으로 입력</div>
						<div class="error-message" id="phoneError"></div>
					</div>
					<div class="form-group">
						<label for="email">E-mail</label>
						<div class="input-button-wrap">
							<input type="text" name="email" id="email"
								placeholder="이메일을 입력하세요">
							<button type="button" id="emailCheckBtn"
								class="btn btn-outline-gray-main">중복확인</button>
						</div>
						<div class="fieldCheckMessage" id="emailFieldCheck">올바르지 않은
							이메일 형식</div>
						<div class="success-message" id="emailCheckResult"></div>
						<div class="error-message" id="emailError"></div>
					</div>
					<div class="form-group">
						<label for="zipcode">ZIPCODE</label>
						<div class="input-button-wrap">
							<input type="text" name="zipcode" id="zipcode" placeholder="우편번호"
								readonly>
							<button type="button" id="zipcodeBtn"
								class="btn btn-outline-gray-main">찾기</button>
						</div>
					</div>
					<div class="form-group">
						<label for="address">ADDRESS</label><input type="text"
							name="address" id="address" placeholder="주소" readonly>
					</div>
					<div class="form-group">
						<label for="addressDetail">ADDRESS DETAIL</label><input
							type="text" name="addressDetail" id="addressDetail"
							placeholder="상세주소를 입력하세요">
					</div>
					<div class="form-group">
						<div class="info-label">개인정보 동의사항</div>
						<div class="information">[게임 허브]는 이용자의 개인정보를 소중히 여기며, 「개인정보
							보호법」 및 관련 법령을 준수합니다. 본 개인정보 처리방침은 이용자가 회원가입 및 서비스 이용 시 제공한 개인정보가
							어떻게 수집, 이용, 보관, 보호되는지 알려드립니다. --- ## 제1조 (수집하는 개인정보 항목) 운영자는 서비스
							제공을 위해 다음과 같은 개인정보를 수집할 수 있습니다. 1. **회원가입 시** - 필수항목: 이메일 주소,
							비밀번호, 닉네임 - 선택항목: 프로필 이미지, 관심 게임 정보 1. **서비스 이용 시 자동 수집 항목** - 접속
							로그(IP 주소, 접속 기기, 브라우저 정보) - 서비스 이용 기록(게임 플레이 기록, 업적 달성 기록 등) -
							쿠키(Cookie) 및 세션 정보 --- ## 제2조 (개인정보의 수집 및 이용 목적) 수집한 개인정보는 다음
							목적에만 사용됩니다. 1. 회원가입, 로그인 및 본인 확인 2. 서비스 제공 및 이용 기록 관리 3. 게임 업적,
							랭킹, 친구 시스템 제공 4. 고객 문의 응답 및 민원 처리 5. 보안, 불법 이용 방지, 서비스 품질 향상 6.
							(선택 동의 시) 마케팅, 이벤트 및 광고 활용 --- ## 제3조 (개인정보의 보관 및 이용 기간) 1. 회원 탈퇴
							시 즉시 파기합니다. 2. 단, 관계 법령에 따라 다음 항목은 아래 기간 동안 보관할 수 있습니다. - 계약 및
							청약철회 기록: 5년 (전자상거래법) - 결제 및 서비스 이용 기록: 5년 (전자상거래법) - 로그 기록: 3개월
							(통신비밀보호법) --- ## 제4조 (개인정보의 제3자 제공) 운영자는 원칙적으로 이용자의 개인정보를 외부에
							제공하지 않습니다. 단, 다음의 경우에는 예외로 합니다. 1. 이용자가 사전에 동의한 경우 2. 법령에 의하여
							요구되는 경우 --- ## 제5조 (개인정보 처리 위탁) 운영자는 안정적인 서비스 제공을 위해 개인정보 처리를 외부
							업체에 위탁할 수 있습니다. 이 경우 위탁 업체명, 위탁 업무 범위를 사전에 공지하고 동의를 받습니다. --- ##
							제6조 (이용자의 권리 및 행사 방법) 1. 이용자는 언제든지 본인의 개인정보를 열람, 수정, 삭제할 수 있습니다.
							2. 회원 탈퇴 시 개인정보는 지체 없이 파기됩니다. 3. 개인정보 열람·정정·삭제는 [마이페이지] 메뉴 또는
							고객센터를 통해 가능합니다. --- ## 제7조 (개인정보 보호를 위한 기술적/관리적 대책) 운영자는 개인정보를
							안전하게 보호하기 위하여 다음과 같은 조치를 취합니다. - 비밀번호 암호화 저장 - 접근 권한 최소화 및 관리 -
							개인정보 접근 기록 보관 - 보안 프로그램 설치 및 정기 점검 --- ## 제8조 (쿠키(Cookie)의 이용) 1.
							서비스는 맞춤형 정보 제공을 위하여 쿠키를 사용할 수 있습니다. 2. 이용자는 웹 브라우저의 설정을 통해 쿠키 저장을
							거부할 수 있습니다. 단, 일부 서비스 이용에 제한이 있을 수 있습니다. --- ## 제9조 (개인정보 보호책임자)

							운영자는 개인정보 처리와 관련한 불만 및 피해 구제를 위하여 아래와 같이 개인정보 보호책임자를 지정합니다. -
							개인정보 보호책임자: [이름] - 이메일: [이메일 주소] - 연락처: [전화번호] --- ## 제10조 (개인정보
							처리방침 변경) 본 개인정보 처리방침은 법령 변경, 서비스 정책 변경에 따라 개정될 수 있으며, 개정 시에는 [게임
							허브 공지사항]을 통해 사전 공지합니다.</div>
						<div class="form-footer">
							<label> <input type="checkbox" name="privacy_agreed_at"
								value="Y" required> 동의여부 체크
							</label>
						</div>
						<div class="button-group">
							<button type="button" id="joinBtn"
								class="btn btn-outline-gray-main">회원가입</button>
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
		        email: /^[a-z0-9]+@[a-z0-9]+(?:\.com|\.co\.kr)$/
		    };

		    let regexMessage = {
		        id: "소문자+숫자 포함, 4~12자 이하",
		        pw: "영문자+숫자+특수문자 포함, 7~15자 이하",
		        pwCheck: "비밀번호를 다시 입력해주세요",
		        name: "한글 1~6자 이하",
		        phone: "예 : 010-0000-0000 숫자 형식으로 입력",
		        email: "예 : exam1@exam.com , exam1@exam.co.kr  ",
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