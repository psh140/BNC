
package com.bnc.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.Criteria;
import com.bnc.domain.PaginationVO;
import com.bnc.service.CompanyService;
import com.bnc.util.Util;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/company")
@AllArgsConstructor
public class CompanyController {
	@Inject
	CompanyService service;

	@RequestMapping(value="/list", method=RequestMethod.GET)
	public String list(HttpServletRequest request, Model model) {

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
		model.addAttribute("resultQueryString", request.getQueryString());
		model.addAttribute("pageMaker", cri.getPageData());
		model.addAttribute("list", list);
		
		return "/company/list";
	}
	
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view(HttpServletRequest request, Model model) {
		
		String cmpy_biznum = request.getParameter("cmpy_biznum");
		//쿼리스트링에서 지울 파라미터
		String[] removeParamKey 	= {"cmpy_biznum"};
		
		//지운 쿼리스트링 던지기
		model.addAttribute("resultQueryString", Util.removeTargetParameterQueryString(request.getQueryString(), removeParamKey));
		model.addAttribute("company", service.read(cmpy_biznum));
		return "company/view";
	
	}
	
	@RequestMapping("/callData")
	@ResponseBody
	public Map<String, Object> companyCallData(@RequestParam("cmpy_biznum") String cmpy_biznum, HttpServletRequest request) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> companyList = new HashMap<String, Object>();
		List<String> companyBizNum		= new ArrayList<String>();
		
		companyBizNum.add(cmpy_biznum);
		
		//쿼리 조회에 필요한 데이터 ArrayList에 put
		companyList.put("company_list", companyBizNum);
		
		List<CompanyVO> companyInfo = service.selectCompanyData(companyList);
		
		result.put("count", companyInfo.size());
		result.put("data", companyInfo);
		
		return result;
	}
}
