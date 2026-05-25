<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/custom.tld" %>
<%@ include file="../common/include.jsp" %>
<div id="wrap">
	<%@ include file="../common/header.jsp" %>
	<div class="container">
		<div class="contents">
			<div class="cont-title">
				<div>프로젝트 정보</div>
			</div>
			<div class="project-view">
				<table>
					<tbody>
						<tr>
							<td rowspan="5" width="200px;">
								<img src="${project.proj_thumb_file_path}">
							</td>
							<tr>
								<th>프로젝트 명</th>
								<td>${project.proj_name}</td>
								<th>협의여부</th>
								<td>
									<c:set var="flags" value="${project.proj_flag}"/>
									<c:out value="${custom:projectTypeKr(flags)}"/>
								</td>
							</tr>
							<tr>
								<th>구분</th>
								<td>${project.proj_kind}</td>
								<th>금액</th>
								<td>${project.proj_price_range}</td>
								
							</tr>
							<tr>
								<th>진행기간</th>
								<td>${project.proj_lead_time}</td>
								<th>키워드</th>
								<td>${project.proj_keyword}</td>
								
							</tr>
							<tr>
								<th>동영상</th>
								<td>${project.proj_mov_url}</td>
								<th>첨부파일</th>
								<td colspan="3">${project.proj_file_path}</td>
							</tr>
						</tr>
						<tr>
							<th colspan="5">상세내용</th>
						</tr>
						<tr>
							<td colspan="5" style="margin:20px auto;">${project.proj_contents}</td>
						</tr>
					</tbody>
				</table>
				<!-- 계약서 -->
				<input type="hidden" value="${contract.cntr_proj_number}">
				<div class="accordion-box">
					<ul>
						<li>
							<div class="accordion-title">계약서<span>▼</span></div>
							<div class="accordion-cont">
								<c:if test="${not empty contract.cntr_proj_number}">
								<div class="cont-wrapper">
									<table>
										<tbody>
											<tr>
												<th>의뢰 회사 기업명</th>
												<td class="top-td" colspan="3">${companyA.cmpy_company_name}</td>
											</tr>
											<tr>
												<th>수주 회사 기업명</th>
												<td colspan="3">${companyB.cmpy_company_name}</td>
											</tr>
											<tr>
												<th>계약금액</th>
												<td>${contract.cntr_price}</td>
												<th>계약상태</th>
												<td>${contract.cntr_flag}</td>
											</tr>
											<tr>
												<th>계약기간</th>
												<td colspan="3">${contract.cntr_start_date} ~ ${contract.cntr_end_date}</td>
											</tr>
										</tbody>
									</table>
									<div class="cont-middle">
										<div class="document-cont">${contract.cntr_contents}</div>
									</div>
									<div class="cont-bottom">
										<div class="sign-row">
											<div>"갑"</div>
											<div class="name">${contract.cntr_req_ceo_name}</div>
											<div class="sign">
												<img src="${contract.cntr_req_sign_path}"/>
											</div>
										</div>
									</div>
									<div class="cont-bottom">
										<div class="sign-row">
											<div>"을"</div>
											<div class="name">${contract.cntr_acp_ceo_name}</div>
											<div class="sign">
												<img src="${contract.cntr_acp_sign_path}"/>
											</div>
										</div>
									</div>
								</div>
								</c:if>
							</div>
						</li>
					</ul>
				</div>
				<div class="btn">
					<a href="delete?proj_number=${project.proj_number}" class="cancel">삭제</a>
					<a href="list${resultQueryString}" class="submit">목록</a>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>
</div>
<script type="text/javascript">
	$("div.accordion-title").on('click',function(){
	  $(this).next(".accordion-cont").slideToggle(100);
	});
</script>
</body>
</html>