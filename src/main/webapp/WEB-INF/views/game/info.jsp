<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>

</style>

<div class="d-flex justify-content-center align-items-center">

   <div class="container mt-5" id="infolist">
  <div class="row">
    <!-- 좌측: 슬라이드 이미지 -->
    <div class="col-md-6">
      <div id="gameCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">
          <div class="carousel-item active">
            <img src="썸네일이미지.jpg" class="d-block w-100" alt="썸네일">
          </div>
          <div class="carousel-item">
            <img src="플레이이미지1.jpg" class="d-block w-100" alt="플레이1">
          </div>
          <div class="carousel-item">
            <img src="플레이이미지2.jpg" class="d-block w-100" alt="플레이2">
          </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#gameCarousel" data-bs-slide="prev">
          <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#gameCarousel" data-bs-slide="next">
          <span class="carousel-control-next-icon"></span>
        </button>
      </div>
    </div>

    <!-- 우측: 게임 소개 -->
    <div class="col-md-6">
      <h2> 게임 이름</h2>
      
      <p><strong>배경 설명:</strong> 배경 설명 내용</p>
      <hr>
      <h4>제작자 코멘트</h4>
      <blockquote class="blockquote">
        <p>“제작자 코멘트를 적어주세요.”</p>
        <footer class="blockquote-footer">제작자 이름</footer>
      </blockquote>
    </div>
  </div>
</div>
</div>

<script>
$.ajax({
	  url: "/info",
	  type: "get",
	  dataType: "json",
	  data: { game_seq: game_seq } // JSP에서 변수 바인딩한 경우: "${game_seq}"
	}).done(function(resp) {
	  let $container = $("#infolist").empty();
</script>

  
   