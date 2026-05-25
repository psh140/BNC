package com.bnc.service;


import java.util.List;
import java.util.Map;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.PaginationVO;

public interface CompanyService {
	
	public List<CompanyVO> getList();
	
	public int selectCompanyListCount(PaginationVO paginationVO);				// 기업정보 List count
	
	public List<CompanyVO> selectCompanyList(PaginationVO paginationVO);		// 기업정보 전체 List 및 paging

	public CompanyVO read(String cmpy_biznum);									// 기업정보 상세보기
	
	
	public CompanyVO selectMyCompanyData(MemberVO memberVO);
	
	public List<CompanyVO> selectCompanyData(Map<String, Object> companyList);
}
