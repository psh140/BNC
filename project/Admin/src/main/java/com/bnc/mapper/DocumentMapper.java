package com.bnc.mapper;

import java.util.List;

import com.bnc.domain.DocumentVO;
import com.bnc.domain.PaginationVO;

public interface DocumentMapper {
	public int selectDocumentListCount(PaginationVO paginationVO);			//전체 로우 카운팅 메소드
	
	public List<DocumentVO> selectDocumentList(PaginationVO paginationVO);	//리스트 리턴 메소드
	
	public DocumentVO read(int doct_code);		// 상세보기
	
	public void write(DocumentVO document);			// 쓰기
	
	public int modify(DocumentVO document);			// 수정
	
	public int delete(int doct_code);			// 삭제
}
