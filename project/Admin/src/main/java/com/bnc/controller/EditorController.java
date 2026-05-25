package com.bnc.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bnc.fileupload.NaverEditorFileUpload;

@Controller
@RequestMapping("/editor")
public class EditorController {

	@RequestMapping("/fileUpload")
	@ResponseBody
	public String fileUpload(HttpServletRequest request, Model model) throws Exception{
		
		System.out.println("여기");
		
		NaverEditorFileUpload fileUpload = new NaverEditorFileUpload();
		
		String result = fileUpload.fileUploadProcess(request);
		
		return result;
	}
}
