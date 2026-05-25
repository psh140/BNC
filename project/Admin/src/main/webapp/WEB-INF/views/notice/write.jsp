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
				<div>공지사항 작성</div>
			</div>
			<div class="notice-write">
				<form method="POST" name="write">
					<table>
						<tbody>
							<tr>
								<th>제목</th>
								<td>
									<input type="text" name="notc_title" placeholder="제목">
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td style="padding-left:80px;">
									<textarea name="notc_contents" id="notc_contents"></textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				<div class="btn">
					<a class="cancel" href="javascript:history.back(-1);">취소</a>
					<a class="submit" onclick="noticeSubmit();">글쓰기</a>
				</div>
			</div>
			
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>	
</div>
</body>
<script>
	function noticeSubmit(){
		
		var frm = document.write;
		
		if(frm.notc_title.value == ""){
			alert('제목을 입력 해주세요.');
			frm.notc_title.focus();
			return;
		}
		
		oEditors.getById["notc_contents"].exec("UPDATE_CONTENTS_FIELD", []);
		
		var contentsCheck = $("#notc_contents").val();

		if(contentsCheck == ""  || contentsCheck == null || contentsCheck == '&nbsp;' || contentsCheck == '<p>&nbsp;</p>' || contentsCheck == '<br>'){
			alert("내용을 입력하세요.");
			oEditors.getById["notc_contents"].exec("FOCUS"); //포커싱
			return;
		}
		
		frm.action = "/notice/write";
		frm.submit();
	}
	
	var oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
	    oAppRef: oEditors,
	    elPlaceHolder: "notc_contents",
	    sSkinURI: "/common/editor/SmartEditor2Skin.html",
	    fCreator: "createSEditor2"
	});
</script>
</html>