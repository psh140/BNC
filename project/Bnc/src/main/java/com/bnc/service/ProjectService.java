package com.bnc.service;

import java.util.List;

import com.bnc.domain.DocumentDTO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.PaginationVO;
import com.bnc.domain.ProjectFileDTO;
import com.bnc.domain.ProjectParticipateVO;
import com.bnc.domain.ProjectVO;

public interface ProjectService {

	//프로젝트 리스트 개수 카운트 로직 
	public int selectProjectListCount(PaginationVO paginationVO);
	
	//프로젝트 리스트 로직
	public List<ProjectVO> selectProjectList(PaginationVO paginationVO);
	
	//프로젝트 데이터 로직
	public ProjectVO selectProjectView(int projectNumber);
	
	//프로젝트 파일 셀렉트
	public List<ProjectFileDTO> selectProjectFiles(int projectNumber);
	
	//프로젝트 매칭 신청 기업 리스트 로직
	public List<ProjectParticipateVO> selectProjectParticipateList(int projectNumber);
	
	//매칭 신청 여부 확인 로직
	public int selectProjectParticipateCheckCount(ProjectParticipateVO projectParticipateVO, MemberVO memberVO);
	
	//프로젝트 매칭 신청 로직
	public void insertProjectParticipateData(ProjectParticipateVO projectParticipateVO, MemberVO memberVO) throws Exception;
	
	//프로젝트 등록 로직
	public void insertProjectData(ProjectVO projectVO, MemberVO memberVO) throws Exception;
	
	//프로젝트 매칭 처리 로직
	public void updateMatchingProcess(ProjectParticipateVO projectParticipateVO);
	
	//마이 프로젝트 리스트 전체 로우 카운팅 메소드
	public int selectMyProjectListCount(PaginationVO paginationVO, MemberVO memberVO);
	
	//마이 프로젝트 리스트
	public List<ProjectVO> selectMyProjectList(PaginationVO paginationVO, MemberVO memberVO);
		
	//문서양식 데이터 인데 사용안할듯....?
	public DocumentDTO selectDocumentFormData();
	
	//프로젝트 카운트
	public int projectCount();
	
	
	// 철회 & 완료 변경 처리
	public void updateProjectWorkingProcess(ProjectVO projectVO);
	
	
	public void updateProjectData(ProjectVO projectVO) throws Exception;
	
	/* 삭제 관련 */
	
	//프로젝트 삭제
	public void deleteProject(ProjectVO projectVO);
	
}
