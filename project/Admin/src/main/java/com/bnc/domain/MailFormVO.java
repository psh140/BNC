package com.bnc.domain;

import lombok.Data;

@Data
public class MailFormVO {
	private String malf_kind;	// 메일 종류
	private String malf_title;	// 메일 양식 이름
	private String malf_form;	// 메일 양식
}
