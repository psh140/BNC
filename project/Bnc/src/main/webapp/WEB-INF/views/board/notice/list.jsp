<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../../common/include.jsp" %>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../../common/header.jsp" %>	
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
							</select>
							<input type="text" name="keyword" value="<c:if test="${keyword != ''}">${keyword}</c:if>">
							<a class="search-btn" href="javascript:void(0);" onclick="searchSubmit();"><img class="search-btn-img" src="/common/image/icon_search.png"></a>
						</form>
					</div>
				</div>
				<div class="board-list">
					<table class="board-list">
						<colgroup>
							<col style="width:140px;">
                    		<col>
	                   		<col style="width:200px;">
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>날짜</th>
							</tr>
						</thead>
						<c:forEach var="boardlist" items="${list}">
							<tr>
								<td>${boardlist.notc_number}</td>                        
		                        <td><a href="view?seq=${boardlist.notc_number}&${resultQueryString}">${boardlist.notc_title}</a></td>
		                        <fmt:parseDate value="${boardlist.notc_udate}" var="udate" pattern="yyyyMMddHHmmss"/>
		                        <td><fmt:formatDate value="${udate}" pattern="yyyy-MM-dd"/></td>
							</tr>		
						</c:forEach>
					</table>
					<div class="page">
						${pageMaker}
					</div>
				</div>
	    	</div>
	    </div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
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