<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:out value="${pageTitle}" default="기본 제목" /></title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link href="/css/main.css" rel="stylesheet" />
</head>
<body>
	<header class="fixed-top">
		<nav class="navbar navbar-expand-lg shadow-sm blur-bg">
			<div class="container-fluid">
				<a class="navbar-brand" href="/">Header 로고</a>
				<button class="navbar-toggler" type="button"
					data-bs-toggle="collapse" data-bs-target="#navbarNav"
					aria-controls="navbarNav" aria-expanded="false"
					aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav ms-auto">
						<li class="nav-item"><a class="nav-link active" href="/">Main
								Page</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/api/game/main?game_seq=1">Game</a></li>
						<li class="nav-item"><a class="nav-link" href="/list.board">Community</a></li>
						<li class="nav-item"><a class="nav-link" href="#">Store</a></li>
					</ul>
					<c:choose>
						<c:when test="${loginId == null }">

							<div class="d-flex ms-3">
								<a class="btn btn-blue-main me-2" href="/api/member/loginPage">로그인</a>
								<a class="btn btn-purple-main" href="/api/member/join">회원가입</a>
							</div>
						</c:when>
						<c:otherwise>
							<div class="header_profile dropdown">
								<a
									class="d-flex align-items-center text-decoration-none dropdown-toggle"
									href="#" id="profileDropdown" data-bs-toggle="dropdown"
									aria-expanded="false"> <!-- 프로필 이미지 --> <img
									src="https://picsum.photos/100/100?random=1" alt="프로필"
									class="rounded-circle me-2" width="40" height="40"> <!-- 아이디와 칭호 -->
									<div class="d-none d-md-block text-end">
										<div class="fw-bold text-purple">${loginId}</div>
										<div class="text-muted">🏆 초보 마스터</div>
									</div>
								</a>
								<ul class="dropdown-menu dropdown-menu-end"
									aria-labelledby="profileDropdown">
									<li><a class="dropdown-item" href="/api/member/mypage">마이
											페이지</a></li>
									<li><a class="dropdown-item" href="#">보유 포인트:
											${currentPoint}</a></li>
									<li><a class="dropdown-item" href="#">채팅</a></li>
									<li><hr class="dropdown-divider"></li>
									<li><a class="dropdown-item text-danger "
										href="/api/member/logout">로그아웃</a></li>
									<li><a class="dropdown-item text-danger" href="#">회원탈퇴</a></li>
								</ul>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</nav>
	</header>
	<main>