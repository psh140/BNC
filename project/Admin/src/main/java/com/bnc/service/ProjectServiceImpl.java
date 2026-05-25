package com.bnc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.ContractVO;
import com.bnc.domain.PaginationVO;
import com.bnc.domain.ProjectParticipateListVO;
import com.bnc.domain.ProjectVO;
import com.bnc.mapper.ProjectMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@AllArgsConstructor
@Log4j
public class ProjectServiceImpl implements ProjectService{
	@Setter(onMethod_ = @Autowired)
	ProjectMapper mapper;
	
	@Override
	public List<ProjectVO> getList() {
		log.info("********************Project getList");
		return mapper.getList();
	}

	@Override
	public ProjectVO projectRead(int proj_number) {
		log.info("********************Project read");
		
		return mapper.projectRead(proj_number);
	}

	@Override
	public boolean delete(int proj_number) {
		log.info("********************Project delete");
		return mapper.delete(proj_number) == 1;
	}

	@Override
	public int selectProjectListCount(PaginationVO paginationVO) {
		// TODO Auto-generated method stub
		return mapper.selectProjectListCount(paginationVO);
	}

	@Override
	public List<ProjectVO> selectProjectList(PaginationVO paginationVO) {
		// TODO Auto-generated method stub
		return mapper.selectProjectList(paginationVO);
	}

	@Override
	public List<ProjectParticipateListVO> participateList(int proj_number) {
		
		return mapper.participateListSelect(proj_number);
	}

	@Override
	public ContractVO contractRead(int cntr_proj_number) {

		return mapper.contractRead(cntr_proj_number);
	}
	

}
