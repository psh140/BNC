package com.bnc.controller;

import java.io.File;
import java.util.List;

import javax.inject.Inject;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bnc.config.UtilConfig;
import com.bnc.domain.Criteria;
import com.bnc.domain.MailFormVO;
import com.bnc.domain.MemberCompanyVO;
import com.bnc.domain.MemberLogVO;
import com.bnc.domain.PaginationVO;
import com.bnc.fileupload.FileUpload;
import com.bnc.service.CompanyService;
import com.bnc.service.MailFormService;
import com.bnc.service.MemberService;
import com.bnc.util.Util;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/member")
@AllArgsConstructor
@Log4j
public class MemberController {
	
	@Inject
	MemberService memberService;
	
	@Inject
	CompanyService companyService;
	
	@Inject
	MailFormService mailFormService;
	
	@Autowired
	JavaMailSenderImpl mailSender;
	
	@RequestMapping(value="/list", method=RequestMethod.GET)
	public String list(HttpServletRequest request, Model model) {

		int page 				= request.getParameter("page") != null && request.getParameter("page") != "" ? Integer.parseInt(request.getParameter("page")) : 1;
		String searchType 		= request.getParameter("srch") != null && request.getParameter("srch") != "" ? request.getParameter("srch") : "";
		String searchKeyword 	= request.getParameter("keyword") != null && request.getParameter("keyword") != "" ? request.getParameter("keyword") : "";

		PaginationVO paginationVO = new PaginationVO();
		paginationVO.setSearchKeyword(searchKeyword);
		paginationVO.setSearchType(searchType);
		
		int allRowCount = memberService.selectMemberListCount(paginationVO);
		Criteria cri = new Criteria(allRowCount, page, 10, request.getRequestURI(), request.getQueryString());
		
		paginationVO.setStartRowNumber(cri.getStartRowNumber());
		paginationVO.setEndRowNumber(cri.getEndRowNumber());
		
		List<MemberCompanyVO> list = memberService.selectMemberList(paginationVO);
		
		log.info(list);
		
		model.addAttribute("srch", searchType);
		model.addAttribute("keyword", searchKeyword);
		model.addAttribute("pageMaker", cri.getPageData());
		model.addAttribute("resultQueryString", request.getQueryString());
		model.addAttribute("list", list);
		
		return "/member/list";
	}
	
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public String view(@RequestParam("memb_id") String memb_id, HttpServletRequest request, Model model) {
		int page = request.getParameter("page") != null && request.getParameter("page") != "" ? Integer.parseInt(request.getParameter("page")) : 1;
		
		PaginationVO paginationVO = new PaginationVO();
		
		System.out.println("memb_id 값 : " + memb_id);
		
		int allRowCount = memberService.selectLogListCount(memb_id);
		
		System.out.println("allRowCount : " + allRowCount);
		Criteria cri = new Criteria(allRowCount, page, 10, request.getRequestURI(), request.getQueryString());
		
		paginationVO.setStartRowNumber(cri.getStartRowNumber());
		paginationVO.setEndRowNumber(cri.getEndRowNumber());
		
		List<MemberLogVO> list = memberService.selectLogList(memb_id);
		
		System.out.println("MemberLogVO : " + list);
		model.addAttribute("pageMaker", cri.getPageData());
		model.addAttribute("member", memberService.read(memb_id)); // 멤버 정보
		model.addAttribute("log", list); // 아이디 로그
		
		String[] removeParamKey = {"memb_id"};
		//지운 쿼리스트링 던지기
		model.addAttribute("resultQueryString", Util.removeTargetParameterQueryString(request.getQueryString(), removeParamKey));
		
		return "member/view";
	}
	
	@RequestMapping(value="/modify", method=RequestMethod.GET)
	public String modify(@RequestParam("memb_id") String memb_id, HttpServletRequest request, Model model) {
		model.addAttribute("member", memberService.read(memb_id));

		return "member/modify";
	}
	
	@RequestMapping(value="/modify/execute", method=RequestMethod.POST) // 첨부파일로 사업자등록증 다시 수정
	public String modifyExecute(MemberCompanyVO company, HttpServletRequest request, Model model) throws Exception {
		
		if (company.getCmpy_bizdoc_file() != null && company.getCmpy_bizdoc_file().getSize() != 0) {
			System.out.println("----------수정이미지 삽입 =>" + company.getCmpy_bizdoc_file());
			String urlPath = UtilConfig.FILE_URL_PATH+UtilConfig.FILE_COMPANY_URL;
			String realPath = UtilConfig.FILE_ROOT_PATH+UtilConfig.FILE_COMPANY_URL;

			// 기존 이미지 파일 삭제
			new File(realPath + request.getParameter("cmpy_ci_file_path")).delete();

			String resultDocFilePath = FileUpload.upload(urlPath, realPath, company.getCmpy_bizdoc_file());
			company.setCmpy_biz_doc_file_path(resultDocFilePath);;
		} else if (company.getCmpy_ci_file_path() != null && company.getCmpy_ci_file_path() != "") {
			System.out.println("----------기존이미지 삽입 =>" + request.getParameter("cmpy_ci_file_path"));
			company.setCmpy_biz_doc_file_path(request.getParameter("cmpy_ci_file_path"));
		}
		
		companyService.modify(company);
		return "redirect:/member/list";
	}
	
	@RequestMapping(value="/activate", method=RequestMethod.GET)
	public String activate(@RequestParam("memb_id") String memb_id, HttpServletRequest request, Model model) {
		MailFormVO mail = mailFormService.read("Y");
		
		final MimeMessagePreparator preparator = new MimeMessagePreparator() {
			@Override 
			public void prepare(MimeMessage mimeMessage) throws Exception { 
				final MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8"); 
				helper.setFrom("psh140140@gmail.com"); // 관리자 아이디
//				helper.setTo(memberService.read(memb_id).getMemb_email());
				helper.setTo(memberService.read(memb_id).getMemb_email());
				helper.setSubject(mail.getMalf_title()); 
				helper.setText(mail.getMalf_form(), true);
				
				} 
			};
		mailSender.send(preparator);
		memberService.activate(memb_id);
		
		return "redirect:/member/list";
	}
	
	@RequestMapping(value="/inactivate", method=RequestMethod.GET)
	public String inactivate(@RequestParam("memb_id") String memb_id, HttpServletRequest request, Model model) {
		memberService.inactivate(memb_id);

		return "redirect:/member/list";
	}
}
