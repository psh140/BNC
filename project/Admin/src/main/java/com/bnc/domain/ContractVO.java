package com.bnc.domain;

import lombok.Data;

@Data
public class ContractVO {
	private int cntr_proj_number;			// 계약서 고유번호			not null
	private int cntr_price;				// 계약 금액				not null
	private String cntr_flag;			// 계약서 상태				not null
	private String cntr_rdate;			// 계약서 생성일				not null
	private String cntr_udate;			// 계약서 수정일				not null
	private String cntr_req_biznum;		// 의뢰회사 사업자등록번호		not null 
	private String cntr_acp_biznum;		// 수주회사 사업자등록번호		not null
	private String cntr_req_sign_path;	// 의뢰회사 사인, 도장파일		yes null
	private String cntr_acp_sign_path;	// 수주회사 사인, 도장파일		yes null
	private String cntr_req_ceo_name;	// 의뢰 회사 대표자명			yes null
	private String cntr_acp_ceo_name;	// 수주 회사 대표자명			yes null
	private String cntr_start_date;		// 계약기간 시작일			not null
	private String cntr_contents;		// 상세 내용 작성				not null
	private String cntr_end_date;		// 계약기간 종료일			not null
}
