package com.bnc.domain;

import lombok.Data;

@Data
public class MemberLogVO {
	private String meml_id;		// 아이디
	private String meml_ldate;	// 로그인 한 시간
	private String meml_ip;		// 로그인한 IP
}
