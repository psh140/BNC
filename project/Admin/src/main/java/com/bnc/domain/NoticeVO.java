package com.bnc.domain;

import lombok.Data;

@Data
public class NoticeVO {
		
	private int notc_number;		// 공지사항 글번호		null 불가
	private String notc_admin_id;	// 공지사항 작성자 아이디	null 불가
	private String notc_title;		// 공지사항 제목			null 불가
	private String notc_rdate;		// 공지사항 작성일		null 불가
	private String notc_udate;		// 공지사항 수정일		null 불가
	private String notc_contents;	// 공지사항 내용			null 불가
}
