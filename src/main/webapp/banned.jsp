<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
     <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
     
<jsp:include page="/WEB-INF/views/common/header.jsp" />

    <h2>계정이 정지되었습니다</h2>
    <p>관리자에 의해 이용이 제한된 계정입니다.<br>
    문의 사항이 있다면 고객센터로 문의해주세요.</p>
<%
    String bannedTs = request.getParameter("bannedUntil");
    java.util.Date bannedDate = null;
    if (bannedTs != null && !bannedTs.isEmpty()) {
        try {
            long ts = Long.parseLong(bannedTs);
            bannedDate = new java.util.Date(ts);
        } catch (NumberFormatException e) {
            bannedDate = null;
        }
    }
    request.setAttribute("bannedDate", bannedDate);
%>

<c:choose>
    <c:when test="${not empty bannedDate}">
        <p>차단 해제 예정일: <fmt:formatDate value="${bannedDate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
    </c:when>
    <c:otherwise>
        <p>차단 해제 예정일: 정보 없음</p>
    </c:otherwise>
</c:choose>
    <a href="/api/member/loginPage">로그인 페이지로</a>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />