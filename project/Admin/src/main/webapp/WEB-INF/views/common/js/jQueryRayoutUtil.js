$(function(){
	$("#gnb").find("._dep1").mouseover(function(){
		$("#gnb .hiding").show();
	});
	$("#gnb").find("._dep1").mouseout(function(){
		$("#gnb .hiding").hide();
	});
});