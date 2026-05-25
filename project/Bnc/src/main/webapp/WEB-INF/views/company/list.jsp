<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/include.jsp" %>
<c:if test="${not empty resultQueryString}">
	<c:set var="queryString" value="&${resultQueryString}"/>
</c:if>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../common/header.jsp" %>	
	<div class="container">	
	    <div class="contents">
	    	<div class="cont-title">
				<div>기업정보</div>
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
				<div class="board-list">
					<c:forEach items="${list}" var="company">
						<div class="box company">
							<a href="view?cmpy_biznum=${company.cmpy_biznum}&${resultQueryString}">
								<div class="box-wrapper">
									<div class="igs">
										<img src="${company.cmpy_ci_file_path}">
									</div>
									<div class="name">${company.cmpy_company_name}</div>
									<div class="kind">${company.bizc_name}</div>
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