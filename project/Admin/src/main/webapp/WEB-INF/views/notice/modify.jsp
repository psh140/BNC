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
				<div>공지사항 수정</div>
			</div>
			<%-- <c:out value="${sessionScope.admin_id}"/>
	    	<c:out value="${data}"/>
	    	<c:out value="${notice.notc_title}"/>	 --%>
			<div class="notice-modify">
				<form method="POST" name="modify">
					<input type="hidden" value="${sessionScope.admin_id}" name="notc_admin_id">
					<input type="hidden" value="${notice.notc_number}" name="notc_number">
					<table>
						<tbody>
							<tr>
								<th>제목</th>
								<td>
									<input type="text" name="notc_title" placeholder="제목" value="<c:out value="${notice.notc_title}"/>">
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td style="padding-left:89px;">
									<textarea name="notc_contents" id="notc_contents"><c:out value="${notice.notc_contents}"/></textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				<div class="btn">
					<a class="cancel" href="javascript:history.back(-1);">취소</a>
					<a class="submit" onclick="noticeSubmit();">수정</a>
				</div>
			</div>
			
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>	
</div>
</body>
</html>
<script>
	function noticeSubmit(){
		
		var frm = document.modify;
		
		oEditors.getById["notc_contents"].exec("UPDATE_CONTENTS_FIELD", []);
		
		frm.action = "/notice/modify/execute";
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
