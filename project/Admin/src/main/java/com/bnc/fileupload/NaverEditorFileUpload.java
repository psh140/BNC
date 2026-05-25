package com.bnc.fileupload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import com.bnc.config.UtilConfig;

public class NaverEditorFileUpload {

	public void mkdirTree(String path)
	{
		File folder = new File(path);	
		
		if (!folder.exists()) 
		{
			try{
				folder.mkdirs(); //폴더 생성합니다.
				System.out.println("폴더가 생성되었습니다.");
			} 
			catch(Exception e){
				e.getStackTrace();
			}      
		}
		else
		{
			System.out.println("이미 폴더가 생성되어 있습니다.");
		}
	}
	
	public String fileUploadProcess(HttpServletRequest request) throws Exception {
		
		String getPath 		= UtilConfig.FILE_ROOT_PATH+request.getHeader("stdFilePath");
		String fileUrlPath  = UtilConfig.FILE_URL_PATH+request.getHeader("stdFilePath");

		String sFileInfo = ""; 

		// 파일명 - 싱글파일업로드와 다르게 멀티파일업로드는 HEADER로 넘어옴 
		String name = request.getHeader("file-name");
		
		// 확장자 
		String ext = name.substring(name.lastIndexOf(".")+1); 
		
		// 파일 경로 
		String defaultPath = getPath; 
		
		// 파일 기본경로 _ 상세경로 
		String path = defaultPath + File.separator; 

		
		
		File file = new File(path); 
		if(!file.exists()) 
		{ 
			file.mkdirs(); 
		}

		String realname 	= UUID.randomUUID().toString() + "." + ext; 
		InputStream is 		= request.getInputStream(); 
		OutputStream os 	= new FileOutputStream(path + realname); 
		int numRead; 
				
		// 파일쓰기 
		byte b[] = new byte[Integer.parseInt(request.getHeader("file-size"))]; 
		
		while((numRead = is.read(b,0,b.length)) != -1) {
			os.write(b,0,numRead); 
		} 
		
		if(is != null) 
		{ 
			is.close(); 
		} 
		
		os.flush(); 
		os.close(); 
		
		System.out.println("path : "+path); 
		System.out.println("realname : "+realname); 
		
		
		sFileInfo += "&bNewLine=true&sFileName="+ name+"&sFileURL="+fileUrlPath+"/"+realname; 
		
		return sFileInfo;
	}
}
