<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

   <div class="container-fluid mt-5">
        <h4 class="mb-4">내 친구 관리</h4>
        
        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header card-header-main">
                        <h4>내가 보낸 친구 요청</h4>
                    </div>
                    <div class="card-body d-flex flex-column" style="height: 400px;">
	                     <div class="flex-grow-1 overflow-y-auto" style="min-height: 0;">
	                    	 <ul class="list-group list-group-flush" id="sentRequestsList">
	                        <li class="list-group-item text-muted">데이터를 불러오는 중...</li>
	                   		 </ul>
	                    </div>
                    </div>
                   
                   
                </div>
            </div>

            <div class="col-md-4">
                <div class="card">
                    <div class="card-header card-header-main">
	                        <h4>내게 온 친구 요청</h4>
	                    </div>   
	                    <div class="card-body d-flex flex-column" style="height: 400px;">
		                     <div class="flex-grow-1 overflow-y-auto" style="min-height: 0;">
		                    <ul class="list-group list-group-flush" id="receivedRequestsList">
		                        <li class="list-group-item text-muted">데이터를 불러오는 중...</li>
		                    </ul>
                    	</div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header card-header-accent">
                        <h4>내 친구 목록</h4>
                    </div>
                     <div class="card-body d-flex flex-column" style="height: 400px;">
		                     <div class="flex-grow-1 overflow-y-auto" style="min-height: 0;">
			                    <ul class="list-group list-group-flush" id="friendsList">
			                        <li class="list-group-item text-muted">데이터를 불러오는 중...</li>
			                    </ul>
			                 </div>
			         </div>
                </div>
            </div>
        </div>
    </div>


    <script>
        
        const currentUserId = '${sessionScope.loginId}';

        function loadFriendData() {
            const fetchData = (url, listId, displayKey) => {
                $.ajax({
                    url: url,
                    type: 'GET',
                    dataType: 'json',
                    success: function(data) {
                        const listElement = $(listId);
                        listElement.empty();

                        if (data.length === 0) {
                            listElement.append('<li class="list-group-item text-muted">목록이 비어있습니다.</li>');
                            return;
                        }

                        data.forEach(item => {
                            const friendId = (displayKey === 'friendId') ?
                                (item.userIdA === currentUserId ? item.userIdB : item.userIdA) :
                                item[displayKey];

                            const listItem = $('<li>').addClass('list-group-item d-flex justify-content-between align-items-center')
                                                      .text('ID: ' + friendId);

                            const buttonContainer = $('<div>');

                            // 버튼 정의
                            const buttons = getButtonsForUrl(url, friendId, () => fetchData(url, listId, displayKey));
                            buttons.forEach(btn => buttonContainer.append(btn));

                            listItem.append(buttonContainer);
                            listElement.append(listItem);
                        });
                    },
                    error: function(xhr) {
                        const errorMessage = xhr.responseJSON ? xhr.responseJSON.error : '알 수 없는 오류';
                        $(listId).html(`<li class="list-group-item text-danger">데이터를 불러오는 데 실패했습니다: ${errorMessage}</li>`);
                    }
                });
            };

            // URL에 따라 버튼 생성
            function getButtonsForUrl(url, friendId, refreshCallback) {
                const btns = [];

                const createBtn = (text, type, clickHandler) => {
                    return $('<button>').addClass('btn btn-sm ms-2 '+type).text(text).click(clickHandler);
                };

                if (url.includes('sent-requests')) {
                    btns.push(createBtn('취소', 'btn-yellow-main', () => handleAction('/api/friends/sent-requests-cancel?targetID='+friendId, refreshCallback, '취소 실패')));
                } else if (url.includes('received-requests')) {
                    btns.push(createBtn('수락', 'btn-green-main', () => handleAction('/api/friends/received-requests-accept?targetID='+friendId, refreshCallback, '수락 실패')));
                } else if (url.includes('/list')) {
                    btns.push(createBtn('삭제', 'btn-red-main', () => handleAction('/api/friends/delete?targetID='+friendId, refreshCallback, '삭제 실패')));
                    btns.push(createBtn('블락', 'btn-gray-main', () => handleAction('/api/friends/block?targetID='+friendId, refreshCallback, '블락 실패')));
                    btns.push(createBtn('채팅', 'btn-navy-main', () => window.location.href = '/chat/open?friendId='+friendId));
                }

                return btns;
            }

            // AJAX 공통 처리
            function handleAction(url, refreshCallback, errorMsg) {
                $.ajax({
                    url: url,
                    type: 'POST',
                    success: refreshCallback,
                    error: () => alert(errorMsg)
                });
            }

            // 리스트 갱신
            fetchData('/api/friends/sent-requests', '#sentRequestsList', 'userIdB');
            fetchData('/api/friends/received-requests', '#receivedRequestsList', 'userIdA');
            fetchData('/api/friends/list', '#friendsList', 'friendId');
        }


        $(document).ready(function() {
            // Load data when the page loads
            loadFriendData();
        });
   
    </script>