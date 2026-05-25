package com.bnc.service;

import java.util.List;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.MemberCompanyVO;
import com.bnc.domain.PaginationVO;

public interface CompanyService {

//	public List<CompanyVO> getList(Criteria cri);	// 리스트 페이징
	public int selectCompanyListCount(PaginationVO paginationVO);
	
	public List<CompanyVO> selectCompanyList(PaginationVO paginationVO);
	
	public List<CompanyVO> getList();				// 리스트페이징x
	
	public CompanyVO selectBiznumRead(String cmpy_biznum);
	
	public CompanyVO selectIdRead(String cmpy_memb_id);
	
	public void modify(MemberCompanyVO company);
	
	public boolean delete(String cmpy_biznum);
}
