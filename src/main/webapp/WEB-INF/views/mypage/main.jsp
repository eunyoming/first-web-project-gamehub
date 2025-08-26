<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

 <ul class="nav nav-tabs d-flex justify-content-center align-items-center" id="gameTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="review-tab" data-bs-toggle="tab" data-bs-target="#collection" type="button" role="tab">Collection</button>
        </li>
         <li class="nav-item" role="presentation">
            <button class="nav-link" id="ranking-tab" data-bs-toggle="tab" data-bs-target="#bio" type="button" role="tab">Bio</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="info-tab" data-bs-toggle="tab" data-bs-target="#bookmark" type="button" role="tab">Bookmark</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="guide-tab" data-bs-toggle="tab" data-bs-target="#friend" type="button" role="tab">Friend</button>
        </li>
        
    </ul>



  <c:choose>
  	<c:when test="${loginId == param.userId}">
  		
  	<!-- 
  	마이 페이지일 경우
여기에 코드 입력
 -->
  	
  	 <p>${loginId}의 페이지</p>
  	 
  	 
  	</c:when>
  	<c:otherwise>
  		
  	<!-- 
  	친구페이지일 경우
여기에 코드 입력
 -->

 <p>친구 ${param.userId}의 페이지</p>
  	
  	</c:otherwise>
  </c:choose>
  
  
  <div class="tab-content mt-3" id="tabContent">
        <div class="tab-pane fade show active" id="collection" role="tabpanel">
            <jsp:include page="/WEB-INF/views/mypage/collection.jsp" />
        </div>
         <div class="tab-pane fade" id="bio" role="tabpanel">
            <jsp:include page="/WEB-INF/views/mypage/bio.jsp" />
        </div>
        <div class="tab-pane fade" id="bookmark" role="tabpanel">
            <jsp:include page="/WEB-INF/views/mypage/bookmark.jsp" />
        </div>
        <div class="tab-pane fade" id="friend" role="tabpanel">
            <jsp:include page="/WEB-INF/views/mypage/friend.jsp" />
        </div>
   
    </div>
  
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
function showSection(id) {
    const sections = ['collection', 'bio', 'bookmark', 'friend'];
    sections.forEach(s => {
        document.getElementById(s).style.display = (s === id) ? 'block' : 'none';
    });
}
</script>