<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../../common/include.jsp" %>
<!-- 미 로그인 확인 -->
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
<c:if test="${view.proj_flag == 'W'}">
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../../common/header.jsp" %>	
	<div class="container">
	    <div class="contents">
			<div class="board">
				<div class="btit">프로젝트 내용</div>
				<form method="POST" name="frmForm" enctype="multipart/form-data">
					<input type="hidden" name="stdFilePath" id="stdFilePath" value="/project"/>
					<div class="cont-info">
						<div class="image-field">
						<c:choose>
							<c:when test="${view.proj_thumb_file_path == null}">	
								<img src="/common/image/project_thumb_default.jpg">
							</c:when>
							<c:when test="${view.proj_thumb_file_path != null}">
								<img src="${view.proj_thumb_file_path}">
							</c:when>
						</c:choose>
						</div>
						<div class="rtb-field">
							<div class="rw">
								<div class="dtd">
									<div class="tit">프로젝트명</div>
									<div class="data-field">${view.proj_name}</div>
								</div>
								<div class="dtd">
									<div class="tit">구분</div>
									<div class="data-field">${view.proj_kind}</div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">금액</div>
									<div class="data-field">${view.proj_price_range}</div>
								</div>
								<div class="dtd">
									<div class="tit">키워드</div>
									<div class="data-field">${view.proj_keyword}</div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">진행기간</div>
									<div class="data-field">
									<div class="data-field">${view.proj_lead_time}</div>	
								</div>
							</div>
						</div>
					</div>
					<div class="cont-textarea">
						<c:if test="${not empty view.proj_mov_url}">
						<div class="cont-movies">
							<iframe class="youtube-frame" width="800" height="400" src="https://www.youtube.com/embed/${view.proj_mov_url}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
						</div>
						</c:if>
						<div class="cont-contents">
							${view.proj_contents}
							
							<div class="cont-file">
								<p class="tit">첨부파일</p>
								<c:forEach var="files" items="${viewfiles}">
								<c:url value="/editor/fileDownload" var="fileUrl">
									<c:param name="filePath" value="${files.prof_file_path}"/>
									<c:param name="downName" value="${files.prof_file_name}"/>
								</c:url>
								<a href="${fileUrl}">${files.prof_file_name}</a>
								</c:forEach>
							</div>
								
							<div class="cont-btn">
								<a class="list" href="list${resultQueryString}">목록</a>
								<c:if test="${view.cmpy_memb_id == sessionMemberID}">
								<a class="list" href="modify?seq=${view.proj_number}">수정</a>
								<a class="list" href="javascript:void(0);" onclick="deleteSubmit();">삭제</a>
								</c:if>
							</div>
						</div>
					</div>
				</form>
				<form method="POST" name="deleteForm">
					<input type="hidden" name="proj_number" value="${view.proj_number}"/>
				</form>
			</div>
			<c:if test="${view.cmpy_memb_id == sessionMemberID}">
			<div class="applied-list">
				<ul>
					<c:forEach var="participateLists" items="${participateList}">
						<li>
							<p class="applied-name"><a onclick="callCompanyData('${participateLists.prpl_acp_biznum}');">${participateLists.cmpy_company_name}</a><p>
							<p class="applied-price">${participateLists.prpl_acp_price}원</p>
							<p>
							<c:url value="/editor/fileDownload" var="fileUrl">
								<c:param name="filePath" value="${participateLists.prpl_file_path}"/>
								<c:param name="downName" value="${participateLists.prpl_file_name}"/>
							</c:url>
							<a href="${fileUrl}">${participateLists.prpl_file_name}</a>
							</p>
							<a class="applied-btn" onclick="matchingResponse('${participateLists.prpl_acp_biznum}')">수락</a>
						</li>
					</c:forEach>
				</ul>
				<form method="POST" name="matFrmForm">
					<input type="hidden" name="prpl_number" value="${view.proj_number}">
					<input type="hidden" name="prpl_acp_biznum" value="">
				</form>
			</div>
			</c:if>
			<c:if test="${view.cmpy_memb_id != sessionMemberID}">
			<div class="btn">
				<a class="list" href="javascript:void(0);" onclick="layerPopupOpen('matchingLayerPopup');">매칭</a>
			</div>
			</c:if>
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
</c:if>

<c:if test="${view.proj_flag == 'C' || view.proj_flag == 'P'}">
<div id="wrap" class="scrollbar-outer">
	<%@ include file="../../common/header.jsp" %>	
	<div class="container">
	    <div class="contents">
	    	<div class="project-company-info">
	    		<div class="btit">매칭 기업 정보</div>
	    		<div class="req">
	    			<div class="tit">의뢰사</div>
	    			<div>	
	    				<div class="cmpy-ci-img">
	    				<c:choose>
							<c:when test="${reqCompanyData.cmpy_ci_file_path == null}">	
								<img src="/common/image/ci_thumb_default.jpg">
							</c:when>
							<c:when test="${reqCompanyData.cmpy_ci_file_path != null}">
								<img src="${reqCompanyData.cmpy_ci_file_path}">
							</c:when>
						</c:choose>
						</div>
	    				<div class="cmpy-name">${reqCompanyData.cmpy_company_name}</div>
	    				<div class="cmpy-contact-phone">담당자 연락처 : ${reqCompanyPhone}</div>
	    			</div>
	    		</div>
	    		<div class="acp">
	    			<div class="tit">수주사</div>
	    			<div>
	    				<div class="cmpy-ci-img">
	    					<img src="${acpCompanyData.cmpy_ci_file_path}"/>
	    				</div>
	    				<div class="cmpy-name">${acpCompanyData.cmpy_company_name}</div>
	    				<div class="cmpy-contact-phone">담당자 연락처 : ${acpCompanyPhone}</div>
	    			</div>
	    		</div>
	    	</div>
	    	
	    	<div class="contract">
	    		<c:if test="${view.proj_flag == 'C'}">
					<a onclick="layerPopupOpen('contract');">계약</a>
				</c:if>
				<c:if test="${view.proj_flag == 'P'}">
					<a onclick="layerPopupOpen('contractComplete');">계약서</a>
				</c:if>
	    	</div>
	    		
			<div class="board">
				<div class="btit">프로젝트 내용</div>
				<form method="POST" name="frmForm" enctype="multipart/form-data">
					<input type="hidden" name="stdFilePath" id="stdFilePath" value="/project"/>
					<div class="cont-info">
						<div class="image-field">
						<c:choose>
							<c:when test="${view.proj_thumb_file_path == null}">	
								<img src="/common/image/project_thumb_default.jpg">
							</c:when>
							<c:when test="${view.proj_thumb_file_path != null}">
								<img src="${view.proj_thumb_file_path}">
							</c:when>
						</c:choose>
						</div>
						<div class="rtb-field">
							<div class="rw">
								<div class="dtd">
									<div class="tit">프로젝트명</div>
									<div class="data-field">${view.proj_name}</div>
								</div>
								<div class="dtd">
									<div class="tit">구분</div>
									<div class="data-field">${view.proj_kind}</div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">금액</div>
									<div class="data-field">${view.proj_price_range}</div>
								</div>
								<div class="dtd">
									<div class="tit">키워드</div>
									<div class="data-field">${view.proj_keyword}</div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">진행기간</div>
									<div class="data-field">
									<div class="data-field">${view.proj_lead_time}</div>	
								</div>
							</div>
						</div>
					</div>
					<div class="cont-textarea">
						<c:if test="${not empty view.proj_mov_url}">
						<div class="cont-movies">
							<iframe class="youtube-frame" width="800" height="400" src="https://www.youtube.com/embed/${view.proj_mov_url}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
						</div>
						</c:if>
						<div class="cont-contents">
							${view.proj_contents}
							<div class="cont-file">
								<p class="tit">첨부파일</p>
								<c:forEach var="files" items="${viewfiles}">
								<c:url value="/editor/fileDownload" var="fileUrl">
									<c:param name="filePath" value="${files.prof_file_path}"/>
									<c:param name="downName" value="${files.prof_file_name}"/>
								</c:url>
								<a href="${fileUrl}">${files.prof_file_name}</a>
								</c:forEach>
							</div>
							<div class="cont-btn">
								<a class="list" href="list${resultQueryString}">목록</a>
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="btn">
				<a class="list" onclick="workingSubmit('C');">철회</a>
				<a class="submit" onclick="workingSubmit('Y');">완료</a>
				<form method="POST" name="workingForm">
					<input type="hidden" name="proj_number" value="${view.proj_number}" />
					<c:choose>
						<c:when test="${authority == 'req'}">
							<input type="hidden" name="proj_req_flag" value="" />
						</c:when>
						<c:when test="${authority == 'acp'}">
							<input type="hidden" name="proj_acp_flag" value="" />
						</c:when>
					</c:choose>
				</form>
			</div>
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
	<c:if test="${view.proj_flag == 'C'}">
		<!--  계약서 레이어 팝업 -->
		<div class="layer-popup" id="contract">
			<div class="layer-mask"></div>
			<div class="layer-contents ly-contract scrollbar-inner">
				<div class="layer-close-btn"><a href="javascript:void()" onclick="layerPopupClose(this);">X</a></div>
				<form method="POST" name="contractForm" enctype="multipart/form-data">
					<input type="hidden" name="authority" value="${authority}"/>
					<input type="hidden" name="proj_number" value="${view.proj_number}"/>
					<div class="contract-form">
						${documentFormData.doct_form}
						<div class="ly-contents">
							<c:if test="${authority == 'req'}">
							<div class="call-btn">
								<a class="call-form" onclick="callFormBtn();">불러오기</a>
							</div>
							<div class="article">
								<textarea name="cntr_contents" id="cntr_contents" style="width:100%; height:400px;"></textarea>
							</div>
							</c:if>
							<c:if test="${authority == 'acp'}">
							<div class="article" id="js_field_contents">

							</div>
							</c:if>
						</div>
						<c:if test="${authority == 'req'}">
						<div class="input-field-form">
							<div class="tit"><p class="center">계약기간</p></div>
							<div class="contract-period">
								<input type="date" name="cntr_start_date" onchange="addJsFieldText(this); endDateCheck(this);" value=""/><span class="delimit">~</span><input type="date" name="cntr_end_date" onchange="addJsFieldText(this); startDateCheck(this);" value=""/>
							</div>
							<div class="contract-price">
								<div class="ct-price-wrap">
									<span class="stit">계약금액</span><input type="text" name="cntr_price" onkeyup="addJsFieldText(this);" value=""/><span class="swon">원</span>
								</div>
							</div>
							<div class="tit"><p>계약자</p></div>
							<div class="sign-fle">
								<div class="sign-wrap">
									<span>"갑"</span>
									<span class="name"><input type="text" name="cntr_req_ceo_name" value=""></span>
									<span class="sign">
										<img id="sign_file" src="/common/image/sign_default.png" onclick="signPopup(this);">
										<!-- img id="sign_file" src="/common/image/sign_default.png" onclick="fileBtnClick(this);"-->
										<input type="file" class="input-file-hidden" name="cntr_req_sign_file">
										<input type="text" class="input-file-hidden-path" name="cntr_req_sign_path">
									</span>
								</div>
							</div>
							<div class="sign-fle">
								<div class="sign-wrap">
									<span>"을"</span>
									<span class="name"><p></p></span>
									<span class="sign">
										<a>(인)</a>
									</span>
								</div>
							</div>
						</div>
						</c:if>
						<c:if test="${authority == 'acp'}">
						<div class="input-field-form">
							<div class="tit"><p>계약자</p></div>
							<div class="sign-fle">
								<div class="sign-wrap">
									<span>"갑"</span>
									<span class="name"><p>${contractData.cntr_req_ceo_name}</p></span>
									<span class="sign">
										<img class="nocursor" id="sign_file" src="${contractData.cntr_req_sign_path}">
									</span>
								</div>
							</div>
							<div class="sign-fle">
								<div class="sign-wrap">
									<span>"을"</span>
									<span class="name"><input type="text" name="cntr_acp_ceo_name" value="${contractData.cntr_acp_ceo_name}"/></span>
									<span class="sign">
										<img id="sign_file" src="/common/image/sign_default.png" onclick="signPopup(this);">
										<!--  img id="sign_file" src="/common/image/sign_default.png" onclick="fileBtnClick(this);" -->
										<input type="text" class="input-file-hidden-path" name="cntr_req_sign_path">
										<input type="file" class="input-file-hidden" name="cntr_acp_sign_file">
										<input type="text" class="input-file-hidden-path" name="cntr_acp_sign_path">
									</span>
								</div>
							</div>
						</div>
						</c:if>
					</div>
					<div class="warning">
						<div class="check-btn">
							<input class="contract-chkbox" type="checkbox" name="chkboxContract">
							<p class="txt">상기 내용에 동의 합니다.</p>
						</div>
					</div>
				</form>
				<div class="contract-btn">
					<a onclick="contractSubmit();">작성</a>
				</div>
			</div>
		</div>
	</c:if>
	<c:if test="${view.proj_flag == 'P'}">
		<!--  계약서 레이어 팝업 -->
		<div class="layer-popup" id="contractComplete">
			<div class="layer-mask"></div>
			<div class="layer-contents ly-contract scrollbar-inner" id="pdfDownLoadForm">
				<a class="pdf-down-btn" onclick="PDFDownLoad(this);" data-html2canvas-ignore="true">다운로드</a>
				<div class="layer-close-btn" data-html2canvas-ignore="true"><a href="javascript:void()" onclick="layerPopupClose(this);">X</a></div>
				<div class="contract-form">
					${documentFormData.doct_form}
					<div class="article" id="js_field_contents">
						${contractData.cntr_contents}
					</div>
					<div class="input-field-form">
						<div class="tit"><p>계약자</p></div>
						<div class="sign-fle">
							<div class="sign-wrap">
								<span>"갑"</span>
								<span class="name"><p>${contractData.cntr_req_ceo_name}</p></span>
								<span class="sign">
									<img class="nocursor" id="sign_file" src="${contractData.cntr_req_sign_path}">
								</span>
							</div>
						</div>
						<div class="sign-fle">
							<div class="sign-wrap">
								<span>"을"</span>
								<span class="name"><p>${contractData.cntr_acp_ceo_name}</p></span>
								<span class="sign">
									<img class="nocursor" id="sign_file" src="${contractData.cntr_acp_sign_path}">
								</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</c:if>
</c:if>

<!-- 종료된 페이지 뷰 (E) -->
<c:if test="${view.proj_flag == 'E'}">
<div id="wrap" class="scrollbar-outer">
	<%@ include file="../../common/header.jsp" %>	
	<div class="container">
	    <div class="contents">
	    	<div class="project-company-info">
	    		<div class="btit">매칭 기업 정보</div>
	    		<div class="req">
	    			<div class="tit">의뢰사</div>
	    			<div>	
	    				<div class="cmpy-ci-img">
	    				<c:choose>
							<c:when test="${reqCompanyData.cmpy_ci_file_path == null}">	
								<img src="/common/image/ci_thumb_default.jpg">
							</c:when>
							<c:when test="${reqCompanyData.cmpy_ci_file_path != null}">
								<img src="${reqCompanyData.cmpy_ci_file_path}">
							</c:when>
						</c:choose>
						</div>
	    				<div class="cmpy-name">${reqCompanyData.cmpy_company_name}</div>
	    			</div>
	    		</div>
	    		<div class="acp">
	    			<div class="tit">수주사</div>
	    			<div>
	    				<div class="cmpy-ci-img">
	    					<img src="${acpCompanyData.cmpy_ci_file_path}"/>
	    				</div>
	    				<div class="cmpy-name">${acpCompanyData.cmpy_company_name}</div>
	    			</div>
	    		</div>
	    	</div>
	    	
	    	<div class="contract">
				<c:if test="${authority == 'req' || authority == 'acp'}">
					<a onclick="layerPopupOpen('contractComplete');">계약서</a>
				</c:if>
	    	</div>
	    		
			<div class="board">
				<div class="btit">프로젝트 내용</div>
				<form method="POST" name="frmForm" enctype="multipart/form-data">
					<input type="hidden" name="stdFilePath" id="stdFilePath" value="/project"/>
					<div class="cont-info">
						<div class="image-field">
						<c:choose>
							<c:when test="${view.proj_thumb_file_path == null}">	
								<img src="/common/image/project_thumb_default.jpg">
							</c:when>
							<c:when test="${view.proj_thumb_file_path != null}">
								<img src="${view.proj_thumb_file_path}">
							</c:when>
						</c:choose>
						</div>
						<div class="rtb-field">
							<div class="rw">
								<div class="dtd">
									<div class="tit">프로젝트명</div>
									<div class="data-field">${view.proj_name}</div>
								</div>
								<div class="dtd">
									<div class="tit">구분</div>
									<div class="data-field">${view.proj_kind}</div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">금액</div>
									<div class="data-field">${view.proj_price_range}</div>
								</div>
								<div class="dtd">
									<div class="tit">키워드</div>
									<div class="data-field">${view.proj_keyword}</div>
								</div>
							</div>
							<div class="rw">
								<div class="dtd">
									<div class="tit">진행기간</div>
									<div class="data-field">
									<div class="data-field">${view.proj_lead_time}</div>	
								</div>
							</div>
						</div>
					</div>
					<div class="cont-textarea">
						<c:if test="${not empty view.proj_mov_url}">
						<div class="cont-movies">
							<iframe class="youtube-frame" width="800" height="400" src="https://www.youtube.com/embed/${view.proj_mov_url}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
						</div>
						</c:if>
						<div class="cont-contents">
							${view.proj_contents}
							<div class="cont-file">
								<p class="tit">첨부파일</p>
								<c:forEach var="files" items="${viewfiles}">
								<c:url value="/editor/fileDownload" var="fileUrl">
									<c:param name="filePath" value="${files.prof_file_path}"/>
									<c:param name="downName" value="${files.prof_file_name}"/>
								</c:url>
								<a href="${fileUrl}">${files.prof_file_name}</a>
								</c:forEach>
							</div>
							<div class="cont-btn">
								<a class="list" href="list${resultQueryString}">목록</a>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<%@ include file="../../common/footer.jsp" %>
</div>
	<c:if test="${authority == 'req' || authority == 'acp'}">
		<!--  계약서 레이어 팝업 -->
		<div class="layer-popup" id="contractComplete">
			<div class="layer-mask"></div>
			<div class="layer-contents ly-contract scrollbar-inner" id="pdfDownLoadForm">
				<a class="pdf-down-btn" onclick="PDFDownLoad(this);" data-html2canvas-ignore="true">다운로드</a>
				<div class="layer-close-btn" data-html2canvas-ignore="true"><a href="javascript:void()" onclick="layerPopupClose(this);">X</a></div>
				<div class="contract-form">
					${documentFormData.doct_form}
					<div class="article" id="js_field_contents">
						${contractData.cntr_contents}
					</div>
					<div class="input-field-form">
						<div class="tit"><p>계약자</p></div>
						<div class="sign-fle">
							<div class="sign-wrap">
								<span>"갑"</span>
								<span class="name"><p>${contractData.cntr_req_ceo_name}</p></span>
								<span class="sign">
									<img class="nocursor" id="sign_file" src="${contractData.cntr_req_sign_path}">
								</span>
							</div>
						</div>
						<div class="sign-fle">
							<div class="sign-wrap">
								<span>"을"</span>
								<span class="name"><p>${contractData.cntr_acp_ceo_name}</p></span>
								<span class="sign">
									<img class="nocursor" id="sign_file" src="${contractData.cntr_acp_sign_path}">
								</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</c:if>
</c:if>
<!-- 종료된 페이지 뷰 (E) END -->

<!-- 기업정보 레이어 팝업 -->
<div class="layer-popup" id="layerCompanyInfo">
	<div class="layer-mask"></div>
	<div class="layer-contents ly-contract company-info scrollbar-inner">
		<div class="layer-close-btn"><a href="javascript:void()" onclick="layerPopupClose(this);">X</a></div>
			<div class="cont-info">
				<div class="cont-title">기업 정보</div>
				<div class="image-field">
					<img src="${company.cmpy_ci_file_path}" id="ly_cmpy_img">
				</div>
				<div class="rtb-field ly">
					<div class="rw ly">
						<div class="dtd">
							<div class="tit">기업명</div>
							<div class="data-field" id="ly_cmpy_name"></div>
						</div>
						<div class="dtd">
							<div class="tit">대표자명</div>
							<div class="data-field" id="ly_cmpy_ceo_name"></div>
							</div>
						</div>
						<div class="rw">
							<div class="dtd">
								<div class="tit">업종</div>
								<div class="data-field" id="ly_cmpy_biz_cate"></div>
							</div>
							<div class="dtd">
								<div class="tit">대표 연락처</div>
								<div class="data-field" id="ly_cmpy_phone"></div>
							</div>
						</div>
						<div class="rw">
							<div class="dtd">
								<div class="tit">회사 주소</div>
								<div class="data-field" id="ly_cmpy_address"></div>
							</div>
							<div class="dtd">
								<div class="tit">홈페이지</div>
								<div class="data-field" id="ly_cmpy_home_url"></div>
							</div>
						</div>
					</div>
			</div>
			<div class="cont-tit">기업소개</div>
			<div class="cont-contents" id="ly_cmpy_contents">
			</div>
	</div>
</div>
<!-- 매칭 신청 레이어 팝업 -->
<div class="layer-popup" id="matchingLayerPopup">
	<div class="layer-mask"></div>
	<div class="layer-contents">
		<div class="layer-wrapper">
			<div class="layer-close-btn"><a href="javascript:void()" onclick="layerPopupClose(this);">X</a></div>
			<form name="layerMatchingForm" method="POST" enctype="multipart/form-data">
			<input type="hidden" name="prpl_number" value="${view.proj_number}"/>
			<div class="rw ly">
				<div class="dtd">
					<div class="tit">금액</div>
					<div class="data-field">
					<input type="text" name="prpl_acp_price"/>
					</div>
				</div>
			</div>
			<div class="rw ly">
				<div class="dtd">
					<div class="tit">담당자 연락처</div>
					<div class="data-field">
					<input type="text" name="prpl_acp_phone"/>
					</div>
				</div>
			</div>
			<div class="rw ly">
				<div class="dtd">
					<div class="tit">첨부파일</div>
					<div class="data-field">
					<input class="input-file" type="file" name="prpl_file"/>
					</div>
				</div>
			</div>
			<div class="btn ly">
				<a onclick="layerMatchingRequest();">매칭요청</a>
			</div>
			</form>
		</div>
	</div>
</div>
<!-- 사인 등록 팝업 -->
<div class="layer-sign">
	<div class="layer-sign-mask"></div>
	<div class="layer-sign-contents">
		<div class="layer-tit">사인 등록</div>
		<div class="layer-sign-wrapper">
			<div class="layer-close-btn"><a href="javascript:void()" onclick="layerPopupClose(this);">X</a></div>
			<div class="swiper-container sign-slider">
				<div class="swiper-wrapper">
					<c:forEach var="sign_files" items="${signFiles}">
					<div class="swiper-slide">
						<a onclick="signUpload('select', this);">
							<img src="${sign_files.sign_file_path}">
						</a>
					</div>
					</c:forEach>
					<div class="swiper-slide">
						<a class="direct-file-btn" onclick="signUpload('direct', this);">
							직접 업로드 하기
						</a>
					</div>
                </div>
                <!-- Add Pagination -->
                <div class="swiper-btn">
                <div class="swiper-pagination"></div>
                <!-- Add Arrows -->
                <div class="swiper-button-next"></div>
                <div class="swiper-button-prev"></div>
                </div>
            </div>
		</div>
	</div>
</div>
</body>
<script>
	function signUpload(type, e){
		
		var authType = "${authority}";
		
		var inputFileObject = $("input[name='cntr_"+authType+"_sign_file']");
		var inputPathObject = $("input[name='cntr_"+authType+"_sign_path']");
		
		inputFileObject.val("");
		inputPathObject.val("");
		
		if(type=="direct")
		{
			inputFileObject.click();
			
			var ext = inputFileObject.val().split(".").pop().toLowerCase();
			if(ext.length > 0){
				if($.inArray(ext, ["gif","png","jpg","jpeg"]) == -1) { 
					alert("gif,png,jpg 파일만 업로드 할수 있습니다.");
					return false;  
				}                  
			}
			
			inputFileObject.change(function () {
				
				readURL(this);
				$(".layer-sign").hide();	
		    });
		}
		else if(type == "select")
		{
			var imgSrc = $(e).children().attr("src");

			inputPathObject.parent().find("#sign_file").attr("src", imgSrc);
			inputPathObject.val(imgSrc);
			$(".layer-sign").hide();
		}
	}
	
	function directSignUpload(){
		var authType = "${authority}";
		
		var inputObject = $("input[name='cntr_"+authType+"_sign_file']");
		inputObject.click();
		
		var ext = inputObject.val().split(".").pop().toLowerCase();
		if(ext.length > 0){
			if($.inArray(ext, ["gif","png","jpg","jpeg"]) == -1) { 
				alert("gif,png,jpg 파일만 업로드 할수 있습니다.");
				return false;  
			}                  
		}
		
		inputObject.change(function () {
			
			readURL(this);
			$(".layer-sign").hide();	
	    });

	}
	
	function signPopup(){
		$(".layer-sign").show();
		var mainSwiper = new Swiper('.sign-slider', {
	        slidesPerView: 1,
	        spaceBetween: 30,
	        loop: false,
	        pagination: {
	          el: '.swiper-pagination',
	          clickable: true,
	        },
	        navigation: {
	          nextEl: '.swiper-button-next',
	          prevEl: '.swiper-button-prev',
	        },
	    });
	}
</script>
<script>
	function workingSubmit(flag)
	{
		var frm = document.workingForm;
		
		if(flag == 'Y')
		{
			if(confirm('프로젝트를 완료 하시겠습니까?'))
			{
				<c:choose>
					<c:when test="${authority == 'req'}">
						frm.proj_req_flag.value = flag;
					</c:when>
					<c:when test="${authority == 'acp'}">
						frm.proj_acp_flag.value = flag;
					</c:when>
				</c:choose>
			}
			else
			{
				return;
			}
		}
		else if(flag == 'C')
		{
			if(confirm('프로젝트를 철회 하시겠습니까?'))
			{
				<c:choose>
					<c:when test="${authority == 'req'}">
						frm.proj_req_flag.value = flag;
					</c:when>
					<c:when test="${authority == 'acp'}">
						frm.proj_acp_flag.value = flag;
					</c:when>
				</c:choose>
			}
			else
			{
				return;
			}
		}
		else
		{
			alert('상태값 오류 입니다. 다시 시도해 주세요.');
			return;
		}
		
		frm.action="/project/recruit/workingProcess";
		frm.submit();
	}
	
	function deleteSubmit(){
		
		if(confirm("프로젝트 공고글을 삭제 하시겠습니까?")){
		
			var frm = document.deleteForm;
			
			if(frm.proj_number.value == ""){
				alert('프로젝트 번호가 없습니다.');
				return;
			}
			
			frm.action="/project/recruit/delete";
			frm.submit();
		}
	}
</script>
<script>	
	function callFormBtn(){
		
		var tUrl = "/contract/callForm";
		var param = {}
		var rData = callAjax("data", "POST", tUrl, param);
		
		if(rData.data != null){
			oEditors.getById["cntr_contents"].exec("SET_IR", [""]);
			oEditors.getById["cntr_contents"].exec("PASTE_HTML", [rData.data.cntc_contract_form]);
		}
		else{
			alert('작성하신 양식이 존재하지 않습니다.');
			return;
		}
	}
	
	function contractInit(proj_number, flag){
		
		var tUrl = "/contract/view";
		var param = { proj_number : proj_number }
		
		var rData = callAjax("data", "POST", tUrl, param);
		
		if(flag == "complete"){
			//계약 기간 세팅
			$("#js_field_cntr_start_date").text(rData.data.cntr_start_date);
			//계약 종료일 세팅
			$("#js_field_cntr_end_date").text(rData.data.cntr_end_date);
			//계약 금액 세팅
			$("#js_field_cntr_price").text(rData.data.cntr_price);
			//계약 내용 세팅
			$("#js_field_contents").children().remove();
			$("#js_field_contents").append(rData.data.cntr_contents);
		}
		else if(flag == "progress")
		{
			if((rData.count > 0) && ($("input[name='authority']").val() == 'req')){
				//계약 내용 세팅
				$("#cntr_contents").text(rData.data.cntr_contents);
				
				//계약기간 세팅
				$("#js_field_cntr_start_date").text(rData.data.cntr_start_date);
				$("#js_field_cntr_end_date").text(rData.data.cntr_end_date);
				$("input[name='cntr_start_date']").val(rData.data.cntr_start_date);
				$("input[name='cntr_end_date']").val(rData.data.cntr_start_date);
				
				//계약 금액 세팅
				$("#js_field_cntr_price").text(rData.data.cntr_price);
				$("input[name='cntr_price']").val(rData.data.cntr_price);
				
				//대표자명 세팅
				$("input[name='cntr_req_ceo_name']").val(rData.data.cntr_req_ceo_name);
			}
			else if((rData.count <= 0) && ($("input[name='authority']").val() == 'acp'))
			{
				alert('아직 의뢰측에서 계약서를 작성하지 않았습니다');
				var layerPopup = $("#contract");
				layerPopup.hide();
			}
			else
			{
				//계약 내용 세팅
				if(rData.data != null){
					$("#js_field_contents").html(rData.data.cntr_contents);
					
					//계약기간 세팅
					$("#js_field_cntr_start_date").text(rData.data.cntr_start_date);
					$("#js_field_cntr_end_date").text(rData.data.cntr_end_date);
					$("input[name='cntr_start_date']").val(rData.data.cntr_start_date);
					$("input[name='cntr_end_date']").val(rData.data.cntr_start_date);
					
					//계약 금액 세팅
					$("#js_field_cntr_price").text(rData.data.cntr_price);
					$("input[name='cntr_price']").val(rData.data.cntr_price);
					
					//대표자명 세팅
					$("input[name='cntr_req_ceo_name']").val(rData.data.cntr_req_ceo_name);
					}
			}
		}
	}
	
	function contractSubmit(){
		var frm = document.contractForm;
		
		if(frm.authority.value == "req" )
		{
			if(frm.cntr_start_date.value ==""){
				alert('계약 시작일을 선택해 주세요.');
				return;
			}
			
			if(frm.cntr_end_date.value ==""){
				alert('계약 종료일을 선택해 주세요.');
				return;
			}
			
			if(frm.cntr_price.value ==""){
				alert('계약금액을 입력해 주세요.');
				return;
			}
			
			if(frm.cntr_req_ceo_name.value==""){
				alert("대표자명을 입력해 주세요.");
				return;
			}
			
			if(frm.cntr_req_sign_file.value == "" && frm.cntr_req_sign_path.value ==""){
				alert("사인 및 도장 이미지를 업로드 해주세요.");
				return;
			}
			
			if(!frm.chkboxContract.checked){
				alert("상기 내용에 동의하시면 체크를 해주세요.");
				return;
			}
			
			oEditors.getById["cntr_contents"].exec("UPDATE_CONTENTS_FIELD", []);
			$("#cntr_contents").val($("#cntr_contents").val().replace(/\ufeff/g, ''));
		}
		else
		{
			if(frm.cntr_acp_ceo_name.value==""){
				alert("대표자명을 입력해 주세요.");
				return;
			}
			
			if(frm.cntr_acp_sign_file.value == "" && frm.cntr_acp_sign_path.value==""){
				alert("사인 및 도장 이미지를 업로드 해주세요.");
				return;
			}
			
			if(!frm.chkboxContract.checked){
				alert("상기 내용에 동의하시면 체크를 해주세요.");
				return;
			}
		}
		
		frm.action="/contract/process";
		frm.submit();
	}
</script>
<script>
	var oEditors = [];
	
	function editorInit(){
	
		$("textarea[name='cntr_contents']").next("iframe").css("height", "450px");
		
		nhn.husky.EZCreator.createInIFrame({
		    oAppRef: oEditors,
		    elPlaceHolder: "cntr_contents",
		    sSkinURI: "/common/editor/SmartEditor2NoPictureSkin2.html",
		    fCreator: "createSEditor2",
		    htParams:{
		    	bUseModeChanger : false,
		    	fOnBeforeUnload:function(){}
		    },
		    fOnAppLoad:function(){
				oEditors.getById["cntr_contents"].exec("CHANGE_EDITING_MODE", ["WYSIWYG"]);
				oEditors.getById["cntr_contents"].exec("RESET_TOOLBAR");
		    }
		});
	}

	function layerPopupOpen(id){

		var layerPopup = $("#"+id);
		layerPopup.show();
		
		if(id == "contract"){
			
			if($("input[name='authority']").val() == 'req'){
				editorInit();
			}
			
			contractInit(${view.proj_number}, "progress");
		}
		else if(id == "contractComplete"){
			contractInit(${view.proj_number}, "complete");
		}
		else if(id == "layerCompanyInfo")
		{
			
		}
		
	}
	
	function layerPopupClose(e){
		var thisObject 		= $(e);
		var parentObject 	= thisObject.parent().parent().parent().parent();
		
		parentObject.hide();
	}
	
	function layerMatchingRequest(){
		var frm = document.layerMatchingForm;
		
		if(frm.prpl_number.value == ""){
			alert('히든값 에러');
			return;
		}
		
		if(frm.prpl_acp_price.value == ""){
			alert('금액을 입력해 주세요');
			return;
		}
		
		if(frm.prpl_acp_phone.value == ""){
			alert('담당자 연락처를 입력해 주세요.');
			return;
		}
		
		frm.action="/project/recruit/participate/process";
		frm.submit();
	}
	
	function matchingResponse(biznum){
		
		var frm = document.matFrmForm;
		
		if(confirm("해당기업과 매칭 하시겠습니까?"))
		{
			$("input[name='prpl_acp_biznum']").val(biznum);
			
			frm.action="/project/recruit/matching/process";
			frm.submit();
		}
	}
	
	function callCompanyData(cmpy_biznum){
		
		var tUrl = "/company/callData";
		var param = { cmpy_biznum : cmpy_biznum }
		
		var rData = callAjax("data", "POST", tUrl, param);
		
		if(rData.count > 0)
		{
			$("#ly_cmpy_img").attr("src", "");
			$("#ly_cmpy_name").text("");
			$("#ly_cmpy_ceo_name").text("");
			$("#ly_cmpy_biz_cate").text("");
			$("#ly_cmpy_phone").text("");
			$("#ly_cmpy_address").text("");
			$("#ly_cmpy_home_url").text("");
			$("#ly_cmpy_contents").text("");
			$("#ly_cmpy_contents").children().remove();

			
			$("#ly_cmpy_img").attr("src", rData.data[0].cmpy_ci_file_path);
			$("#ly_cmpy_name").text(rData.data[0].cmpy_company_name);
			$("#ly_cmpy_ceo_name").text(rData.data[0].cmpy_ceo_name);
			$("#ly_cmpy_biz_cate").text(rData.data[0].bizc_name);
			$("#ly_cmpy_phone").text(rData.data[0].cmpy_biz_phone);
			$("#ly_cmpy_address").text(rData.data[0].cmpy_biz_address);
			$("#ly_cmpy_home_url").text(rData.data[0].cmpy_homepage);
			$("#ly_cmpy_contents").append(rData.data[0].cmpy_contents);
			
			layerPopupOpen("layerCompanyInfo");
		}
		else{
			alert('기업 정보가 없습니다.');
			return;
		}
	}
</script>
<script>
	$(document).ready(function(){
		$("#js_field_proj_name").text("${view.proj_name}");
	});
	
	function startDateCheck(e){
		
		if($("input[name='cntr_start_date']").val() == "" )
		{
			$(e).val("");
			alert('시작일을 먼저 선택해 주세요.');
			return;
		}
		
		if($("input[name='cntr_start_date']").val() > $(e).val() ){
			$(e).val("");
			alert('종료일은 시작일보다 작을 수 없습니다');
			return;
		}
	}
	
	function endDateCheck(e){
		
		if($("input[name='cntr_end_date']").val() < $(e).val() && $("input[name='cntr_end_date']").val() != "" ){
			$(e).val("");
			alert('시작일은 종료일보다 클 수 없습니다');
			return;
		}
	}
	
	function addJsFieldText(e){
		var thisObj = $(e);
		$("#js_field_"+thisObj.attr("name")).text(thisObj.val());
	}

	
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
	        	$(input).parent().find("#sign_file").attr('src', e.target.result);
	        }
	        reader.readAsDataURL(input.files[0]);
		}
	}
</script>
<script>
	function PDFDownLoad(e){

		var fileName = "${view.proj_name} 계약서.pdf";
        var element = document.getElementById('pdfDownLoadForm');
		var useWidth = $(".contract-form").width() + 120;
		var useHeight = $(".contract-form").height() + 120;

        // Generate the PDF.
        html2pdf().from(element).set({
          margin: 1,
          filename: fileName,
          html2canvas: { scale: 2, width:useWidth, height:useHeight},
          jsPDF: {orientation: 'portrait', unit: 'in', format: 'letter', compressPDF: true}
        }).save();

	}
</script>
</html>