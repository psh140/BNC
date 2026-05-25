<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../common/include.jsp" %>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script> 
<div id="wrap" class="scrollbar-inner">
	<%@ include file="../common/header.jsp" %>
	<div class="container">
		<div class="contents">
			<div class="cont-title">
				<div>통계내역</div>
				
			</div>
		</div>
		<div class="chart-view">
			<ul class="chart-top">
				<li>
					<div class="chart-title">프로젝트 현황</div>
					<div id="piechart"></div>
				</li>
				<li>
					<div class="chart-title">프로젝트 종류 비율</div>
					<div id="piechart2"></div>
				</li>
				<li>
					<div class="chart-title">가입자 수 현황</div>
					<div id="barchart"></div>
				</li>
			</ul>
			<ul class="chart-middle">
				<li>
					<div class="chart-title">전체 회원 수</div>
					<div class="chart-cont">
						<fmt:formatNumber type="number" value="${totalMemberCount}"/> 명
					</div>
				</li>
				<li>
					<div class="chart-title">인증 완료 기업 수</div>
					<div class="chart-cont">
						<fmt:formatNumber type="number" value="${totalCompanyCount}"/> 개
					</div>
				</li>
				<li>
					<div class="chart-title">완료된 프로젝트 계약 금액 총합</div>
					<div class="chart-cont">
						<fmt:formatNumber type="number" value="${endProjectPriceTotal}"/> 원
					</div>
				</li>
				<li>
					<div class="chart-title">완료된 프로젝트 계약 금액 평균</div>
					<div class="chart-cont">
						<fmt:formatNumber type="number" value="${endProjectAvgPrice}"/> 원
					</div>
				</li>
			</ul>
			<ul class="chart-bottom">
				<li>
					<div class="chart-img">
						<img src="../common/image/chart/request.png" alt=""/>
					</div>
					<div class="chart-title">최다 의뢰 기업</div>
					<div class="chart-cont">
						<a href="/company/view?cmpy_biznum=${topReqCompany.proj_req_biznum}">
							<ul>
								<li>${topReqCompany.cmpy_company_name}</li>
								<li>${topReqCompany.cnt}번</li>
								<li><fmt:formatNumber type="number" value="${topReqCompany.totalPrice}"/> 원</li>
							</ul>
						</a>
					</div>
				</li>
				<li>
					<div class="chart-img">
						<img src="../common/image/chart/order.png" alt=""/>
					</div>
					<div class="chart-title">최다 수주 기업</div>
					<div class="chart-cont">
						<a href="/company/view?cmpy_biznum=${topAcpCompany.proj_acp_biznum}">
							<ul>
								<li>${topAcpCompany.cmpy_company_name}</li>
								<li>${topAcpCompany.cnt} 번</li>
								<li><fmt:formatNumber type="number" value="${topAcpCompany.totalPrice}"/>원</li>
							</ul>
						</a>
					</div>
				</li>
				<li>
					<div class="chart-img">
						<img src="../common/image/chart/project.png" alt=""/>
					</div>
					<div class="chart-title">최고 금액 프로젝트</div>
					<div class="chart-cont">
						<a href="/project/view?proj_number=${topProjectPriceInfo.proj_number}">
							<ul>
								<li>${topProjectPriceInfo.proj_name}</li>
								<li>　<li>
								<li><fmt:formatNumber type="number" value="${topProjectPriceInfo.cntr_price}"/> 원</li>
							</ul>
						</a>
					</div>
				</li>
				<div>※ 클릭하시면 상세페이지로 이동합니다.</div>
			</ul>
		</div>
	</div>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>
<script type="text/javascript"> 
	google.charts.load('current', {'packages':['corechart']}); 
	google.charts.setOnLoadCallback(projectProgressChart);
	google.charts.setOnLoadCallback(projectKindChart);
	google.charts.setOnLoadCallback(drawChart2);   
	
	function projectProgressChart() { 
		var pieData = new google.visualization.DataTable();
		pieData.addColumn('string', 'stat');
		pieData.addColumn('number', 'alphabet');
		pieData.addRows([
			['모집 중', ${fChart.proj_flag_W}],
			['협의 중', ${fChart.proj_flag_C}],
			['진행 중', ${fChart.proj_flag_P}],
			['완료됨', ${fChart.proj_flag_E}]
		]);
		
		var pieOptions = { title: '' }; 
		var pieChart = new google.visualization.PieChart(document.getElementById('piechart')); 
		pieChart.draw(pieData, pieOptions); 
	
		};
		
	function projectKindChart() { 
		var pieData = new google.visualization.DataTable();
		pieData.addColumn('string', 'stat');
		pieData.addColumn('number', 'alphabet');
		pieData.addRows([
			['제작', ${kChart[0]}],
			['견적', ${kChart[1]}],
			['컨설팅', ${kChart[2]}]
		]);
		
		var pieOptions = { title: '' }; 
		var pieChart = new google.visualization.PieChart(document.getElementById('piechart2')); 
		pieChart.draw(pieData, pieOptions); 
		

		};

	function drawChart2() {

	      var pieData = new google.visualization.DataTable();
	      pieData.addColumn('string', 'stat');
	      pieData.addColumn('number', '가입자 수');
	      pieData.addRows([
	    	 ['${list[5].memb_rdate}월', ${list[5].cnt}],
	         ['${list[4].memb_rdate}월', ${list[4].cnt}],
	         ['${list[3].memb_rdate}월', ${list[3].cnt}],
	         ['${list[2].memb_rdate}월', ${list[2].cnt}],
	         ['${list[1].memb_rdate}월', ${list[1].cnt}],
	         ['${list[0].memb_rdate}월', ${list[0].cnt}]

	      ]);
	      
	      var barOptions = {title: '' };
	      var barChart = new google.visualization.ColumnChart(document.getElementById('barchart'));
	      barChart.draw(pieData, barOptions);
	   };

</script>