package com.bnc.domain;

import lombok.Data;

@Data
public class ProjectParticipateListVO {
	private int prpl_number;		// 프로젝트 고유번호 			not null
	private String prpl_acp_biznum;	// 참여신청 회사 사업자등록번호 	not null
	private int prpl_acp_price;		// 제안 금액				not null
	private String prpl_acp_phone;	// 담당자 연락처				not null
	private String prpl_rdate;		// 참가 신청일				not null
}
