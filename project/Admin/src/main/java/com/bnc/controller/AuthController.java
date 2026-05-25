package com.bnc.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bnc.domain.AdminVO;
import com.bnc.service.AuthService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;


@Controller
@RequestMapping("/auth")
@AllArgsConstructor
@Log4j
public class AuthController {
	@Inject
	private AuthService service;
	
	
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public void login(HttpServletRequest request, Model model) {

	}
	
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login(AdminVO admin, HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();

		if (service.adminLoginSelect(admin)) {
			session.setAttribute("admin_id", admin.getAdmin_id());
			log.info("login OK");
			return "redirect:/";
		} else {
			log.info("login fail");
			return "redirect:/auth/login";	
		}
	}
	
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public String logout(Model model, HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.invalidate();
		
		return "redirect:/auth/login";
	}
	
}
