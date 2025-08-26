<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link href="/css/main.css" rel="stylesheet"/>
</head>
<body>
<header class="fixed-top">
	<nav class="navbar navbar-expand-lg shadow-sm blur-bg">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">Header 로고</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
            data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link active" href="/">Main Page</a></li>
        <li class="nav-item"><a class="nav-link" href="/api/game">Game</a></li>
        <li class="nav-item"><a class="nav-link" href="#">Community</a></li>
         <li class="nav-item"><a class="nav-link" href="#">Store</a></li>
      </ul>
      
      <div class="d-flex ms-3">
        <a class="btn btn-blue-main me-2" href="#">로그인</a>
        <a class="btn btn-purple-main" href="#">회원가입</a>
      </div>
    </div>
  </div>
</nav>
</header>
<main>
 