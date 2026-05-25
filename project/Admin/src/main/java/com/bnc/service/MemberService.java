package com.bnc.service;

import java.util.List;

import com.bnc.domain.MemberCompanyVO;
import com.bnc.domain.MemberLogVO;
import com.bnc.domain.PaginationVO;

public interface MemberService {
	public int selectMemberListCount(PaginationVO paginationVO);
	
	public List<MemberCompanyVO> selectMemberList(PaginationVO paginationVO);
	
	public MemberCompanyVO read(String memb_id);
	
	public boolean delete(String memb_id);
	
	public int selectLogListCount(String memb_id);
	
	public List<MemberLogVO> selectLogList (String memb_id);
	
	public boolean activate(String memb_id);
	
	public boolean inactivate(String memb_id);
}
