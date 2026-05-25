<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/include.jsp" %>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../common/header.jsp" %>
	<div class="container">
		<div class="contents">
			<div class="cont-title">
				<div>계약서 관리</div>
			</div>
			<div class="board">
				<div class="board-top">
					<div class="board-search">
						<form method="GET" action="" name="searchForm">
							<select name="srch">
								<option value="doct_code" <c:if test="${srch == 'doct_code'}">selected</c:if>>문서번호</option>
								<option value="doct_name" <c:if test="${srch == 'doct_name'}">selected</c:if>>문서이름</option>
							</select>
							<input type="text" name="keyword" value="<c:if test="${keyword != ''}">${keyword}</c:if>">
							<a href="javascript:void(0);" onclick="searchSubmit();"><img class="search-btn-img" src="/common/image/icon_search.png"></a>
						</form>
					</div>
				</div>
				<div class="btn-wrapper">
					<div class="btn">
						<a href="/document/write" class="submit">등록</a>
					</div>
				</div>
				<table>
					<thead>
						<tr>
							<th style="width:350px;">문서 고유코드</th>
							<th>문서이름</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list}" var="document">
							<tr>
								<td>${document.doct_code}</td>
								<td><a href="/document/view?doct_code=${document.doct_code}&${resultQueryString}">${document.doct_name}</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<div class="page">
					${pageMaker}
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>	
</div>
</body>
<script>
function searchSubmit(){
	var frm = document.searchForm;
	
	if(frm.keyword.value == ""){
		alert('검색어를 입력해 주세요.');
		return;
	}
	
	frm.submit();
}
</script>
</html>