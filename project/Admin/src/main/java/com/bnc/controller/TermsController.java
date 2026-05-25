package com.bnc.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bnc.domain.TermsVO;
import com.bnc.service.TermsService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/terms")
@AllArgsConstructor
@Log4j
public class TermsController {
	@Inject
	TermsService service;
	
	@RequestMapping(value="/termsAndConditions/view", method=RequestMethod.GET)
	public String termsAndConditionsView(HttpServletRequest request, Model model) {
		
		model.addAttribute("view", service.read("T"));
		
		return "terms/termsAndConditions/view";
	}
	
	@RequestMapping(value="/privacyPolicy/view", method=RequestMethod.GET)
	public String privacyPolicyView(HttpServletRequest request, Model model) {
		
		model.addAttribute("view", service.read("P"));
		
		return "terms/privacyPolicy/view";
	}
	
	@RequestMapping(value="/termsAndConditions/modify", method=RequestMethod.GET)
	public String termsAndConditionsModify(@RequestParam("pol_kind") String pol_kind, HttpServletRequest request, Model model) {
		model.addAttribute("view", service.read(pol_kind));

		return "terms/termsAndConditions/modify";
	}
	
	@RequestMapping(value="termsAndConditions/modify/execute", method=RequestMethod.POST)
	public String termsAndConditionsModifyExecute(TermsVO terms, HttpServletRequest request, Model model) {
		
		service.modify(terms);
		return "redirect:/terms/termsAndConditions/view";
	}
	
	@RequestMapping(value="/privacyPolicy/modify", method=RequestMethod.GET)
	public String privacyPolicyModify(@RequestParam("pol_kind") String pol_kind, HttpServletRequest request, Model model) {
		model.addAttribute("view", service.read(pol_kind));

		return "terms/privacyPolicy/modify";
	}
	
	@RequestMapping(value="privacyPolicy/modify/execute", method=RequestMethod.POST)
	public String privacyPolicyModifyExecute(TermsVO terms, HttpServletRequest request, Model model) {
		
		service.modify(terms);
		return "redirect:/terms/privacyPolicy/view";
	}
}
