package com.bnc.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.Criteria;
import com.bnc.domain.PaginationVO;
import com.bnc.domain.ProjectParticipateListVO;
import com.bnc.domain.ProjectVO;
import com.bnc.service.CompanyService;
import com.bnc.service.ProjectService;
import com.bnc.util.Util;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/project")
@AllArgsConstructor
@Log4j
public class ProjectController {
	@Inject
	ProjectService projectService;
	
	@Inject
	CompanyService companyService;
	
	@RequestMapping(value="/list", method=RequestMethod.GET)
	public String list (Model model, HttpServletRequest request) {
		
		int page 				= request.getParameter("page") != null && request.getParameter("page") != "" ? Integer.parseInt(request.getParameter("page")) : 1;
		String searchType 		= request.getParameter("srch") != null && request.getParameter("srch") != "" ? request.getParameter("srch") : "";
		String searchKeyword 	= request.getParameter("keyword") != null && request.getParameter("keyword") != "" ? request.getParameter("keyword") : "";

		PaginationVO paginationVO = new PaginationVO();
		paginationVO.setSearchKeyword(searchKeyword);
		paginationVO.setSearchType(searchType);
		
		int allRowCount = projectService.selectProjectListCount(paginationVO);
		Criteria cri = new Criteria(allRowCount, page, 10, request.getRequestURI(), request.getQueryString());
		
		paginationVO.setStartRowNumber(cri.getStartRowNumber());
		paginationVO.setEndRowNumber(cri.getEndRowNumber());
		
		List<ProjectVO> list = projectService.selectProjectList(paginationVO);
		
		log.info(list);
		
		model.addAttribute("srch", searchType);
		model.addAttribute("keyword", searchKeyword);
		model.addAttribute("pageMaker", cri.getPageData());
		model.addAttribute("resultQueryString", request.getQueryString());
		model.addAttribute("list", list);
		
		return "/project/list";
	}
	
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view(@RequestParam("proj_number") int proj_number, Model model, HttpServletRequest request) {

		ProjectVO project = projectService.projectRead(proj_number);
		
		if(project.getProj_flag().equals("W")) { // 모집중일때 참여기업 리스트
			List<ProjectParticipateListVO> participateList = projectService.participateList(proj_number);
			model.addAttribute("participateList", participateList);
		} 
		else { // 나머지 flag일때 매칭된 두기업 정보 
			CompanyVO companyA = companyService.selectBiznumRead(project.getProj_req_biznum());	// 프로젝트 올린 회사 정보
			CompanyVO companyB = companyService.selectBiznumRead(project.getProj_acp_biznum()); // 수주한 회사 정보
			model.addAttribute("companyA", companyA);
			model.addAttribute("companyB", companyB);
			System.out.println("contract : " + projectService.contractRead(project.getProj_number()));
			model.addAttribute("contract", projectService.contractRead(project.getProj_number()));
		}
		model.addAttribute("project", project);
		String[] removeParamKey = {"proj_number"};
		//지운 쿼리스트링 던지기
		model.addAttribute("resultQueryString", Util.removeTargetParameterQueryString(request.getQueryString(), removeParamKey));
		return "project/view";
	}
	
	@RequestMapping(value="/delete", method=RequestMethod.GET)
	public String delete(@RequestParam("proj_number") int proj_number, Model model, HttpServletRequest request) {
		
		projectService.delete(proj_number);
		return "redirect:/project/list";
	}
}
