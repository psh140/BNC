package com.bnc.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.bnc.domain.Criteria;
import com.bnc.domain.NoticeVO;
import com.bnc.domain.PaginationVO;
import com.bnc.service.NoticeService;
import com.bnc.util.Util;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/board")
public class BoardController {
	@Inject
	NoticeService service;

	@RequestMapping("/notice/list")
	public String noticeList(HttpServletRequest request, Model model) {

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
		
		return "/board/notice/list";
	}
	

	@RequestMapping("/notice/view")
	public String noticeView(@RequestParam("seq") int notc_number, HttpServletRequest request, Model model) {
		log.info("Notice View !!");
		
		String[] removeParamKey 	= {"seq"};
		//지운 쿼리스트링 던지기
		model.addAttribute("resultQueryString", Util.removeTargetParameterQueryString(request.getQueryString(), removeParamKey));
		model.addAttribute("notice", service.read(notc_number));
		return "board/notice/view";
	}
	
	
}
