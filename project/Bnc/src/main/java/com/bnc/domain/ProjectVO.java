package com.bnc.domain;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ProjectVO {

	private String authCheck;				// 의뢰/수주 체크 하기 위한 값
	private String cmpy_memb_id;
	private String stdFilePath;
	private int proj_number;				//프로젝트 고유번호		널 여부 : not null
	private String proj_thumb_file_path;	//프로젝트 썸네일 파일 경로	널 여부 : null
	private String proj_name;				//프로젝트명			널 여부 : not null
	private String proj_kind;				//구분	견적/제작/컨설팅	널 여부 : not null
	private String proj_req_phone;			//의뢰사 담당자 연락처	널 여부 : not null
	private String proj_req_biznum;			//의뢰사 사업자등록번호	널 여부 : not null
	private String proj_acp_phone;			//수주사 담당자 연락처	널 여부 : null
	private String proj_acp_biznum;			//수주사 사업자등록번호	널 여부 : null
	//private String proj_cntr_num;			//계약서 고유 번호		널 여부 : not null
	private String proj_mov_url;			//프로젝트 관련 영상 URL	널 여부 : null
	//private String proj_file_path;			//프로젝트 첨부파일		널 여부 : null
	//private String proj_file_real_name;		//프로젝트 첨부파일		널 여부 : null
	private String proj_keyword;			//프로젝트 검색 키워드	널 여부 : null
	private String proj_lead_time;			//프로젝트 진행 기간		널 여부 : null
	private String proj_flag;				//프로젝트 상태 기본값 	널 여부 : not null W:모집중 / C:협의중 / P:진행중 / E:종료
	private String proj_price_range;		//의뢰 금액 범위		널 여부 : not null
	private String proj_contents;			//프로젝트 상세 내용
	private String proj_rdate;				//등록일	널 여부 : not null
	private String proj_udate;				//수정일	널 여부 : not null
	
	private String proj_req_flag;			//의뢰측 철회 및 완료 여부 값 널 여부 : null
	private String proj_acp_flag;			//수즈측 철회 및 완료 여부 값 널 여부 : null
	
	private MultipartFile projThumbNail;	//프로젝트 썸네일 input type file
	private List<MultipartFile> fileField;	//프로젝트 첨부파일
	
	private List<String> modifyFiles;		//프로젝트 수정시 기존 첨부파일 리스트
}
