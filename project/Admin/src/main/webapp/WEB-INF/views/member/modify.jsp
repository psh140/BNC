<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/include.jsp" %>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../common/header.jsp" %>	
	<div class="container">
		<div class="contents">
			<div class="cont-title">
				<div>회원정보 수정</div>
			</div>
			<div class="member-modify">
				<form method="POST" name="modifyForm" enctype="multipart/form-data">
					<table>
						<tbody>
							<tr>
								<th>아이디</th>
								<td>
									<c:out value="${member.memb_id}"/>
									<input type="hidden" value="${member.memb_id}" name="cmpy_memb_id">
								</td>
							</tr>
							<tr>
								<th>사업자등록번호</th>
								<td>
									<input type="text" name="cmpy_biznum" value="${member.cmpy_biznum}"/>
								</td>
							</tr>
							<tr>
								<th>사업자등록증</th>
								<td>
									<input type="hidden" name="cmpy_biz_doc_file_path" value="${member.cmpy_biz_doc_file_path}"/>
									<div class="image-field">
										<img id="cmpy_Bizdoc_file" src="${member.cmpy_biz_doc_file_path}">
										<span class="file-img-btn" onclick="fileBtnClick(this);">
											<img src="/common/image/thumb_add.png">
										</span>
										<input class="input-file-hidden" type="file" name="cmpy_bizdoc_file" id="cmpy_bizdoc_file"/>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				<div class="btn">
						<a class="cancel" href="javascript:history.back(-1);">취소</a>
						<a class="submit" onclick="memberSubmit();">수정</a>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>	
</div>
</body>
<script>
	function memberSubmit() {
		var frm = document.modifyForm;
		
		frm.action="/member/modify/execute";
		frm.submit();
	}
</script>
<script>
	function fileBtnClick(e){
	
		var btnObj = $(e).parent().find("input");
		
		btnObj.click();
	       
		var ext = btnObj.val().split(".").pop().toLowerCase();
		if(ext.length > 0){
			if($.inArray(ext, ["gif","png","jpg","jpeg","pdf"]) == -1) { 
				alert("gif,png,jpg,pdf 파일만 업로드 할수 있습니다.");
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
	        	$(input).parent().find("#cmpy_Bizdoc_file").attr('src', e.target.result)
	        }
	        reader.readAsDataURL(input.files[0]);
		}
	}
</script>
</html>