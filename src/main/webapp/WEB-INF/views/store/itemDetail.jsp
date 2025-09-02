<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<!-- 
여기에 코드 입력
 -->

<style>
/* 이미지 영역 */
.image-container {
	width: 50%;
	height: 500px; /* 고정 높이 */
	display: flex;
	justify-content: center;
	align-items: center;
	overflow: hidden;
}

.shop-image {
	width: 100%; /* 컨테이너 너비에 맞춤 */
	height: 100%; /* 컨테이너 높이에 맞춤 */
	object-fit: cover; /* 비율 유지, 잘리지 않게 */
}

/* 버튼 그라디언트 스타일 */
.btn-gradient {
	background: linear-gradient(90deg, #ff7a18, #af002d);
	color: #fff;
	border: none;
	border-radius: 12px;
	font-size: 1.1rem;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
	transition: transform 0.2s, box-shadow 0.2s;
}

.btn-gradient:hover {
	transform: translateY(-3px) scale(1.02);
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
}

/* RP 경고 강조 */
.rp-warning {
	font-size: 0.95rem;
	letter-spacing: 0.5px;
	display: flex;
	align-items: center;
	gap: 0.3rem;
}

.shop-card {
	overflow: hidden;
}
</style>


<div class="container my-5" id="point-store-container">
	<h2 class="mb-4">포인트 상점</h2>


	<!-- <div class="row g-4" id="selling-clickItem">
		<div class="col-md-12">
			<div class="card shop-card shadow-xl rounded-4">
				<div class="row g-0">

					이미지 영역
					<div
						class="col-md-6 d-flex justify-content-center align-items-center image-container">
						<img src="/uploads/space_battle_boss_figure.png" alt="꼬마 악마 트리스타나"
							class="img-fluid shop-image">
					</div>

					내용 영역
					<div class="col-md-6">
						<div
							class="card-body d-flex flex-column justify-content-between h-100 p-4">

							제목 & 설명
							<div>
								<h2 class="card-title fw-bold mb-3 text-dark">꼬마 악마 트리스타나</h2>
								<p class="card-text text-muted fs-5">트리스타나에게 새 스킨을 입혀 주세요.
									다양한 스타일과 장식을 추가할 수 있습니다.</p>
							</div>

							RP 알림 & 버튼
							<div class="mt-3">
								<p class="rp-warning text-danger fw-semibold mb-3">
									<i class="bi bi-exclamation-circle-fill"></i> point가 부족합니다.
								</p>
								<button class="btn btn-gradient w-100 py-2 fw-bold">
									1350 RP 충전하기</button>
							</div>

						</div>
					</div>

				</div>
			</div>
		</div>
	</div> -->


</div>
<script>

	$(function() {
	    // 로그인 여부 확인 (서버에서 JS 변수로 전달된 경우 사용)
	    
	   	var loginId = "${sessionScope.loginId}"
		
	    if (!loginId) return; // 로그인 안 되어 있으면 종료
	    //currentPoint
	    $.ajax({
	    	url : "/api/store/itemDetailView",
	    	type:"post",
	    	data : { seq: ${seq}},
	    	dataType:"json"
	    }).done(function(resp) {
	        console.log(resp, "응답 받음");

	        // 카드 생성 함수
	        function createCard(item) {
	        	
	        	var $img = $('<img>', {
                    src: item.url || '/uploads/space_battle_figure.png',
                    alt: item.itemName || '아이템',
                    class: 'img-fluid shop-image'
                });
	        	
			    var $row = $('<div>', { class: 'row g-4', id: 'selling-clickItem' }).append(
			        $('<div>', { class: 'col-md-12' }).append(
			            $('<div>', { class: 'card shop-card shadow-xl rounded-4' }).append(
			                $('<div>', { class: 'row g-0' }).append(
			                    // 이미지 영역
			                    $('<div>', { class: 'col-md-6 d-flex justify-content-center align-items-center image-container' }).append(
			                    		$img
			                    		
			                    		/* $('<img>', {
			                            src: item.url || '/uploads/space_battle_figure.png',
			                            alt: item.itemName || '아이템',
			                            class: 'img-fluid shop-image'
			                        }) */
			                    ),
			                    // 내용 영역
			                    $('<div>', { class: 'col-md-6' }).append(
			                        $('<div>', { class: 'card-body d-flex flex-column justify-content-between h-100 p-4' }).append(
			                            // 제목 & 설명
			                            $('<div>').append(
			                                $('<h2>', { class: 'card-title fw-bold mb-3 text-dark', text: item.itemName || '아이템 이름' }),
			                                $('<p>', { class: 'card-text text-muted fs-5', text: item.contents || '아이템 설명' })
			                            ),
			                            // RP 알림 & 버튼
			                            (function() {
			                                var $actionArea = $('<div>', { class: 'mt-3' });

			                                var $button = $('<button>', {
			                                    class: 'btn btn-gradient w-100 py-2 fw-bold',
			                                    text: item.price + " Point 구매하기"
			                                });

			                                // ✅ 아이템 이미 구매된 경우 처리
			                                if (item.isPurchased) {
			                                    // 이미지 회색 처리 (grayscale 필터)
			                                    $img.css("filter", "grayscale(100%)");

			                                    // 버튼 비활성화 + 텍스트 변경
			                                    $button.prop("disabled", true)
			                                           .addClass("btn-secondary")
			                                           .removeClass("btn-gradient")
			                                           .text("이미 구매한 아이템");
			                                } else {
			                                    // 구매 가능할 때만 클릭 이벤트 등록
			                                    $button.on("click", function () {
			                                        if ($(this).prop("disabled")) return;

			                                        if (confirm("정말 구매하시겠습니까?")) {
			                                            console.log("구매 진행");
			                                        } else {
			                                            console.log("구매 취소");
			                                            return false;
			                                        }

			                                        $.ajax({
			                                            url : "/api/store/itemDetailBuy",
			                                            type:"post",
			                                            data : { 
			                                                points : item.price,
			                                                itemName : item.itemName,
			                                                storeSeq: item.seq
			                                            },
			                                            dataType:"json"
			                                        }).done(function(resp) {
			                                            console.log(resp, "응답 받음");
			                                            console.log("구매후 ajax동작.");
			                                            location.reload();
			                                        }).fail(function(err) {
			                                            console.log("실패", err);
			                                        });
			                                    });

			                                    // 🔹 포인트 부족 시 처리
			                                    if ("${sessionScope.currentPoint}" < item.price) {
			                                        $actionArea.append(
			                                            $('<p>', { class: 'rp-warning text-danger fw-semibold mb-3' })
			                                                .html('<i class="bi bi-exclamation-circle-fill"></i> point가 부족합니다.')
			                                        );
			                                        $button.prop("disabled", true).addClass("btn-secondary").removeClass("btn-gradient");
			                                    }
			                                }

			                                $actionArea.append($button);
			                                return $actionArea;
			                            })()
			                        )
			                    )
			                )
			            )
			        )
			    );
			    return $row;
			}


	        // 카드 리스트 생성
	        
	        $("#point-store-container").append(createCard(resp));
	      
	    }).fail(function(err) {
	        console.error("AJAX 에러:", err);
	    });
	});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />