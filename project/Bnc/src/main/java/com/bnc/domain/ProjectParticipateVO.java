package com.bnc.domain;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ProjectParticipateVO {

	private int prpl_number;			//프로젝트 번호	
	private String prpl_acp_biznum;		//신청 기업 사업자등록번호
	private String cmpy_company_name;	//신청 기업명
	private int prpl_acp_price;			//제안 금액
	private	String prpl_rdate;			//신청일
	private String prpl_acp_phone;		//신청 기업 담당자연락처
	
	private String prpl_file_path;			// 파일경로
	private String prpl_file_name;			// 파일이름
	
	private MultipartFile prpl_file;			// 사업자등록증
}
