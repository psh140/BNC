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
				<div>계약서 등록</div>
			</div>
			<div class="document-wirte">
				<form method="POST" name="write">
					<table>
						<tbody>
							<tr>
								<th>문서이름</th>
								<td><input type="text" name="doct_name" placeholder="문서이름"/></td>
							</tr>
							<tr>
								<th>문서내용</th>
								<td style="padding-left:80px;">
									<textarea name="doct_form" id="doct_form"></textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				<div class="btn">
					<a class="cancel" href="javascript:history.back(-1);">취소</a>
					<a class="submit" onclick="documentSubmit();">등록</a>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>	
</div>
</body>
<script>
	function documentSubmit(){
		
		var frm = document.write;
		
		oEditors.getById["doct_form"].exec("UPDATE_CONTENTS_FIELD", []);
		
		frm.action = "/document/write";
		frm.submit();
	}
	
	var oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
	    oAppRef: oEditors,
	    elPlaceHolder: "doct_form",
	    sSkinURI: "/common/editor/SmartEditor2Skin.html",
	    fCreator: "createSEditor2"
	});
</script>
</html>