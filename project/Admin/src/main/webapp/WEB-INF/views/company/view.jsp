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
				<div>기업정보</div>
			</div>
		<div>
		<div class="company-view">
			<table>
				<tbody>
					<tr>
						<td rowspan="4" style="width: 200px; height: 200px; border:1px solid black;">
							<c:if test="${empty company.cmpy_ci_file_path}">
								<img alt="" src="/common/image/ci_thumb_default.jpg" width=200px; height=200px;/>
							</c:if>
							<c:if test="${not empty company.cmpy_ci_file_path}">
								<img alt="" src="${company.cmpy_ci_file_path}" width=200px; height=200px;/>
							</c:if>
						</td>
						<tr>
							<th>기업명</th>
							<td>${company.cmpy_company_name}</td>
							<th>대표자명</th>
							<td>${company.cmpy_ceo_name}</td>
						</tr>
						<tr>
							<th>업종</th>
							<td>${company.bizc_name}</td>
							<th>대표 연락처</th>
							<td>${company.cmpy_biz_phone}</td>
						</tr>
						<tr>
							<th>회사 주소</th>
							<td>${company.cmpy_biz_address}</td>
							<th>홈페이지</th>
							<td>${company.cmpy_homepage}</td>
						</tr>
					</tr>
					<tr>
						<th colspan="5">기업소개</th>
					</tr>
					<tr>
						<td colspan="5" style="margin:20px auto;">${company.cmpy_contents}</td>
					</tr>
				</tbody>
			</table>
			<div class="btn">
				<a href="delete?cmpy_biznum=${company.cmpy_biznum}" class="cancel">삭제</a>
				<a href="list${resultQueryString}" class="submit">목록</a>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>		
</div>
</body>
</html>