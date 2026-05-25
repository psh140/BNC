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
				<div>회원관리</div>
			</div>
			<div class="board">
				<div class="board-top">
					<div class="board-search">
						<form method="GET" action="" name="searchForm">
							<select name="srch">
								<option value="memb_email" <c:if test="${srch == 'proj_kind'}">selected</c:if>>이메일</option>
							</select>
							<input type="text" name="keyword" value="<c:if test="${keyword != ''}">${keyword}</c:if>">
							<a href="javascript:void(0);" onclick="searchSubmit();"><img class="search-btn-img" src="/common/image/icon_search.png"></a>
						</form>
					</div>
				</div>
				<table>
					<thead>
						<tr>
							<th>아이디</th>
							<th>기업명</th>
							<th>사업자번호</th>
							<th>인증여부</th>
							<th>가입일</th>
							<th>비고</th>
						</tr>
					</thead>
					<c:forEach items="${list}" var="member">
						<tr>
							<td><a href="/member/view?memb_id=${member.memb_id}&${resultQueryString}">${member.memb_id}</a></td>
							<td><a href="/member/view?memb_id=${member.memb_id}&${resultQueryString}">${member.cmpy_company_name}</a></td>
							<td><a href="/member/view?memb_id=${member.memb_id}&${resultQueryString}">${member.cmpy_biznum}</a></td>
							<td>${member.memb_auth_flag}</td>
							<fmt:parseDate value="${member.memb_rdate}" var="rdate" pattern="yyyyMMddHHmmss"/>
							<td><fmt:formatDate value="${rdate}" pattern="yyyy-MM-dd"/></td>
							<td><a class="link-btn" href="/member/modify?memb_id=${member.memb_id}">수정</a>&nbsp;
							<c:choose>
								<c:when test="${member.memb_auth_flag == 'Y'}">
									<a class="link-btn" href="/member/inactivate?memb_id=${member.memb_id}">비활성화</a>
								</c:when>
								<c:when test="${member.memb_auth_flag == 'N'}">
									<a class="link-btn" href="/member/activate?memb_id=${member.memb_id}">활성화</a>
								</c:when>
							</c:choose>
							</td>
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