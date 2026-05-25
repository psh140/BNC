<?php
//기본 리다이렉트
echo $_REQUEST["htImageInfo"];

$url = $_REQUEST["callback"] .'?callback_func='. $_REQUEST["callback_func"];
$bSuccessUpload = is_uploaded_file($_FILES['Filedata']['tmp_name']);
if (bSuccessUpload) { //성공 시 파일 사이즈와 URL 전송
	
	$tmp_name = $_FILES['Filedata']['tmp_name'];
	$name = $_FILES['Filedata']['name'];
	$new_path = $_SERVER['DOCUMENT_ROOT']."/fileupload/".urlencode($_FILES['Filedata']['name']);

	$fileext = strtolower(substr(strrchr($_FILES["Filedata"]["name"],"."), 1));
	$temp_folder = $_SERVER['DOCUMENT_ROOT']."/fileupload/";
	
	//@move_uploaded_file($tmp_name, $new_path);

	$filename = rand(1000000, 9999999);	// Create a pretend file id, this might have come from a database.
	$cname = $temp_folder . $filename . "." . $fileext;
	move_uploaded_file($_FILES["Filedata"]["tmp_name"],"$cname");

	$url .= "&bNewLine=true";
	$url .= "&sFileName=".$filename . "." . $fileext;
	//$url .= "&size=". $_FILES['Filedata']['size'];
	//아래 URL을 변경하시면 됩니다.
	$url .= "&sFileURL=http://".$_SERVER['HTTP_HOST']."/fileupload/".$filename . "." . $fileext;
} else { //실패시 errstr=error 전송
	$url .= '&errstr=error';
}
header('Location: '. $url);
?>