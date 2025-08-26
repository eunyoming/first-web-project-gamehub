<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<!-- <html><head></head><body> -->
<!-- 
여기에 코드 입력
 -->
<div class="container p-5">
<div class="mb-4"><h2>버튼 모음</h2>
<p> 기본적으로 btn 클래스는 무조건 포함임</p></div>
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
	
</div>

 <!-- </body></html> -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />