<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/custom.tld" %>
<%@ include file="common/include.jsp" %>
<div id="wrap" class="scrollbar-inner">
	<%@ include file="common/header.jsp" %>
	<div class="container">
		<div class="main-banner">
			<div class="main-banner-mask"></div>
			<img class="main-banner-img" src="/common/image/main-banner.jpg">
			<div class="main-site-cont">
				<div class="main-site-name">Bridge N Contract</div>
			</div>
		</div>
		<!-- div class="home-board-img">
			<img src="/common/image/default/main_img.jpg" />
			<div class="home-board">
				<div class="home-board-top">  
		    		<div class="sign">
						<span class="sign-word">Bridge&nbsp;</span>
						<span class="sign-word">N&nbsp;</span>
						<span class="sign-word">Contract</span>
					</div>	
	
			
				</div> 
	    	</div>
		</div-->
		<div class="chart">
			<div class="chart-wrapper">
				<div class="chart-cont">
					<img src="/common/image/company.png"/>
					<div class="chart-title">가입된 기업 수</div>
					<div id="counter1"></div>
				</div>
				<div class="chart-cont">
					<img src="/common/image/project.png"/>
					<div class="chart-title">총 프로젝트 수</div>
					<div id="counter2"></div>
				</div> 
			</div>
   		</div>
	    <div class="main-contents">
	    	<div class="main-company">
		    	<div class="main-company-title"><!-- <img src="/common/image/company.png"/> -->기업 정보</div>
		    	<div class="main-company-list">
		    	<c:forEach items="${cList}" var="company">
					<div class="box company">
						<a href="/company/view?cmpy_biznum=${company.cmpy_biznum}&${resultQueryString}">
							<div class="box-wrapper">
								<div class="igs">
									<img src="${company.cmpy_ci_file_path}">
								</div>
								<div class="name">${company.cmpy_company_name}</div>
								<div class="kind">${company.bizc_name}</div>
							</div>
						</a>
					</div>
				</c:forEach>
		    	</div>
	    	</div>
	    	
	    	<div class="main-project">
	    		<div class="main-project-title"><!-- <img src="/common/image/project.png"/> --> 프로젝트</div>
	    		<div class="main-project-list">
		    	<c:forEach var="lists" items="${pList}">
					<div class="box project">
						<a href="/project/view?seq=${lists.proj_number}${queryString}">
							<div class="box-wrapper project">
								<div class="igs">
									<c:choose>
										<c:when test="${lists.proj_thumb_file_path == null}">	
											<img src="/common/image/project_thumb_default.jpg">
										</c:when>
										<c:when test="${lists.proj_thumb_file_path != null}">
											<img src="${lists.proj_thumb_file_path}">
										</c:when>
									</c:choose>
								</div>
								<div class="name">${lists.proj_name}</div>
								<div class="kind">${lists.proj_kind}</div>
								<div class="stat">
									<c:set var="flags" value="${lists.proj_flag}"/>
									<c:out value="${custom:projectTypeKr(flags)}"/>
								</div>
								<div class="date">
									<fmt:parseDate var="jstlDate" value="${lists.proj_rdate}" pattern="yyyyMMddHHmmss"/>
									<fmt:formatDate value="${jstlDate}" pattern="yyyy-MM-dd"/>
								</div>
							</div>
						</a>
					</div>
				</c:forEach>
	    		</div>
	    	</div>
	    	
	    	<div class="main-notice">
	    		<div class="main-notice-title">공지사항</div>
	    		<div class="main-notice-list">
	    		<table class="board-list">
					<colgroup>
						<col style="width:140px;">
	                	<col>
		            	<col style="width:200px;">
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>날짜</th>
						</tr>
					</thead>
					<c:forEach var="boardlist" items="${nList}">
						<tr>
							<td>${boardlist.notc_number}</td>                        
							<td><a href="/board/notice/view?seq=${boardlist.notc_number}&${resultQueryString}">${boardlist.notc_title}</a></td>
							<fmt:parseDate value="${boardlist.notc_udate}" var="udate" pattern="yyyyMMddHHmmss"/>
							<td><fmt:formatDate value="${udate}" pattern="yyyy-MM-dd"/></td>
						</tr>		
					</c:forEach>
				</table>
				</div>
	    	</div>
	    </div>
	</div>
	<div class="home-footer">
		<div class="home-footer-text">
			Copyright ⓒ 충북대학교 Java 웹/앱 과정 B조. ALL rights reserved.
		</div>
						
	</div>
	
</div>
</body>
</html>
<script>
function numberCounter(target_frame, target_number) {
    this.count = 0; this.diff = 0;
    this.target_count = parseInt(target_number);
    this.target_frame = document.getElementById(target_frame);
    this.timer = null;
    this.counter();
};
numberCounter.prototype.counter = function() {
    var self = this;
    this.diff = this.target_count - this.count;
     
    if(this.diff > 0) {
        self.count += Math.ceil(this.diff / 5);
    }
     
    this.target_frame.innerHTML = this.count.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
     
    if(this.count < this.target_count) {
        this.timer = setTimeout(function() { self.counter(); }, 20);
    } else {
        clearTimeout(this.timer);
    }
};

new numberCounter("counter1", ${mCount});
new numberCounter("counter2", ${pCount});
</script>