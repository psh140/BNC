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
				<div>개인정보처리방침 수정</div>
			</div>
		</div>
		<div class="terms-modify">
			<form method="POST" name="modify">
				<input type="hidden" value="${view.pol_kind}" name="pol_kind">
				<textarea name="pol_contents" id="pol_contents">
					<c:out value="${view.pol_contents}"/>
				</textarea>
			</form>
			<div class="btn">
				<a class="cancel" href="javascript:history.back(-1);">취소</a>
				<a class="submit" href="" onclick="termsSubmit(); return false;">수정</a>
			</div>
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>		
</div>
</body>
</html>
<script>
	function termsSubmit(){
		
		var frm = document.modify;
		
		oEditors.getById["pol_contents"].exec("UPDATE_CONTENTS_FIELD", []);
		
		frm.action = "/terms/privacyPolicy/modify/execute";
		frm.submit();
	}
	
 	var oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
	    oAppRef: oEditors,
	    elPlaceHolder: "pol_contents",
	    sSkinURI: "/common/editor/SmartEditor2Skin.html",
	    fCreator: "createSEditor2"
	}); 
</script>
