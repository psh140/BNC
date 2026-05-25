package com.bnc.domain;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class SignVO {
	
	private String stdFilePath;
	
	private int sign_num;				// 서명 시퀀스		
	private String sign_file_path;		// 서명 파일 경로
	private String sign_memb_id;		// 고유 아이디
	private String sign_rdate;			// 등록일
	private String sign_udate;			// 수정일
	
	private MultipartFile signFile;		// 서명 파일
}