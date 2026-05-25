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
				<div>기업관리</div>
			</div>
			<div class="board">
				<div class="board-top">
					<div class="board-search">
						<form method="GET" action="" name="searchForm">
							<select name="srch">
								<option value="bizc_name" <c:if test="${srch == 'bizc_name'}">selected</c:if>>업종</option>
							</select>
							<input type="text" name="keyword" value="<c:if test="${keyword != ''}">${keyword}</c:if>">
							<a class="search-btn" href="javascript:void(0);" onclick="searchSubmit();"><img class="search-btn-img" src="/common/image/icon_search.png"></a>
						</form>
					</div>
				</div>
				<table>
					<thead>
						<tr>
							<th>CI 이미지</th>
							<th>기업명</th>
							<th>업종</th>
							<th>등록일</th>
							<th>수정일</th>
						</tr>
					</thead>
					<c:forEach items="${list}" var="company">
						<tr>
							<td>
								<a href="/company/view?cmpy_biznum=${company.cmpy_biznum}&${resultQueryString}">
									<img src="${company.cmpy_ci_file_path}" width="80px;" height="80px;">
								</a>
							</td>
							<td>
								<a href="/company/view?cmpy_biznum=${company.cmpy_biznum}&${resultQueryString}">
									${company.cmpy_company_name}
								</a>
							</td>
							<td>
								<a href="/company/view?cmpy_biznum=${company.cmpy_biznum}&${resultQueryString}">
									${company.bizc_name}
								</a>
							</td>
							<fmt:parseDate value="${company.cmpy_rdate}" var="rdate" pattern="yyyyMMddHHmmss"/>
							<td><fmt:formatDate value="${rdate}" pattern="yyyy-MM-dd"/></td>
							<fmt:parseDate value="${company.cmpy_udate}" var="udate" pattern="yyyyMMddHHmmss"/>
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