package com.bnc.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.PaginationVO;
import com.bnc.mapper.CompanyMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class CompanyServiceImpl implements CompanyService {
	@Setter(onMethod_ = @Autowired)
	CompanyMapper mapper;

	public CompanyVO selectMyCompanyData(MemberVO memberVO) {
		return mapper.selectMyCompanyData(memberVO);
	}

	public int selectCompanyListCount(PaginationVO paginationVO) {
		return mapper.selectCompanyListCount(paginationVO);

	}

	public List<CompanyVO> selectCompanyList(PaginationVO paginationVO) {
		return mapper.selectCompanyList(paginationVO);
	}

	public List<CompanyVO> selectCompanyData(Map<String, Object> companyList) {
		return mapper.selectCompanyData(companyList);
	}

	public CompanyVO read(String cmpy_biznum) {
		return mapper.read(cmpy_biznum);
	}

	public List<CompanyVO> getList() { 
		return mapper.getList(); 
	}
	 
}
