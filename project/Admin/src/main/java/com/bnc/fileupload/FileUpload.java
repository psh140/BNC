package com.bnc.fileupload;

import java.io.File;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

public class FileUpload {
	public static String upload(String urlPath, String realPath, MultipartFile file) throws Exception{
		
		String name 	= file.getOriginalFilename();
		String ext 		= name.substring(name.lastIndexOf(".")+1);
		String realname = UUID.randomUUID().toString() + "." + ext; 
				
		File dir	= new File(realPath);
		
		if(!dir.exists()) 
		{ 
			dir.mkdirs(); 
		}
				
		File uploadedFile  		= new File(realPath+"/"+realname);
		
		System.out.println(realPath+"/"+realname);
		file.transferTo(uploadedFile);
		
		return urlPath+"/"+realname;
	}
}
