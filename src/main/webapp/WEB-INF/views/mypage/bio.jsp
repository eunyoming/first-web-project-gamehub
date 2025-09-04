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
  align-items: center; /* 인풋과 라벨 세로 중앙 정렬 */
  margin-bottom: 20px;
  margin-left: 30px;
}

.form-group label {
  font-weight: bold;
  width: 100px;  /* 조금 줄여서 여백 균형 맞춤 */
  text-align: right;
  margin-right: 15px; /* 균형 잡힌 여백 */
  line-height: normal; /* 따로 지정 안 하고 flex에 맡김 */
}

.input-wrap {
  flex: 1;
  display: flex;
  flex-direction: column; /* input 아래 메시지가 붙도록 */
}

input[type="text"], input[type="email"] {
  padding: 10px 20px;
  width: 350px;
  max-width: 100%;
  border-radius: 8px;
  border: 1px solid #ccc;
}

.input-button-wrap {
  display: flex;
  align-items: center;
  gap: 8px; /* 버튼과 인풋 사이 여백 */
  width: 350px; /* 라벨 맞춘 input 기준 width 유지 */
}

.input-button-wrap input {
  flex: 1;         /* 버튼 뺀 나머지 공간 차지 */
  min-width: 0;    /* 넘치면 줄바꿈 방지 */
}

.input-button-wrap button {
  flex-shrink: 0;  /* 버튼 크기 고정 */
  white-space: nowrap; /* 버튼 텍스트 줄바꿈 방지 */
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
  margin-right: 40px;
}

.fieldCheckMessage,
.error-message,
.success-message {
  font-size: 0.9rem;
  margin-top: 5px;
}

.fieldCheckMessage {
  display: none;
  color: gray;
}

.error-message {
  color: red;
  display: none;
}

.success-message {
  color: green;
  display: none;
}

/* side menu */

.page-wrapper {
  display: flex;
  max-width: 1200px;
  margin: 40px auto;
  gap: 20px;
  padding-left: 40px;
  align-items: flex-start; /* 위쪽 라인 맞춤 */
}

.sidebar {
  width: 200px;
  background: #f7f7f7;
  border-radius: 20px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  /* height: fit-content; 삭제 */
  position: sticky;
  top: 0; /* 헤더 고정 말고 그냥 위에서 시작 */
  margin-top: 100px; /* container의 margin-top과 동일하게 */
}
/* h2 → 메뉴처럼 동작 */
.sidebar h2 {
  margin: 0;
  font-size: 1rem;
  font-weight: bold;
  text-align: center;
}

.sidebar h2 a {
  text-decoration: none;
  color: #333;
  display: block;
  padding: 8px 12px;
  border-radius: 8px;
  transition: all 0.2s ease-in-out;
  cursor: pointer;
}

.sidebar h2 a:hover,
.sidebar h2 a.active {
  background: #ddd;
  font-weight: bold;
}

/* ul (서브메뉴) */
.sidebar ul {
  list-style: none;
  padding: 0;
  margin: 0;
  font-size: 0.85rem;
  display: none; /* 기본 숨김 */
}

.sidebar ul li {
  margin-bottom: 8px;
}

.sidebar ul li a {
  display: block;
  padding: 6px 10px;
  border-radius: 6px;
  text-decoration: none;
  color: #333;
  text-align: center;
  transition: all 0.2s ease-in-out;
}

.sidebar ul li a:hover,
.sidebar ul li a.active {
  background: #ddd;
  font-weight: bold;
}

</style>

<div class="page-wrapper">
  <!-- 왼쪽 사이드 메뉴 -->
  <aside class="sidebar">
    <h2><a href="">Collection</a></h2>
    <ul>
      <li><a href="/api/member/mypage?section=collection&userId=${paramUserId}">최근 플레이 게임</a></li>
      <li><a href="/api/member/mypage?section=collection&userId=${paramUserId}">내 업적</a></li>
    </ul>
    <h2><a href="/api/member/mypage?section=bio&userId=${paramUserId}">Bio</a></h2>
    <ul>
      <li><a href="/api/member/mypage?section=bio&userId=${paramUserId}">내 정보</a></li>
      <li><a href="/api/member/mypage?section=secession&userId=${paramUserId}">회원 탈퇴</a></li>
    </ul>
    <h2><a href="">Bookmark</a></h2>
    <ul>
      <li><a href="/api/member/mypage?section=bookmark&userId=${paramUserId}">내 게시글</a></li>
      <li><a href="/api/member/mypage?section=bookmark&userId=${paramUserId}">내 댓글</a></li>
    </ul>
    <h2><a href="">Friend</a></h2>
    <ul>
      <li><a href="/api/member/mypage?section=friend&userId=${paramUserId}">친구 요청</a></li>
      <li><a href="/api/member/mypage?section=friend&userId=${paramUserId}">친구 신청</a></li>
      <li><a href="/api/member/mypage?section=friend&userId=${paramUserId}">친구 목록</a></li>
    </ul>
  </aside>
  
 <script>
  $(function(){
    // h2 클릭 시 ul 토글 + 세션스토리지 저장
    $(".sidebar h2").on("click", function(e){
      e.preventDefault();
      let $ul = $(this).next("ul");

      if($ul.hasClass("open")){
        $ul.removeClass("open").slideUp(200);
        sessionStorage.removeItem("openMenu"); // 닫으면 기록 삭제
      } else {
        $(".sidebar ul.open").removeClass("open").slideUp(200);
        $ul.addClass("open").slideDown(200);
        sessionStorage.setItem("openMenu", $(".sidebar h2").index(this)); // 몇 번째 h2인지 저장
      }
    });

    // li 클릭 시 ul 고정 유지 (열려있던 메뉴 기록도 갱신)
    $(".sidebar ul li a").on("click", function(){
      let $parentUl = $(this).closest("ul");
      $(".sidebar ul").not($parentUl).removeClass("open").slideUp(200);
      $parentUl.addClass("open").show();

      let parentIndex = $(".sidebar h2").index($parentUl.prev("h2"));
      sessionStorage.setItem("openMenu", parentIndex);
    });

    // 페이지 로드 시 마지막에 열어둔 메뉴 복원
    let openMenuIndex = sessionStorage.getItem("openMenu");
    if(openMenuIndex !== null){
      let $targetUl = $(".sidebar h2").eq(openMenuIndex).next("ul");
      $targetUl.addClass("open").show();
    }
  });
</script>

<div class="container">
	<main>
  <h1>회원정보</h1>
 <div class="form-group">
    <label for="id">ID</label>
    <div class="input-wrap">
      <input type="text" id="id" name="id" readonly>
    </div>
  </div>

  <div class="form-group">
    <label for="name">NAME</label>
    <div class="input-wrap">
      <input type="text" id="name" name="name" readonly>
      <div class="fieldCheckMessage">한글 1~6자 이하</div>
      <div class="error-message" id="nameError">이름 형식이 올바르지 않습니다.</div>
    </div>
  </div>

  <div class="form-group">
    <label for="phone">PHONE</label>
    <div class="input-wrap">
      <input type="text" id="phone" name="phone" readonly>
      <div class="fieldCheckMessage">예 : 010-0000-0000</div>
      <div class="error-message" id="phoneError">전화번호 형식이 올바르지 않습니다.</div>
    </div>
  </div>

  <div class="form-group">
    <label for="email">E-mail</label>
    <div class="input-wrap">
      <div class="input-button-wrap">
        <input type="text" name="email" id="email" placeholder="이메일을 입력하세요">
        <button type="button" id="emailCheckBtn" style="display: none;" class="btn btn-outline-gray-main">중복확인</button>
      </div>
      <div class="fieldCheckMessage" id="emailFieldCheck">예 : example@exam.com</div>
      <div class="success-message" id="emailCheckResult"></div>
      <div class="error-message" id="emailError">이메일 형식이 올바르지 않습니다.</div>
    </div>
  </div>

  <div class="form-group">
    <label for="zipcode">ZIPCODE</label>
    <div class="input-wrap">
      <div class="input-button-wrap">
        <input type="text" id="zipcode" name="zipcode" readonly>
        <button type="button" id="zipcodeBtn" style="display: none;">찾기</button>
      </div>
    </div>
  </div>

  <div class="form-group">
    <label for="address">ADDRESS</label>
    <div class="input-wrap">
      <input type="text" id="address" name="address" readonly>
    </div>
  </div>

  <div class="form-group">
    <label for="addressDetail">ADDRESS DETAIL</label>
    <div class="input-wrap">
      <input type="text" id="addressDetail" name="addressDetail" readonly>
    </div>
  </div>

  <div class="button-group">
    <button type="button" id="updateBtn">회원정보 수정</button>
    <a href="/"><button type="button" id="backBtn" style="display: inline-block;">뒤로가기</button></a>
    <button type="button" id="sucessBtn" style="display: none;">수정 완료</button>
    <button type="button" id="cancleBtn" style="display: none;">수정 취소</button>
  </div>
</main>
</div>

<script>
$(function() {
    let emailChecked = true; // 처음에는 기존 이메일 그대로라서 true

    // 회원정보 출력
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

 // 수정 버튼 클릭
    $("#updateBtn").on("click", function(){
     	$("#updateBtn, #secessionBtn, #backBtn").hide();
        $("#updateBtn, #secessionBtn").hide();
        $("#sucessBtn, #cancleBtn, #zipcodeBtn, #emailCheckBtn").show();
        $("#name, #phone, #email, #zipcode, #address, #addressDetail").prop("readonly", false);

        // focus/blur 이벤트 수정 모드일 때만 활성화
        $("input").on("focus.fieldMsg", function(){
            $(this).siblings(".fieldCheckMessage").show();
        }).on("blur.fieldMsg", function(){
            $(this).siblings(".fieldCheckMessage").hide();
        });
    });

    // 취소 버튼 클릭 시
    $("#cancleBtn").on("click", function(){
        $("input").off(".fieldMsg");  // focus/blur 이벤트 제거
        location.reload();
    });

    // 실시간 유효성 검사
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

    // 이메일 실시간 유효성 검사 (공백 제거 추가)
    $("#email").on("input", function(){
        let email = $(this).val().trim(); 
        $(this).val(email); // 자동으로 공백 제거 후 다시 세팅

        let regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if(!regex.test(email)){
            $("#emailError").show();
        } else {
            $("#emailError").hide();
        }
        $("#emailCheckResult").text(""); // 이메일 변경 시 중복확인 결과 초기화
        emailChecked = false;
    });

    // 이메일 중복확인 버튼
    $("#emailCheckBtn").on("click", function(){
        let email = $("#email").val().trim();
        $("#email").val(email); // input 값 갱신

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

    // 우편번호 API
    $("#zipcodeBtn").on("click", function () {
        new daum.Postcode({
            oncomplete: function (data) {
                $("#zipcode").val(data.zonecode);
                $("#address").val(data.roadAddress);
            }
        }).open();
    });

 // 수정 완료 버튼
    $("#sucessBtn").on("click", function(){
        // 유효성 검사
        if($("#nameError:visible, #phoneError:visible, #emailError:visible").length > 0){
            alert("입력값을 올바르게 수정해주세요.");
            return;
        }

        let email = $("#email").val().trim();
        $("#email").val(email); // 최종 값도 trim 적용

        if (!emailChecked) {
            alert("이메일 중복 확인을 해주세요.");
            $("#email").focus();
            return;
        }

        // DB 업데이트 요청
        $.ajax({
            url: "/api/member/userInpoUpdate",
            method: "post",
            data: {
                name: $("#name").val(),
                phone: $("#phone").val(),
                email: email,
                zipcode: $("#zipcode").val(),
                address: $("#address").val(),
                addressDetail: $("#addressDetail").val()
            },
            dataType: "json"
        }).done(function(resp){
            alert("회원정보가 성공적으로 수정되었습니다.");
            // 값 갱신
            $("#id").val(resp.id);
            $("#name").val(resp.name);
            $("#phone").val(resp.phone);
            $("#email").val(resp.email);
            $("#zipcode").val(resp.zipcode);
            $("#address").val(resp.address);
            $("#addressDetail").val(resp.addressDetail);

            // 조회 모드로 전환
            $("#sucessBtn, #cancleBtn, #zipcodeBtn, #emailCheckBtn").hide();
            $("#updateBtn, #secessionBtn").show();
            $("#name, #phone, #email, #zipcode, #address, #addressDetail").prop("readonly", true);

            $("input").off(".fieldMsg"); // 메시지 이벤트 해제
            emailChecked = true;
        }).fail(function(){
            alert("회원정보 수정에 실패했습니다.");
        });
    });
});
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>