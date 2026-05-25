package com.bnc.mapper;


import java.util.List;
import java.util.Map;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.Criteria;
import com.bnc.domain.MemberVO;
import com.bnc.domain.PaginationVO;

public interface CompanyMapper {
	
	public List<CompanyVO> getList();											// 기업정보 전체 List
	
	public int selectCompanyListCount(PaginationVO paginationVO);				// 기업정보 List count
	
	public List<CompanyVO> selectCompanyList(PaginationVO paginationVO);		// 기업정보 전체 List 및 paging
	
	public CompanyVO read(String cmpy_biznum);									// 기업정보 상세보기
	
	public int getTotalCount(Criteria cri);										// paging
	
	
	/*뭔지모르겠음...*/
	public CompanyVO selectMyCompanyData(MemberVO memberVO);	

	public List<CompanyVO> selectCompanyData(Map<String, Object> companyList);

}
