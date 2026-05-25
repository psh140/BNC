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
				<div>이용약관</div>
			</div>
			<div class="terms-view">
				<div class="terms-date-wrapper">
					<ul>
						<li>날짜&nbsp;</li>
						<fmt:parseDate value="${view.pol_udate}" var="udate" pattern="yyyyMMddHHmmss"/>
						<li>
							<fmt:formatDate value="${udate}" pattern="yyyy-MM-dd"/>
						</li>
					</ul>
				</div>
				<div>
					${view.pol_contents}
				</div>
				<div class="btn">
					<a href="modify?pol_kind=${view.pol_kind}" class="submit">수정</a>
				</div>
			</div>
		<div>
	</div>
	<%@ include file="../../common/footer.jsp" %>		
</div>
</body>
</html>