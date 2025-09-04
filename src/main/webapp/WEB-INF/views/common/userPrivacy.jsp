<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
 <%
request.setAttribute("pageTitle", "개인정보 처리방침 - 게임 허브");
%>    
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<style>
  .container { max-width: 900px; margin: auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #333; }
        h2 { margin-top: 30px; color: #444; }
        ul { margin-left: 20px; }
        .info-label { font-size: 1.2em; font-weight: bold; margin-bottom: 10px; }

</style>
  <div class="container">
        <div class="info-label">개인정보 동의사항</div>
        <p>[게임 허브]는 이용자의 개인정보를 소중히 여기며, 「개인정보 보호법」 및 관련 법령을 준수합니다. 본 개인정보 처리방침은 이용자가 회원가입 및 서비스 이용 시 제공한 개인정보가 어떻게 수집, 이용, 보관, 보호되는지 알려드립니다.</p>

        <h2>제1조 (수집하는 개인정보 항목)</h2>
        <ul>
            <li><strong>회원가입 시</strong>
                <ul>
                    <li>필수항목: 이메일 주소, 비밀번호, 닉네임</li>
                    <li>선택항목: 프로필 이미지, 관심 게임 정보</li>
                </ul>
            </li>
            <li><strong>서비스 이용 시 자동 수집 항목</strong>
                <ul>
                    <li>접속 로그(IP 주소, 접속 기기, 브라우저 정보)</li>
                    <li>서비스 이용 기록(게임 플레이 기록, 업적 달성 기록 등)</li>
                    <li>쿠키 및 세션 정보</li>
                </ul>
            </li>
        </ul>

        <h2>제2조 (개인정보의 수집 및 이용 목적)</h2>
        <ul>
            <li>회원가입, 로그인 및 본인 확인</li>
            <li>서비스 제공 및 이용 기록 관리</li>
            <li>게임 업적, 랭킹, 친구 시스템 제공</li>
            <li>고객 문의 응답 및 민원 처리</li>
            <li>보안, 불법 이용 방지, 서비스 품질 향상</li>
            <li>(선택 동의 시) 마케팅, 이벤트 및 광고 활용</li>
        </ul>

        <h2>제3조 (개인정보의 보관 및 이용 기간)</h2>
        <ul>
            <li>회원 탈퇴 시 즉시 파기</li>
            <li>법령에 따라 보관:
                <ul>
                    <li>계약 및 청약철회 기록: 5년 (전자상거래법)</li>
                    <li>결제 및 서비스 이용 기록: 5년 (전자상거래법)</li>
                    <li>로그 기록: 3개월 (통신비밀보호법)</li>
                </ul>
            </li>
        </ul>

        <h2>제4조 (개인정보의 제3자 제공)</h2>
        <ul>
            <li>이용자가 사전에 동의한 경우</li>
            <li>법령에 의하여 요구되는 경우</li>
        </ul>

        <h2>제5조 (개인정보 처리 위탁)</h2>
        <p>운영자는 안정적인 서비스 제공을 위해 개인정보 처리를 외부 업체에 위탁할 수 있으며, 위탁 업체명과 업무 범위를 사전에 공지하고 동의를 받습니다.</p>

        <h2>제6조 (이용자의 권리 및 행사 방법)</h2>
        <ul>
            <li>개인정보 열람, 수정, 삭제 가능</li>
            <li>회원 탈퇴 시 개인정보 즉시 파기</li>
            <li>[마이페이지] 또는 고객센터를 통해 권리 행사 가능</li>
        </ul>

        <h2>제7조 (개인정보 보호를 위한 기술적/관리적 대책)</h2>
        <ul>
            <li>비밀번호 암호화 저장</li>
            <li>접근 권한 최소화 및 관리</li>
            <li>접근 기록 보관</li>
            <li>보안 프로그램 설치 및 점검</li>
        </ul>

        <h2>제8조 (쿠키의 이용)</h2>
        <ul>
            <li>맞춤형 정보 제공을 위해 쿠키 사용</li>
            <li>브라우저 설정을 통해 쿠키 저장 거부 가능 (일부 서비스 제한 가능)</li>
        </ul>

        <h2>제9조 (개인정보 보호책임자)</h2>
        <ul>
            <li>개인정보 보호책임자: [이름]</li>
            <li>이메일: [이메일 주소]</li>
            <li>연락처: [전화번호]</li>
        </ul>

        <h2>제10조 (처리방침 변경)</h2>
        <p>법령 및 서비스 정책 변경 시 [게임 허브 공지사항]을 통해 사전 공지합니다.</p>
    </div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />