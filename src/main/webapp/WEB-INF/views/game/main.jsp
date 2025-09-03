<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setAttribute("pageTitle", "게임페이지");
%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<script src="https://cdn.jsdelivr.net/npm/phaser@3/dist/phaser.js"></script>
<div
	class="container game_container d-flex justify-content-center align-items-center  flex-column">

	<!--  여기에 우리가 만들 게임이 include 됩니다. -->

		<div class="gameNavBar d-flex flex-wrap justify-content-center gap-3 w-100">
			<a href="/api/game/main?game_seq=1"><button class="btn gameSelectBtn" data-seq="1">게임1</button></a>
			<a href="/api/game/main?game_seq=2"><button class="btn gameSelectBtn" data-seq="2">게임2</button></a>
			<a href="/api/game/main?game_seq=3"><button class="btn gameSelectBtn" data-seq="3">게임3</button></a>
			<a href="/api/game/main?game_seq=4"><button class="btn gameSelectBtn" data-seq="4">게임4</button></a>
			<a href="/api/game/main?game_seq=5"><button class="btn gameSelectBtn" data-seq="5">게임5</button></a>
		
		</div>
	


	<div class=" w-100 flex-fill d-flex justify-content-center align-items-center" id="gamebox"></div>

	<c:choose>
		<c:when test="${param.game_seq == '1'}">

		</c:when>
		<c:when test="${param.game_seq == '2'}">
			<c:set var="imgPath" value="/games/game2/" />
			<c:set var="loginId" value="${loginId}" />


			<script>
    const IMG_PATH = "${imgPath}";
    const loginId = "${loginId}";
</script>
			<script src="/games/achievementPopup.js"></script>

			<script src="/games/game2/Intro.js"></script>
			<script src="/games/game2/MainGame.js"></script>
			<script src="/games/game2/Gameover.js"></script>
			<script>
    
    const GAME_WIDTH = 800;
    const GAME_HEIGHT = 900;

    let config = {
        type: Phaser.AUTO,
        parent:"gamebox" ,
        width:GAME_WIDTH,
        height: GAME_HEIGHT,
        scale: {
            mode: Phaser.Scale.FIT,
            autoCenter: Phaser.Scale.CENTER_BOTH,
            parent: "gamebox"
        },

        physics: {
            default: "arcade",
          arcade:{
        
          }

        },
        scene:[Intro, MainGame, Gameover]

    };

    let game = new Phaser.Game(config);
    </script>
		</c:when>

	<c:when test="${param.game_seq == '4'}">
		<c:set var="imgPath" value="/games/game4/" />
		<c:set var="loginId" value="${loginId}" />


	<script>
    const IMG_PATH = "${imgPath}";
    const loginId = "${loginId}";
	</script>
			<script src="/games/achievementPopup.js"></script>

			<script src="/games/game4/GameIntro.js"></script>
			<script src="/games/game4/tetris.js"></script>
			<script src="/games/game4/Gameover.js"></script>
			<script>
    
    const GAME_WIDTH = 650;
    const GAME_HEIGHT = 740;

    let config = {
        type: Phaser.AUTO,
        parent:"gamebox" ,
        width:GAME_WIDTH,
        height: GAME_HEIGHT,
       
        physics: {
            default: "arcade",
          arcade:{
        	  gravity: { y: 0 },
              debug: false
          }

        },
        scene:[GameIntro, tetris,Gameover]

    };

    let game = new Phaser.Game(config);
    </script>
		</c:when>
		<c:otherwise>
			<img alt="임시게임화면" src="/asset/img/임시게임화면.png">
		</c:otherwise>
	</c:choose>

</div>



<ul
	class="nav nav-tabs d-flex justify-content-center align-items-center"
	id="gameTab" role="tablist">
	<li class="nav-item" role="presentation">
		<button class="nav-link active" id="review-tab" data-bs-toggle="tab"
			data-bs-target="#review" type="button" role="tab">Review</button>
	</li>
	<li class="nav-item" role="presentation">
		<button class="nav-link" id="ranking-tab" data-bs-toggle="tab"
			data-bs-target="#ranking" type="button" role="tab">Ranking</button>
	</li>
	<li class="nav-item" role="presentation">
		<button class="nav-link" id="info-tab" data-bs-toggle="tab"
			data-bs-target="#info" type="button" role="tab">Info</button>
	</li>
	<li class="nav-item" role="presentation">
		<button class="nav-link" id="guide-tab" data-bs-toggle="tab"
			data-bs-target="#guide" type="button" role="tab">Guide</button>
	</li>


</ul>

<div class="tab-content mt-3" id="tabContent">
	<div class="tab-pane fade show active" id="review" role="tabpanel">
		<jsp:include page="/WEB-INF/views/game/review.jsp" />
	</div>
	<div class="tab-pane fade" id="ranking" role="tabpanel">
		<jsp:include page="/WEB-INF/views/game/ranking.jsp" />
	</div>
	<div class="tab-pane fade" id="guide" role="tabpanel">
		<jsp:include page="/WEB-INF/views/game/guide.jsp" />
	</div>
	<div class="tab-pane fade" id="info" role="tabpanel">
		<jsp:include page="/WEB-INF/views/game/info.jsp" />
	</div>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>

$.ajax({
    url: "/api/game/gameList",
    type: "GET",
    dataType: "json",
    success: function(data){
        data.forEach(game => {
            // 해당 seq를 가진 article 찾기
            let bTn = $('button[data-seq="' + game.seq + '"]');

           bTn.text(game.title);
        });
    }
});

function showSection(id) {
    const sections = ['guide', 'info', 'review', 'ranking'];
    sections.forEach(s => {
        document.getElementById(s).style.display = (s === id) ? 'block' : 'none';
    });
}

$(window).on("scroll", function () {
    const canvasTop = $("canvas").offset().top - $(window).scrollTop();

    if (canvasTop <= 100) {
        $("header").fadeOut(); // 부드럽게 숨김
    } else {
        $("header").fadeIn(); // 다시 보이게
    }
});
</script>