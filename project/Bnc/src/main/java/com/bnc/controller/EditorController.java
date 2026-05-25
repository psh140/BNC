package com.bnc.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bnc.config.UtilConfig;
import com.bnc.fileupload.NaverEditorFileUpload;

@Controller
@RequestMapping("/editor")
public class EditorController {

	@RequestMapping("/fileUpload")
	@ResponseBody
	public String fileUpload(HttpServletRequest request, Model model) throws Exception{
		
		NaverEditorFileUpload fileUpload = new NaverEditorFileUpload();
		
		String result = fileUpload.fileUploadProcess(request);
		
		return result;
	}
	
	@RequestMapping("/fileDownload")
	public void fileDownload(HttpServletRequest request,HttpServletResponse response) throws UnsupportedEncodingException {
        
		//저장 경로
		String path =  UtilConfig.FILE_DOWNLOAD_PATH;
        
        String filename = request.getParameter("filePath");
        String downname = request.getParameter("downName");
        String realPath = "";
        
        System.out.println("downname: "+downname);
        if (filename == null || "".equals(filename)) {
        	System.out.println("filename none");
            return;
        }
         
        try {
            String browser = request.getHeader("User-Agent"); 
            //파일 인코딩 
            if (browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")) {
                filename = URLEncoder.encode(filename, "UTF-8").replaceAll("%2F","/");
                downname = URLEncoder.encode(downname, "UTF-8").replaceAll("%2F","/");
            } else {
                filename = new String(filename.getBytes("UTF-8"), "ISO-8859-1");
                downname = new String(downname.getBytes("UTF-8"), "ISO-8859-1");
            }
        } catch (UnsupportedEncodingException ex) {
            System.out.println("UnsupportedEncodingException");
        }
        realPath = path + filename;
        
        System.out.println(realPath);
        
        File file1 = new File(realPath);
        if (!file1.exists()) {
        	System.out.println("실제 파일 없음");
            return;
        }
         
        // 파일명 지정        
        response.setContentType("application/octer-stream");
        response.setHeader("Content-Transfer-Encoding", "binary;");
        response.setHeader("Content-Disposition", "attachment; filename="+downname);
        try {
            OutputStream os = response.getOutputStream();
            FileInputStream fis = new FileInputStream(realPath);
 
            int ncount = 0;
            byte[] bytes = new byte[512];
 
            while ((ncount = fis.read(bytes)) != -1 ) {
                os.write(bytes, 0, ncount);
            }
            fis.close();
            os.close();
        } catch (FileNotFoundException ex) {
            System.out.println("FileNotFoundException");
        } catch (IOException ex) {
            System.out.println("IOException");
        }
    }
}
