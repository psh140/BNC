package com.bnc.domain;

import lombok.Data;

@Data
public class TermsVO {
	private String pol_kind;			//타입. T:이용약관  / P:개인정보처리방침
	private String pol_contents;		//상세내용
	private String pol_rdate;			//등록일
	private String pol_udate;			//수정일
}
