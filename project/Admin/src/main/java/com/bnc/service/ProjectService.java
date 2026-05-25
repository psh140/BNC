package com.bnc.service;

import java.util.List;

import com.bnc.domain.ContractVO;
import com.bnc.domain.PaginationVO;
import com.bnc.domain.ProjectParticipateListVO;
import com.bnc.domain.ProjectVO;

public interface ProjectService {
//	public List<CompanyVO> getList(Criteria cri);	// 리스트 페이징
	
	public int selectProjectListCount(PaginationVO paginationVO);
	
	public List<ProjectVO> selectProjectList(PaginationVO paginationVO);
	
	public List<ProjectVO> getList();				// 리스트페이징x
	
	public ProjectVO projectRead(int proj_number);
	
	public List<ProjectParticipateListVO> participateList(int proj_number);
	
	public boolean delete(int proj_number);
	
	public ContractVO contractRead(int cntr_proj_number);
}
