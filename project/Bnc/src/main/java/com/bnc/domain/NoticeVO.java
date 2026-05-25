package com.bnc.domain;

import lombok.Data;

@Data
public class NoticeVO {
	private int notc_number;			// 공지사항 고유번호 PK     								  not null 
	private String notc_admin_id;		// 관리자 아이디  FK		  								  not null
	private String notc_title;			// 공지사항 글제목		  							      not null
	private String notc_rdate;			// 공지사항 작성일 ex)20201109151106 yyyyMMddHHmmss		  not null
	private String notc_udate;			// 공지사항 수정일  ex)20201109151106 yyyyMMddHHmmss 		  not null
	private String notc_contents;		// 공지사항 상세내용 		  								  not null
}
