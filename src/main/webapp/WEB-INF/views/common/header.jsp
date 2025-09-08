<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:out value="${pageTitle}" default="기본 제목" /></title>
<!-- 부트스트랩 cdn -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- jquery cdn -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- main css -->
<link href="/css/main.css" rel="stylesheet" />


</head>
<body>
	<header class="fixed-top">
		<nav class="navbar navbar-expand-lg shadow-sm blur-bg">
			<div class="container-fluid">
				<a class="navbar-brand" href="/"><img src="/asset/img/Logo.png"
					style="height: 30px"></a>
				<button class="navbar-toggler" type="button"
					data-bs-toggle="collapse" data-bs-target="#navbarNav"
					aria-controls="navbarNav" aria-expanded="false"
					aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav ms-auto">
						<li class="nav-item"><a class="nav-link" href="/">Main
								Page</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/api/game/main?game_seq=1">Game</a></li>
						<li class="nav-item"><a class="nav-link" href="/list.board">Community</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/api/point/pointPage">Store</a></li>
						<c:if
							test="${not empty simpleProfile and  simpleProfile.category eq 'Manager'}">
							<li class="nav-item"><a class="nav-link"
								href="/api/manage/main">Manager</a></li>
						</c:if>



					</ul>

					<c:if test="${loginId != null }">

						<div class="header-bell"
							style="padding: 10px; padding-right: 20px;">
							<div class="dropdown">
								<a href="#" class="position-relative text-decoration-none"
									id="notificationDropdown" data-bs-toggle="dropdown"
									aria-expanded="false"> 🔔 <span
									class="position-absolute top-0 start-100 translate-middle p-1 
                         bg-danger border border-light rounded-circle headerJspBellRed"
									style="display: none;"></span>
								</a>
								<ul class="dropdown-menu dropdown-menu-end"
									aria-labelledby="notificationDropdown"
									id="notification-dropdown-list">
									<li><span class="dropdown-item-text"">새 알림이 없습니다.</span></li>
									<!-- 실제 알림이 있으면 여기 li 추가 -->


								</ul>
							</div>
						</div>

						<script>
						$(function() {
						    console.log("header DOM 준비 완료");

						    // 알림 배지 업데이트 함수
						    function updateNotificationBadge() {
						        $.ajax({
						            url: "/notification/checkNotification",
						            type: "post"
						        }).done(function(resp) {
						            if (resp == "true") {
						                $(".headerJspBellRed").show();
						            } else {
						                $(".headerJspBellRed").hide();
						            }
						        }).fail(function(err) {
						            console.error("배지 업데이트 실패:", err);
						        });
						    }

						    // 페이지 로드 시 한 번 실행
						    updateNotificationBadge();

						    // WebSocket 연결
						    let socket;
						    const protocol = location.protocol === 'https:' ? 'wss' : 'ws';
						    const wsUrl = protocol + "://" + window.location.host + "/NotificationServer";
						    console.log(wsUrl);

						    socket = new WebSocket(wsUrl);

						    socket.onopen = function() {
						        console.log("서버 연결됨");
						        socket.send("REGISTER:" + "${loginId}");
						    };

						    socket.onmessage = function(event) {
						        // 서버에서 알림이 올 때 배지 갱신
						        
						        console.log("이벤트는"+event);
						        console.log(event);
						        if (event.data == "notification") {
						            updateNotificationBadge();
						        }
						    };

						    socket.onclose = function() {
						        console.log("연결 종료");
						    };
						});
						
						$("#notificationDropdown").on("click",function(){
							$.ajax({
					            url: "/notification/viewNotification",
					            type: "post",
					            dataType:"json"
					        }).done(function(resp) {
					        	console.log("notificationResp:"+resp);
					        	console.log(resp);
					        	console.log(resp.length);
					        	if(resp.length > 0)
					        	{
						        	$("#notification-dropdown-list").html("");
						        	$(".headerJspBellRed").hide();
						        	console.log("foreach문 도는중");
						        	 resp.forEach(function(item){
						        		 
							            	let dropli = $("<li>");
							            	
							            	let dropa = $("<a>");
							            	
							            	 switch(item.type) {
							        		    case "store":
							        		        console.log('store입니다.');
							        		        dropa.attr({"class":"dropdown-item","href":"/api/point/pointPage"})
							        		        break;
							        		    case "friend":
							        		        console.log('friend입니다.'); // a는 2입니다.
							        		        dropa.attr({"class":"dropdown-item","href":"/api/member/mypage?userId=${loginId}&section=friend"})
							        		        break;
							        		    case "achievement":
							        		        console.log('achievement입니다.'); // a는 2입니다.
							        		        dropa.attr({"class":"dropdown-item","href":"/api/member/mypage?userId=${loginId}&section=collection"})
							        		        break;
							        		    case "point":
							        		        console.log('point입니다.'); // a는 2입니다.
							        		        dropa.attr({"class":"dropdown-item","href":"/api/member/mypage?userId=${loginId}&section=point"})
							        		        break;
							        		    case "chat":
								        		    console.log('chat입니다.'); // a는 2입니다.
								        		    dropa.attr({"class":"dropdown-item","href":"/chat/open?friendId="+item.related_userId})
								        		    break;
							        		    case "reply":
								        		    console.log('reply입니다.'); // a는 2입니다.
								        		    dropa.attr({"class":"dropdown-item","href":"/detailPage.board?seq="+item.related_objectId})
								        		    break;
							        		    default:
							        		    	dropa.attr({"class":"dropdown-item","href":"#"})
							        		        console.log('잘못된 타입입니다.');
							        		}
							        		 
							            	
							            	dropa.text(item.message);
							            	 
							            	dropli.append(dropa);
							            	
							            	$("#notification-dropdown-list").append(dropli);
							            });
						        	 
						        	 let lastDropli = $("<li>");
						            	
						            	let lastDropa = $("<a>");
						            	lastDropa.attr({"class":"dropdown-item","href":"/api/member/mypage?userId=${loginId}&section=notification"});
						            	lastDropa.css({"font-size":"12px","color":"skyblue"});
						            	lastDropa.text("알림 내역 페이지로 이동");
						            	lastDropli.append(lastDropa);
							            	
							        $("#notification-dropdown-list").append(lastDropli);
						        }
					        	else
					        	{
					        		$("#notification-dropdown-list").html(`<li><span class="dropdown-item-text">새 알림이 없습니다.</span></li>`);
					        		$("#notification-dropdown-list").append(`<hr>`);
					        	     		
									let dropli = $("<li>");
							            	
						            	let dropa = $("<a>");
				        		    	dropa.attr({"class":"dropdown-item","href":"/api/member/mypage?userId=${loginId}&section=notification"});
				        		    	dropa.css({"font-size":"12px","color":"skyblue"});
						            	dropa.text("알림 내역 페이지로 이동");
							        dropli.append(dropa);
							            	
							        $("#notification-dropdown-list").append(dropli);
					        	}
					        	
					        	
					           
					        }).fail(function(err) {
					            console.error("배지 업데이트 실패:", err);
					        });
							
						});
						
						</script>
					</c:if>
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
									src="${simpleProfile.profileImage }" alt="프로필"
									class="rounded-circle me-2" width="40" height="40"> <!-- 아이디와 칭호 -->
									<div class="d-none d-md-block text-end">
										<div class="fw-bold text-purple">${loginId}</div>
										<div class="text-muted">${simpleProfile.achievDTO.title}</div>
									</div>
								</a>
								<ul class="dropdown-menu dropdown-menu-end"
									aria-labelledby="profileDropdown">
									<li><a class="dropdown-item"
										href="/api/member/mypage?section=collection&userId=${loginId}">마이
											페이지</a></li>
									<li><a class="dropdown-item" href="/api/member/mypage?userId=${loginId}&section=point">보유 포인트:
											${currentPoint}</a></li>
									<li><a class="dropdown-item" href="/chat/open">채팅</a></li>
									<li><hr class="dropdown-divider"></li>
									<li><a class="dropdown-item text-danger "
										href="/api/member/logout">로그아웃</a></li>
									<li><a class="dropdown-item text-danger" href="/api/member/mypage?section=secession&userId=${loginId}">회원탈퇴</a></li>
								</ul>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</nav>
	</header>
	<main>