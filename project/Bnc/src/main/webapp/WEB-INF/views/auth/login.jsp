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
					<%--
						소셜 로그인 버튼은 해당 제공자의 키가 .env에 채워져 있을 때만 노출된다.
						(활성화 판단은 OAuthConfig.isNaverEnabled() / isKakaoEnabled())
					--%>
					<c:if test="${naver_enabled}">
						<a class="naver" href="${naver_url}">
							네이버로 로그인
							<!-- img width="223" src="${pageContext.request.contextPath}/resources/img/naver_Bn_Green.PNG"/-->
						</a>
					</c:if>
					<c:if test="${kakao_enabled}">
						<a class="kakao" href="${kakao_url}">
							카카오로 로그인
							<!-- img width="223" src="#"/-->
						</a>
					</c:if>
					<c:if test="${not naver_enabled and not kakao_enabled}">
						<p class="login-disabled" style="text-align:center; color:#888; font-size:14px; line-height:1.6;">
							소셜 로그인은 현재 비활성화되어 있습니다.
						</p>
					</c:if>
					<a class="admin" href="/admin/auth/login" style="display:block; margin-top:20px; text-align:center; color:#888; font-size:13px;">
						관리자 페이지
					</a>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>