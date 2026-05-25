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
				<div>회원탈퇴</div>
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
					<div class="board-title">회원탈퇴 유의사항</div>
					<div class="title-sub">아래의 유의사항을 꼭 확인하시기 바랍니다.</div>
					<div class="board-box">
						<p>- 회원탈퇴 후 재가입 시, 제한을 받을 수 있습니다.</p>
						<p>- 회원탈퇴 시 동일한 아이디로는 재가입 하실 수 없으며, 복구하는 것이 불가능 하오니 탈퇴 시 유의하시기 바랍니다.</p>
						<p>- 회원탈퇴 시 등록하신 모든 콘텐츠를 삭제되며, 삭제된 데이터는 복구가 불가합니다.</p>
					</div>
					<form method="POST" name="withdrawalForm">
						<div class="board-input">
							<label>E-mail</label>
							<input tpye="text" name="memb_email">
						</div>
					</form>
					<div class="btn">
						<a href="javascript:void(0)" onclick="formSubmit();" class="submit">회원탈퇴</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../../../common/footer.jsp" %>
</div>
</body>
<script>
	function formSubmit(){
		
		var form = document.withdrawalForm;
		
		form.action = "/auth/mypage/withdrawal/process";
		form.submit();
	}
</script>
</html>

