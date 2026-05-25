<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/custom.tld" %>
<%@ include file="../common/include.jsp" %>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../common/header.jsp" %>
	<div class="container">
		<div class="contents">
			<div class="cont-title">
				<div>프로젝트 관리</div>
			</div>
			<div class="board">
				<div class="board-top">
					<div class="board-search">
						<form method="GET" action="" name="searchForm">
							<select name="srch">
								<option value="proj_kind" <c:if test="${srch == 'proj_kind'}">selected</c:if>>구분</option>
								<option value="proj_name" <c:if test="${srch == 'proj_name'}">selected</c:if>>프로젝트명</option>
							</select>
							<input type="text" name="keyword" value="<c:if test="${keyword != ''}">${keyword}</c:if>" placeholder="예: 제작, 견적, 컨설팅">
							<a href="javascript:void(0);" onclick="searchSubmit();"><img class="search-btn-img" src="/common/image/icon_search.png"></a>
						</form>
					</div>
				</div>
				<table>
					<thead>
						<tr>
							<th>이미지</th>
							<th>프로젝트 명</th>
							<th>구분</th>
							<th>협의여부</th>
							<th>금액</th>
							<th>등록일</th>
							<th>수정일</th>
						</tr>
					</thead>
						<c:forEach items="${list}" var="project">
							<tr>
								<td><img src="${project.proj_thumb_file_path}" width="80px;" height="80px;"/></td>
								<td><a href="/project/view?proj_number=${project.proj_number}&${resultQueryString}">${project.proj_name}</a></td>
								<td>${project.proj_kind}</td>
								<td>
									<c:set var="flags" value="${project.proj_flag}"/>
									<c:out value="${custom:projectTypeKr(flags)}"/>
								</td>
								<td>${project.proj_price_range}</td>
								<fmt:parseDate value="${project.proj_rdate}" var="rdate" pattern="yyyyMMddHHmmss"/>
								<td><fmt:formatDate value="${rdate}" pattern="yyyy-MM-dd"/></td>
								<fmt:parseDate value="${project.proj_udate}" var="udate" pattern="yyyyMMddHHmmss"/>
								<td><fmt:formatDate value="${udate}" pattern="yyyy-MM-dd"/></td>
							</tr>
						</c:forEach>

					<tbody>
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