package com.bnc.controller;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bnc.domain.ContractDTO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.ProjectVO;
import com.bnc.service.CompanyService;
import com.bnc.service.ContractService;
import com.bnc.service.ProjectService;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/contract")
public class ContractController {

	@Inject
	private ProjectService projectService;
	
	@Inject
	private CompanyService companyService;
	
	@Inject
	private ContractService contractService;
	
	@RequestMapping("/process")
	public String contractProcess(ProjectVO projectVO, ContractDTO contractDTO, HttpServletRequest request, Model model) throws Exception {
		
		HttpSession session = request.getSession();
		String memberID = session.getAttribute("memb_id").toString();
		
		MemberVO memberVO = new MemberVO();
		memberVO.setMemb_id(memberID);
		
		System.out.println(projectVO);
		System.out.println(contractDTO);
		
		ProjectVO projectData = projectService.selectProjectView(projectVO.getProj_number());
		
		int contractCheck = contractService.selectContractCount(projectData);
		
		//계약서가 미생성이고 의뢰기업에서 계약서 생성할 경우(등록)
		if(contractDTO.getAuthority().equals("req") && contractCheck == 0)
		{
			contractService.insertReqContractData(projectData, contractDTO, memberVO);	
		}
		//계약서가 이미 존재하는경우 의뢰기업은  (수정)
		else if(contractDTO.getAuthority().equals("req") && contractCheck > 0)
		{
			System.out.println("여기");	
			contractService.updateReqContractData(projectVO, contractDTO, memberVO);
		}
		//계약서가 이미 존재하고 수주측일경우 
		else if(contractDTO.getAuthority().equals("acp") && contractCheck > 0)
		{
			System.out.println("여기지롱");
			contractService.updateAcpContractData(projectVO, contractDTO, memberVO);
		}
		else
		{
			System.out.println("에러임 에러임");
		}

		return "redirect:/project/recruit/view?seq="+projectData.getProj_number();
	}
	
	
	@RequestMapping("/view")
	@ResponseBody
	public Map<String, Object> contractView(@RequestParam("proj_number") int proj_number, HttpServletRequest request) throws Exception {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		ProjectVO projectVO = new ProjectVO();
		projectVO.setProj_number(proj_number);
		
		
		ContractDTO contractData = contractService.selectContractData(projectVO);
		
		System.out.println(contractData);
		
		if(contractData != null) {
			result.put("count", 1);
			result.put("data", contractData);
		}
		else
		{
			result.put("count", 0);
			result.put("data", null);
		}
		
		return result;
	}
	
	@RequestMapping("/callForm")
	@ResponseBody
	public Map<String, Object> contractCallForm(HttpServletRequest request) throws Exception {
		
		
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, String> data = new HashMap<String, String>();
		
		HttpSession session = request.getSession();
		String memberID = session.getAttribute("memb_id").toString();
		
		MemberVO memberVO = new MemberVO();
		memberVO.setMemb_id(memberID);
		
		data = contractService.selectContractCompanyData(memberVO);
				
		if(data != null) {
			result.put("data", data);
		}
		else
		{
			result.put("data", null);
		}
		
		return result;
	}
}
