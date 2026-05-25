package com.bnc.domain;

import lombok.Data;

@Data
public class ProjectVO {
	private int proj_number;				//프로젝트 고유번호		널 여부 : not null
	private String proj_thumb_file_path;	//프로젝트 썸네일 파일 경로	널 여부 : null
	private String proj_name;				//프로젝트명			널 여부 : not null
	private String proj_kind;				//구분	견적/제작/컨설팅	널 여부 : not null
	private String proj_req_phone;			//의뢰사 담당자 연락처	널 여부 : not null
	private String proj_req_biznum;			//의뢰사 사업자등록번호	널 여부 : not null
	private String proj_acp_phone;			//수주사 담당자 연락처	널 여부 : null
	private String proj_acp_biznum;			//수주사 사업자등록번호	널 여부 : null
	private String proj_mov_url;			//프로젝트 관련 영상 URL	널 여부 : null
	private String proj_file_path;			//프로젝트 첨부파일		널 여부 : null
	private String proj_file_real_name;		//첨부파일 실제 이름		널 여부 : null
	private String proj_keyword;			//프로젝트 검색 키워드	널 여부 : null
	private String proj_lead_time;			//프로젝트 진행 기간		널 여부 : null
	private String proj_flag;				//프로젝트 상태 기본값 	널 여부 : not null W:모집중 / C:협의중 / P:진행중 / E:종료
	private String proj_price_range;		//의뢰 금액 범위		널 여부 : not null
	private String proj_rdate;				//등록일	널 여부 : not null
	private String proj_udate;				//수정일	널 여부 : not null
	private String proj_contents;			//프로젝트 내용	널 여부 : not null
}
