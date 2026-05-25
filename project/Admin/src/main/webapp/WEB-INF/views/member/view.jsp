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
				<div>회원정보</div>
			</div>
			<div class="member-view">
				<table>
					<tbody>
						<tr>
							<th>아이디</th>
							<td><c:out value="${member.memb_id}"/></td>
						</tr>
						<tr>
							<th>로그인 종류</th>
							<td><c:out value="${member.memb_kind}"/></td>
						</tr>
						<tr>
							<th>이메일</th>
							<td><c:out value="${member.memb_email}"/></td>
						</tr>
						<tr>
							<th>가입일</th>
							<td><c:out value="${member.memb_rdate}"/></td>
						</tr>
						<tr>
							<th>상태</th>
							<td><c:out value="${member.memb_id}"/></td>
						</tr>
						<tr>
							<th>기업명</th>
							<td><c:out value="${member.cmpy_company_name}"/></td>
						</tr>
						<tr>
							<th>사업자등록번호</th>
							<td><c:out value="${member.cmpy_biznum}"/></td>
						</tr>
						<tr>
							<td colspan="4">
								<img alt="" src="${member.cmpy_biz_doc_file_path}"/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div>
									<a class="link-btn" href="/member/modify?memb_id=${member.memb_id}">수정</a>&nbsp;
									<c:choose>
										<c:when test="${member.memb_auth_flag == 'Y'}">
											<a class="link-btn" href="/member/inactivate?memb_id=${member.memb_id}">비활성화</a>&nbsp;
										</c:when>
										<c:when test="${member.memb_auth_flag == 'N'}">
											<a class="link-btn" href="/member/activate?memb_id=${member.memb_id}">활성화</a>&nbsp;
										</c:when>
									</c:choose>
									<a class="link-btn" href="list${resultQueryString} ">목록</a> 
								</div>
							</td>
						</tr>
						<tr>
							<th>접속한시간</th>
							<th>접속한 IP</th>
						</tr>
						<c:forEach items="${log}" var="log">
							<tr>
								<td>${log.meml_ldate}</td>
								<td>${log.meml_ip}</td>	
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>	
</div>
</body>
</html>
