<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../../common/include.jsp" %>
<c:choose>
	<c:when test="${loginResult.code == '2000' || loginResult.code == '2002'}">
		<script>
			alert("${loginResult.msg}");
			location.href="/auth/logout";
		</script>
	</c:when>
	<c:when test="${loginResult.code == '2003' || loginResult.code == '2004'}">
		<script>
			alert("${loginResult.msg}");
			history.back(-1);
		</script>
	</c:when>
</c:choose>

<!-- 프로세스 결과 처리 확인 -->
<c:choose>
	<c:when test="${result.code != '0000' && not empty result.code}">
		<script>
			alert("${result.msg}");
		</script>
	</c:when>
</c:choose>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../../common/header.jsp" %>	
	<div class="container">
	    <div class="contents">
			<div class="board">
				<form method="POST" name="frmForm" enctype="multipart/form-data">
					<input type="hidden" name="stdFilePath" id="stdFilePath" value="/project"/>
					<div class="cont-info">
						<div class="image-field">
							<img id="proj_thumbnail" src="/common/image/project_thumb_default.jpg">
							<span class="file-img-btn" onclick="fileBtnClick(this);">
								<img src="/common/image/thumb_add.png">
							</span>
							<input class="input-file-hidden" type="file" name="projThumbNail" id="projThumbNail"/>
						</div>
						<div class="rtb-field">
							<div class="rw">
								<div class="dtd">
									<div class="tit">프로젝트명</div>
									<div class="data-field"><input type="text" name="proj_name" placeholder="프로젝트명"/></div>
								</div>
								<div class="dtd">
									<div class="tit">구분</div>
									<div class="data-field">
										<select name="proj_kind">
											<option value="">선택</option>
											<option value="제작">제작</option>
											<option value="견적">견적</option>
											<option value="컨설팅">컨설팅</option>
										</select>
									</div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">담당자 연락처</div>
									<div class="data-field"><input type="text" name="proj_req_phone" placeholder="담당자 연락처"/></div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">금액</div>
									<div class="data-field">
										<select name="proj_price_range">
											<option value="">선택</option>
											<option value="100만원 미만">100만원 미만</option>
											<option value="100만원 ~ 500만원">100만원 ~ 500만원</option>
											<option value="500만원 ~ 1000만원">500만원 ~ 1000만원</option>
											<option value="1000만원 ~ 3000만원">1000만원 ~ 3000만원</option>
											<option value="3000만원 ~ 5000만원">3000만원 ~ 5000만원</option>
											<option value="5000만원 이상">5000만원 이상</option>
										</select>
										<!-- input type="text" name="proj_price_range" placeholder="금액"/-->
									</div>
								</div>
								<div class="dtd">
									<div class="tit">키워드</div>
									<div class="data-field"><input type="text" name="proj_keyword" placeholder="키워드 구분자 ',' 최대 5개"/></div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">진행기간</div>
									<div class="data-field"><input type="text" name="proj_lead_time" placeholder="진행기간"/></div>
								</div>
								<div class="dtd">
									<div class="tit">동영상</div>
									<div class="data-field"><input type="text" name="proj_mov_url" placeholder="동영상 URL"/></div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">프로젝트 첨부파일</div>
									<div class="data-field file"><input class="input-file" type="file" name="fileField"  multiple/></div>
								</div>
							</div>
						</div>
					</div>
					<div class="cont-textarea">
						<textarea name="proj_contents" id="proj_contents" style="width:100%; height:400px;"></textarea>
					</div>
				</form>
				<div class="btn">
					<a class="cancel" href="javascript:history.back(-1);">취소</a>
					<a class="submit" href="javascript:void(0)" onclick="projectSubmit();">등록</a>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
<script>
	function projectSubmit(){
		
		var frm = document.frmForm;
		
		if(frm.projThumbNail.value == ""){
			alert('프로젝트 썸네일을 등록해 주세요.');
			return;
		}
		
		if(frm.proj_name.value ==""){
			alert('프로젝트명을 입력해 주세요.');
			frm.proj_name.focus();
			return;
		}
		
		if(frm.proj_kind.value ==""){
			alert('구분을 선택해 주세요.');
			frm.proj_kind.focus();
			return;
		}
		
		if(frm.proj_req_phone.value ==""){
			alert('담당자 연락처를 입력해 주세요.');
			frm.proj_req_phone.focus();
			return;
		}
		
		if(frm.proj_price_range.value ==""){
			alert('금액을 선택해 주세요.');
			frm.proj_price_range.focus();
			return;
		}
		
		if(frm.proj_lead_time.value ==""){
			alert('진행 기간을 입력해 주세요.');
			frm.proj_lead_time.focus();
			return;
		}
		
		oEditors.getById["proj_contents"].exec("UPDATE_CONTENTS_FIELD", []);
		
		var contentsCheck = $("#proj_contents").val();

		if(contentsCheck == ""  || contentsCheck == null || contentsCheck == '&nbsp;' || contentsCheck == '<p>&nbsp;</p>' || contentsCheck == '<br>'){
			alert("내용을 입력하세요.");
			oEditors.getById["proj_contents"].exec("FOCUS"); //포커싱
			return;
		}

		
		frm.action = "/project/recruit/write/process";
		frm.submit();
	}
	
	var oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
	    oAppRef: oEditors,
	    elPlaceHolder: "proj_contents",
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
		if (input.files && input.files[0]) {
			var reader = new FileReader();
	        reader.onload = function(e){
	        	$(input).parent().find("#proj_thumbnail").attr('src', e.target.result)
	        }
	        reader.readAsDataURL(input.files[0]);
		}
	}
</script>
</html>