<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 
여기에 코드 입력
 -->
 <style>
    * {
        box-sizing: border-box;
    }

    .container {
        border: 1px solid rgb(167, 166, 166);
        margin: auto;
        margin-top: 100px;
        width: 600px;
        min-height: 600px;
        border-radius: 40px;
    }

    h1 {
        margin-bottom: 30px;
        text-align: center;
    }

    .form-group {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
        padding-left: 30px;
        /* 수정 */
        margin-bottom: 10px;
        width: 100%;
    }

    .form-group>div {
        margin-left: 20px;
        padding: 10px 20px;
        width: 60%;
        height: 38px;
        border-radius: 8px;
        border: 1px solid #ccc;
    }

    .form-group label {
        width: 120px;
        margin: 0;
        text-align: right;
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
        margin-left: 40px;
        padding: 10px 20px;
        width: 60%;
        border-radius: 8px;
        border: 1px solid #ccc;
    }

    /* #address,
    #addressDetail {
        width: 80%;
    } */

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
        justify-content: center;
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

    .fieldCheckMessage {
        display: none;
        font-size: 0.9rem;
        margin-top: 5px;
        margin-left: 40px;
        width: 60%;
        color: gray;
    }
</style>
<!-- id, name , phoneNumber ,email, zipcode , address , address Detail  -->
    <!-- 정보  contenteditable="true" -->
    <div class="container">
        <main>
            <h1>회원정보</h1>
            <div class="form-group">
                <label for="id">ID</label>
                <div name="id" id="id" contenteditable="false"></div>
            </div>
            <div class="form-group">
                <label for="name">NAME</label>
                <div name="name" id="name" contenteditable="false"></div>
                <div class="fieldCheckMessage" id="nameFieldCheck">한글 1~6자 이하</div>
                <!-- <div class="error-message" id="nameError"></div> -->
            </div>
            <div class="form-group">
                <label for="phone">PHONE</label>
                <div name="phone" id="phone" contenteditable="false"></div>
                <div class="fieldCheckMessage" id="phoneFieldCheck">예 : 010-0000-0000 숫자 형식으로 입력</div>
                <!-- <div class="error-message" id="phoneError"></div> -->
            </div>
            <div class="form-group">
                <label for="email">E-mail</label>
                <div name="email" id="email" contenteditable="false"></div>
                <div class="fieldCheckMessage" id="emailFieldCheck">올바르지 않은 이메일 형식</div>
                <!-- <div class="error-message" id="emailError"></div> -->
            </div>
            <div class="form-group">
                <label for="zipcode">ZIPCODE</label>
                <div class="input-button-wrap">
                    <div name="zipcode" id="zipcode" contenteditable="false"></div>
                    <!-- <button type="button" id="zipcodeBtn" class="btn btn-outline-gray-main">찾기</button> -->
                </div>
            </div>
            <div class="form-group">
                <label for="address">ADDRESS</label>
                <div name="address" id="address" contenteditable="false"></div>
            </div>
            <div class="form-group">
                <label for="addressDetail">ADDRESS DETAIL</label>
                <div name="addressDetail" id="addressDetail" contenteditable="false"></div>
            </div>
            <div class="button-group">
                <button type="button" id="joinBtn" class="btn btn-outline-gray-main">회원정보 수정</button>
                <button type="button" class="btn btn-outline-gray-main">
                    <a href="/" style="text-decoration: none; color: inherit;">회원 탈퇴</a>
                </button>
            </div>
    </div>
    <script>
	$(function() {
		$.ajax ({
			url : "/api/member/userInpo",
			method : "post",
			dataType : "json"
		}).done(function(resp){
			
			let result =resp;
			
			$("#id").text(result.id);
			$("#name").text(result.name);
			$("#phone").text(result.phone);
			$("#email").text(result.email);
			$("#zipcode").text(result.zipcode);
			$("#address").text(result.address);
			$("#addressDetail").text(result.addressDetail);
		})
	})
    </script>
