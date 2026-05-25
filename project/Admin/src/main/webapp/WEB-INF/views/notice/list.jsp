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
				<div>공지사항</div>
			</div>
			<div class="board">
				<div class="board-top">
					<div class="board-search">
						<form method="GET" action="" name="searchForm">
							<select name="srch">
								<option value="notc_title" <c:if test="${srch == 'notc_title'}">selected</c:if>>제목</option>
								<option value="notc_contents" <c:if test="${srch == 'notc_contents'}">selected</c:if>>내용</option>
							</select>
							<input type="text" name="keyword" value="<c:if test="${keyword != ''}">${keyword}</c:if>">
							<a href="javascript:void(0);" onclick="searchSubmit();"><img class="search-btn-img" src="/common/image/icon_search.png"></a>
						</form>
					</div>
				</div>
				<div class="btn-wrapper">
					<div class="btn">
						<a href="/notice/write" class="submit">글쓰기</a>
					</div>
				</div>
				<table>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>날짜</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list}" var="notice">
							<tr>
								<td>${notice.notc_number}</td>
								<td><a href="/notice/view?notc_number=${notice.notc_number}&${resultQueryString}">${notice.notc_title}</a></td>
								<fmt:parseDate value="${notice.notc_udate}" var="udate" pattern="yyyyMMddHHmmss"/>
								<td><fmt:formatDate value="${udate}" pattern="yyyy-MM-dd"/></td>
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
</html>
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