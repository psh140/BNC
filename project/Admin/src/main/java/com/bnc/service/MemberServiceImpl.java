package com.bnc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.MemberCompanyVO;
import com.bnc.domain.MemberLogVO;
import com.bnc.domain.PaginationVO;
import com.bnc.mapper.MemberMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
@Service
@AllArgsConstructor
@Log4j
public class MemberServiceImpl implements MemberService{
	@Setter(onMethod_ = @Autowired)
	MemberMapper mapper;
	
	@Override
	public int selectMemberListCount(PaginationVO paginationVO) {
		// TODO Auto-generated method stub
		return mapper.selectMemberListCount(paginationVO);
	}

	@Override
	public List<MemberCompanyVO> selectMemberList(PaginationVO paginationVO) {
		// TODO Auto-generated method stub
		return mapper.selectMemberList(paginationVO);
	}

	@Override
	public MemberCompanyVO read(String memb_id) {
		// TODO Auto-generated method stub
		return mapper.read(memb_id);
	}

	@Override
	public boolean delete(String memb_id) {
		// TODO Auto-generated method stub
		return mapper.delete(memb_id) == 1;
	}

	@Override
	public int selectLogListCount(String memb_id) {
		System.out.println("selectLogListCount 넘어온 memb_id : " + memb_id);
		int a = mapper.selectLogListCount(memb_id);
		System.out.println(" a 값 : " + a);
		return a;
	}
	
	@Override
	public List<MemberLogVO> selectLogList(String memb_id) {
		System.out.println("selectLogList 넘어온 memb_id : " + memb_id);
		return mapper.selectLogList(memb_id);
	}
	
	@Override
	public boolean activate(String memb_id) {
		// TODO Auto-generated method stub
		return mapper.activate(memb_id) == 1;
	}

	@Override
	public boolean inactivate(String memb_id) {
		// TODO Auto-generated method stub
		return mapper.inactivate(memb_id) == 1;
	}





}
