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
				<div>기업정보</div>
			</div>
	    	<div class="board">
	    		<div class="board-top">
				</div>
				<div class="board-view">
					<div class="cont-info">
						<div class="image-field">
							<img src="${company.cmpy_ci_file_path}">
						</div>
						<div class="rtb-field">
							<div class="rw">
								<div class="dtd">
									<div class="tit">기업명</div>
									<div class="data-field">${company.cmpy_company_name}</div>
								</div>
								<div class="dtd">
									<div class="tit">대표자명</div>
									<div class="data-field">${company.cmpy_ceo_name}</div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">업종</div>
									<div class="data-field">${company.bizc_name}</div>
								</div>
								<div class="dtd">
									<div class="tit">대표 연락처</div>
									<div class="data-field">${company.cmpy_biz_phone}</div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">회사 주소</div>
									<div class="data-field">${company.cmpy_biz_address}</div>
								</div>
								<div class="dtd">
									<div class="tit">홈페이지</div>
									<div class="data-field">${company.cmpy_homepage}</div>
								</div>
							</div>
						</div>
					</div>
					<div class="tit">기업소개</div>
					<div class="cont-contents">
						${company.cmpy_contents}
					</div>
					<div class="cont-btn">
						<a class="list" href="list${resultQueryString}">목록</a>
					</div>
				</div>
	    	</div>
	    </div>
	</div>
	<%@ include file="../common/footer.jsp" %> 
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