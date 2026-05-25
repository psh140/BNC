package com.bnc.mapper;

import java.util.List;
import java.util.Map;

import com.bnc.domain.PaginationVO;
import com.bnc.domain.ProjectFileDTO;
import com.bnc.domain.ProjectParticipateVO;
import com.bnc.domain.ProjectVO;

public interface ProjectMapper {

	//전체 로우 카운팅 메소드
	public int selectProjectListCount(PaginationVO paginationVO);
	
	//리스트 리턴 메소드
	public List<ProjectVO> selectProjectList(PaginationVO paginationVO);	
	
	//프로젝트 뷰 리턴 메소드
	public ProjectVO selectProjectView(int projectNumber);
	
	//매칭을 신청한 기업 리스트
	public List<ProjectParticipateVO> selectProjectParticipateList(int projectNumber);	
	
	//매칭 신청 기업 정보
	public ProjectParticipateVO selectProjectParticipateData(ProjectParticipateVO projectParticipateVO);
	
	//매칭 신청 여부 확인 메소드
	public int selectProjectParticipateCheckCount(ProjectParticipateVO projectParticipateVO);	
	
	//매칭 신청 기업 인서트
	public void insertProjectParticipateData(ProjectParticipateVO projectParticipateVO);
	
	//프로젝트 로우 인서트
	public int insertProjectData(ProjectVO projectVO);	
	
	//프로젝트 매칭시 업데이트 처리
	public void updateProjectMatching(ProjectParticipateVO projectParticipateVO);
	
	//프로젝트 상태값 변경
	public void updateProjectFlag(ProjectVO projectVO);
		
	//마이 프로젝트 리스트 전체 로우 카운팅 메소드
	public int selectMyProjectListCount(Map<String, Object> maps);
	
	//마이 프로젝트 리스트
	public List<ProjectVO> selectMyProjectList(Map<String, Object> maps);
	
	
	//파일 업로드
	public void insertProjectFiles(ProjectFileDTO projectfileDTO);
	
	//파일 셀렉트
	public List<ProjectFileDTO> selectProjectFiles(int projectNumber);
	
	//프로젝트 카운트
	public int projectCount();
	
	
	// 철회 & 완료 변경 처리
	public void updateProjectWorkingFlag(ProjectVO projectVO);
		
	//프로젝트 업데이트 처리
	public void updateProjectData(ProjectVO projectVO);
	
	
	/* 삭제 관련 */
	//프로젝트 삭제
	public void deleleProject(ProjectVO projectVO);
	
	//프로젝트 첨부 파일 삭제
	public void deleteProjectFile(ProjectVO projectVO);
	
	//프로젝트 매칭 신청 기업 삭제
	public void deleteProjectParticipateData(ProjectVO projectVO);
	
	public void deleteProjectFilesNotIn(Map<String, Object> fileList);
	
}
