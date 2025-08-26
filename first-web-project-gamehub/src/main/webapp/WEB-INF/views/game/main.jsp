<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container game_container d-flex justify-content-center align-items-center">

<!--  여기에 우리가 만들 게임이 include 됩니다. -->
<img alt="임시게임화면" src="/asset/img/임시게임화면.png">

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
</script>