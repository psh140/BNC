package com.bnc.domain;

import lombok.Data;

@Data
public class ProjectContractLogVO {
	private int pctl_number;			// 시퀀스										not null
	private int pctl_proj_number;		// 프로젝트 고유번호								not null
	private String pctl_rdate;			// 로우 생성일									not null
	private String pctl_msg;
}
