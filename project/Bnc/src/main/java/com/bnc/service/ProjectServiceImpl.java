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

/*
 * 프로젝트 등록/수정/상태전이와 첨부파일 처리를 담당하는 서비스.
 *
 * [트랜잭션 범위]
 * 여러 테이블을 함께 건드리는 메서드에는 @Transactional 이 붙어 있어 DB 작업은 함께 롤백된다.
 * 다만 FileUpload.upload() 로 디스크에 쓴 파일은 트랜잭션 대상이 아니라서,
 * 뒤에서 예외가 나면 DB 레코드는 사라지지만 업로드된 파일은 디스크에 그대로 남는다.
 * (고아 파일이 쌓이는 구조 — 정리 로직은 아직 없다)
 *
 * [프로젝트 상태값 proj_flag]  W:모집중 / C:협의중 / P:진행중 / E:종료
 */
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
	
	/*
	 * 프로젝트 등록.
	 *
	 * [처리 순서가 중요한 이유]
	 *   1. 로그인한 회원의 기업정보를 조회해 발주사(req) 사업자번호를 채운다
	 *   2. 썸네일을 업로드하고 경로를 VO 에 담는다
	 *   3. 프로젝트를 INSERT — 이 시점에 proj_number(PK)가 채워진다
	 *   4. 첨부파일들을 INSERT — 3에서 받은 proj_number 를 FK 로 써야 하므로 반드시 뒤에 와야 한다
	 *
	 * 첨부파일은 <input multiple> 로 올라와 리스트로 들어온다. 파일을 하나도 고르지 않아도
	 * 빈 항목 하나가 들어오기 때문에, 0번 항목의 파일명이 빈 문자열인지로 첨부 여부를 판단한다.
	 */
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
	
	/*
	 * 프로젝트 수정.
	 *
	 * 첨부파일은 "화면에 남아 있는 것만 유지" 방식이다. 수정 화면에서 사용자가 지운 파일은
	 * modifyFiles 목록에서 빠지므로, 그 목록에 없는 기존 파일을 먼저 DELETE 한 뒤
	 * 새로 올라온 파일을 INSERT 한다. (deleteProjectFilesNotIn = 목록에 없는 것 삭제)
	 *
	 * 썸네일은 새로 올린 경우에만 교체하고, 비워두면 기존 것을 그대로 둔다.
	 * 등록(insertProjectData)과 달리 UPDATE 가 마지막에 실행된다 — proj_number 가 이미 있어서
	 * 순서에 제약이 없기 때문이다.
	 */
	@Transactional
	public void updateProjectData(ProjectVO projectVO) throws Exception {

		Map<String, Object> fileList = new HashMap<String, Object>();
		fileList.put("proj_number", projectVO.getProj_number());
		fileList.put("prof_files", projectVO.getModifyFiles());

		//유지할 파일 목록이 넘어온 경우에만 정리한다 (null 이면 기존 파일을 건드리지 않음)
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
	
	/*
	 * 프로젝트 진행 상태 전이 — 발주사와 수주사의 의사가 일치할 때만 상태를 바꾼다.
	 *
	 * [양측 플래그 proj_req_flag / proj_acp_flag]
	 *   'N' : 아직 의사 표시 없음(기본값)
	 *   'Y' : 완료 처리에 동의
	 *   'C' : 철회에 동의
	 *
	 * [판단 규칙]
	 *   Y + Y  → 프로젝트 종료.  proj_flag 를 'E' 로 변경
	 *   C + C  → 프로젝트 철회.  'W'(모집중)로 되돌리고 매칭 관련 데이터를 전부 지운다
	 *              (수주사 정보 초기화 → 참여 신청 기업 삭제 → 계약서 로그 삭제 → 계약서 삭제)
	 *   그 외   → 한쪽만 눌렀거나 서로 다른 선택을 한 상태이므로 아무것도 하지 않고 상대를 기다린다
	 *
	 * 한쪽이 누른 플래그 자체는 맨 위 updateProjectWorkingFlag 에서 이미 저장되므로,
	 * 상대가 나중에 같은 값을 누르면 그때 이 조건에 걸려 전이가 일어난다.
	 */
	@Transactional
	public void updateProjectWorkingProcess(ProjectVO projectVO) {
		//먼저 이번에 누른 쪽의 플래그를 저장한다
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
	
	/*
	 * 프로젝트 삭제. 외래키로 물린 자식 데이터부터 지우고 마지막에 프로젝트 본체를 지운다.
	 * 순서를 바꾸면 참조 무결성 제약에 걸린다.
	 * (업로드된 실제 파일은 디스크에 남는다 — 클래스 상단 주석 참고)
	 */
	@Transactional
	public void deleteProject(ProjectVO projectVO) {

		contractMapper.deleteContractLog(projectVO);
		contractMapper.deleteContract(projectVO);
		projectMapper.deleteProjectFile(projectVO);
		projectMapper.deleteProjectParticipateData(projectVO);
		projectMapper.deleleProject(projectVO);
	}
}
