package com.bnc.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bnc.config.ErrorConfig;
import com.bnc.domain.CompanyVO;
import com.bnc.domain.Criteria;
import com.bnc.domain.MemberVO;
import com.bnc.domain.PaginationVO;
import com.bnc.domain.ProjectFileDTO;
import com.bnc.domain.ProjectParticipateVO;
import com.bnc.domain.ProjectVO;
import com.bnc.domain.SignVO;
import com.bnc.service.AuthService;
import com.bnc.service.CompanyService;
import com.bnc.service.ContractService;
import com.bnc.service.ProjectService;
import com.bnc.util.Util;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/project")
public class ProjectController {

	@Inject
	private ProjectService projectService;
	
	@Inject
	private CompanyService companyService;
	
	@Inject
	private ContractService contractService;
	
	@Inject
	private AuthService authService;
	
	@RequestMapping("/recruit/list")
	public void recruitList(HttpServletRequest request, Model model) {
		
		int page 				= request.getParameter("page") != null && request.getParameter("page") != "" ? Integer.parseInt(request.getParameter("page")) : 1;
		String searchType 		= request.getParameter("srch") != null && request.getParameter("srch") != "" ? request.getParameter("srch") : "";
		String searchKeyword 	= request.getParameter("keyword") != null && request.getParameter("keyword") != "" ? request.getParameter("keyword") : "";
		
		log.info("==============/project/list=================");
		
		PaginationVO paginationVO = new PaginationVO();
		paginationVO.setSearchKeyword(searchKeyword);
		paginationVO.setSearchType(searchType);
		
		int allRowCount = projectService.selectProjectListCount(paginationVO);
		Criteria cri = new Criteria(allRowCount, page, 12, request.getRequestURI(), request.getQueryString());
		
		paginationVO.setStartRowNumber(cri.getStartRowNumber());
		paginationVO.setEndRowNumber(cri.getEndRowNumber());
		
		List<ProjectVO> list = projectService.selectProjectList(paginationVO);

		log.info(list);
		
		model.addAttribute("srch", searchType);
		model.addAttribute("keyword", searchKeyword);
		model.addAttribute("resultQueryString", request.getQueryString());
		model.addAttribute("pageMaker", cri.getPageData());
		model.addAttribute("list",list);
	}
	
	@RequestMapping("/recruit/view")
	public void recruitView(HttpServletRequest request, Model model) {
				
		//프로세스 처리 결과 데이터를 보내주기위한 해시맵 선언
		Map<String, String> resultCode = new HashMap<String, String>();
		
		//프로젝트 고유번호 값 받아오기
		int projectNumber = Integer.parseInt(request.getParameter("seq"));
		
		System.out.println("==============/project/view=================");
		
		//세션
		HttpSession session = request.getSession();
		String memberID	= (String)session.getAttribute("memb_id") != null ? (String)session.getAttribute("memb_id") : "";

		
		//로그인 했을 경우
		if(!memberID.equals("")) {
		
			MemberVO memberVO 	= authService.selectMemberData(memberID);
			List<SignVO> signVO	= authService.signList(memberID);
			CompanyVO myCompany	= companyService.selectMyCompanyData(memberVO);
			
			if(myCompany != null && memberVO.getMemb_auth_flag().equals("Y"))
			{
				//프로젝트 정보 가져오기
				ProjectVO projectVO = projectService.selectProjectView(projectNumber);
				//프로젝트 파일정보 가져오기
				List<ProjectFileDTO> fileDTO = projectService.selectProjectFiles(projectNumber);
				
				//프로젝트 상태가 모집중 일 경우 ( W )
				if(projectVO.getProj_flag().equals("W"))
				{
					List<ProjectParticipateVO> projectParticipateVO = projectService.selectProjectParticipateList(projectNumber);
					
					System.out.println(projectVO);
					System.out.println(projectParticipateVO);
					
					//모집중일경우 매칭 신청한 기업 데이터 
					model.addAttribute("participateList", projectParticipateVO);
				}
				//프로젝트 상태가 협의중/모집중 일 경우 ( C OR P )
				else if(projectVO.getProj_flag().equals("C") || projectVO.getProj_flag().equals("P"))
				{
					String authCheck 	= null;
					String myBiznum 	= myCompany.getCmpy_biznum();
					
					if(myBiznum.equals(projectVO.getProj_req_biznum())) {
						authCheck = "req";
					}
					else if(myBiznum.equals(projectVO.getProj_acp_biznum()))
					{
						authCheck = "acp";
					}
					
					if(authCheck != null)
					{
						System.out.println(authCheck);
						System.out.println("myCompanyData =>" + myCompany);
						
						Map<String, Object> companyList = new HashMap<String, Object>();
						List<String> companyBizNum		= new ArrayList<String>();
						
						//자사측 사업자등록번호
						companyBizNum.add(projectVO.getProj_req_biznum());
						//수주측 사업자등록번호
						companyBizNum.add(projectVO.getProj_acp_biznum());
						
						//쿼리 조회에 필요한 데이터 ArrayList에 put
						companyList.put("company_list", companyBizNum);
						
						System.out.println(companyBizNum);
						System.out.println(projectVO);
						
						
						List<CompanyVO> companyInfo = companyService.selectCompanyData(companyList);
						
						for(int i=0; i<companyInfo.size(); i++)
						{
							if(companyInfo.get(i).getCmpy_biznum().equals(projectVO.getProj_req_biznum()))
							{
								model.addAttribute("reqCompanyData", companyInfo.get(i));
								model.addAttribute("reqCompanyPhone", projectVO.getProj_req_phone());
							}
							else
							{
								model.addAttribute("acpCompanyData", companyInfo.get(i));
								model.addAttribute("acpCompanyPhone", projectVO.getProj_acp_phone());
							}
						}
						

						//권한 (의뢰측인지 수주측인지 뷰에서 확인하기위함
						model.addAttribute("authority", authCheck);
						//계약서 양식 가져오기
						model.addAttribute("documentFormData", projectService.selectDocumentFormData());
						
						//각 회사별 계약서 정보 가져오기
						model.addAttribute("contractData", contractService.selectContractData(projectVO));
						System.out.println("signVO=>"+signVO);
						//사인 파일 가져오기
						model.addAttribute("signFiles", signVO);
						System.out.println(companyInfo);
						
						//로그인 체크 코드 0000이면 정상
						resultCode.put("code", ErrorConfig.ERROR_CODE_0000);
						resultCode.put("msg", ErrorConfig.ERROR_MSG_0000);
						model.addAttribute("loginResult", resultCode);
					}
					else
					{
						//로그인 체크 코드 2002이면 프로젝트가 플래그값이 C일경우 의뢰/수주 측이 아니면 게시물 열람 불가
						resultCode.put("code", ErrorConfig.ERROR_CODE_2002);
						resultCode.put("msg", ErrorConfig.ERROR_MSG_2002);
						model.addAttribute("loginResult", resultCode);
					}
				}
				//프로젝트 상태가 협의중/모집중 일 경우 ( C OR P )
				else if(projectVO.getProj_flag().equals("E"))
				{
					String authCheck 	= null;
					String myBiznum 	= myCompany.getCmpy_biznum();
					
					if(myBiznum.equals(projectVO.getProj_req_biznum())) {
						authCheck = "req";
					}
					else if(myBiznum.equals(projectVO.getProj_acp_biznum()))
					{
						authCheck = "acp";
					}
					
					System.out.println(authCheck);
					System.out.println("myCompanyData =>" + myCompany);
					
					Map<String, Object> companyList = new HashMap<String, Object>();
					List<String> companyBizNum		= new ArrayList<String>();
					
					//자사측 사업자등록번호
					companyBizNum.add(projectVO.getProj_req_biznum());
					//수주측 사업자등록번호
					companyBizNum.add(projectVO.getProj_acp_biznum());
					
					//쿼리 조회에 필요한 데이터 ArrayList에 put
					companyList.put("company_list", companyBizNum);
					
					System.out.println(companyBizNum);
					System.out.println(projectVO);
					
					
					List<CompanyVO> companyInfo = companyService.selectCompanyData(companyList);
					
					for(int i=0; i<companyInfo.size(); i++)
					{
						if(companyInfo.get(i).getCmpy_biznum().equals(projectVO.getProj_req_biznum()))
						{
							model.addAttribute("reqCompanyData", companyInfo.get(i));
							model.addAttribute("reqCompanyPhone", projectVO.getProj_req_phone());
						}
						else
						{
							model.addAttribute("acpCompanyData", companyInfo.get(i));
							model.addAttribute("acpCompanyPhone", projectVO.getProj_acp_phone());
						}
					}
					

					//권한 (의뢰측인지 수주측인지 뷰에서 확인하기위함
					model.addAttribute("authority", authCheck);
					//계약서 양식 가져오기
					model.addAttribute("documentFormData", projectService.selectDocumentFormData());
					
					model.addAttribute("contractData", contractService.selectContractData(projectVO));
					System.out.println(companyInfo);
					
					//로그인 체크 코드 0000이면 정상
					resultCode.put("code", ErrorConfig.ERROR_CODE_0000);
					resultCode.put("msg", ErrorConfig.ERROR_MSG_0000);
					model.addAttribute("loginResult", resultCode);
				}			
				
				//쿼리스트링에서 지울 파라미터
				String[] removeParamKey 	= {"seq"};
				//지운 쿼리스트링 던지기
				model.addAttribute("resultQueryString", Util.removeTargetParameterQueryString(request.getQueryString(), removeParamKey));
				//자신의 계정으로 등록한 프로젝트 일경우 아이디값으로 체크하기위해 던져줌
				model.addAttribute("sessionMemberID", memberID);
				//프로젝트 정보
				model.addAttribute("view", projectVO);
				model.addAttribute("viewfiles", fileDTO);
			}
			else if(!memberID.equals("") && myCompany == null)
			{
				//로그인은 했으나  및 기업정보 미등록 에러코드 2003
				resultCode.put("code", ErrorConfig.ERROR_CODE_2003);
				resultCode.put("msg", ErrorConfig.ERROR_MSG_2003);
				model.addAttribute("loginResult", resultCode);
			}
			else if(!memberID.equals("") && myCompany != null && !memberVO.getMemb_auth_flag().equals("Y"))
			{
				//로그인은 했으나  및 기업 미인증 에러코드 2004
				resultCode.put("code", ErrorConfig.ERROR_CODE_2004);
				resultCode.put("msg", ErrorConfig.ERROR_MSG_2004);
				model.addAttribute("loginResult", resultCode);
			}

		}
		else
		{
			//미 로그인 에러코드 2000
			resultCode.put("code", ErrorConfig.ERROR_CODE_2000);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_2000);
			model.addAttribute("loginResult", resultCode);
		}
	}
	
	@RequestMapping("/recruit/write")
	public void recruitWrite(HttpServletRequest request, Model model) {
	
		Map<String, String> resultCode = new HashMap<String, String>();
		
		System.out.println("==============/project/write=================");
		
		HttpSession session = request.getSession();
		String memberID	= (String)session.getAttribute("memb_id");

		if(memberID == null) {
			resultCode.put("code", ErrorConfig.ERROR_CODE_2000);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_2000);
			model.addAttribute("loginResult", resultCode);
		}
		else
		{
			MemberVO memberVO = authService.selectMemberData(memberID);
			
			if(memberVO.getMemb_auth_flag().equals("Y")) {
			
				CompanyVO myCompany	= companyService.selectMyCompanyData(memberVO);
				
				if(myCompany == null) {
					resultCode.put("code", ErrorConfig.ERROR_CODE_2003);
					resultCode.put("msg", ErrorConfig.ERROR_MSG_2003);
					model.addAttribute("loginResult", resultCode);
				}
			}
			else
			{
				resultCode.put("code", ErrorConfig.ERROR_CODE_2004);
				resultCode.put("msg", ErrorConfig.ERROR_MSG_2004);
				model.addAttribute("loginResult", resultCode);
			}
		}
		
	}
	
	@RequestMapping("/recruit/write/process")
	public String recruitWriteProcess(ProjectVO projectVO, HttpServletRequest request, Model model) throws Exception {
		
		HttpSession session = request.getSession();
		String memberID = session.getAttribute("memb_id").toString();
		
		MemberVO memberVO = new MemberVO();
		memberVO.setMemb_id(memberID);
		
		projectService.insertProjectData(projectVO, memberVO);
		
		return "redirect:/project/recruit/view?seq="+projectVO.getProj_number();
	}
	
	
	@RequestMapping("/recruit/modify")
	public void recruitModify(HttpServletRequest request, Model model) {
		
		Map<String, String> resultCode = new HashMap<String, String>();
		
		System.out.println("==============/project/modify=================");
		
		//프로젝트 고유번호 값 받아오기
		int projectNumber = request.getParameter("seq") != null ? Integer.parseInt(request.getParameter("seq")) : -1;
		
		HttpSession session = request.getSession();
		String memberID	= (String)session.getAttribute("memb_id") != null ? (String)session.getAttribute("memb_id") : "";
		
		MemberVO memberVO = new MemberVO();
		memberVO.setMemb_id(memberID);
		CompanyVO myCompany	= companyService.selectMyCompanyData(memberVO);
		
		//로그인 및 기업정보 완료 했을 경우
		if(!memberID.equals("") && myCompany != null && projectNumber != -1) {
			
			//프로젝트 정보 가져오기
			ProjectVO projectVO 			= projectService.selectProjectView(projectNumber);
			List<ProjectFileDTO> fileDTO 	= projectService.selectProjectFiles(projectNumber);
			
			if(projectVO.getProj_req_biznum().equals(myCompany.getCmpy_biznum())) {
				model.addAttribute("view", projectVO);	
				model.addAttribute("viewfiles", fileDTO);
			}
			else {
				resultCode.put("code", ErrorConfig.ERROR_CODE_9999);
				resultCode.put("msg", ErrorConfig.ERROR_MSG_9999);
				model.addAttribute("result", resultCode);
			}
		}
		else if(projectNumber == -1)
		{
			resultCode.put("code", ErrorConfig.ERROR_CODE_9999);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_9999);
			model.addAttribute("result", resultCode);
		}
		else
		{
			resultCode.put("code", ErrorConfig.ERROR_CODE_2000);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_2000);
			model.addAttribute("loginResult", resultCode);
		}
	}
	
	@RequestMapping("/recruit/modify/process")
	public String recruitModifyProcess(ProjectVO projectVO, HttpServletRequest request, Model model) throws Exception {
		
		HttpSession session = request.getSession();
		String memberID = session.getAttribute("memb_id").toString();
		
		MemberVO memberVO = new MemberVO();
		memberVO.setMemb_id(memberID);
		
		System.out.println(projectVO);
		
		projectService.updateProjectData(projectVO);
		
		return "redirect:/project/recruit/view?seq="+projectVO.getProj_number();
	}
	
	
	@RequestMapping("/recruit/delete")
	public String recruitDelete(ProjectVO projectVO, HttpServletRequest request, Model model, RedirectAttributes rttr) {
	
		Map<String, String> resultCode = new HashMap<String, String>();
		
		System.out.println("==============/project/delete=================");
		
		HttpSession session = request.getSession();
		String memberID	= (String)session.getAttribute("memb_id");
		
		System.out.println(memberID);
		
		if(memberID == null) {
			resultCode.put("code", ErrorConfig.ERROR_CODE_2000);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_2000);
			rttr.addFlashAttribute("result", resultCode);
		}
		else
		{
			System.out.println(projectVO);
			projectService.deleteProject(projectVO);
			
			resultCode.put("code", ErrorConfig.ERROR_CODE_4000);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_4000);
			rttr.addFlashAttribute("result", resultCode);
		}
		
		return "redirect:/project/recruit/list";
	}
	
	@RequestMapping("/recruit/workingProcess")
	public String recruitWorkingProcess(ProjectVO projectVO, HttpServletRequest request, Model model, RedirectAttributes rttr) {
	
		Map<String, String> resultCode = new HashMap<String, String>();
		
		System.out.println("==============/project/workingProcess=================");
		
		int projectNumber = projectVO.getProj_number();
		//프로젝트 정보 가져오기
		ProjectVO projectData = projectService.selectProjectView(projectNumber);
		
		HttpSession session = request.getSession();
		String memberID	= (String)session.getAttribute("memb_id") != null ? (String)session.getAttribute("memb_id") : "";
		
		MemberVO memberVO = new MemberVO();
		memberVO.setMemb_id(memberID);
		
		if(memberID == null) {
			resultCode.put("code", ErrorConfig.ERROR_CODE_2000);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_2000);
			rttr.addFlashAttribute("result", resultCode);
		}
		else
		{
			CompanyVO myCompany	= companyService.selectMyCompanyData(memberVO);

			String authCheck 	= null;
			String myBiznum 	= myCompany.getCmpy_biznum();

			if(myBiznum.equals(projectData.getProj_req_biznum())) {
				projectData.setAuthCheck("req");
				projectData.setProj_req_flag(projectVO.getProj_req_flag());
				projectService.updateProjectWorkingProcess(projectData);
			}
			else if(myBiznum.equals(projectData.getProj_acp_biznum()))
			{
				projectData.setAuthCheck("acp");
				projectData.setProj_acp_flag(projectVO.getProj_acp_flag());
				projectService.updateProjectWorkingProcess(projectData);
			}

		}
		
		return "redirect:/project/recruit/view?seq="+projectNumber;

	}
	
	@RequestMapping("/recruit/participate/process")
	public String recruitParticipateProcess(ProjectParticipateVO projectParticipateVO, HttpServletRequest request,  RedirectAttributes rttr) throws Exception {
		
		Map<String, String> resultCode = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		String memberID = session.getAttribute("memb_id").toString();
		
		MemberVO memberVO = new MemberVO();
		memberVO.setMemb_id(memberID);
		
		System.out.println("여기=>>>>>>>>>>>>>>" + projectParticipateVO);
		
		int checkCount = projectService.selectProjectParticipateCheckCount(projectParticipateVO, memberVO);
		System.out.println(checkCount);
		
		if(checkCount > 0)
		{
			resultCode.put("code", ErrorConfig.ERROR_CODE_3001);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_3001);
			rttr.addFlashAttribute("result", resultCode);
		}
		else
		{
			projectService.insertProjectParticipateData(projectParticipateVO, memberVO);
			resultCode.put("code", ErrorConfig.ERROR_CODE_3000);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_3000);
			rttr.addFlashAttribute("result", resultCode);
		}
		
		return "redirect:/project/recruit/view?seq="+projectParticipateVO.getPrpl_number();
	}
	
	@RequestMapping("/recruit/matching/process")
	public String recruitMatchingProcess(ProjectParticipateVO projectParticipateVO, HttpServletRequest request, RedirectAttributes rttr) {
		
		//결과 코드 및 메세지 해시맵 선언
		Map<String, String> resultCode = new HashMap<String, String>();
		
		System.out.println("==============/recruit/matching/process=================");
		System.out.println("in => " + projectParticipateVO);
		
		//로그인 세션
		HttpSession session = request.getSession();
		String memberID = session.getAttribute("memb_id").toString();
		
		MemberVO memberVO = new MemberVO();
		memberVO.setMemb_id(memberID);

		//현재 서브밋 받은 prpl_number, prpl_acp_biznum 값으로 프로젝트 정보 가져오기 
		ProjectVO myProject = projectService.selectProjectView(projectParticipateVO.getPrpl_number());
		//내 기업 정보 가져오기 
		CompanyVO myCompany	= companyService.selectMyCompanyData(memberVO);
		
		String projectBiznum 	= myProject.getProj_req_biznum();
		String myCompanyBiznum	= myCompany.getCmpy_biznum();

		//내가 등록한 프로젝트인지 체크 하기 위함
		if(projectBiznum.equals(myCompanyBiznum))
		{
			projectService.updateMatchingProcess(projectParticipateVO);
			resultCode.put("code", ErrorConfig.ERROR_CODE_3100);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_3100);
			rttr.addFlashAttribute("result", resultCode);
		}
		else
		{
			resultCode.put("code", ErrorConfig.ERROR_CODE_9999);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_9999);
			rttr.addFlashAttribute("result", resultCode);
		}
		
		return "redirect:/project/recruit/view?seq="+projectParticipateVO.getPrpl_number();
	}
	
	@RequestMapping("/my/list")
	public void myProjectList(HttpServletRequest request, Model model) {
		
		//프로세스 처리 결과 데이터를 보내주기위한 해시맵 선언
		Map<String, String> resultCode = new HashMap<String, String>();

		//세션
		HttpSession session = request.getSession();
		String memberID	= (String)session.getAttribute("memb_id") != null ? (String)session.getAttribute("memb_id") : "";
				
		if(memberID == null || memberID.equals("")) {
			resultCode.put("code", ErrorConfig.ERROR_CODE_2000);
			resultCode.put("msg", ErrorConfig.ERROR_MSG_2000);
			model.addAttribute("loginResult", resultCode);
		}
		else
		{
			MemberVO memberVO = authService.selectMemberData(memberID);
			
			if(memberVO.getMemb_auth_flag().equals("Y")) {
				
				CompanyVO myCompany	= companyService.selectMyCompanyData(memberVO);
				
				if(myCompany == null) {
					resultCode.put("code", ErrorConfig.ERROR_CODE_2003);
					resultCode.put("msg", ErrorConfig.ERROR_MSG_2003);
					model.addAttribute("loginResult", resultCode);
				}
				else
				{
					int page 				= request.getParameter("page") != null && request.getParameter("page") != "" ? Integer.parseInt(request.getParameter("page")) : 1;
					String searchType 		= request.getParameter("srch") != null && request.getParameter("srch") != "" ? request.getParameter("srch") : "";
					String searchKeyword 	= request.getParameter("keyword") != null && request.getParameter("keyword") != "" ? request.getParameter("keyword") : "";
					
					System.out.println("==============/project/my/list=================");
					
					PaginationVO paginationVO = new PaginationVO();
					paginationVO.setSearchKeyword(searchKeyword);
					paginationVO.setSearchType(searchType);
					
					int allRowCount = projectService.selectMyProjectListCount(paginationVO, memberVO);
					Criteria cri = new Criteria(allRowCount, page, 5, request.getRequestURI(), request.getQueryString());
					
					paginationVO.setStartRowNumber(cri.getStartRowNumber());
					paginationVO.setEndRowNumber(cri.getEndRowNumber());
					
					List<ProjectVO> list = projectService.selectMyProjectList(paginationVO, memberVO);

					System.out.println(list);
					
					model.addAttribute("srch", searchType);
					model.addAttribute("keyword", searchKeyword);
					model.addAttribute("resultQueryString", request.getQueryString());
					model.addAttribute("pageMaker", cri.getPageData());
					model.addAttribute("list",list);
				}
			}
			else
			{
				resultCode.put("code", ErrorConfig.ERROR_CODE_2004);
				resultCode.put("msg", ErrorConfig.ERROR_MSG_2004);
				model.addAttribute("loginResult", resultCode);
			}
		}
	}
}
