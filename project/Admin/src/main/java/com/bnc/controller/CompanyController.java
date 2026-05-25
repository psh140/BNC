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
import com.bnc.service.CompanyService;
import com.bnc.util.Util;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/company")
@AllArgsConstructor
@Log4j
public class CompanyController {
	@Inject
	CompanyService service;
	
	@RequestMapping(value="/list", method=RequestMethod.GET)
	public String list (Model model, HttpServletRequest request) {
		
		int page 				= request.getParameter("page") != null && request.getParameter("page") != "" ? Integer.parseInt(request.getParameter("page")) : 1;
		String searchType 		= request.getParameter("srch") != null && request.getParameter("srch") != "" ? request.getParameter("srch") : "";
		String searchKeyword 	= request.getParameter("keyword") != null && request.getParameter("keyword") != "" ? request.getParameter("keyword") : "";

		PaginationVO paginationVO = new PaginationVO();
		paginationVO.setSearchKeyword(searchKeyword);
		paginationVO.setSearchType(searchType);
		
		int allRowCount = service.selectCompanyListCount(paginationVO);
		Criteria cri = new Criteria(allRowCount, page, 10, request.getRequestURI(), request.getQueryString());
		
		paginationVO.setStartRowNumber(cri.getStartRowNumber());
		paginationVO.setEndRowNumber(cri.getEndRowNumber());
		
		List<CompanyVO> list = service.selectCompanyList(paginationVO);
		
		log.info(list);
		
		model.addAttribute("srch", searchType);
		model.addAttribute("keyword", searchKeyword);
		model.addAttribute("pageMaker", cri.getPageData());
		model.addAttribute("resultQueryString", request.getQueryString());
		model.addAttribute("list", list);
		
		return "/company/list";
	}
	
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view(@RequestParam("cmpy_biznum") String cmpy_biznum, Model model, HttpServletRequest request) {

		log.info("view 불러올 정보 : "+service.selectBiznumRead(cmpy_biznum));
		model.addAttribute("company", service.selectBiznumRead(cmpy_biznum));
		String[] removeParamKey = {"cmpy_biznum"};
		//지운 쿼리스트링 던지기
		model.addAttribute("resultQueryString", Util.removeTargetParameterQueryString(request.getQueryString(), removeParamKey));
		return "company/view";
	}
	
	@RequestMapping(value="/delete", method=RequestMethod.GET)
	public String delete(@RequestParam("cmpy_biznum") String cmpy_biznum, Model model, HttpServletRequest request) {
		
		service.delete(cmpy_biznum);
		return "redirect:/company/list";
	}
}
