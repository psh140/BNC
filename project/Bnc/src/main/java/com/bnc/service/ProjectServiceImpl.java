package com.bnc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bnc.config.UtilConfig;
import com.bnc.domain.CompanyVO;
import com.bnc.domain.DocumentDTO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.PaginationVO;
import com.bnc.domain.ProjectFileDTO;
import com.bnc.domain.ProjectParticipateVO;
import com.bnc.domain.ProjectVO;
import com.bnc.fileupload.FileUpload;
import com.bnc.mapper.CompanyMapper;
import com.bnc.mapper.ContractMapper;
import com.bnc.mapper.DocumentMapper;
import com.bnc.mapper.ProjectMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class ProjectServiceImpl implements ProjectService{

	@Setter(onMethod_= @Autowired)
	private ProjectMapper projectMapper;
	
	@Setter(onMethod_= @Autowired)
	private CompanyMapper companyMapper;
	
	@Setter(onMethod_= @Autowired)
	private DocumentMapper documentMapper;
	
	@Setter(onMethod_ = @Autowired)
	private ContractMapper contractMapper;
	
	//마이 프로젝트 리스트 전체 로우 카운팅 메소드
	public int selectMyProjectListCount(PaginationVO paginationVO, MemberVO memberVO) {
		
		Map<String, Object> maps = new HashMap<String, Object>();
		
		CompanyVO companyVO = companyMapper.selectMyCompanyData(memberVO);
		
		maps.put("pageData", paginationVO);
		maps.put("companyData", companyVO);
		
		
		return projectMapper.selectMyProjectListCount(maps);
	}
	
	//마이 프로젝트 리스트
	public List<ProjectVO> selectMyProjectList(PaginationVO paginationVO, MemberVO memberVO){
		
		Map<String, Object> maps = new HashMap<String, Object>();
		
		CompanyVO companyVO = companyMapper.selectMyCompanyData(memberVO);
		
		maps.put("pageData", paginationVO);
		maps.put("companyData", companyVO);
		
		return projectMapper.selectMyProjectList(maps);
	}
		
	//전체 로우 카운팅 메소드
	public int selectProjectListCount(PaginationVO paginationVO) {
		return projectMapper.selectProjectListCount(paginationVO);
	}
	
	//리스트 리턴 메소드
	public List<ProjectVO> selectProjectList(PaginationVO paginationVO){
		return projectMapper.selectProjectList(paginationVO);
	}
	
	//프로젝트 뷰 리턴 메소드
	public ProjectVO selectProjectView(int projectNumber) {
		return projectMapper.selectProjectView(projectNumber);
	}
	
	//매칭을 신청한 기업 리스트
	public List<ProjectParticipateVO> selectProjectParticipateList(int projectNumber) {
		return projectMapper.selectProjectParticipateList(projectNumber);
	}
	
	//매칭 신청 여부 확인 메소드
	public int selectProjectParticipateCheckCount(ProjectParticipateVO projectParticipateVO, MemberVO memberVO) {
		
		CompanyVO companyVO = companyMapper.selectMyCompanyData(memberVO);
		projectParticipateVO.setPrpl_acp_biznum(companyVO.getCmpy_biznum());
		
		return projectMapper.selectProjectParticipateCheckCount(projectParticipateVO);
	}
	
	
	public DocumentDTO selectDocumentFormData() {
		return documentMapper.selectDocumentData();
	}
	
	public void insertProjectParticipateData(ProjectParticipateVO projectParticipateVO, MemberVO memberVO) throws Exception{
		
		CompanyVO companyVO = companyMapper.selectMyCompanyData(memberVO);
		projectParticipateVO.setPrpl_acp_biznum(companyVO.getCmpy_biznum());
		
		System.out.println(projectParticipateVO);
		
		
		
		if(!projectParticipateVO.getPrpl_file().getOriginalFilename().equals(""))
		{
			//파일 경로 세팅
			String urlPath	= UtilConfig.FILE_URL_PATH;
			String realPath	= UtilConfig.FILE_ROOT_PATH;
			
			String resultFilePath = FileUpload.upload(urlPath, realPath, projectParticipateVO.getPrpl_file());
			String resultFileRealName = projectParticipateVO.getPrpl_file().getOriginalFilename();
				
			projectParticipateVO.setPrpl_file_path(resultFilePath);
			projectParticipateVO.setPrpl_file_name(resultFileRealName);
		}
	
		projectMapper.insertProjectParticipateData(projectParticipateVO);
		
	}
	
	
	//프로젝트 파일 리턴 메소드
	public List<ProjectFileDTO> selectProjectFiles(int projectNumber) {
		return projectMapper.selectProjectFiles(projectNumber);
	}
	
	//프로젝트 등록
	@Transactional
	public void insertProjectData(ProjectVO projectVO, MemberVO memberVO) throws Exception {
		
		//자신이 등록한 기업정보 셀렉트 
		CompanyVO companyVO = companyMapper.selectMyCompanyData(memberVO);
		projectVO.setProj_req_biznum(companyVO.getCmpy_biznum());
		
		//파일 경로 세팅
		String urlPath	= UtilConfig.FILE_URL_PATH + projectVO.getStdFilePath();
		String realPath	= UtilConfig.FILE_ROOT_PATH + projectVO.getStdFilePath();

		//FileUpload 클래스는 com.bnc.fileupload 패키지에 있음 FileUpload.java
		//프로젝트 썸네일 파일 업로드 (write.jsp 참고 input name="projThumbNail"  
		String resultThumbFilePath = FileUpload.upload(urlPath, realPath, projectVO.getProjThumbNail());
		projectVO.setProj_thumb_file_path(resultThumbFilePath);
		
		//프로젝트 등록
		projectMapper.insertProjectData(projectVO);
		
		if(!projectVO.getFileField().get(0).getOriginalFilename().equals(""))
		{
			//첨부 파일 다중 업로드 input 태그의 multiple (write.jsp 참고 input name="fileField" )
			for(int i=0; i<projectVO.getFileField().size(); i++) {
				String resultFilePath = FileUpload.upload(urlPath, realPath, projectVO.getFileField().get(i));
				String resultFileRealName = projectVO.getFileField().get(i).getOriginalFilename();
				
				ProjectFileDTO fileDTO = new ProjectFileDTO();
				
				fileDTO.setProf_proj_number(projectVO.getProj_number());
				fileDTO.setProf_file_path(resultFilePath);
				fileDTO.setProf_file_name(resultFileRealName);

				System.out.println(fileDTO);
				
				projectMapper.insertProjectFiles(fileDTO);
				
			}
		}
	}
	

	@Transactional
	public void updateMatchingProcess(ProjectParticipateVO projectParticipateVO) {
		
		ProjectParticipateVO resultData = projectMapper.selectProjectParticipateData(projectParticipateVO);
		
		System.out.println("select => " + resultData);
		
		projectMapper.updateProjectMatching(resultData);
	}

	@Override
	public int projectCount() {
		// TODO Auto-generated method stub
		return projectMapper.projectCount();
	}
	
	@Transactional
	public void updateProjectData(ProjectVO projectVO) throws Exception {
		
		Map<String, Object> fileList = new HashMap<String, Object>();
		fileList.put("proj_number", projectVO.getProj_number());
		fileList.put("prof_files", projectVO.getModifyFiles());

		if(projectVO.getModifyFiles() != null) {
			projectMapper.deleteProjectFilesNotIn(fileList);
		}
		
		//파일 경로 세팅
		String urlPath	= UtilConfig.FILE_URL_PATH + projectVO.getStdFilePath();
		String realPath	= UtilConfig.FILE_ROOT_PATH + projectVO.getStdFilePath();
		
		
		if(!projectVO.getProjThumbNail().getOriginalFilename().equals(""))
		{
			//FileUpload 클래스는 com.bnc.fileupload 패키지에 있음 FileUpload.java
			//프로젝트 썸네일 파일 업로드 (write.jsp 참고 input name="projThumbNail"  
			String resultThumbFilePath = FileUpload.upload(urlPath, realPath, projectVO.getProjThumbNail());
			projectVO.setProj_thumb_file_path(resultThumbFilePath);
					
		}
		
	
		//첨부 파일 다중 업로드 input 태그의 multiple (write.jsp 참고 input name="fileField" )
		if(!projectVO.getFileField().get(0).getOriginalFilename().equals("")) {
		
			for(int i=0; i<projectVO.getFileField().size(); i++) {
				String resultFilePath = FileUpload.upload(urlPath, realPath, projectVO.getFileField().get(i));
				String resultFileRealName = projectVO.getFileField().get(i).getOriginalFilename();
				
				ProjectFileDTO fileDTO = new ProjectFileDTO();
				
				fileDTO.setProf_proj_number(projectVO.getProj_number());
				fileDTO.setProf_file_path(resultFilePath);
				fileDTO.setProf_file_name(resultFileRealName);
	
				System.out.println(fileDTO);
					
				projectMapper.insertProjectFiles(fileDTO);
				
			}
		}
		
		projectMapper.updateProjectData(projectVO);
				
	}
	
	@Transactional
	public void updateProjectWorkingProcess(ProjectVO projectVO) {
		projectMapper.updateProjectWorkingFlag(projectVO);
		
		String reqFlag = projectVO.getProj_req_flag();
		String acpFlag = projectVO.getProj_acp_flag();

		System.out.println("req flag = >"+reqFlag);
		System.out.println("acp flag = >"+acpFlag);
		
		if(reqFlag.equals(acpFlag))
		{
			if(reqFlag.equals("Y") && acpFlag.equals("Y"))
			{
				System.out.println("프로젝트 완료?????");
				projectVO.setProj_flag("E");
				projectMapper.updateProjectFlag(projectVO);
				
				System.out.println("프로젝트 완료");
			}
			else if(reqFlag.equals("C") && acpFlag.equals("C"))
			{
				//철회 프로세스 타야함
				projectVO.setProj_flag("W");
				projectVO.setProj_acp_phone(null);
				projectVO.setProj_acp_biznum(null);
				projectVO.setProj_acp_flag("N");
				projectVO.setProj_req_flag("N");
				
				System.out.println(projectVO);
				
				projectMapper.updateProjectData(projectVO);
				
				//프로젝트 참여 신청 기업 없애기
				projectMapper.deleteProjectParticipateData(projectVO);
				
				//계약서 로그 없애기
				contractMapper.deleteContractLog(projectVO);;
				
				//계약서 삭제
				contractMapper.deleteContract(projectVO);
				System.out.println("프로젝트 철회");
			}
		}
		else{
			System.out.println("프로젝트 값 다르므로 처리 없음");
		}
		
	}
	
	@Transactional
	public void deleteProject(ProjectVO projectVO) {
		
		contractMapper.deleteContractLog(projectVO);
		contractMapper.deleteContract(projectVO);
		projectMapper.deleteProjectFile(projectVO);
		projectMapper.deleteProjectParticipateData(projectVO);
		projectMapper.deleleProject(projectVO);
	}
}
