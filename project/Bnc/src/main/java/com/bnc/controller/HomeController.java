package com.bnc.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.Criteria;
import com.bnc.domain.NoticeVO;
import com.bnc.domain.PaginationVO;
import com.bnc.domain.ProjectVO;
import com.bnc.service.AuthService;
import com.bnc.service.CompanyService;
import com.bnc.service.NoticeService;
import com.bnc.service.ProjectService;

import lombok.extern.log4j.Log4j;

/**
 * Handles requests for the application home page.
 */
@Log4j
@Controller
public class HomeController {

	@Inject
	private ProjectService pService;
	
	@Inject
	private AuthService aService;
	
	@Inject
	private CompanyService cService;
	
	@Inject 
	private NoticeService nService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpServletRequest request) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("mCount", aService.memberCount());
		model.addAttribute("pCount", pService.projectCount());
		model.addAttribute("serverTime", formattedDate );
//		model.addAttribute("vo", service.selectList());

		PaginationVO paginationVO = new PaginationVO();
	
		Criteria cri = new Criteria(1, 1, 6, request.getRequestURI(), request.getQueryString());
		
		paginationVO.setStartRowNumber(cri.getStartRowNumber());
		paginationVO.setEndRowNumber(cri.getEndRowNumber());
		
		List<CompanyVO> cList = cService.selectCompanyList(paginationVO);
//		model.addAttribute("resultQueryString", request.getQueryString());
		model.addAttribute("cList", cList); // 회사 리스트
		log.info(cList);
		System.out.println(cList);
		
		List<ProjectVO> pList = pService.selectProjectList(paginationVO);
		model.addAttribute("pList", pList); // 프로젝트 리스트
		System.out.println(pList);
		
		cri = new Criteria(1, 1, 3, request.getRequestURI(), request.getQueryString());
		List<NoticeVO> nList = nService.selectNoticeList(paginationVO);
		model.addAttribute("nList", nList); // 공지사항 리스트
		System.out.println(nList);
		
		return "home";
	}
	
}
