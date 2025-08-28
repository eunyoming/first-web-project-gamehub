<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<script src="https://cdn.jsdelivr.net/npm/phaser@3/dist/phaser.js"></script>
<div class="container game_container d-flex justify-content-center align-items-center">

<!--  여기에 우리가 만들 게임이 include 됩니다. -->



     <div id="gamebox" >
     
     </div>

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
         	debug:true,
          }

        },
        scene:[Intro, MainGame, Gameover]

    };

    let game = new Phaser.Game(config);
    </script>
    </c:when>
    <c:otherwise>
       <img alt="임시게임화면" src="/asset/img/임시게임화면.png">
    </c:otherwise>
</c:choose>

</div>



 <ul class="nav nav-tabs d-flex justify-content-center align-items-center" id="gameTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="review-tab" data-bs-toggle="tab" data-bs-target="#review" type="button" role="tab">Review</button>
        </li>
         <li class="nav-item" role="presentation">
            <button class="nav-link" id="ranking-tab" data-bs-toggle="tab" data-bs-target="#ranking" type="button" role="tab">Ranking</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="info-tab" data-bs-toggle="tab" data-bs-target="#info" type="button" role="tab">Info</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="guide-tab" data-bs-toggle="tab" data-bs-target="#guide" type="button" role="tab">Guide</button>
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