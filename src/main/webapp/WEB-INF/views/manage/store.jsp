<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setAttribute("pageTitle", "관리자 상점 관리 페이지");
%>
<jsp:include page="/WEB-INF/views/common/manage_header.jsp" />

<div class="container-fluid mt-5">
	<h2 class="mb-4">상점 관리 대시보드</h2>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />