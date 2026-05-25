package com.bnc.domain;

import lombok.Data;

@Data
public class AdminVO {
	private String admin_id;		// 관리자 아이디
	private String admin_name;		// 관리자 이름
	private String admin_password;	// 관리자 비밀번호
	private int admin_grade;		// 관리자 등급. 초기값 1
}
