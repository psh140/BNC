package com.bnc.domain;

import lombok.Data;

@Data
public class MemberVO {
	private String memb_id;
	private String memb_kind;
	private String memb_email;
	private String memb_rdate;
	private String memb_auth_flag;
	private String memb_stat;
	private String memb_ip;
}
