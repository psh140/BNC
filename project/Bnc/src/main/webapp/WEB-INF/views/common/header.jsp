<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="header">
	<div class="wrapper">
		<div class="logo">
			<a href="/">
				<img class="logo-img" src="/common/image/logo.png" width="70px;" height="70px;">
				<img src="/common/image/default/bnc.png">
			</a>
		</div>
		<div class="auth">
			<div class="info">
				<c:choose>
					<c:when test="${sessionScope.memb_id == null}">
						<p><a href="/auth/login">Login</a></p>
					</c:when>
					<c:when test="${sessionScope.memb_id != null}">
						<p><a href="/auth/logout">Logout</a></p>
						<p><a href="/auth/mypage/companyInfo/view">Mypage&nbsp;&nbsp;</a></p>
					</c:when>
				</c:choose>
			</div>
		</div>
		<div class="menu">
			<ul>
				<li><a href="/company/list">기업정보</a></li>
				<li class="dropdown-menu">
					<a href="/project/recruit/list">프로젝트</a>
					<ul class="sub-menu">
						<div class="sub-menu-wrapper">
							<ul>
								<li><a href="/project/recruit/list">모집 프로젝트</a></li>
								<li><a href="/project/my/list">내 프로젝트 현황</a></li>
							</ul>
						</div>
					</ul>    
				</li>
				<li><a href="/board/notice/list">공지사항</a></li>
				<li class="dropdown-menu">
					<a href="/terms/termsAndConditions">이용약관</a>
					<ul class="sub-menu">
						<div class="sub-menu-wrapper">
							<ul>
								<li><a href="/terms/termsAndConditions">이용약관</a></li>
								<li><a href="/terms/privacyPolicy">개인정보처리방침</a></li>
							</ul>
						</div>
					</ul>    
				</li>
			</ul>
		</div>
	</div>
</div>