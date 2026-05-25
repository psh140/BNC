package com.bnc.domain;

import lombok.Data;

@Data
public class MemberVO {
	private String memb_id;			// 아이디
	private String memb_kind;		// oAuth 종류. NAVER or Kakao
	private String memb_email;		// 이메일 주소
	private String memb_rdate;		// 가입밀
	private String memb_auth_flag;	// 인증 여부 Y or N or E 는 비활성화
	private String memb_ip;			// 최초 가입시의 IP
}
