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
  padding: 20px 30px;
}

h1 {
  margin-bottom: 30px;
  text-align: center;
}

/* side menu */
.page-wrapper {
  display: flex;
  max-width: 1200px;
  margin: 40px auto;
  gap: 20px;
  padding-left: 40px;
  align-items: flex-start;
}

.sidebar {
  width: 200px;
  background: #f7f7f7;
  border-radius: 20px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  position: sticky;
  top: 0;
  margin-top: 100px;
}

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

.sidebar ul {
  list-style: none;
  padding: 0;
  margin: 0;
  font-size: 0.85rem;
  display: none;
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

/* 회원 탈퇴 본문 */
.terms-box {
  margin-bottom: 20px;
}

.terms-box h2 {
  text-align: center;
  margin-bottom: 15px;
}

.terms-content {
  max-height: 250px;
  overflow-y: auto;
  padding: 15px;
  border: 1px solid #ccc;
  border-radius: 10px;
  font-size: 0.9rem;
  line-height: 1.5;
}

#agree {
margin-top: 30px;
}

.confirm-section {
  text-align: center;
  margin: 20px 0;
}

.button-group {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-top : 60px;
}

.button-group button {
  padding: 8px 20px;
  border-radius: 8px;
  border: 1px solid #ccc;
  cursor: pointer;
}

.button-group button:disabled {
  background: #eee;
  cursor: not-allowed;
}
</style>

<div class="page-wrapper">
  <!-- 왼쪽 사이드 메뉴 -->
  <aside class="sidebar">
    <h2><a href="">Collection</a></h2>
    <ul>
      <li><a href="">최근 플레이 게임</a></li>
      <li><a href="">내 업적</a></li>
    </ul>
    <h2><a href="/api/member/mypage?section=bio&userId=${paramUserId}">Bio</a></h2>
    <ul>
      <li><a href="/api/member/mypage?section=bio&userId=${paramUserId}">내 정보</a></li>
      <li><a href="/api/member/mypage?section=secession&userId=${paramUserId}">회원 탈퇴</a></li>
    </ul>
    <h2><a href="">Bookmark</a></h2>
    <ul>
      <li><a href="">내 게시글</a></li>
      <li><a href="">내 댓글</a></li>
    </ul>
    <h2><a href="">Friend</a></h2>
    <ul>
      <li><a href="">친구 요청</a></li>
      <li><a href="">친구 신청</a></li>
      <li><a href="">친구 목록</a></li>
    </ul>
  </aside>
  
 <script>
  $(function(){
    $(".sidebar h2").on("click", function(e){
      e.preventDefault();
      let $ul = $(this).next("ul");

      if($ul.hasClass("open")){
        $ul.removeClass("open").slideUp(200);
        sessionStorage.removeItem("openMenu");
      } else {
        $(".sidebar ul.open").removeClass("open").slideUp(200);
        $ul.addClass("open").slideDown(200);
        sessionStorage.setItem("openMenu", $(".sidebar h2").index(this));
      }
    });

    $(".sidebar ul li a").on("click", function(){
      let $parentUl = $(this).closest("ul");
      $(".sidebar ul").not($parentUl).removeClass("open").slideUp(200);
      $parentUl.addClass("open").show();

      let parentIndex = $(".sidebar h2").index($parentUl.prev("h2"));
      sessionStorage.setItem("openMenu", parentIndex);
    });

    let openMenuIndex = sessionStorage.getItem("openMenu");
    if(openMenuIndex !== null){
      let $targetUl = $(".sidebar h2").eq(openMenuIndex).next("ul");
      $targetUl.addClass("open").show();
    }
  });
</script>

<div class="container">
	<main>
  <div class="terms-box">
    <h1>회원 탈퇴 안내</h1>
    <div class="terms-content">
  <p>
    회원 탈퇴를 선택하신다는 것은,<br>
    그동안 함께 쌓아온 <strong>모든 기록과 추억을 스스로 지우는 것</strong>과 같습니다.
  </p>

  <ul>
    <li>오랜 시간 플레이하며 달성했던 <strong>업적과 랭킹 기록</strong></li>
    <li>하나하나 모아온 <strong>포인트와 보상 아이템</strong></li>
    <li>친구들과 함께 했던 <strong>즐거운 순간과 대화 기록</strong></li>
    <li>당신의 발자취가 담긴 <strong>게시글과 댓글</strong></li>
  </ul>

  <p>
    이 모든 것은 탈퇴와 동시에 <strong>되돌릴 수 없이 사라집니다.</strong><br>
    지금의 선택은 단 한 번의 클릭으로 <strong>영원히 후회할 수 있는 결정</strong>이 될 수 있습니다.
  </p>

  <p>
    혹시 잠시 힘들거나 불편해서 떠나려는 건 아닌가요?<br>
    조금만 더 생각해보신다면,<br>
    당신이 이곳에서 만들어온 추억과 가치가 얼마나 소중한지 다시 느끼실 수 있을 겁니다.
  </p>

  <hr>

  <h3>탈퇴 시 불이익 안내</h3>
  <ul>
    <li>계정 및 개인정보는 <strong>즉시 삭제</strong>되며, 복구가 불가능합니다.</li>
    <li>작성하신 게시글과 댓글은 <strong>삭제되지 않고 그대로 남아</strong> 다른 회원들에게 계속 노출됩니다.</li>
  </ul>

  <h3>보관되는 항목 (법적 근거)</h3>
  <ul>
    <li>계약 및 청약 철회 기록: 5년 (전자상거래법)</li>
    <li>대금 결제 및 재화 공급 기록: 5년 (전자상거래법)</li>
    <li>소비자 불만 및 분쟁 처리 기록: 3년 (전자상거래법)</li>
    <li>로그인 기록(IP 포함): 3개월 (통신비밀보호법)</li>
  </ul>

  <p>
    ⚠️ 지금까지의 모든 기록과 추억은 <strong>한순간에 사라지고, 다시는 돌아오지 않습니다.</strong><br>
    ⚠️ 서비스에 재가입하더라도 과거의 데이터는 <strong>절대 복구되지 않습니다.</strong>
  </p>
</div>
  </div>

  <div class="confirm-section">
    <label>
      <input type="checkbox" id="agree"> 안내사항을 모두 확인하였으며, 이에 동의합니다.
    </label>
  </div>

  <div class="button-group">
   <a href="/api/member/mypage?section=bio&userId=${paramUserId}"><button type="button" id="cancelBtn">취소</button></a>
    <button type="button" id="secessionBtn" disabled>회원 탈퇴</button>
  </div>
</div>

<script>
// 체크박스 동의해야 버튼 활성화
$("#agree").on("change", function(){
  $("#secessionBtn").prop("disabled", !this.checked);
});

//회원 탈퇴 버튼 클릭
$("#secessionBtn").on("click", function(){
    if(confirm("저희와 함께 쌓아온 추억을 정말로 지우시겠습니까?")){
        $.post("/api/member/userSecession", function(){
            alert("회원탈퇴가 완료되었습니다.");
            location.href = "/";
        }).fail(function(){
            alert("회원탈퇴 처리 중 오류가 발생했습니다.");
        });
    }
});
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>