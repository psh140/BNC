package com.bnc.mapper;

import java.util.List;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.Criteria;
import com.bnc.domain.MemberCompanyVO;
import com.bnc.domain.PaginationVO;

public interface CompanyMapper {

//	public List<CompanyVO> getList(Criteria cri);	// 리스트 페이징
	
	public List<CompanyVO> getList();				// 페이징 x
	
	public int selectCompanyListCount(PaginationVO paginationVO);			//전체 로우 카운팅 메소드
	
	public List<CompanyVO> selectCompanyList(PaginationVO paginationVO);	//리스트 리턴 메소드
	
	public CompanyVO selectBiznumRead(String cmpy_biznum);					// 사업자번호로 상세보기
	
	public CompanyVO selectIdRead(String cmpy_memb_id);						// 아이디로 상세보기

	public int delete(String cmpy_biznum);									// 삭제
	
	public void modify(MemberCompanyVO company);							// 수정
	
	public int getTotalCount(Criteria cri);
	
}
