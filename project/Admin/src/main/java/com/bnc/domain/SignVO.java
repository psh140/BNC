package com.bnc.domain;

import lombok.Data;

@Data
public class SignVO {
	private int sign_num;			// 시퀀스
	private String sign_file_path;	// 서명 파일 경로
	private String sign_memb_id;	// 고유 아이디
	private String sign_rdate;		// 등록일
	private String sign_udate;		// 수정일
}
