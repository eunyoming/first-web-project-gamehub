<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
</style>


<div class="d-flex justify-content-center align-items-center">

	<div class="container" id="rankList">
	
	</div>
</div>

<script>
function gameRecordByUserId(userId, score, startTime, endTime) {
	  $.ajax({
	    url: "/recordInsert",
	    type: "post",
	    contentType: "json; charset=UTF-8",
	    data: JSON.stringify({
	      userId: userId,
	      game_seq: game_seq,
	      gameScore: score,
	      gameStartTime: startTime,
	      gameEndTime: endTime
	    }),
	    success: function(resp) {
	      console.log("점수 기록 성공:", resp);
	      alert("점수가 저장되었습니다!");
	    },
	    error: function(xhr, status, error) {
	      console.error("점수 기록 실패:", error);
	      alert("점수 저장에 실패했습니다.");
	    }
	  });
	}




let game_seq = "${game_seq}";
$.ajax({
	  url: "/api/game/main/record",
	  type: "get",
	  dataType: "json",
	  data: { game_seq: game_seq } // JSP에서 변수 바인딩한 경우: "${game_seq}"
	}).done(function(resp) {
		console.log(resp);
		
		let $container = $("#rankList").empty();
	console.log(resp.records);
	console.log(resp.profiles);
		  resp.records.forEach(function(record, index) {
		    let profile = resp.profiles.find(p => p.userId == record.userId);

		    let $row = $(
		      '<div class="row mb-2">'+
		        '<div class="col-12">'+
		          '<div class="card">'+
		            '<div class="card-body">'+
		              '<div class="row">'+
		                '<div class="col-2">' + (index + 1) + '등</div>'+
		                '<div class="col-2">'+
		                  '<img src="'+profile.profileImage+ '" alt="아이콘" class="rounded-circle mb-3" width="80" height="80">'+
		                '</div>'+
		                '<div class="col-3"><a href="/api/member/mypage?userId=' +
		                record.userId  +
		                '" style="text-decoration: none; color: inherit;"><div class="row" >' + record.userId + '</div>' +
		                 '<div class="row" >' +profile.achievDTO.title + '</div></a></div>'+
		                '<div class="col-2"></div>'+
		                '<div class="col-3">점수 ' + record.gameScore + '</div>'+
		              '</div>'+
		            '</div>'+
		          '</div>'+
		        '</div>'+
		      '</div>'
		    );

		    $container.append($row);
		  });
	}).fail(function(xhr, status, error) {
	  console.error("AJAX 실패:", status, error);
	});


	
	
</script>