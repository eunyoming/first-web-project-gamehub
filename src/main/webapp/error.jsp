<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setAttribute("pageTitle", "에러페이지");
%>

<jsp:include page="/WEB-INF/views/common/header.jsp" />


     <style>
     
     </style>
    <div class="container d-flex justify-content-center">
        <div class="card error-card">
            <div class="card-body">
                <h1 class="error-title">오류 발생!</h1>
                <h2 class="error-subtitle">죄송합니다. 요청을 처리하는 중에 문제가 발생했습니다.</h2>
                <p class="mt-4 lead">
                    일시적인 문제일 수 있습니다. 잠시 후 다시 시도해 주시거나,
                    아래 버튼을 눌러 홈으로 돌아가 주세요.
                </p>
                <p class="error-type">오류 유형: <strong>${errorType}</strong></p>
                <a href="/" class="btn btn-home mt-4">홈으로 돌아가기</a>
            </div>
        </div>
    </div>
        <script
  src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"
  integrity="sha512-..."
  crossorigin="anonymous"
  referrerpolicy="no-referrer"
></script>

    
    <script>
        // GSAP 애니메이션
        $(document).ready(function() {
            // GSAP 타임라인 생성
            const tl = gsap.timeline();

            // 컨테이너가 부드럽게 나타나는 애니메이션
            tl.from(".error-card", {
                duration: 1.2,
                y: 100,
                opacity: 0,
                ease: "power3.out"
            });

            // 제목과 서브타이틀이 순차적으로 나타나는 애니메이션
            tl.from(".error-title", {
                duration: 0.8,
                opacity: 0,
                y: -50,
                ease: "power2.out"
            }, "-=0.8"); // 앞의 애니메이션보다 0.8초 먼저 시작

            tl.from(".error-subtitle", {
                duration: 0.8,
                opacity: 0,
                y: -30,
                ease: "power2.out"
            }, "-=0.6");

            // 기타 내용들 순차적으로 나타내기
            tl.from(".lead, .error-type, .btn-home", {
                duration: 0.7,
                opacity: 0,
                stagger: 0.2, // 각 요소가 0.2초 간격으로 나타남
                ease: "power1.out"
            }, "-=0.4");
        });
    </script>
 
<jsp:include page="/WEB-INF/views/common/footer.jsp" />