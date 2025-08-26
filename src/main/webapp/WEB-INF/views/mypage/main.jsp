<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

  <c:choose>
  	<c:when test="${loginId==param.clickedUserID}">
  		
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
 <p>친구 ${param.clickedUserID}의 페이지</p>
  	
  	</c:otherwise>
  </c:choose>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />