<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="header">
	<div class="wrapper">
		<div class="logo">
			<a href="/"><img src="/common/image/default/bnc.png"></a>
		</div>
		<div class="auth">
			<div class="info">
				<c:choose>
					<c:when test="${sessionScope.admin_id != null}">
						<p><a href="/auth/logout">Logout</a></p>
					</c:when>
				</c:choose>
			</div>
		</div>
		<div class="menu">
			<ul>
				<li><a href="/member/list">회원관리</a></li>
				<li><a href="/company/list">기업관리</a></li>
				<li><a href="/project/list">프로젝트</a></li>
				<li><a href="/document/list">서식관리</a></li>
				<li><a href="/notice/list">공지사항</a></li>
				<li>
					<a href="">약관관리</a>
					<ul class="sub-menu">
						<div class="sub-menu-wrapper">
							<ul>
								<li><a href="/terms/termsAndConditions/view">이용약관</a></li>
								<li><a href="/terms/privacyPolicy/view">개인정보처리방침</a></li>
							</ul>
						</div>
					</ul>
				</li>
				<li><a href="/chart/view">통계관리</a></li>
			</ul>
		</div>
	</div>
</div>