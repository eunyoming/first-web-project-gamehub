<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
request.setAttribute("pageTitle", "메인페이지");
%>


<jsp:include page="/WEB-INF/views/common/header.jsp" />
<!-- <html><head></head><body> -->
<!-- 
여기에 코드 입력
 -->
<style>
.strips {
	min-height: 100vh;
	text-align: center;
	overflow: hidden;
	color: white;
}

.strips__strip {
	will-change: width, left, z-index, height;
	position: absolute;
	width: 20%;
	min-height: 100vh;
	overflow: hidden;
	cursor: pointer;
}

.strips__strip:nth-child(1) {
	left: 0;
}

.strips__strip:nth-child(2) {
	left: 20vw;
}

.strips__strip:nth-child(3) {
	left: 40vw;
}

.strips__strip:nth-child(4) {
	left: 60vw;
}

.strips__strip:nth-child(5) {
	left: 80vw;
}

.strips__strip:nth-child(1) .strip__content {
	background: linear-gradient(to right, var(--red-color),
		var(--peach-color));
	transform: translate3d(-100%, 0, 0);
}

.strips__strip:nth-child(2) .strip__content {
	background-image: url("/games/game2/assets/image/startPage.png");
	background-size: cover;
  background-position: center;
	
	transform: translate3d(0, 100%, 0);
}

.strips__strip:nth-child(3) .strip__content {
	background: linear-gradient(to right, var(--navy-color),
		var(--main-color));
	transform: translate3d(0, -100%, 0);
}

.strips__strip:nth-child(4) .strip__content {
	background-image: url("/games/game4/assets/tetrisSceneBackground1.png");
	background-size: cover;
  background-position: center;
	
	transform: translate3d(0, 100%, 0);
}

.strips__strip:nth-child(5) .strip__content {
	background: linear-gradient(to right, var(--main-color) 0%,
		var(--accent-color) 100%);
	transform: translate3d(100%, 0, 0);
}

@media screen and (max-width: 760px) {
	.strips__strip {
		min-height: 20vh;
	}
	.strips__strip:nth-child(1) {
		top: 0;
		left: 0;
		width: 100%;
	}
	.strips__strip:nth-child(2) {
		top: 20vh;
		left: 0;
		width: 100%;
	}
	.strips__strip:nth-child(3) {
		top: 40vh;
		left: 0;
		width: 100%;
	}
	.strips__strip:nth-child(4) {
		top: 60vh;
		left: 0;
		width: 100%;
	}
	.strips__strip:nth-child(5) {
		top: 80vh;
		left: 0;
		width: 100%;
	}
}

.strips .strip__content {
	display: flex;
	align-items: center;
	justify-content: center;
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	text-decoration: none;
}

.strips .strip__content:before {
	content: "";
	position: absolute;
	z-index: 1;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: white;
	opacity: 0.05;
	transform-origin: center center;
	transform: skew(-30deg) scaleY(1) translate(0, 0);
	transition: all 0.6s cubic-bezier(0.23, 1, 0.32, 1);
}

.strips .strip__content:hover:before {
	transform: skew(-30deg) scale(3) translate(0, 0);
	opacity: 0.1;
}

.strips .strip__inner-text {
	color: #fff; /* 하얀색 글씨 */
	text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.6); /* 어두운 그림자 */
	font-family: 'Danjo', sans-serif;
	will-change: transform, opacity;
	position: absolute;
	z-index: 5;
	top: 50%;
	left: 50%;
	width: 70%;
	transform: translate(-50%, -50%) scale(0.5);
	opacity: 0;
}

.strips__strip--expanded {
	width: 100%;
	top: 100vh +100 !important;
	left: 0 !important;
	z-index: 3;
	cursor: default;
	transition: all 0.5s cubic-bezier(0.23, 1, 0.32, 1); /* 확대/축소 부드럽게 */
}

@media screen and (max-width: 760px) {
	.strips__strip {
		position: relative; /* 기존 absolute 제거, 위에서 아래로 쌓이게 */
		width: 100%;
		min-height: 20vh;
		left: 0 !important;
		top: auto !important; /* 기존 top 제거 */
		margin-bottom: 10px; /* 스트립 사이 간격 */
	}

	/* 모바일에서 expanded */
	.strips__strip--expanded {
		width: 100%;
		min-height: 100vh; /* 화면 전체 차지 */
		top: auto !important; /* relative라 top 필요 없음 */
		left: 0 !important;
		z-index: 3;
		cursor: default;
	}
}

.strips__strip--expanded .strip__content:hover:before {
	transform: skew(-30deg) scale(1) translate(0, 0);
	opacity: 0.05;
}

.strips__strip--expanded .strip__title {

	opacity: 0;
}

.strips__strip--expanded .strip__inner-text {
	opacity: 1;
	transform: translate(-50%, -50%) scale(1);
}

.strip__title {
	font-family: 'Danjo', sans-serif;
	color: #fff; /* 하얀색 글씨 */
	text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.6); /* 어두운 그림자 */
	display: block;
	margin: 0;
	position: relative;
	z-index: 2;
	width: 100%;
	font-size: 3.5vw;
	color: white;
	word-break: keep-all;
white-space: normal;
}

@media screen and (max-width: 760px) {
	.strip__title {
		font-size: 28px;
	}
}

.strip__close {
	opacity: 0;
	cursor: pointer;
}

.strip__game {
	opacity: 0;
	cursor: pointer;
}

.strip__game--show {
	opacity: 1;
}

.strip__close--show {
	opacity: 1;
}

body.expanded-mode {
  overflow: hidden;
}


h1, h2 {
	font-weight: 300;
}

h2 {
	font-size: 36px;
	margin: 0 0 16px;
}

.fa {
	font-size: 30px;
	color: white;
}
</style>

<section class="container-fluid p-5 main-section bg-main-waves">
	<div class="mb-4">
		<h2>버튼 모음</h2>
		<p>기본적으로 btn 클래스는 무조건 포함임</p>
	</div>
	<div class="d-flex justify-content-center gap-3 mb-4">
		<button class="btn btn-blue-main">btn-blue-main</button>
		<button class="btn btn-purple-main">btn-purple-main</button>
		<button class="btn btn-outline-blue-main">btn-outline-blue-main</button>
		<button class="btn btn-outline-purple-main">btn-outline-purple-main</button>

	</div>
	<div class="d-flex justify-content-center gap-3 mb-4">
		<button class="btn btn-red-main">btn-red-main</button>
		<button class="btn btn-yellow-main">btn-yellow-main</button>
		<button class="btn btn-outline-red-main">btn-outline-red-main</button>
		<button class="btn btn-outline-yellow-main">btn-outline-yellow-main</button>

	</div>
	<div class="d-flex justify-content-center gap-3 mb-4">
		<button class="btn btn-green-main">btn-green-main</button>
		<button class="btn btn-peach-main">btn-peach-main</button>
		<button class="btn btn-outline-green-main">btn-outline-green-main</button>
		<button class="btn btn-outline-peach-main">btn-outline-peach-main</button>

	</div>
	<div class="d-flex justify-content-center gap-3 mb-4">
		<button class="btn btn-navy-main">btn-navy-main</button>
		<button class="btn btn-gray-main">btn-gray-main</button>
		<button class="btn btn-outline-navy-main">btn-outline-navy-main</button>
		<button class="btn btn-outline-gray-main">btn-outline-gray-main</button>

	</div>

	<div class="d-flex justify-content-center gap-3 mb-4">
		<button class="btn btn-gradient btn-blue-purple">btn-blue-purple</button>
		<button class="btn btn-gradient btn-red-peach">btn-red-peach</button>
		<button class="btn btn-gradient btn-yellow-green">btn-yellow-green</button>
		<button class="btn btn-gradient btn-navy-blue">btn-navy-blue</button>
		<button class="btn btn-gradient btn-gray-purple">btn-gray-purple</button>

	</div>

	<div class="d-flex justify-content-center gap-3 mb-4">
		<a href="/api/manage/main"><button class="btn btn-blue-main">관리자
				페이지 확인용</button></a> <a href="/api/member/mypage?section=collection&userId=${loginId}"><button
				class="btn btn-purple-main">마이페이지 확인용</button></a>
					<form action="/api/friends/request" method="post">
				<input type="hidden" name="toUser" value="friend001">
				  <input type="hidden" name="fromUser" value="${loginId}">
				  <button type="submit" class="btn btn-outline-blue-main"> friend001에게 친구 요청</button>
	</form> 
	</div>


</section>
<section class="strips strips-container">
	<article class="strips__strip">
		<div class="strip__content">
			<h1 class="strip__title">게임1</h1>
			<div class="strip__inner-text">
				<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
						<h2>게임1</h2>
						<p>게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<img src="your-image.jpg" alt="대체이미지" class="img-fluid mb-3">
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=1" class="btn btn-navy-main strip__game">게임하러 가기</a>

							<button class="btn btn-navy-main strip__close">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<article class="strips__strip">
		<div class="strip__content">
			<h1 class="strip__title">스페이스 배틀</h1>
			<div class="strip__inner-text">
				<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
						<h2>스페이스 배틀</h2>
						<p>게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<video src="/games/game2/thumbnails/gamevideo.mp4" autoplay muted loop class="img-fluid mb-3"></video>
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=2"><button
									class="btn btn-navy-main strip__game">게임하러 가기</button></a>
							<button class="btn btn-navy-main strip__close btn">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<article class="strips__strip">
		<div class="strip__content">
			<h1 class="strip__title">게임3</h1>
			<div class="strip__inner-text">
			<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
						<h2>게임3</h2>
						<p>게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<img src="your-image.jpg" alt="대체이미지" class="img-fluid mb-3">
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=5"><button
									class="btn btn-navy-main strip__game">게임하러 가기</button></a>
							<button class="btn btn-navy-main strip__close btn">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<article class="strips__strip">
		<div class="strip__content">
			<h1 class="strip__title">테트리스</h1>
			<div class="strip__inner-text">
			<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
						<h2>테트리스</h2>
						<p>게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<video src="/games/game4/thumbnails/tetrisGame.mp4" autoplay muted loop class="img-fluid mb-3"></video>
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=4"><button
									class="btn btn-navy-main strip__game">게임하러 가기</button></a>
							<button class="btn btn-navy-main strip__close btn">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<article class="strips__strip">
		<div class="strip__content">
			<h1 class="strip__title">게임5</h1>
			<div class="strip__inner-text">
			<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
						<h2>게임5</h2>
						<p>게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<img src="your-image.jpg" alt="대체이미지" class="img-fluid mb-3">
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=1"><button
									class="btn btn-navy-main strip__game">게임하러 가기</button></a>
							<button class="btn btn-navy-main strip__close btn">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<i class="fa fa-close strip__close"></i>
</section>

<section class="container-fluid hero">
	<img src="/asset/img/stacked-peaks.png" alt="배경" class="responsive-img">
</section>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollTrigger.min.js"></script>
<script>
//Expand 모듈 (GSAP 버전)
gsap.registerPlugin(ScrollTrigger);

// --- 초기 애니메이션 (strip1~5 keyframes 대체)
const stripsTimeline = gsap.timeline();

const strips = document.querySelectorAll('.strips__strip');
strips.forEach((strip, index) => {
  const content = strip.querySelector('.strip__content');
  let fromVars = { x: "0%", y: "0%" };

  if (index === 0) fromVars = { x: "-100%" };
  else if (index === 1) fromVars = { y: "100%" };
  else if (index === 2) fromVars = { y: "-100%" };
  else if (index === 3) fromVars = { y: "100%" };
  else if (index === 4) fromVars = { x: "100%" };

  stripsTimeline.fromTo(content, fromVars, {
    x: "0%",
    y: "0%",
    duration: 1,
    ease: "power3.out"
  }, index * 0.3); // 기존 delay 반영
});


ScrollTrigger.create({
  trigger: ".strips-container",
  start: "top top",               // trigger의 top이 뷰포트 top에 닿을 때 시작
  end: "bottom top",
  scrub: true,
  pin:true,
  pinSpacing: true,
  animation: stripsTimeline,
  invalidateOnRefresh: true

});

var Expand = (function() {
    var tile = $('.strips__strip');
    var tileLink = $('.strips__strip > .strip__content');
    var tileText = tileLink.find('.strip__inner-text');
    var stripClose = $('.strip__close');
    var stripGame = $('.strip__game');
    var expanded = false;

    var open = function(event) {
       
        var tileEl = $(this).parent();
        var index = tileEl.index();

        if (!expanded) {
          

            tileEl.addClass('strips__strip--expanded');
            tileEl.css('z-index', '10');
            $('body').addClass('expanded-mode');
            tileText.css('transition', 'all .5s .3s cubic-bezier(0.23, 1, 0.32, 1)');
            stripClose.addClass('strip__close--show');
            stripGame.addClass('strip__game--show');
            stripClose.css('transition', 'all .6s 1s cubic-bezier(0.23, 1, 0.32, 1)');
            stripGame.css('transition', 'all .6s 1s cubic-bezier(0.23, 1, 0.32, 1)');
            expanded = true;
        }
    };

    var close = function(event) {
        event.stopPropagation();
        if (expanded) {
            $('.strips__strip--expanded').removeClass('strips__strip--expanded');
            $('.strips__strip').css('z-index', '3'); 
            $('body').removeClass('expanded-mode'); 
            tileText.css('transition', 'all 0.15s 0 cubic-bezier(0.23, 1, 0.32, 1)');
            stripClose.removeClass('strip__close--show');
            stripGame.removeClass('strip__game--show');
            stripClose.css('transition', 'all 0.2s 0s cubic-bezier(0.23, 1, 0.32, 1)');
            stripGame.css('transition', 'all 0.2s 0s cubic-bezier(0.23, 1, 0.32, 1)');

         
            expanded = false;
        }
    };

    var bindActions = function() {
        tileLink.on('click', open);
        stripClose.on('click', close);
        
    };

    var init = function() {
        bindActions();
    };

    return {
        init: init
    };
}());

Expand.init();


if ('scrollRestoration' in history) {
	  history.scrollRestoration = 'manual';
	}

        </script>
<!-- </body></html> -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />