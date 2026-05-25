package com.bnc.domain;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class CompanyVO {
		
	private String cmpy_biznum;				// 사업자등록번호 PK									not null
	private String cmpy_biz_doc_file_path;	// 사업자등록증 파일 경로								not null
	private String cmpy_memb_id;			// 고유 아이디  FK 									not null
	private String cmpy_company_name;		// 기업명											not null
	private String cmpy_ceo_name;			// 대표자명										yes null
	private String cmpy_biz_code;			// 업종 카테고리 코드  FK biz_code						not null
	private String cmpy_biz_address;		// 사업장 주소										yes null
	private String cmpy_biz_phone;			// 기업 대표 연락처									yes null
	private String cmpy_biz_email;			// 기업 이메일 주소									yes null
	private String cmpy_rdate;			// 등록일  ex)20201109151106 yyyyMMddHHmmss ? 맞나	not null
	private String cmpy_udate;			// 수정일  ex)202011 3075943  yyyyMMddHHmmss		not null
	private String cmpy_ci_file_path;		// 기업 CI 이미지									yes null
	private String cmpy_contents;			// 기업상세내용										yes null
	private String cmpy_homepage;			// 기업홈페이지										yes null

	
	private MultipartFile cmpy_bizdoc_file;


	private String bizc_name;				// 업종명 가져오기
}
