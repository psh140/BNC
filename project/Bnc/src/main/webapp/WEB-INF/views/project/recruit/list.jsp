<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/custom.tld" %>
<%@ include file="../../common/include.jsp" %>
<c:if test="${not empty resultQueryString}">
	<c:set var="queryString" value="&${resultQueryString}"/>
</c:if>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../../common/header.jsp" %>	
	<div class="container">
	    <div class="contents">
	    	<div class="cont-title">
				<div>모집 프로젝트</div>
			</div>
	    	<div class="board">
	    		<div class="board-top">
		    		<div class="board-search">
						<form method="GET" action="" name="searchForm">
							<select name="srch">
								<option value="proj_kind" <c:if test="${srch == 'proj_kind'}">selected</c:if>>구분</option>
								<option value="proj_name" <c:if test="${srch == 'proj_name'}">selected</c:if>>프로젝트명</option>
							</select>
							<input type="text" name="keyword" value="<c:if test="${keyword != ''}">${keyword}</c:if>">
							<a class="search-btn" href="javascript:void(0);" onclick="searchSubmit();"><img class="search-btn-img" src="/common/image/icon_search.png"></a>
						</form>
					</div>
					<div class="board-btn">
						<a href="write">등록</a>
					</div>
				</div>
				<div class="board-list">
					<c:forEach var="lists" items="${list}">
					<div class="box project">
						<a href="view?seq=${lists.proj_number}${queryString}">
							<div class="box-wrapper project">
								<div class="igs">
									<c:choose>
										<c:when test="${lists.proj_thumb_file_path == null}">	
											<img src="/common/image/project_thumb_default.jpg">
										</c:when>
										<c:when test="${lists.proj_thumb_file_path != null}">
											<img src="${lists.proj_thumb_file_path}">
										</c:when>
									</c:choose>
								</div>
								<div class="name">${lists.proj_name}</div>
								<div class="kind">${lists.proj_kind}</div>
								<div class="stat">
									<c:set var="flags" value="${lists.proj_flag}"/>
									<c:out value="${custom:projectTypeKr(flags)}"/>
								</div>
								<div class="date">
									<fmt:parseDate var="jstlDate" value="${lists.proj_rdate}" pattern="yyyyMMddHHmmss"/>
									<fmt:formatDate value="${jstlDate}" pattern="yyyy-MM-dd"/>
								</div>
							</div>
						</a>
					</div>
					</c:forEach>
					
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