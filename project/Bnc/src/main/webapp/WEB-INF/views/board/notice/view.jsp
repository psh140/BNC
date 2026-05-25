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
	    		<div>공지사항</div>
	    	</div>
	    	<div class="board">
				<div class="noti-view">
					<table>
						<tbody>
							<tr>
								<td class="noti-td">번호</td>
								<td class="noti-td">${notice.notc_number}</td>
								<td class="noti-td">날짜</td>
								<td>
									<fmt:parseDate value="${notice.notc_udate}" var="udate" pattern="yyyyMMddHHmmss"/>
									<fmt:formatDate value="${udate}" pattern="yyyy-MM-dd"/>
								</td>
							</tr>
							<tr>
								<td class="noti-td">제목</td>
								<td colspan="3">${notice.notc_title}</td>
							</tr>
							<tr>
								<td colspan="4" class="notc-cont">
								<div class="div-conts">${notice.notc_contents}</div>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="cont-btn">
						<a class="list" href="list${resultQueryString}">목록</a>
					</div>
				</div>
	    	</div>
	    </div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</body>
<script>
function searchSubmit(){
	var frm = document.searchForm;
	
	if(frm.keyword.value == ""){
		alert('검색어를 입력해 주세요.');
		return;
	}
	
	frm.submit();
}
</script>
</html>