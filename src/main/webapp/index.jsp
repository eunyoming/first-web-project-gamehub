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
	background-image: url("/games/game1/assets/image/gameTitle.png");
	background-size: cover;
	background-position: center;
	transform: translate3d(-100%, 0, 0);
}

.strips__strip:nth-child(2) .strip__content {
	background-image: url("/games/game2/assets/image/startPage.png");
	background-size: cover;
  background-position: center;
	
	transform: translate3d(0, 100%, 0);
}

.strips__strip:nth-child(3) .strip__content {
	background-image: url("/games/game3/thumbnails/thumbnails.png");
	background-size: cover;
  background-position: center;
	transform: translate3d(0, 100%, 0);
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

<section class="strips strips-container">
	<article class="strips__strip" data-seq="1">
		<div class="strip__content">
			<h1 class="strip__title">게임1</h1>
			<div class="strip__inner-text">
				<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
						<h2 class="display-5 fw-bold">게임1</h2>
						<p class="col-md-8 fs-4">게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<video src="/games/game1/thumbnails/gamevideo.mp4" autoplay muted loop class="img-fluid mb-3"></video>
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=1" > <button
									class="btn gameSelectBtn strip__game">게임하러 가기</button></a>

							<button class="btn gameSelectBtn strip__close">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<article class="strips__strip" data-seq="2">
		<div class="strip__content">
			<h1 class="strip__title">게임2</h1>
			<div class="strip__inner-text">
				<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
						<h2 class="display-5 fw-bold">게임2</h2>
						<p class="col-md-8 fs-4">게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<video src="/games/game2/thumbnails/gamevideo.mp4" autoplay muted loop class="img-fluid mb-3"></video>
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=2"><button
									class="btn gameSelectBtn strip__game">게임하러 가기</button></a>
							<button class="btn gameSelectBtn strip__close btn">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<article class="strips__strip" data-seq="3">
		<div class="strip__content">
			<h1 class="strip__title">게임3</h1>
			<div class="strip__inner-text">
			<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
						<h2 class="display-5 fw-bold">게임3</h2>
						<p class="col-md-8 fs-4">게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<img src="your-image.jpg" alt="대체이미지" class="img-fluid mb-3">
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=3"><button
									class="btn gameSelectBtn strip__game">게임하러 가기</button></a>
							<button class="btn gameSelectBtn strip__close btn">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<article class="strips__strip" data-seq="4">
		<div class="strip__content">
			<h1 class="strip__title">게임4</h1>
			<div class="strip__inner-text">
			<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
					<h2 class="display-5 fw-bold">게임4</h2>
						<p class="col-md-8 fs-4">게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<video src="/games/game4/thumbnails/tetrisGame.mp4" autoplay muted loop class="img-fluid mb-3"></video>
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=4"><button
									class="btn gameSelectBtn strip__game">게임하러 가기</button></a>
							<button class="btn gameSelectBtn strip__close btn">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<article class="strips__strip" data-seq="5">
		<div class="strip__content">
			<h1 class="strip__title">게임5</h1>
			<div class="strip__inner-text">
			<div class="row align-items-center">
					<div class="col-md-6 text-center text-md-start">
						<h2 class="display-5 fw-bold">게임5</h2>
						<p class="col-md-8 fs-4">게임 설명</p>
					</div>
					<div class="col-md-6 text-center">
						<img src="your-image.jpg" alt="대체이미지" class="img-fluid mb-3">
						<div class="d-flex justify-content-center gap-2">
							<a href="/api/game/main?game_seq=5"><button
									class="btn gameSelectBtn strip__game">게임하러 가기</button></a>
							<button class="btn gameSelectBtn strip__close btn">close</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</article>
	<i class="fa fa-close strip__close"></i>
</section>

<section class="container-fluid p-5 main-section bg-main-waves">
	<div class="container d-flex flex-column align-items-center">
  <img src="/asset/img/game_controller.svg" class="image-box mb-4 p-5" />

  <div   class="welcome-box text-center mb-5">
    <h1 class="font_YeogiOttae">
    
		<span class="line fw-bolder">쉽게 찾고</span>
		<span class="line fw-bolder">쉽게 플레이하세요</span>
	</h1>

    <h5 class="font_gowooDodum" class="text-center">
      <span class="line">사용자들과 경험을 나누고</span>
      <span class="line">자신의 취향을 공유하세요</span>
    </h5>
  </div>
  <div  class="welcome-box text-center">
   

    <h3 class="font_gowooDodum" class="text-center">
      <span class="line">오늘까지 게시판에 올라온 게시글 갯수는...!</span>
 		 <span class="line post-count">0</span>
    </h3>
  </div>
</div>


</section>
<section class="container-fluid p-5 main-section position-relative">
  <div class="container d-flex flex-column align-items-center">
    <img src="/asset/img/goodjob.png" class="image-box2 p-0" />
    <div class="welcome-box2 text-center mb-5">
      <h1 class="font_YeogiOttae">
        <span class="line fw-bolder">달성한 업적들을</span>
        <span class="line fw-bolder">장착해보세요</span>
      </h1>
      <h5 class="font_gowooDodum text-center">
        <span class="line">우리 잘했조?</span>
        <span class="line">자랑해보세요</span>
      </h5>
    </div>
  </div>

  <!-- 이미지 고정 위치 -->
 <div class="image-grid" id="imageContainer"></div>
</section>


<section class="container-fluid p-5 main-section bg-main-stacked">
<p>섹션3</p>

</section>

<script
  src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"
  integrity="sha512-..."
  crossorigin="anonymous"
  referrerpolicy="no-referrer"
></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollTrigger.min.js" integrity="sha512-..."
  crossorigin="anonymous"
  referrerpolicy="no-referrer"></script>
	
<script>

$(document).ready(function(){
    $.ajax({
        url: "/api/game/gameList",
        type: "GET",
        dataType: "json",
        success: function(data){
            data.forEach(game => {
                // 해당 seq를 가진 article 찾기
                let $strip = $('.strips__strip[data-seq="' + game.seq + '"]');

                if ($strip.length > 0) {
                    // 제목 교체
                    $strip.find('.strip__title').text(game.title);
                    $strip.find('h2').text(game.title);

                    // 설명 교체
                    $strip.find('p').text(game.description || '게임 설명 없음');

                    // 링크 교체
                    $strip.find('.strip__game').attr('href', '/api/game/main?game_seq=' + game.seq);
                }
            });
        }
    });


});



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

gsap.to(".image-box", {
    scrollTrigger: {
      trigger: ".image-box",
      start: "top 80%", 
      toggleActions: "play none none none", 
    },
    opacity: 1,
    y: 0,
    duration: 1
  });
  
gsap.to(".image-box2", {
    scrollTrigger: {
      trigger: ".image-box2",
      start: "top 80%", 
      toggleActions: "play none none none", 
    },
    opacity: 1,
    y: 0,
    duration: 1
  });  
gsap.to(".image-box", { 
	  rotation: 360,
	  duration: 2,
	  repeat: -1,
	  repeatDelay: 2,
	  ease: 'bounce.out'
	});

gsap.utils.toArray(".welcome-box .line").forEach((el, i) => {
	  gsap.to(el, {
	    scrollTrigger: {
	      trigger: ".welcome-box",
	      start: "top 70%",
	      toggleActions: "play none none none"
	    },
	    opacity: 1,
	    y: 0,
	    duration: 0.8,
	    delay: i * 0.5,
	    ease: "power2.out"
	  });
	});
	
gsap.utils.toArray(".welcome-box2 .line").forEach((el, i) => {
	  gsap.to(el, {
	    scrollTrigger: {
	      trigger: ".welcome-box2",
	      start: "top 70%",
	      toggleActions: "play none none none"
	    },
	    opacity: 1,
	    y: 0,
	    duration: 0.8,
	    delay: i * 0.5,
	    ease: "power2.out"
	  });
	});
function animatePostCount(targetCount) {
	  const counter = { value: 0 };
	  const $display = $('.post-count');

	  gsap.to(counter, {
	    value: targetCount,
	    duration: 4,
	    ease: "none",
	    scrollTrigger: {
	      trigger: ".post-count",
	      start: "top 80%",
	      toggleActions: "play none none none"
	    },
	    onUpdate: function() {
	      $display.text(Math.floor(counter.value) + "개!");
	    } ,onComplete: function () {
	    
	    }
	  });
	  
	  
	}


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
$.ajax({
	  url: '/total-board-count.board',
	  method: 'GET',
	  dataType: 'json',
	  success: function(data) {
	    animatePostCount(data.count);
	  }
	});
	
	
	//세번째 section 용
	


$.ajax({
  url: "/randomImages",
  type: "GET",
  dataType: "json",
  success: function(images) {
    const container = $("#imageContainer");
    container.empty();

    images.forEach((src, index) => {
    	  const wrapper = $('<div>', { class: 'image-wrapper' });
    	  const img = $('<img>', {
    	    src: src,
    	    class: 'img-fluid gsap-img',
    	    css: { opacity: 0, transform: 'translateY(50px)' }
    	  });
    	  wrapper.append(img);
    	  container.append(wrapper);
    	});

    // GSAP ScrollTrigger 애니메이션
    gsap.registerPlugin(ScrollTrigger);

    gsap.utils.toArray(".gsap-img").forEach((img, i) => {
      gsap.to(img, {
        opacity: 1,
        y: 0,
        duration: 2,
        delay: i * 0.2, // 순차적으로 등장
        ease: "power2.out",
        scrollTrigger: {
          trigger: img,
          start: "top 90%", // 화면에 거의 들어올 때
          toggleActions: "play none none none"
        }
      });
    });
  },
  error: function() {
    alert("이미지를 불러오는 데 실패했습니다.");
  }
});

        </script>
<!-- </body></html> -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />