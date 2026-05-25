package com.bnc.domain;

import lombok.Data;

@Data
public class ChartVO {
	private int proj_flag_W;	// 프로젝트 현황 : 모집중
	private int proj_flag_C;	// 프로젝트 현황 : 협의중
	private int proj_flag_P;	// 프로젝트 현황 : 진행중
	private int proj_flag_E;	// 프로젝트 현황 : 종료
	
//	private int curMonthMemberCount;	// 현재 달 회원가입 수
//	private int minOneMMemberCount;		// 지난달 회원가입 수
//	private int minTwoMMemberCount;		// 2달전 회원가입 수
//	private int minThreeMMemberCount;	// 3달전 회원가입 수
//	private int minFourMMemberCount;	// 4달전 회원가입 수
//	private int minFiveMMemberCount;	// 5달전 회원가입 수
	
	private int monthMemberCount;
	
	private String proj_name;			// 프로젝트 이름
	private String proj_req_biznum;		// 의뢰회사 사업자등록번호
	private String proj_acp_biznum;		// 수주회사 사업자 등록번호
	private String cmpy_company_name;	// 회사 이름
	
	private String memb_rdate;			// 날짜
	private int proj_number;			// 프로젝트 번호
	private int cntr_price;				// 프로젝트 계약금액
	private int cnt;					// 횟수 
	private int totalPrice;				// 총액 
}
