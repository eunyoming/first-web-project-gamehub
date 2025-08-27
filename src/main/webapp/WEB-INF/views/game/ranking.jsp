<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
</style>


<div class="d-flex justify-content-center align-items-center">

	<div class="container">
	<c:forEach var="rec" items="${gameRecordList}" varStatus="status">
		<div class="row">
			<div class="col-12">
				<div class="card">
					<div class="card-body">
						
						<div class="row" id=rank1>
							<div class="col-2" >${status.index + 1}등</div>
							<div class="col-2" ><img alt="아이콘" class="img-fluid">
							</div>
							<div class="col-3" >${rec.userId}</div>
							<div class="col-2" >             </div>
							<div class="col-3" ><h3>${rec.gameScore}점</h3></div>
						</div>
						
					</div>
				</div>
			</div>
		</div>
		</c:forEach>
	</div>
</div>

<script>
	
	
	
	
</script>