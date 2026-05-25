package com.bnc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.MemberCompanyVO;
import com.bnc.domain.PaginationVO;
import com.bnc.mapper.CompanyMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
@Service
@AllArgsConstructor
@Log4j
public class CompanyServiceImpl implements CompanyService{
	@Setter(onMethod_ = @Autowired)
	CompanyMapper mapper;
	
	@Override
	public List<CompanyVO> getList() {
		log.info("**************************Company getList");
		return mapper.getList();
	}

	@Override
	public CompanyVO selectBiznumRead(String cmpy_biznum) {
		log.info("**************************Company read");
		return mapper.selectBiznumRead(cmpy_biznum);
	}

	@Override
	public CompanyVO selectIdRead(String cmpy_memb_id) {
		// TODO Auto-generated method stub
		return mapper.selectIdRead(cmpy_memb_id);
	}
	
	@Override
	public boolean delete(String cmpy_biznum) {
		log.info("**************************Company delete");
		return mapper.delete(cmpy_biznum) == 1;
	}

	@Override
	public int selectCompanyListCount(PaginationVO paginationVO) {
		
		return mapper.selectCompanyListCount(paginationVO);
	}

	@Override
	public List<CompanyVO> selectCompanyList(PaginationVO paginationVO) {
		
		return mapper.selectCompanyList(paginationVO);
	}

	@Override
	public void modify(MemberCompanyVO company) {
		mapper.modify(company);
		
	}



}
