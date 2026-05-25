package com.bnc.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bnc.service.TermsService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/terms")
@AllArgsConstructor
public class TermsController {
	TermsService service;

	@RequestMapping(value="/termsAndConditions", method=RequestMethod.GET)
	public String termsAndConditions(HttpServletRequest request, Model model) {
		
		model.addAttribute("termsAndConditions", service.read("T"));
		
		return "terms/termsAndConditions";
	}

	@RequestMapping(value="/privacyPolicy", method=RequestMethod.GET)
	public String privacyPolicy(HttpServletRequest request, Model model) {
		
		model.addAttribute("privacyPolicy", service.read("P"));
		
		return "terms/privacyPolicy";
	}
	

	
}
