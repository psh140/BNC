<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../../common/include.jsp" %>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../../common/header.jsp" %>
	<div class="container">
		<div class="contents">
			<form method="POST" name="agreeForm">
				<div class="terms-and-conditions">
					<div class="title">이용 약관</div>			
					<div class="agreement-texa">${termsAndConditions.pol_contents}</div>
					<div class="chkbox-wrap">
						<input class="chkbox" name="agree" type="checkbox"/>
						<p class="agree-txt">상기 내용에 동의 합니다.</p>
					</div>
				</div>
			
				<div class="privacy-policy">
					<div class="title">개인정보 처리 방침</div>
						<div class="agreement-texa">${privacyPolicy.pol_contents}</div> 
					<div class="chkbox-wrap">
						<input class="chkbox" name="agree" type="checkbox"/>
						<p class="agree-txt">상기 내용에 동의 합니다.</p>
					</div>
				</div>
			
				<input type="hidden" name="memb_id" value="${member.memb_id}"/>
				<input type="hidden" name="memb_kind" value="${member.memb_kind}"/>
				<input type="hidden" name="memb_email" value="${member.memb_email}"/>
				<input type="hidden" name="memb_ip" value="${member.memb_ip}"/>
			</form>
			<div class="btn">
				<a href="../../">돌아가기</a>
				<a class="submit" href="javascript:void(0);" onclick="agree();">가입</a>
			</div>
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>
<script>
	function agree() {
		var form = document.agreeForm;
		var chkbox = document.getElementsByName('agree');
		var chk = false;
		
		for(var i=0; i<chkbox.length; i++) {
			if(chkbox[i].checked) {
				chk = true;
			} else {
				chk = false;
			}
		}
		
		if(!chk) {
			alert('모든 약관에 동의해주시기 바랍니다.');
			return false;
		}
		
		form.action = "/auth/login/agreement/process";
		form.submit();
	}
</script>