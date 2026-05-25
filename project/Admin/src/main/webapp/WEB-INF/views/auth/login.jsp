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
				<div>Login</div>
			</div>
			<div class="login-form-wrapper">
				<div class="login-form">
					<form method="post" name="loginForm">
						<table>
							<tbody>
								<tr>
									<td>ID</td>
									<td><input type="text" name="admin_id" class="form-control"></td>
								</tr>
								<tr>
									<td>Pass</td>
									<td><input type="password" name="admin_password" class="form-control"></td>
								</tr>
							</tbody>
						</table>
					</form>
					<div class="btn">
						<a class="submit" href="#" onclick="loginSubmit(); return false;">로그인</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>
<script>
	function loginSubmit() {
		var form = document.loginForm;
		
		form.action="/auth/login";
		form.submit();
	}
</script>