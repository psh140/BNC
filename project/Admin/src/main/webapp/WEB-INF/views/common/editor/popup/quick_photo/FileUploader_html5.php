<?php

    function mkdirTree($dirName, $rights=0775){
        $dirs = explode('/', $dirName);
        $dir='';
        foreach ($dirs as $part) {
            $dir.=$part.'/';
            if (!is_dir($dir) && strlen($dir)>0)
                mkdir($dir, $rights);
        }
    }

    function apache_request_headers() {
        $arh = array();
        $rx_http = '/\AHTTP_/';
        foreach($_SERVER as $key => $val) {
            if( preg_match($rx_http, $key) ) {
                $arh_key = preg_replace($rx_http, '', $key);
                $rx_matches = array();
                // do some nasty string manipulations to restore the original letter case
                // this should work in most cases
                $rx_matches = explode('_', $arh_key);
                if( count($rx_matches) > 0 and strlen($arh_key) > 2 ) {
                    foreach($rx_matches as $ak_key => $ak_val) $rx_matches[$ak_key] = ucfirst($ak_val);
                    $arh_key = implode('-', $rx_matches);
                }
                $arh[$arh_key] = $val;
            }
        }
        return( $arh );
    }
    
    $serverHeader = apache_request_headers();
    
    $sFileInfo = '';
    
    $headers = array();
    $svHeader = array();
    
    foreach ($_SERVER as $k => $v){
        
        if(substr($k, 0, 9) == "HTTP_FILE"){
            $k = substr(strtolower($k), 5);
            $headers[$k] = $v;
        }
    }
	
    $filePath       = trim($serverHeader['STDFILEPATH']);
    $filePathArr    = explode("_",$filePath);
    $filePath       = implode("/",$filePathArr);
    
    
    $rootPath       = $_SERVER['DOCUMENT_ROOT'];
    $rootRealPath   = $rootPath."/fileupload/".$filePath."/".date("Y_m_d");
    $urlPath        = "/fileupload/".$filePath."/".date("Y_m_d");
    
    if(!is_dir($rootRealPath)){
        mkdirTree($rootRealPath);
    }	
    
    // 파일 확장자 소문자 변환 및 파일 이름 변경
    $ext = substr(strrchr($headers['file_name'],"."),1);
    $ext = strtolower($ext);
    
    $movefilename =   rand(1, 55).time().".".$ext;
    
	$file = new stdClass; 
	$file->name = $movefilename;	
	$file->size = $headers['file_size'];
	$file->content = file_get_contents("php://input"); 
	
	$newPath = $rootRealPath."/".iconv("utf-8", "cp949", $file->name);
	
	if(file_put_contents($newPath, $file->content)) {	// php5에서 되는기능
		$sFileInfo .= "&bNewLine=true";
		$sFileInfo .= "&sFileName=".$file->name;
		$sFileInfo .= "&sFileURL=http://".$_SERVER['HTTP_HOST'].$urlPath."/".$file->name;
	}
	echo $sFileInfo;
 ?>
