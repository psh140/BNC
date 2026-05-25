<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html lang="ko">
<c:import url="${configData.FILE_PATH_HEAD}"/>
<body>
<script>
	function joinSubmit(){
		
		var frm = document.frmForm;
		
		if(frm.memberID.value == ""){
			alert('아이디를 입력해 주세요.');
			return;
		}
		
		if(frm.memberPassword.value == ""){
			alert('비밀번호를 입력해 주세요.');
			return;
		}
		
		if(frm.memberName.value == ""){
			alert('이름을 입력해 주세요.');
			return;
		}
		
		if(frm.memberAddr.value == ""){
			alert('주소를 입력해 주세요.');
			return;
		}
		
		if(frm.memberPhone.value == ""){
			alert('연락처를 입력해 주세요.');
			return;
		}
		
		frm.action = "${configData.CONTEXT_PATH}/Member/joinProcess";
		frm.submit();
	}
</script>
<div class="scrollbar-inner">
	<div id="wrap">
		<c:import url="${configData.FILE_PATH_GNB}"/>
		<div id="container">
			<div class="contents">
				<div class="top">
					<ul class="info">
					</ul>
				</div>
				<div class="center">
					<form method="POST" name="frmForm">
					<div class="join">
						<div class="title">회원 가입</div>
						<div class="subtitle">환영합니다!</div>
						<div class="inputfield">
							<input type="text" name="memberID" placeholder="아이디"/>
						</div>
						<div class="inputfield">
							<input type="password" name="memberPassword" placeholder="비밀번호"/>
						</div>
						<div class="inputfield">
							<input type="text" name="memberName" placeholder="성함"/>
						</div>
						<div class="inputfield">
							<input type="text" name="memberAddr" placeholder="주소"/>
						</div>
						<div class="inputfield lastest">
							<input type="text" name="memberPhone" placeholder="연락처"/>
						</div>
					</div>
					</form>
					<div class="btn double">
						<a class="lf" href="history.back(-1);">돌아가기</a>
						<a class="rt" href="javascript:void(0);" onclick="joinSubmit();">가입하기</a>
					</div>
				</div>
			</div>
		</div>
		<c:import url="${configData.FILE_PATH_FOOTER}"/>
	</div>
</div>
</body>
<!-- 카카오 주소 API 스크립트 -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
	function popPostSearchOpen(){
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
                // 예제를 참고하여 다양한 활용법을 확인해 보세요.
                //$("#m_post_num").val(data.zonecode);
                $("#m_address").val(data.roadAddress);
                //$("#m_corp_detail_address").val(null);
            }
        }).open();
	}
</script>
</html>