package com.bnc.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bnc.domain.Criteria;
import com.bnc.domain.NoticeVO;
import com.bnc.domain.PaginationVO;
import com.bnc.service.NoticeService;
import com.bnc.util.Util;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/notice")
@AllArgsConstructor
@Log4j
public class NoticeController {
	@Inject
	NoticeService service;
	
	@RequestMapping(value="/list", method=RequestMethod.GET)
	public String list(HttpServletRequest request, Model model) {

		int page 				= request.getParameter("page") != null && request.getParameter("page") != "" ? Integer.parseInt(request.getParameter("page")) : 1;
		String searchType 		= request.getParameter("srch") != null && request.getParameter("srch") != "" ? request.getParameter("srch") : "";
		String searchKeyword 	= request.getParameter("keyword") != null && request.getParameter("keyword") != "" ? request.getParameter("keyword") : "";

		PaginationVO paginationVO = new PaginationVO();
		paginationVO.setSearchKeyword(searchKeyword);
		paginationVO.setSearchType(searchType);
		
		int allRowCount = service.selectNoticeListCount(paginationVO);
		Criteria cri = new Criteria(allRowCount, page, 10, request.getRequestURI(), request.getQueryString());
		
		paginationVO.setStartRowNumber(cri.getStartRowNumber());
		paginationVO.setEndRowNumber(cri.getEndRowNumber());
		
		List<NoticeVO> list = service.selectNoticeList(paginationVO);
		
		log.info(list);
		
		model.addAttribute("srch", searchType);
		model.addAttribute("keyword", searchKeyword);
		model.addAttribute("pageMaker", cri.getPageData());
		model.addAttribute("resultQueryString", request.getQueryString());
		model.addAttribute("list", list);
		
		return "/notice/list";
	}
	
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view(@RequestParam("notc_number") int notc_number, HttpServletRequest request, Model model) {

		model.addAttribute("notice", service.read(notc_number));
		String[] removeParamKey = {"notc_number"};
		//지운 쿼리스트링 던지기
		model.addAttribute("resultQueryString", Util.removeTargetParameterQueryString(request.getQueryString(), removeParamKey));
		return "notice/view";
	}
	
	@RequestMapping(value="/write", method=RequestMethod.GET)
	public String write(HttpServletRequest request, Model model) {

		return "/notice/write";
	}
	
	@RequestMapping(value="/write", method=RequestMethod.POST)
	public String write(NoticeVO notice, HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		notice.setNotc_admin_id((String)session.getAttribute("admin_id"));
		
		service.write(notice);
		return "redirect:/notice/list";
	}
	
	@RequestMapping(value="/modify", method=RequestMethod.GET)
	public String modify(@RequestParam("notc_number") int notc_number, HttpServletRequest request, Model model) {

		
		model.addAttribute("notice", service.read(notc_number));
		return "/notice/modify";
	}
	
	@RequestMapping(value="/modify/execute", method=RequestMethod.POST)
	public String modifyExecute(NoticeVO notice, HttpServletRequest request, Model model) {
		
		service.modify(notice);
		return "redirect:/notice/list";
	}
	
	
	@RequestMapping(value="/delete", method=RequestMethod.GET)
	public String delete(@RequestParam("notc_number") int notc_number, HttpServletRequest request, Model model) {

		service.delete(notc_number);
		return "redirect:/notice/list";
	}
}
