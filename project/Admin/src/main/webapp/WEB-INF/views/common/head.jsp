<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<head>
	<title>Bridge N Contract</title>
	<meta charset='UTF-8'>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

	<!-- meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" /-->
	<link rel="stylesheet" type="text/css" href="/common/css/style.css" />
	<!-- link rel="stylesheet" type="text/css" href="/common/css/oyj.css" /-->
	<link rel="stylesheet" type="text/css" href="/common/css/jquery.scrollbar.css" />
	
	<script src="http://code.jquery.com/jquery-2.1.3.min.js"></script>
	<script type="text/javascript" src="/common/js/util.js" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/utilAjax.js" charset="utf-8"></script>
	<script type="text/javascript" src="/common/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/jquery.scrollbar.js"></script>
	<script type="text/javascript" src="/common/js/ofi.min.js"></script>
	<script type="text/javascript" src="/common/js/utilValidate.js"></script>    
	<script>
	$(document).ready(function(){
		/*IE obejct-fit 플러그인  Css font-family:'object-fit:cover' 구문 */
		objectFitImages(); 
		
		/* 사이트 전체영역 스크롤바 세팅 */
	    $('#wrap').scrollbar();
		$(".scrollbar-inner").scrollbar();
	});
	</script>
</head>
<body>