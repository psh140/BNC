package com.bnc.domain;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class CompanyVO {
	
	private String stdFilePath;
	
	private String cmpy_biznum;					// 사업자등록증번호, Not null
	private String cmpy_biz_doc_file_path;		// 사업자등록증파일, Not null
	private String cmpy_memb_id;				// 회원아이디, Not null
	private String cmpy_company_name;			// 기업명, Not null
	private String cmpy_ceo_name;				// 기업 대표명
	private String cmpy_biz_code;				// 업종 구분, Not null
	private String cmpy_biz_address;			// 기업 주소
	private String cmpy_biz_phone;				// 기업 연락처
	private String cmpy_biz_email;				// 기업 이메일
	private String cmpy_biz_sign_file_path;		// 회원 서명파일
	private String cmpy_rdate;					// 기업정보 등록일, Not null
	private String cmpy_udate;					// 기업정보 수정일, Not null
	private String cmpy_ci_file_path;			// 기업CI파일
	private String cmpy_contents;				// 기업소개
	private String cmpy_homepage;				// 기업홈페이지
	
	
	private MultipartFile ciThumbNail;			// 기업CI
	private MultipartFile biznumFile;			// 사업자등록증
		
	private String bizc_name; 					// 업종명
}
