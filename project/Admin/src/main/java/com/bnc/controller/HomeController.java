package com.bnc.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bnc.domain.ChartVO;
import com.bnc.service.ChartService;
import com.bnc.util.ChartDate;
import com.bnc.util.Util;

import lombok.extern.log4j.Log4j;

/**
 * Handles requests for the application home page.
 */
@Log4j
@Controller
public class HomeController {

	@Inject ChartService cService;
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 * @throws Exception 
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) throws Exception {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		
		ChartVO projFlagChart = cService.readProjFlag();
		String criteriaMonth = ChartDate.getCalsDate(2, -5, "YYYYMM");
		String curMonth = ChartDate.getCalsDate(2, 0, "YYYYMM");
		List<ChartVO> monthMemberCount = cService.readForMonthMember(curMonth, criteriaMonth); 
		
		model.addAttribute("list", monthMemberCount); // 월별 회원가입 숫자
		model.addAttribute("fChart", projFlagChart); // 프로젝트 현황 데이터
		model.addAttribute("topReqCompany", cService.topReqCompanyRead());
		model.addAttribute("topAcpCompany", cService.topAcpCompanyRead());
		model.addAttribute("endProjectAvgPrice", cService.endProjectAvgPrice());
		model.addAttribute("kChart", cService.projectKindCount()); // 0 : 제작, 1 : 견적, 2 : 컨설팅
		model.addAttribute("totalMemberCount", cService.totalMemberCount());
		model.addAttribute("totalCompanyCount", cService.totalCompanyCount());
		model.addAttribute("topProjectPriceInfo", cService.topProjectPriceInfo());
		model.addAttribute("endProjectPriceTotal", cService.endProjectPriceTotal());
		
		Util.projectTypeKr("");
		
		return "chart/view";
	}
	
}
