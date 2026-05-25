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
			<div class="notice">
				<div class="notice-view">
					<table>
						<tbody>
							<tr>
								<th>번호</th>
								<td>${notice.notc_number}</td>
								<th style="border-left:1px solid #e0e0e0;">날짜</th>
								<fmt:parseDate value="${notice.notc_udate}" var="udate" pattern="yyyyMMddHHmmss"/>
								<td><fmt:formatDate value="${udate}" pattern="yyyy-MM-dd"/></td>
							</tr>
							<tr>
								<th>제목</th>
								<td colspan="3">${notice.notc_title}</td>
							</tr>
							<tr>
								<td colspan="4">${notice.notc_contents}</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn">
					<a href="list${resultQueryString}" class="cancel">목록</a>
					<a href="modify?notc_number=${notice.notc_number}" class="submit">수정</a>
					<a href="delete?notc_number=${notice.notc_number}" class="cancel">삭제</a>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>	
</div>
</body>
</html>