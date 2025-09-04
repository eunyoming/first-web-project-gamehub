<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setAttribute("pageTitle", "관리자 상점 관리 페이지");
%>
<jsp:include page="/WEB-INF/views/common/manage_header.jsp" />
<style>
.sellingCard {
	
	transition: background-color 0.2s ease;
}
.sellingCard:hover {
	background-color: #f8f9fa;
}
</style>
<div class="container-fluid mt-5">
	<h2 class="mb-4">상점 관리 대시보드</h2>
</div>

<div class="container-fluid my-5">
	<ul class="list-group" id="selling-list-div">
		<!-- 동적으로 아이템이 추가될 영역 -->
	</ul>
</div>

<script>
$(function(){
	$.ajax({
		url : '/api/store/itemAll',
		type : 'post'
	}).done(function(resp){
		console.log(resp + '응답 받음');

		$('#selling-list-div').html('');

		if('${loginId}' != '') {
			resp.forEach(function(list){
				let listItem = $('<li>').addClass('list-group-item sellingCard');

				let wrapper = $('<div>').addClass('d-flex align-items-start');

				let img = $('<img>').attr({
					'src': list.url,
					'alt': 'item image',
					'title': '이미지를 클릭해 변경',
				}).css({
					'width': '80px',
					'height': '80px',
					'object-fit': 'cover',
					'margin-right': '15px',
					'border-radius': '5px',
					'cursor': 'pointer'
				});

				// 숨겨진 파일 업로드 input
				let fileInput = $('<input>').attr({
					'type': 'file',
					'accept': 'image/*',
					'style': 'display:none'
				});

				// 이미지 클릭 시 파일 선택창 열기
				img.on('click', function() {
					fileInput.trigger('click');
				});

				// 파일 선택 후 업로드
					fileInput.on('change', function() {
					let file = this.files[0];
					if (!file) return;
				
					let formData = new FormData();
					formData.append('file', file);
					formData.append('seq', list.seq); // 아이템 고유 번호도 함께 전송
				
					$.ajax({
						url: '/api/manage/storeUploadImage',
						type: 'post',
						data: formData,
						processData: false,
						contentType: false,
						success: function(data) {
							if (data.url) {
								img.attr('src', data.url);
								alert('이미지가 성공적으로 변경되었습니다!');
							} else {
								alert('업로드 실패');
							}
						},
						error: function() {
							alert('서버 오류 발생');
						}
					});
				});

					let infoDiv = $('<div>').addClass('flex-grow-1');

					let nameInput = $('<input>').addClass('form-control mb-2').val(list.itemName);
					let priceInput = $('<input>').addClass('form-control mb-2').attr('type', 'number').val(list.price);
					let contentsInput = $('<textarea>').addClass('form-control mb-2').val(list.contents);

					let saveBtn = $('<button>').addClass('btn btn-sm btn-purple-main').text('수정 저장');

					saveBtn.on('click', function() {
						let updatedData = {
							seq: list.seq,
							itemName: nameInput.val(),
							price: priceInput.val(),
							contents: contentsInput.val()
						};

						$.ajax({
							url: '/api/store/updateItemInfo',
							type: 'post',
							contentType: 'application/json',
							data: JSON.stringify(updatedData),
							success: function(result) {
								alert('수정 완료!');
							},
							error: function() {
								alert('수정 실패');
							}
						});
					});

					infoDiv.append(nameInput).append(priceInput).append(contentsInput).append(saveBtn);
					wrapper.append(img).append(infoDiv);
					listItem.append(wrapper);

					$('#selling-list-div').append(listItem);

			});
		}
	});
});
	
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />