package com.bnc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.DocumentVO;
import com.bnc.domain.PaginationVO;
import com.bnc.mapper.DocumentMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@AllArgsConstructor
@Log4j
public class DocumentServiceImpl implements DocumentService{
	@Setter(onMethod_ = @Autowired)
	DocumentMapper mapper;

	@Override
	public int selectDocumentListCount(PaginationVO paginationVO) {
		
		return mapper.selectDocumentListCount(paginationVO);
	}

	@Override
	public List<DocumentVO> selectDocumentList(PaginationVO paginationVO) {
		// TODO Auto-generated method stub
		return mapper.selectDocumentList(paginationVO);
	}

	@Override
	public DocumentVO read(int doct_code) {
		// TODO Auto-generated method stub
		return mapper.read(doct_code);
	}

	@Override
	public void write(DocumentVO document) {
		mapper.write(document);
		
	}

	@Override
	public boolean modify(DocumentVO document) {
		// TODO Auto-generated method stub
		return mapper.modify(document) == 1;
	}

	@Override
	public boolean delete(int doct_code) {
		// TODO Auto-generated method stub
		return mapper.delete(doct_code) == 1;
	}
}
