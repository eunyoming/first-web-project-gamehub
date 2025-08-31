<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />



 <c:choose>
    <c:when test="${loginId == paramUserId}">
        <ul class="nav nav-tabs d-flex justify-content-center align-items-center">
            <li class="nav-item">
                <a href="/api/member/mypage?section=collection&userId=${paramUserId}" 
                   class="nav-link ${active=='collection' ? 'active' : ''}">Collection</a>
            </li>
            <li class="nav-item">
                <a href="/api/member/mypage?section=bio&userId=${paramUserId}" 
                   class="nav-link ${active=='bio' ? 'active' : ''}">Bio</a>
            </li>
            <li class="nav-item">
                <a href="/api/member/mypage?section=bookmark&userId=${paramUserId}" 
                   class="nav-link ${active=='bookmark' ? 'active' : ''}">Bookmark</a>
            </li>
            <li class="nav-item">
                <a href="/api/member/mypage?section=friend&userId=${paramUserId}" 
                   class="nav-link ${active=='friend' ? 'active' : ''}">Friend</a>
            </li>
        </ul>

        <div class="mt-3">
            <jsp:include page="/WEB-INF/views/mypage/${active}.jsp" />
        </div>
    </c:when>

    <c:otherwise>
        <div class="container">
            <p>${paramUserId}의 페이지</p>
            <form action="/api/friends/request" method="post">
                <input type="hidden" name="toUser" value="${paramUserId}">
                <input type="hidden" name="fromUser" value="${loginId}">
                <button type="submit" class="btn btn-blue-main"> ${paramUserId}에게 친구 요청</button>
            </form>
        </div>
    </c:otherwise>
</c:choose>

  
  
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
function showSection(id) {
    const sections = ['collection', 'bio', 'bookmark', 'friend'];
    sections.forEach(s => {
        document.getElementById(s).style.display = (s === id) ? 'block' : 'none';
    });
}
</script>