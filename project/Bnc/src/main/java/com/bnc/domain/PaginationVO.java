package com.bnc.domain;

import lombok.Data;

@Data
public class PaginationVO {

	private String searchType;				//서치 타입
	private String searchKeyword;			//서치 키워드 값
	
	private int startRowNumber;				//로우넘 시작 번호
	private int endRowNumber;				//로우넘 끝 번호
}
