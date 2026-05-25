package com.bnc.mapper;

import java.util.List;

import com.bnc.domain.MemberCompanyVO;
import com.bnc.domain.MemberLogVO;
import com.bnc.domain.PaginationVO;

public interface MemberMapper {

	public int selectMemberListCount(PaginationVO paginationVO);						//전체 로우 카운팅 메소드
	
	public List<MemberCompanyVO> selectMemberList(PaginationVO paginationVO);			//리스트 리턴 메소드
	
	public MemberCompanyVO read(String memb_id);										// 상세보기
	
	public void modify(String memb_id);													// 수정
			
	public int delete(String memb_id);													// 삭제
	
	public int selectLogListCount(String memb_id);			// 로그 카운팅
	
	public List<MemberLogVO> selectLogList(String memb_id);	// 로그띄우기
	
	public int activate(String memb_id);												// 사용자 활성화

	public int inactivate(String memb_id);												// 사용자 비활성화
}
