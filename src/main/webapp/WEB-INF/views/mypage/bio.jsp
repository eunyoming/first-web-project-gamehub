<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
* {
	box-sizing: border-box;
}

.container {
	border: 1px solid rgb(167, 166, 166);
	margin: auto;
	margin-top: 100px;
	margin-bottom: 100px;
	width: 600px;
	min-height: 600px;
	border-radius: 40px;
	padding: 20px 0;
}

h1 {
	margin-bottom: 30px;
	text-align: center;
}

.form-group {
    display: flex;
    align-items: center;       /* 라벨과 인풋 세로 중앙 맞춤 */
    justify-content: flex-start;   /* 라벨+인풋 세트 자체를 가운데 정렬 */
    margin-bottom: 15px;
    gap: 10px;                 /* 라벨과 인풋 사이 간격 */
}

.form-group label {
    font-weight: bold;
    width: 120px;              /* 라벨 고정 너비 → 라벨 오른쪽 정렬 */
    text-align: right;
    margin-right: 10px;
    margin-bottom: 0;          /* 기존 column용 여백 제거 */
}
.fieldCheckMessage,
.error-message,
.success-message {
position: absolute;
    margin-left: calc(120px + 10px + 2px); /* label + margin-right + border */
    padding-left: 20px; /* input 좌측 padding 보정 */
    margin-top: 2px;
}

input[type="text"], input[type="email"] {
	padding: 10px 20px;
	width: 60%;
	border-radius: 8px;
	border: 1px solid #ccc;
}

.input-button-wrap {
	display: flex;
	align-items: center;
	gap: 5px;
	width: 60%;
}

.input-button-wrap input {
	flex: 1;
}

button {
	padding: 8px 16px;
	border-radius: 8px;
	border: 1px solid #666;
	background: #f5f5f5;
	cursor: pointer;
}

.button-group {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 40px;
	margin-right : 40px;
}

.fieldCheckMessage {
	display: none;
	font-size: 0.9rem;
	margin-top: 5px;
	color: gray;
}

.error-message {
	color: red;
	font-size: 0.9rem;
	margin-top: 5px;
	display: none;
}

.success-message {
	color: green;
	font-size: 0.9rem;
	margin-top: 5px;
	display: none;
}
</style>

<div class="container">
	<main>
		<h1>회원정보</h1>

		<div class="form-group">
			<label for="id">ID</label> <input type="text" id="id" name="id"
				readonly>
		</div>

		<div class="form-group">
			<label for="name">NAME</label> <input type="text" id="name"
				name="name" readonly>
				</div>
			<div class="fieldCheckMessage">한글 1~6자 이하</div>
			<div class="error-message" id="nameError">이름 형식이 올바르지 않습니다.</div>

		<div class="form-group">
			<label for="phone">PHONE</label> <input type="text" id="phone"
				name="phone" readonly>
				</div>
			<div class="fieldCheckMessage">예 : 010-0000-0000</div>
			<div class="error-message" id="phoneError">전화번호 형식이 올바르지 않습니다.</div>

		<div class="form-group">
			<label for="email">E-mail</label>
			<div class="input-button-wrap">
				<input type="text" name="email" id="email" placeholder="이메일을 입력하세요">
				<button type="button" id="emailCheckBtn" style="display: none;"
					class="btn btn-outline-gray-main">중복확인</button>
			</div>
			</div>
			<div class="fieldCheckMessage" id="emailFieldCheck">올바르지 않은 이메일
				형식</div>
			<div class="success-message" id="emailCheckResult"></div>
			<div class="error-message" id="emailError"></div>
		

		<div class="form-group">
			<label for="zipcode">ZIPCODE</label>
			<div class="input-button-wrap">
				<input type="text" id="zipcode" name="zipcode" readonly>
				<button type="button" id="zipcodeBtn" style="display: none;">찾기</button>
			</div>
		</div>

		<div class="form-group">
			<label for="address">ADDRESS</label> <input type="text" id="address"
				name="address" readonly>
		</div>

		<div class="form-group">
			<label for="addressDetail">ADDRESS DETAIL</label> <input type="text"
				id="addressDetail" name="addressDetail" readonly>
		</div>

		<div class="button-group">
			<button type="button" id="updateBtn">회원정보 수정</button>
			<button type="button" id="secessionBtn">회원 탈퇴</button>
			<button type="button" id="sucessBtn" style="display: none;">수정
				완료</button>
			<button type="button" id="cancleBtn" style="display: none;">수정
				취소</button>
		</div>
	</main>
</div>

<script>
$(function() {
    let emailChecked = true; // 처음에는 기존 이메일 그대로라서 true

    // 1. 회원정보 출력
    $.ajax({
        url : "/api/member/userInpo",
        method : "post",
        dataType : "json"
    }).done(function(resp){
        $("#id").val(resp.id);
        $("#name").val(resp.name);
        $("#phone").val(resp.phone);
        $("#email").val(resp.email);
        $("#zipcode").val(resp.zipcode);
        $("#address").val(resp.address);
        $("#addressDetail").val(resp.addressDetail);
    });

    // 2. 수정 버튼 클릭
    $("#updateBtn").on("click", function(){
        $("#updateBtn, #secessionBtn").hide();
        $("#sucessBtn, #cancleBtn, #zipcodeBtn, #emailCheckBtn").show();
        $("#name, #phone, #email, #zipcode, #address, #addressDetail").prop("readonly", false);
    });

    // 3. 취소 버튼 클릭
    $("#cancleBtn").on("click", function(){
        location.reload();
    });

    // 4. 포커스 시 안내 메시지 보이기
    $("input").on("focus", function(){
    	 $(this).closest(".form-group").next(".fieldCheckMessage").show();
    }).on("blur", function(){
    	$(this).closest(".form-group").next(".fieldCheckMessage").hide();
    });

    // 5. 실시간 유효성 검사
    $("#name").on("input", function(){
        let regex = /^[가-힣]{1,6}$/;
        if(!regex.test($(this).val())){
            $("#nameError").show();
        } else {
            $("#nameError").hide();
        }
    });

    $("#phone").on("input", function(){
        let regex = /^010-\d{4}-\d{4}$/;
        if(!regex.test($(this).val())){
            $("#phoneError").show();
        } else {
            $("#phoneError").hide();
        }
    });

    $("#email").on("input", function(){
        let regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if(!regex.test($(this).val())){
            $("#emailError").show();
        } else {
            $("#emailError").hide();
        }
        $("#emailCheckResult").text(""); // 이메일 변경 시 중복확인 결과 초기화
        emailChecked = false;
    });

    // 6. 이메일 중복확인 버튼
    $("#emailCheckBtn").on("click", function(){
        let email = $("#email").val().trim();
        let regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!regex.test(email)) {
            alert("이메일 형식이 올바르지 않습니다.");
            return;
        }

        $.ajax({
            url: "/api/member/emailCheck",
            data: { email: email },
            dataType: "json",
            success: function (resp) {
                if (resp.result) {
                    $("#emailCheckResult").text("이미 사용 중인 이메일입니다.").css("color", "red").show();
                    emailChecked = false;
                } else {
                    $("#emailCheckResult").text("사용 가능한 이메일입니다.").css("color", "blue").show();
                    emailChecked = true;
                }
            }
        });
    });

    // 7. 우편번호 API
    $("#zipcodeBtn").on("click", function () {
        new daum.Postcode({
            oncomplete: function (data) {
                $("#zipcode").val(data.zonecode);
                $("#address").val(data.roadAddress);
            }
        }).open();
    });

    // 8. 수정 완료 버튼 → DB 업데이트 요청
    $("#sucessBtn").on("click", function(){
        if($("#nameError:visible, #phoneError:visible, #emailError:visible").length > 0){
            alert("입력값을 올바르게 수정해주세요.");
            return;
        }

        if (!emailChecked) {
            alert("이메일 중복 확인을 해주세요.");
            $("#email").focus();
            return;
        }

        $.ajax({
            url: "/api/member/userInpoUpdate",
            method: "post",
            data: {
                name: $("#name").val(),
                phone: $("#phone").val(),
                email: $("#email").val(),
                zipcode: $("#zipcode").val(),
                address: $("#address").val(),
                addressDetail: $("#addressDetail").val()
            },
            dataType: "json"
        }).done(function(resp){
            alert("회원정보가 성공적으로 수정되었습니다.");
            // 화면 값 갱신
            $("#id").val(resp.id);
            $("#name").val(resp.name);
            $("#phone").val(resp.phone);
            $("#email").val(resp.email);
            $("#zipcode").val(resp.zipcode);
            $("#address").val(resp.address);
            $("#addressDetail").val(resp.addressDetail);

            // 다시 조회 모드로 전환
            $("#sucessBtn, #cancleBtn, #zipcodeBtn, #emailCheckBtn").hide();
            $("#updateBtn, #secessionBtn").show();
            $("#name, #phone, #email, #zipcode, #address, #addressDetail").prop("readonly", true);

            emailChecked = true;
        }).fail(function(){
            alert("회원정보 수정에 실패했습니다.");
        });
    });
 // 회원 탈퇴 버튼 클릭
    $("#secessionBtn").on("click", function(){
        if(confirm("정말 탈퇴하시겠습니까?")){
            $.post("/api/member/userSecession", function(){
                alert("회원탈퇴가 완료되었습니다.");
                location.href = "/"; // 메인 페이지로 이동
            }).fail(function(){
                alert("회원탈퇴 처리 중 오류가 발생했습니다.");
            });
        }
    });

});
</script>