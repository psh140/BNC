package com.bnc.domain;

import lombok.Data;

@Data
public class DocumentVO {
	private int doct_code;			// 문서 고유번호
	private String doct_name;			// 문서 이름
	private String doct_form;			// 문서 양식
}
