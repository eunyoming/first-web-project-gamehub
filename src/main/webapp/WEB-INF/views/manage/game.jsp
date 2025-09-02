<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/manage_header.jsp" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>

<div class="container-fluid mt-5">
	<h2 class="mb-4">게임 관리 대시보드</h2>
	
	<div class="row">
	<div class="col-4">
		    <h4>게임 목록</h4>
		    <ul id="gameList" class="list-group">게임 목록을 불러오는 중입니다...</ul>
		  </div>
		  <div class="col-8">
		    <h4>게임 상세</h4>
		    <div id="gameDetail"> 게임 상세 페이지를 불러오는 중입니다...</div>
		  </div>
		</div>

	<div id="guideEditorModal" style="display:none;">
	  <textarea id="guideEditor"></textarea>
	  <button onclick="saveGuide()" class="btn btn-success">저장</button>
	</div>
</div>

<script>
$(document).ready(function(){
    $.ajax({
        url: "/api/game/gameList",
        type: "GET",
        dataType: "json",
        success: function(data){
            let listHtml = "";
            data.forEach(game => {
            	listHtml += '<li class="list-group-item" onclick="loadGameInfo(' + game.seq + ')">'
                + '<div><strong>' + game.title + '</strong></div>'
                + '<small class="text-muted">' + (game.description ? game.description: "설명 없음") + '</small>'
                + '</li>';
            });
            $("#gameList").html(listHtml);
        }
    });
});

function loadGameInfo(seq){
    $.ajax({
        url: "/api/game/gameInfo?seq=" + seq,
        type: "GET",
        dataType: "json",
        success: function(info){
        	let html = 
        	    '<h5>' + info.creator + ' 님의 코멘트</h5>' +
        	    '<p>' + (info.creatorComment || '없음') + '</p>' +
        	    '<h5>가이드</h5>' +
        	    '<div>' + (info.guide || '작성된 가이드 없음') + '</div>' +
        	    '<button onclick="editGuide(' + seq + ')" class="btn btn-primary mt-2">가이드 수정</button>';
            $("#gameDetail").html(html);
            
            
            $('#guideEditor').summernote({
                height: 300,
                fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체'],
                fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
             
                lang: "ko-KR",
                placeholder : "내용을 작성하세요.",
                 toolbar: [
                       ['style', ['bold', 'italic', 'underline', 'clear']],
                       ['font', ['fontname', 'fontsize', 'strikethrough', 'superscript', 'subscript']],
                       ['color', ['color']],
                       ['para', ['ul', 'ol', 'paragraph']],
                       ['insert', ['link', 'picture', 'video']],
                       ['view', ['fullscreen', 'codeview', 'help']]
                     ],
                callbacks: {
                    onImageUpload: function(files) {
                        for (var i = 0; i < files.length; i++) {
                            uploadImage(files[i]);
                        }
                    }
                }
            });
            
            $('#guideEditor').summernote('code', info.guide || '');
        }
    });
}

let currentSeq = null;

function editGuide(seq){
    currentSeq = seq;
    $("#guideEditorModal").show();
} 


function saveGuide(){
	 const content = $('#guideEditor').summernote('code');
    $.ajax({
        url: "/api/manage/saveGameInfo",
        type: "POST",
        data: { seq: currentSeq, guide: content },
        success: function(){
            alert("저장 완료!");
            $("#guideEditorModal").hide();
            loadGameInfo(currentSeq);
        }
    });
}



function uploadImage(file) {
    var data = new FormData();
    data.append("file", file);

    $.ajax({
        url: '/api/manage/gameGuideUploadImage',
        type: 'POST',
        data: data,
        cache: false,
        contentType: false,
        processData: false,
        success: function(resp) {
            $('#guideEditor').summernote('insertImage', resp.url);
        }
    });
}
</script>

 
<jsp:include page="/WEB-INF/views/common/footer.jsp" />