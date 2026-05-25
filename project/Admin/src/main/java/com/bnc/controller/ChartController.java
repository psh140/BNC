package com.bnc.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bnc.domain.ChartVO;
import com.bnc.service.ChartService;
import com.bnc.util.ChartDate;
import com.bnc.util.Util;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/chart")
@AllArgsConstructor
@Log4j
public class ChartController {
	@Inject
	ChartService service;
	
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view(Model model, HttpServletRequest request) throws Exception {
		
		
		ChartVO projFlagChart = service.readProjFlag();
		String curMonth = ChartDate.getCalsDate(2, 0, "YYYYMM");
		String criteriaMonth = ChartDate.getCalsDate(2, -5, "YYYYMM");
		
//		System.out.println("띄워라 : " + criteriaMonth);
		
		List<ChartVO> monthMemberCount = service.readForMonthMember(curMonth, criteriaMonth); 
		
		
		model.addAttribute("list", monthMemberCount); // 월별 회원가입 숫자
		model.addAttribute("fChart", projFlagChart); // 프로젝트 현황 데이터
		model.addAttribute("topReqCompany", service.topReqCompanyRead());
		model.addAttribute("topAcpCompany", service.topAcpCompanyRead());
		model.addAttribute("endProjectAvgPrice", service.endProjectAvgPrice());
		model.addAttribute("kChart", service.projectKindCount()); // 0 : 제작, 1 : 견적, 2 : 컨설팅
		model.addAttribute("totalMemberCount", service.totalMemberCount());
		model.addAttribute("totalCompanyCount", service.totalCompanyCount());
		model.addAttribute("topProjectPriceInfo", service.topProjectPriceInfo());
		model.addAttribute("endProjectPriceTotal", service.endProjectPriceTotal());
		
		Util.projectTypeKr("");
		return "chart/view";
	}
}
