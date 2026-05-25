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
				<div>기업정보</div>
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
					<form method="POST" name="companyForm" enctype="multipart/form-data">
						<input type="hidden" name="stdFilePath" id="stdFilePath" value="/companyInfo"/>
						<table>
							<tbody>
								<tr>
									<th>기업명</th>
									<td colspan="2">
										<input type="text" name="cmpy_company_name" value="${companyInfo.cmpy_company_name}">
									</td>
								</tr>
								<tr>
									<th>기업CI</th>
									<td colspan="2">
										<div class="image-field">
											<input type="hidden" name="cmpy_ci_file_path" value="${companyInfo.cmpy_ci_file_path}"/>
											<img id="cmpy_thumbnail" src="${companyInfo.cmpy_ci_file_path}">
											<span class="m-file-img-btn" onclick="fileBtnClick(this);">
												<img src="/common/image/thumb_add.png">
											</span>
											<input class="input-file-hidden" type="file" name="ciThumbNail" id="ciThumbNail"/>
										</div>
									</td>
								</tr>
								<tr>
									<th>대표자명</th>
									<td colspan="2">
										<input type="text" name="cmpy_ceo_name" value="${companyInfo.cmpy_ceo_name}">
									</td>
								</tr>
								<tr>
									<th>업종</th>
									<td colspan="2">
										<select name="cmpy_biz_code" style="width:450px; height:40px; padding:5px; border:1px solid #e0e0e0; margin:5px auto;">
											<c:forEach items="${bizcode}" var="bizcode">
												<option value="${bizcode.bizc_code}">${bizcode.bizc_name}</option>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<th>회사 주소</th>
									<td class="td-pos-wrapper">
										<input type="text" id="cmpy_biz_address" name="cmpy_biz_address" value="${companyInfo.cmpy_biz_address}">
										<a onclick="popPostSearchOpen();" class="address-btn">검색</a>
									</td>
								</tr>
								<tr>
									<th>대표 연락처</th>
									<td colspan="2">
										<input type="text" name="cmpy_biz_phone" value="${companyInfo.cmpy_biz_phone}">
									</td>
								</tr>
								<tr>
									<th>대표 이메일</th>
									<td colspan="2">
										<input type="text" name="cmpy_biz_email" value="${companyInfo.cmpy_biz_email}">
									</td>
								</tr>
								<tr>
									<th>홈페이지</th>
									<td colspan="2">
										<input type="text" name="cmpy_homepage" value="${companyInfo.cmpy_homepage}">
									</td>
								</tr>
								<tr>
									<th>기업소개</th>
									<td colspan="2" style="padding-left:120px;">
										<textarea name="cmpy_contents" id="cmpy_contents">${companyInfo.cmpy_contents}</textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
					<div class="btn">
						<a href="javascript:history.back(-1);" class="cancel">취소</a>
						<a href="javascript:void(0)" onclick="companyInfoSubmit();" class="submit">완료</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../../../common/footer.jsp" %>
</div>
</body>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
   function popPostSearchOpen(){
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
                // 예제를 참고하여 다양한 활용법을 확인해 보세요.
                //$("#m_post_num").val(data.zonecode);
                $("input[name='cmpy_biz_address']").val(data.roadAddress);
                //$("#m_corp_detail_address").val(null);
            }
        }).open();
   }
</script>
<script>
	function companyInfoSubmit(){
		
		var form = document.companyForm;
		
		var cmpy_name = form.cmpy_company_name.value;
		var cmpy_ceo = form.cmpy_ceo_name.value;
		var cmpy_bizcode = form.cmpy_biz_code.value;
		
		if(cmpy_name=="") {
			alert('기업명을 입력해주시기 바랍니다.');
			form.cmpy_company_name.focus();
			return false;
		} else if(cmpy_ceo=="") {
			alert('대표자 명을 입력해주시기 바랍니다.');
			form.cmpy_ceo_name.focus();
			return false;
		} else if(cmpy_bizcode=="") {
			orm.cmpy_biz_code.focus();
			return false;
		} else {
			oEditors.getById["cmpy_contents"].exec("UPDATE_CONTENTS_FIELD", []);
			
			form.action = "/auth/mypage/companyInfo/modify/process";
			form.submit();
			return true;
		}
	}
	
	var oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
	    oAppRef: oEditors,
	    elPlaceHolder: "cmpy_contents",
	    sSkinURI: "/common/editor/SmartEditor2Skin.html",
	    fCreator: "createSEditor2"
	});
</script>
<script>
	function fileBtnClick(e){
	
		var btnObj = $(e).parent().find("input");
		
		btnObj.click();
	       
		var ext = btnObj.val().split(".").pop().toLowerCase();
		if(ext.length > 0){
			if($.inArray(ext, ["gif","png","jpg","jpeg"]) == -1) { 
				alert("gif,png,jpg 파일만 업로드 할수 있습니다.");
				return false;  
			}                  
		}
	
		btnObj.change(function () {
	   		readURL(this);
	    });
	}
		
	function readURL(input) {
		if (input.files && input.
				files[0]) {
			var reader = new FileReader();
	        reader.onload = function(e){
	        	$(input).parent().find("#cmpy_thumbnail").attr('src', e.target.result)
	        }
	        reader.readAsDataURL(input.files[0]);
		}
	}
</script>
</html>
