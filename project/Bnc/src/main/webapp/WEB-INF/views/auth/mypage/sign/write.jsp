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
					<form method="POST" name="signForm" enctype="multipart/form-data">
						<input type="hidden" name="stdFilePath" id="stdFilePath" value="/sign"/>
						<div class="sign-image">
							<div class="image-field">
								<img id="sign_file" src="/common/image/ci_thumb_default.jpg">
								<span class="sign-img-btn" onclick="fileBtnClick(this);">
									<img src="/common/image/thumb_add.png">
								</span>
								<input class="input-file-hidden" type="file" name="signFile" id="signFile"/>
							</div>
						</div>
					</form>
					<div class="btn">
						<a href="javascript:history.back(-1);" class="cancel">취소</a>
						<a href="javascript:void(0)" onclick="signSubmit();" class="submit">등록</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../../../common/footer.jsp" %>
</div>
</body>
<script>
	function signSubmit(){
		
		var form = document.signForm;
		
		var sign_file = form.signFile.value;
		
		if(sign_file=="") {
			alert('서명을 등록해주시기 바랍니다.');
			return false;
			
		} else {
			form.action = "/auth/mypage/sign/write/process";
			form.submit();
			return true;
		}
	}
</script>
<script>
	function fileBtnClick(e){
	
		var btnObj = $(e).parent().find("input");
		
		btnObj.click();
	       
		var ext = btnObj.val().split(".").pop().toLowerCase();
		if(ext.length > 0){
			if($.inArray(ext, ["gif","png","jpg","jpeg","ai"]) == -1) { 
				alert("gif,png,jpg 파일만 업로드 할수 있습니다.");
				return false;  
			}                  
		}
	
		btnObj.change(function () {
	   		readURL(this);
	    });
	}
		
	function readURL(input) {
		if (input.files && input.files[0]) {
			var reader = new FileReader();
	        reader.onload = function(e){
	        	$(input).parent().find("#sign_file").attr('src', e.target.result)
	        }
	        reader.readAsDataURL(input.files[0]);
		}
	}
</script>
</html>
