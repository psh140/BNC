package com.bnc.domain;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ContractDTO {

	private String authority;			//계약서 작성한 사측 구분위한 값
	
	private int cntr_proj_number;		//계약서 고유 번호
	private int cntr_price;				//계약금액
	
	private String cntr_flag;			//계약서 상태
	private String cntr_rdate;			//계약서 생성일
	private String cntr_udate;			//계약서 업데이트일
	
	private String cntr_req_biznum;		//의뢰사 사업자등록번호
	private String cntr_acp_biznum;		//수주사 사업자등록번호
	
	private String cntr_req_sign_path;	//의뢰사 사인 파일
	private String cntr_acp_sign_path;	//수주사 사인 파일
	
	private String cntr_req_ceo_name;	//의뢰사 대표자명
	private String cntr_acp_ceo_name;	//수주사 대표자명
	
	private String cntr_start_date;		//계약기간 시작일
	private String cntr_end_date;		//계약기간 종료일
	
	private String cntr_contents;		//계약내용
	
	private MultipartFile cntr_req_sign_file;	//사인 파일 의뢰측
	private MultipartFile cntr_acp_sign_file;	//사인 파일 수주측
	
}
