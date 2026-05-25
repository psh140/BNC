<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/include.jsp" %>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../common/header.jsp" %>
	<div class="container">
		<div class="contents">
			<div class="login-box">
				<div class="box-intro">BNC에 오신것을 환영 합니다.</div>
				<div class="box-title">로그인</div>
				<div class="box-btn">
					<a class="naver" href="${naver_url}">
						네이버로 로그인
						<!-- img width="223" src="${pageContext.request.contextPath}/resources/img/naver_Bn_Green.PNG"/-->
					</a>
					<a class="kakao" href="${kakao_url}">
						카카오로 로그인
						<!-- img width="223" src="#"/-->
					</a>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>