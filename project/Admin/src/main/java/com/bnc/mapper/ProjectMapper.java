package com.bnc.mapper;

import java.util.List;

import com.bnc.domain.ContractVO;
import com.bnc.domain.Criteria;
import com.bnc.domain.PaginationVO;
import com.bnc.domain.ProjectParticipateListVO;
import com.bnc.domain.ProjectVO;

public interface ProjectMapper {
//	public List<CompanyVO> getList(Criteria cri);	// 리스트 페이징
	
	public List<ProjectVO> getList();				// 페이징 x
	
	public int selectProjectListCount(PaginationVO paginationVO);			//전체 로우 카운팅 메소드
	
	public List<ProjectVO> selectProjectList(PaginationVO paginationVO);	//리스트 리턴 메소드
	
	public ProjectVO projectRead(int proj_number);			// 특정 프로젝트 보기
	
	public List<ProjectParticipateListVO> participateListSelect(int proj_number);
	
//	public List<ProjectContractLogVO> logListSelect(Projec)

	public int delete(int proj_number);				// 삭제
	
	public int getTotalCount(Criteria cri);
	
	public ContractVO contractRead(int cntr_proj_number);
}
