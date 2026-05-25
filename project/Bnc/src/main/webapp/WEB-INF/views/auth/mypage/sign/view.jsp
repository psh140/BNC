<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../../../common/include.jsp" %>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../../../common/header.jsp" %>
	<div class="container">
		<div class="contents">
			<div class="cont-title">
				<div>서명관리</div>
			</div>
			<div class="cont-space">
				<div class="left-menu">
					<ul>
						<li><a href="/auth/mypage/companyInfo/view">기업정보</a></li>
						<li><a href="/auth/mypage/sign/view">서명관리</a></li>
						<li><a href="/auth/mypage/withdrawal/view">회원탈퇴</a></li>
					</ul>
				</div>
				<div class="board-write">
					<div class="btn">
						<a href="/auth/mypage/sign/write" onclick="signSubmit();" class="submit">등록</a>
					</div>
					<c:forEach items="${signList}" var="sign">
						<input type="hidden" name="sign_num" value="${sign.sign_num}"/>
						<div class="sign-wrapper">
							<img alt="" src="${sign.sign_file_path}" width=200px; height=200px;/>
							<div class="btn-mini">
								<a href="/auth/mypage/sign/delete?seq=${sign.sign_num}" class="cancel-mini">삭제</a>
								<a href="/auth/mypage/sign/modify?seq=${sign.sign_num}" class="submit-mini">수정</a>
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../../../common/footer.jsp" %>
</body>
</html>
