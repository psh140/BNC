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
				<div>계약서</div>
			</div>
			<div class="document-view">
				<table>
					<tbody>
						<tr>
							<th>문서번호</th>
							<td>${document.doct_code}</td>
							<th style="border-left:1px solid #e0e0e0;">문서이름</th>
							<td>${document.doct_name}</td>
						</tr>
						<tr>
							<td colspan="4">${document.doct_form}</td>
						<tr>
					</tbody>
				</table>
			</div>
			<div class="btn">
				<a href="list${resultQueryString}" class="cancel">목록</a>
				<a href="modify?doct_code=${document.doct_code}&${resultQueryString}" class="submit">수정</a>
				<a href="delete?doct_code=${document.doct_code}" class="cancel">삭제</a>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>