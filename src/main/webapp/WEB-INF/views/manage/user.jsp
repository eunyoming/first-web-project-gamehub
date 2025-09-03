<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setAttribute("pageTitle", "관리자 유저 관리 페이지");
%>
<jsp:include page="/WEB-INF/views/common/manage_header.jsp" />


<div class="container-fluid mt-5">
	<h2 class="mb-4">유저 관리 대시보드</h2>
	<div class="row">
		<div class="col-6">
			<div class="card">
				<form id="reportControlForm" method="post" action="/handled">
					<div class="card-header card-header-gray">
						<h4>신고 유저/게시글 목록</h4>
					</div>

					<!-- 카드 본문 전체 높이 설정 -->
					<div class="card-body d-flex flex-column" style="height: 400px;">

						<!-- 스크롤 가능한 리스트 영역 -->
						<div class="flex-grow-1 overflow-y-auto" style="min-height: 0;">
							<ul class="list-group list-group-flush" id="reportList">
								<!-- 여러 개의 리스트 항목이 여기에 append됨 -->
							</ul>
						</div>
						<!-- 고정된 조작 영역 -->
						<div class="mt-3">
							<label for="banned-date">차단 기간</label> <select id="banned-date"
							name="bannedDays"
								class="form-select form-select-sm mb-3"
								aria-label="banned-aria-date">
								<option selected value="7">7일</option>
								<option value="14">14일</option>
								<option value="30">30일</option>
								<option value="365">365일</option>
							</select> <label for="banned-reason">차단 사유</label> <select
								name="proceedReason" id="banned-reason"
								class="form-select form-select-sm mb-3"
								aria-label="banned-aria-reason">
								<option selected value="게시판 유저 신고">게시판 유저 신고</option>
								<option value="광고/홍보성 글 도배">광고/홍보성 글 도배</option>
								<option value="괘씸죄">괘씸죄</option>
							</select>

							<div class="text-end">
								<button id="proccedReportBtn" type="button"
									class="btn btn-red-main">해당 유저 차단</button>
								<button id="rejectReportBtn" type="button"
									class="btn btn-yellow-main">신고 삭제(거절)</button>
							</div>
						</div>

					</div>
				</form>
			</div>
		</div>
		<div class="col-6">
			<div class="card">
				<div class="card-header card-header-red">
					<h4>차단된 유저 목록</h4>
				</div>
				<div class="card-body d-flex flex-column" style="height: 400px;">
					<div class="flex-grow-1 overflow-y-auto" style="min-height: 0;">
						<ul class="list-group list-group-flush" id="bannedList">
							<li class="list-group-item text-muted">데이터를 불러오는 중...</li>
						</ul>
					</div>
				</div>
			</div>

		</div>
	</div>
	<div class="row">
		<div class="card">
			<div class="card-header card-header-peach">
				<h4>회원 목록</h4>
			</div>
			<div class="card-body">
				<ul class="list-group list-group-flush" id="userList">
					<li class="list-group-item text-muted">데이터를 불러오는 중...</li>
				</ul>
				<div id="pagination" class="mt-3"></div>
				<div class="row">
					<div class="col-6">
						<input type="number" id="pointInput" placeholder="포인트 입력">
						<input type="text" id="pointDesc" placeholder="포인트 지급 설명">
						<button class="btn btn-blue-purple" type="button" onclick="addPoints()">선택회원 포인트 적립</button>
					</div>
					<div class="col-6">
						<select id="roleSelect">
							<option value="User">User</option>
							<option value="Manager">Manager</option>
							<option value="Banned">Banned</option>
						</select>
						<button class="btn btn-red-peach" type="button" onclick="updateRole()">선택회원 권한 변경</button>
					</div>
				</div>

				<!-- 권한 변경 select + 버튼 -->

			</div>

		</div>
	</div>
</div>
<script type="text/javascript">

function loadReportData() {
    $.ajax({
        url: '/report/list',
        type: 'GET',
        dataType: 'json'
    })
    .done(function(data) {
    
        const list = $("#reportList"); // id 넣어줘야 함
        list.empty();

        if (!data || !data.reports || data.reports.length === 0) {
            list.append(`<li class="list-group-item text-muted">처리 대기 중인 신고가 없습니다.</li>`);
            return;
        }

        
        const reports = data.reports;
        const users = data.users;

        console.log("신고 리스트:", reports);
        console.log("밴 대상 유저 프로필:", users);

        reports.forEach((report,index) => {
        	
        	 const targetUser = data.users[index];
        	 if (!targetUser) {
        		  console.warn("targetUser가 undefined입니다. index:", index, "report:", report);
        		  return; // 또는 기본값 처리
        		}

        	 
        	 //밴된 대상 유저 프로필 블록
        	 const profileBlock =
        		    '<div class="profile d-flex align-items-center justify-content-between text-decoration-none">' +
        		        '<a href="/api/member/mypage?section=collection&userId=' + targetUser.userId + '">' +
        		            '<img src="' + targetUser.profileImage + '" alt="프로필" class="rounded-circle me-2" width="40" height="40">' +
        		        '</a>' +
        		        '<div class="d-none d-md-block text-end">' +
        		            '<a href="/api/member/mypage?section=collection&userId=' + targetUser.userId + '" class="text-decoration-none">' +
        		                '<div class="fw-bold text-red">' + targetUser.userId + '</div>' +
        		            '</a>' +
        		            '<div class="text-muted">' + targetUser.equipedAchiev + '</div>' +
        		        '</div>' +
        		    '</div>';

        	
        	// 링크 포함 여부에 따라 targetInfo 구성
        	let targetInfo = '';
        	if (report.targetType === 'Board') {
        	    targetInfo = '<a href="/detail.board?seq=' + report.targetSeq + '" class="text-decoration-none">' +
        	                 report.targetSeq + '</a> <strong> [' + report.targetType + ']</strong>';
        	} else {
        	    targetInfo = report.targetSeq + ' <strong> [' + report.targetType + ']</strong>';
        	}


            const item = '<li class="list-group-item">' +
            '<div class="form-check">' +
                '<input class="form-check-input report-checkbox" name="report_seq" type="checkbox" value="' + report.seq + '" id="report_' + report.seq + '">' +
                '<label class="form-check-label" for="report_' + report.seq + '">' +
                    '<div><span class="text-primary">' + report.reporterId + '</span> → ' +targetInfo+ '</div>' +
                    '<div>사유: ' + report.reason + '</div>' +
                    '<div class="text-muted small">상태: ' + report.status + ' | 생성: ' + report.createdAt + '</div>' +
                    '<div class="text-danger small">밴 대상 유저 </div>' +
                    profileBlock+
                '</label>' +
            '</div>' +
        '</li>';

            list.append(item);
        });

    })
    .fail(function(xhr, status, error) {
        console.error("데이터 불러오기 실패:", error);
    })
    .always(function() {
        console.log("AJAX 요청 완료됨");
    });
}

function loadBannedData() {
    $.ajax({
        url: '/api/manage/bannedUserList',
        type: 'GET',
        dataType: 'json'
    }).done(function(result) {
        const list = $("#bannedList");
        list.empty();

        if (!result || !result.profiles || result.profiles.length === 0) {
            list.append(`<li class="list-group-item text-muted">현재 밴된 유저가 존재하지 않습니다.</li>`);
            return;
        }

        const profiles = result.profiles;
        const banInfo = result.banInfo;
	console.log(profiles);
	console.log(banInfo);
        profiles.forEach(profile => {
            // userId 기준으로 banInfo 찾기
            const ban = banInfo.find(b => b.id === profile.userId);
            console.log(ban)

            const profileBlock =
                '<div class="profile d-flex align-items-center justify-content-between">' +
                    '<div class="d-flex align-items-center">' +
                        '<a href="/api/member/mypage?section=collection&userId=' + profile.userId + '">' +
                            '<img src="' + profile.profileImage + '" alt="프로필" class="rounded-circle me-2" width="40" height="40">' +
                        '</a>' +
                        '<div class="d-none d-md-block">' +
                            '<a href="/api/member/mypage?section=collection&userId=' + profile.userId + '" class="text-decoration-none">' +
                                '<div class="fw-bold text-purple">' + profile.userId + '</div>' +
                            '</a>' +
                            '<div class="text-muted">' + profile.equipedAchiev + '</div>' +
                            '<div class="text-muted small">차단 사유: ' + ban.bannedReason + '</div>' +
                            '<div class="text-muted small">차단 만료: <span id="banned-time-' + profile.userId + '">' + formatRemainingTime(ban.bannedUntil) + '</span></div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="text-end">' +
                        '<button type="button" class="btn btn-navy-main unbanBtn" data-user-id="' + profile.userId + '">차단 해제</button>' +
                    '</div>' +
                '</div>';

            const item = '<li class="list-group-item">' + profileBlock + '</li>';
            list.append(item);
            
            setInterval(function() {
                var span = document.getElementById('banned-time-' + profile.userId);
                if (span) span.textContent = formatRemainingTime(ban.bannedUntil);
            }, 1000);
        });
    });
}


$(document).ready(function() {
    loadReportData();
    loadBannedData();
});

$(document).on('click', '.unbanBtn', function() {
	  const userId = $(this).data('user-id');

	  console.log('차단 해제 버튼 클릭됨! ');
	  console.log($(".unbanBtn").attr('data-user-id'))

	  $.ajax({
		  url: '/api/manage/unban',
		  method: 'POST',
		  data: {
		    bannedId: userId 
		  },
		  success: function(response) {
		    alert('차단 해제 완료!');
		    location.reload(); 
		  },
		  error: function(xhr, status, error) {
		    console.error('에러 발생:', error);
		  }
		});

	});

$("#rejectReportBtn").on("click", function(){
	$("#reportControlForm").attr("action","/report/reject");
	$("#reportControlForm").submit();
	
})


$("#proccedReportBtn").on("click", function(){
	$("#reportControlForm").attr("action","/report/proceed");
	$("#reportControlForm").submit();
	
})

function loadMembers(page) {
  $.ajax({
    url: "/api/manage/memberList",
    type: "GET",
    data: { page: page },
    dataType: "json",
    success: function(res) {
      let ul = $("#userList");
      ul.empty();

      if (res.members.length === 0) {
        ul.append(`<li class="list-group-item text-muted">회원이 없습니다.</li>`);
        return;
      }

      res.members.forEach(function(m) {
    	  ul.append(
    			  '<li class="list-group-item d-flex justify-content-between align-items-center">' +
    			    '<div>' +
    			      '<input type="checkbox" class="chk me-2" value="' + m.id + '">' +
    			      '<strong>' + m.id + '</strong> / ' + m.email + '<br>' +
    			      '<span class="text-muted">포인트: ' + m.point +
    			      ' | 권한: ' + m.role +
    			      ' | 가입일: ' + m.createdAt + '</span>' +
    			    '</div>' +
    			    '<div>' +
    			      '<button class="btn btn-sm btn-blue-main me-2" onclick="openMypage(\'' + m.id + '\')">마이페이지</button>' +
    			     
    			    '</div>' +
    			  '</li>'
    			);
      });

      makePagination(res.totalCount, page);
    }
  });
}

// 페이지네이션 버튼
function makePagination(totalCount, currentPage) {
  let pageSize = 10;
  let totalPage = Math.ceil(totalCount / pageSize);
  let div = $("#pagination");
  div.empty();

  for (let i = 1; i <= totalPage; i++) {
    let btn = 
      '<button class="btn btn-sm ' +
      (i === currentPage ? 'btn-peach-main' : 'btn-outline-peach-main') +
      ' me-1" onclick="loadMembers(' + i + ')">' +
      i +
      '</button>';
    div.append(btn);
  }
}

function addPoints() {
	 let ids = $(".chk:checked").map(function() { return this.value; }).get();

    var points = $('#pointInput').val();
    var description = $('#pointDesc').val() || "포인트 지급";
    var typeCode = 'admin'; 

    if (ids.length === 0) {
	    alert("적용할 회원을 선택하세요.");
	    return;
	  }
    
    $.ajax({
        url: '/api/point/addPointsUsersByManager',
        type: 'POST',
	    data: {
	      ids: ids,
	      points:points,
	      description: description,
	      typeCode: typeCode
	    },
	    traditional: true,
        success: function(res) {
            alert('포인트가 지급되었습니다.');
            loadMembers(currentPage);
        },
        error: function() {
            alert('포인트 지급에 실패했습니다.');
        }
    });
}

function openMypage(id) {
	  location.href = '/api/member/mypage?section=collection&userId=' + encodeURIComponent(id);
	}


function updateRole() {
	  let ids = $(".chk:checked").map(function() { return this.value; }).get();
	  let role = $("#roleSelect").val();

	  if (ids.length === 0) {
	    alert("적용할 회원을 선택하세요.");
	    return;
	  }
	  
	  console.log("선택된 ID들:", ids);

	  $.ajax({
		    url: "/api/manage/updateRole",  // 수정된 엔드포인트
		    type: "POST",
		    data: {
		      ids: ids,
		      role: role
		    },
		    traditional: true, // 배열 전송 시 필요
		    success: function(res) {
		      alert("권한 변경 완료");
		      loadMembers(1);
		    }
		  });
	}

function formatRemainingTime(bannedUntil) {
    if (!bannedUntil) return "차단 기간 없음";

    var endDate = new Date(bannedUntil);
    var now = new Date();

    var diff = endDate - now;

    if (diff <= 0) return "차단 만료";

    var days = Math.floor(diff / (1000 * 60 * 60 * 24));
    diff -= days * (1000 * 60 * 60 * 24);

    var hours = Math.floor(diff / (1000 * 60 * 60));
    diff -= hours * (1000 * 60 * 60);

    var minutes = Math.floor(diff / (1000 * 60));
    diff -= minutes * (1000 * 60);

    var seconds = Math.floor(diff / 1000);

    var result = "";
    if (days > 0) result += days + "일 ";
    if (hours > 0) result += hours + "시간 ";
    if (minutes > 0) result += minutes + "분 ";
    result += seconds + "초 남음";

    return result;
}


// 최초 로딩
$(document).ready(function() {
  loadMembers(1);
});

</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />