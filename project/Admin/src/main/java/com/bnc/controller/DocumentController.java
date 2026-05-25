package com.bnc.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bnc.domain.Criteria;
import com.bnc.domain.DocumentVO;
import com.bnc.domain.PaginationVO;
import com.bnc.service.DocumentService;
import com.bnc.util.Util;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/document")
@AllArgsConstructor
@Log4j
public class DocumentController {
	DocumentService service;
	
	@RequestMapping(value="/list", method=RequestMethod.GET)
	public String list (Model model, HttpServletRequest request) {
		
		int page 				= request.getParameter("page") != null && request.getParameter("page") != "" ? Integer.parseInt(request.getParameter("page")) : 1;
		String searchType 		= request.getParameter("srch") != null && request.getParameter("srch") != "" ? request.getParameter("srch") : "";
		String searchKeyword 	= request.getParameter("keyword") != null && request.getParameter("keyword") != "" ? request.getParameter("keyword") : "";

		PaginationVO paginationVO = new PaginationVO();
		paginationVO.setSearchKeyword(searchKeyword);
		paginationVO.setSearchType(searchType);
		
		int allRowCount = service.selectDocumentListCount(paginationVO);
		Criteria cri = new Criteria(allRowCount, page, 10, request.getRequestURI(), request.getQueryString());
		
		paginationVO.setStartRowNumber(cri.getStartRowNumber());
		paginationVO.setEndRowNumber(cri.getEndRowNumber());
		
		List<DocumentVO> list = service.selectDocumentList(paginationVO);
		
		log.info(list);
		
		model.addAttribute("srch", searchType);
		model.addAttribute("keyword", searchKeyword);
		model.addAttribute("pageMaker", cri.getPageData());
		model.addAttribute("resultQueryString", request.getQueryString());
		model.addAttribute("list", list);
		
		return "/document/list";
	}
	
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view(@RequestParam("doct_code") int doct_code, Model model, HttpServletRequest request) {

		model.addAttribute("document", service.read(doct_code));
		String[] removeParamKey = {"doct_code"};
		//지운 쿼리스트링 던지기
		model.addAttribute("resultQueryString", Util.removeTargetParameterQueryString(request.getQueryString(), removeParamKey));
		return "document/view";
	}
	
	@RequestMapping(value="/write", method=RequestMethod.GET)
	public String write(HttpServletRequest request, Model model) {

		return "/document/write";
	}
	
	@RequestMapping(value="/write", method=RequestMethod.POST)
	public String write(DocumentVO document, HttpServletRequest request, Model model) {
		
		service.write(document);
		return "redirect:/document/list";
	}
	
	@RequestMapping(value="/modify", method=RequestMethod.GET)
	public String modify(@RequestParam("doct_code") int doct_code, HttpServletRequest request, Model model) {

		model.addAttribute("document", service.read(doct_code));
		return "/document/modify";
	}
	
	@RequestMapping(value="/modify/execute", method=RequestMethod.POST)
	public String modifyExecute(DocumentVO document, HttpServletRequest request, Model model) {
		service.modify(document);
		return "redirect:/document/list";
	}
	
	
	@RequestMapping(value="/delete", method=RequestMethod.GET)
	public String delete(@RequestParam("doct_code") int doct_code, Model model, HttpServletRequest request) {
		
		service.delete(doct_code);
		return "redirect:/document/list";
	}
}
