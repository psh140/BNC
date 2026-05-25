package com.bnc.service;

import java.util.List;

import com.bnc.domain.DocumentVO;
import com.bnc.domain.PaginationVO;

public interface DocumentService {
	public int selectDocumentListCount(PaginationVO paginationVO);
	
	public List<DocumentVO> selectDocumentList(PaginationVO paginationVO);
	
	public DocumentVO read(int doct_code);
	
	public void write(DocumentVO document);
	
	public boolean modify(DocumentVO document); 
	
	public boolean delete(int doct_code);
}
