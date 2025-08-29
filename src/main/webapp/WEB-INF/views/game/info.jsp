<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
	.info-game-card, .info-game-info .card {
		border-radius: 12px;
		box-shadow: 0 2px 6px rgba(0,0,0,0.1);
		overflow: hidden;
		background-color: #fff;
	}

	.info-game-card img {
		object-fit: cover;
		height: 300px;
	}

	.info-game-info .card {
		padding: 20px;
	}

	.info-game-info h2 {
		font-size: 1.8rem;
		font-weight: 600;
		margin-bottom: 15px;
	}

	.info-game-info p {
		font-size: 1rem;
		line-height: 1.6;
		margin-bottom: 20px;
	}

	.info-game-info blockquote {
		font-size: 1rem;
		font-style: italic;
		margin: 0;
	}
</style>
<div class="d-flex justify-content-center align-items-center">
	<div class="container"  id="infoList">
		<div class="row">
			
			<!-- 좌측: 이미지 캐러셀 -->
			<div class="col-md-6">
				<div class="info-game-card">
					<div id="gameCarousel" class="carousel slide" data-bs-ride="carousel">
						<div class="carousel-inner">
							<div class="carousel-item active">
								<img src="${gameList.url} + '/썸네일이미지.jpg'" class="d-block w-100" alt="썸네일">
							</div>
							<div class="carousel-item">
								<img src="${gameList.url} + '/플레이이미지1.jpg'" class="d-block w-100" alt="플레이1">
							</div>
							<div class="carousel-item">
								<img src="${gameList.url} + '/플레이이미지2.jpg'" class="d-block w-100" alt="플레이2">
							</div>
						</div>
						<button class="carousel-control-prev" type="button"
							data-bs-target="#gameCarousel" data-bs-slide="prev">
							<span class="carousel-control-prev-icon"></span>
						</button>
						<button class="carousel-control-next" type="button"
							data-bs-target="#gameCarousel" data-bs-slide="next">
							<span class="carousel-control-next-icon"></span>
						</button>
					</div>
				</div>
			</div>

			<!-- 우측: 게임 정보 카드 -->
			<div class="col-md-6">
				<div class="info-game-info">
					<div class="card">
						<h2>${gameList.title}</h2>
						<p><strong>배경 설명:</strong> 
						${gameList.description}
						</p>
						<hr>
						<h4>제작자 코멘트</h4>
						<blockquote class="blockquote">
							<p>“안녕하세요?”</p>
							<footer class="blockquote-footer">${gameList.creator}</footer>
						</blockquote>
					</div>
				</div>
			</div>
			
		</div>
	</div>
</div>




<script>




</script>


