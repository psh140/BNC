package com.bnc.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bnc.config.UtilConfig;
import com.bnc.domain.BizCategoryVO;
import com.bnc.domain.CompanyVO;
import com.bnc.domain.MemberLogVO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.SignVO;
import com.bnc.domain.TermsVO;
import com.bnc.fileupload.FileUpload;
import com.bnc.oauth.KakaoLoginConn;
import com.bnc.oauth.NaverLoginConn;
import com.bnc.service.AuthService;
import com.github.scribejava.core.model.OAuth2AccessToken;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/auth")
public class AuthController {

	@Inject
	private AuthService service;

	private NaverLoginConn naverLoginConn;
	private KakaoLoginConn kakaoLoginConn = new KakaoLoginConn();

	private String apiResult = null;

	@Autowired
	private void setNaverLoginConn(NaverLoginConn naverLoginConn) {
		this.naverLoginConn = naverLoginConn;
	}

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		
		String naverUrl = naverLoginConn.getAuthorizationUrl(session);
		String kakaoUrl = kakaoLoginConn.getAuthorizationUrl(session);

		model.addAttribute("naver_url", naverUrl);
		model.addAttribute("kakao_url", kakaoUrl);
		
		return "/auth/login";
	}

	/*개인정보처리방침-이용약관 */
	@RequestMapping(value = "/login/agreement", method = RequestMethod.GET)
	public String loginAgreement(MemberVO member, TermsVO terms, HttpServletRequest request, Model model) {
		System.out.println("Agreement view");
		String privacyPolicy;
		String termsAndConditions;
		
		model.addAttribute("privacyPolicy", service.read("P"));
		model.addAttribute("termsAndConditions", service.read("T"));
		return "/auth/login/agreement";
	}

	@RequestMapping(value = "/login/agreement/process", method = RequestMethod.POST)
	public String loginAgreementProcess(MemberVO member, HttpServletRequest request, Model model) {
		System.out.println("Agreement Process");
		HttpSession session = request.getSession();
		
		session.setAttribute("memb_id", member.getMemb_id());
		service.insertMember(member);

		return "redirect:/";
	}

	@RequestMapping(value = "/naverLogin", method = RequestMethod.GET)
	public String naverLogin(Model model, @RequestParam String code, @RequestParam String state,
		HttpServletRequest request, RedirectAttributes rttr) throws IOException, ParseException {
		MemberVO member = new MemberVO();
		MemberLogVO memberlog = new MemberLogVO();
		String kind = "naver";
		HttpSession session = request.getSession();
		
		OAuth2AccessToken oauthToken;
		oauthToken = naverLoginConn.getAccessToken(session, code, state);

		// 로그인 사용자 정보를 읽어온다.
		apiResult = naverLoginConn.getUserProfile(oauthToken);
		// {"resultcode":"00","message":"success","response":{"id":"","email":""}}

		// String형식인 apiResult를 json형태로 바꿈
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(apiResult);
		JSONObject jsonObj = (JSONObject) obj;

		// 데이터 파싱
		JSONObject response_obj = (JSONObject) jsonObj.get("response");
		String id = kind + "_" + (String) response_obj.get("id");
		String email = (String) response_obj.get("email");

		member.setMemb_id(id);
		member.setMemb_kind(kind);
		member.setMemb_email(email);
		member.setMemb_ip(request.getRemoteAddr());
		
		memberlog.setMeml_id(id);
		memberlog.setMeml_ip(request.getRemoteAddr());

		String memb_id = id;
		boolean stat = service.selectMember(memb_id);

		if (stat) {
			session.setAttribute("memb_id", member.getMemb_id());
			service.insertMemberLog(memberlog);
			return "redirect:/";
		} else {
			rttr.addFlashAttribute("member", member);
			return "redirect:/auth/login/agreement";
		}
	}

	@RequestMapping("/kakaoLogin")
	public String kakaoLogin(Model model, @RequestParam("code") String code, HttpServletRequest request, RedirectAttributes rttr) {
		String access_Token = kakaoLoginConn.getAccessToken(code);
		HashMap<String, Object> userInfo = kakaoLoginConn.getUserInfo(access_Token);
		HttpSession session = request.getSession();

		MemberVO member = new MemberVO();
		MemberLogVO memberlog = new MemberLogVO();
		
		String kind = "kakao";

		String id = kind + "_" + userInfo.get("id").toString();
		String email = userInfo.get("email").toString();

		member.setMemb_id(id);
		member.setMemb_kind(kind);
		member.setMemb_email(email);
		member.setMemb_ip(request.getRemoteAddr());
		
		memberlog.setMeml_id(id);
		memberlog.setMeml_ip(request.getRemoteAddr());

		String memb_id = id;

		if (service.selectMember(memb_id)) {
			session.setAttribute("memb_id", member.getMemb_id());
			service.insertMemberLog(memberlog);
			return "redirect:/";
		} else {
			rttr.addFlashAttribute("member", member);
			return "redirect:/auth/login/agreement";
		}
	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		session.invalidate();

		return "redirect:/";
	}

	@RequestMapping(value = "/mypage/companyInfo/view", method = RequestMethod.GET)
	public String companyInfoView(HttpServletRequest request, Model model) {
		System.out.println("CompanyInfo View");
		HttpSession session = request.getSession();

		System.out.println(session.getAttribute("memb_id"));

		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		String cmpy_memb_id = (String) session.getAttribute("memb_id");
		System.out.println(service.CompanyInfo(cmpy_memb_id));

		model.addAttribute("companyInfo", service.CompanyInfo(cmpy_memb_id));

		return "/auth/mypage/companyInfo/view";
	}

	@RequestMapping(value = "/mypage/companyInfo/write", method = RequestMethod.GET)
	public String companyInfoWirte(HttpServletRequest request, Model model) {
		System.out.println("CompanyInfo Insert Process");
		HttpSession session = request.getSession();

		System.out.println(session.getAttribute("memb_id"));

		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		List<BizCategoryVO> bizcode = service.bizcodeList();
		model.addAttribute("bizcode", bizcode);

		return "/auth/mypage/companyInfo/write";
	}

	@RequestMapping(value = "/mypage/companyInfo/write/process", method = RequestMethod.POST)
	public String companyInfoWirte(CompanyVO company, HttpServletRequest request, Model model) throws Exception {
		System.out.println("CompanyInfo Insert Process");
		HttpSession session = request.getSession();

		System.out.println(session.getAttribute("memb_id"));

		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		String memb_id = (String) session.getAttribute("memb_id");
		company.setCmpy_memb_id(memb_id);

		// FileUpload Setting
		String urlPath = UtilConfig.FILE_URL_PATH + company.getStdFilePath();
		String realPath = UtilConfig.FILE_ROOT_PATH + company.getStdFilePath();

		// FileUpload Class 참조
		String resultBizNumFilePath = FileUpload.upload(urlPath, realPath, company.getBiznumFile());
		company.setCmpy_biz_doc_file_path(resultBizNumFilePath);

		String resultThumbFilePath = FileUpload.upload(urlPath, realPath, company.getCiThumbNail());
		company.setCmpy_ci_file_path(resultThumbFilePath);

		System.out.println(resultBizNumFilePath);
		System.out.println(resultThumbFilePath);

		service.insertCompanyInfo(company);

		return "redirect:/auth/mypage/companyInfo/view";
	}

	@RequestMapping(value = "/mypage/companyInfo/modify", method = RequestMethod.GET)
	public String companyInfoModify(HttpServletRequest request, Model model) {
		System.out.println("CompanyInfo Modify");
		HttpSession session = request.getSession();

		System.out.println(session.getAttribute("memb_id"));

		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		List<BizCategoryVO> bizcode = service.bizcodeList();
		model.addAttribute("bizcode", bizcode);

		String cmpy_memb_id = (String) session.getAttribute("memb_id");
		model.addAttribute("companyInfo", service.CompanyInfo(cmpy_memb_id));

		return "/auth/mypage/companyInfo/modify";
	}

	@RequestMapping(value = "/mypage/companyInfo/modify/process", method = RequestMethod.POST)
	public String companyInfoModify(CompanyVO company, HttpServletRequest request, Model model) throws Exception {
		System.out.println("CompanyInfo Modify Process");
		HttpSession session = request.getSession();

		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		System.out.println(session.getAttribute("memb_id"));

		if (company.getCiThumbNail() != null && company.getCiThumbNail().getSize() != 0) {
			System.out.println("----------수정이미지 삽입 =>" + company.getCiThumbNail());
			String urlPath = UtilConfig.FILE_URL_PATH + company.getStdFilePath();
			String realPath = UtilConfig.FILE_ROOT_PATH + company.getStdFilePath();

			// 기존 이미지 파일 삭제
			new File(realPath + request.getParameter("cmpy_ci_file_path")).delete();

			String resultThumbFilePath = FileUpload.upload(urlPath, realPath, company.getCiThumbNail());
			company.setCmpy_ci_file_path(resultThumbFilePath);
		} else if (company.getCmpy_ci_file_path() != null && company.getCmpy_ci_file_path() != "") {
			System.out.println("----------기존이미지 삽입 =>" + request.getParameter("cmpy_ci_file_path"));
			company.setCmpy_ci_file_path(request.getParameter("cmpy_ci_file_path"));
		}

		String memb_id = (String) session.getAttribute("memb_id");
		company.setCmpy_memb_id(memb_id);

		service.modifyCompanyInfo(company);

		return "redirect:/auth/mypage/companyInfo/view";
	}

	@RequestMapping(value = "/mypage/sign/view", method = RequestMethod.GET)
	public String signList(HttpServletRequest request, Model model) {
		System.out.println("Sign List");
		HttpSession session = request.getSession();
		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		String sign_memb_id = (String) session.getAttribute("memb_id");
		System.out.println(service.signList(sign_memb_id));

		model.addAttribute("signList", service.signList(sign_memb_id));

		return "/auth/mypage/sign/view";
	}

	@RequestMapping(value = "/mypage/sign/write", method = RequestMethod.GET)
	public String signWirte(HttpServletRequest request, Model model) {
		System.out.println("Sign Insert");
		HttpSession session = request.getSession();

		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		return "/auth/mypage/sign/write";
	}

	@RequestMapping(value = "/mypage/sign/write/process", method = RequestMethod.POST)
	public String signWirte(SignVO sign, HttpServletRequest request, Model model) throws Exception {
		System.out.println("Sign Insert Process");
		HttpSession session = request.getSession();

		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		String memb_id = (String) session.getAttribute("memb_id");
		sign.setSign_memb_id(memb_id);

		String urlPath = UtilConfig.FILE_URL_PATH + sign.getStdFilePath();
		String realPath = UtilConfig.FILE_ROOT_PATH + sign.getStdFilePath();

		String resultSignFilePath = FileUpload.upload(urlPath, realPath, sign.getSignFile());
		sign.setSign_file_path(resultSignFilePath);

		service.insertSign(sign);

		return "redirect:/auth/mypage/sign/view";
	}

	@RequestMapping(value = "/mypage/sign/modify", method = RequestMethod.GET)
	public String signModify(@RequestParam("seq") int sign_num, HttpServletRequest request, Model model)
			throws Exception {
		System.out.println("Sign Modify");
		HttpSession session = request.getSession();

		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		String sign_memb_id = (String) session.getAttribute("memb_id");

		SignVO sign = new SignVO();

		sign.setSign_num(sign_num);
		sign.setSign_memb_id(sign_memb_id);

		model.addAttribute("sign", service.selectSign(sign));

		return "/auth/mypage/sign/modify";
	}

	@RequestMapping(value = "/mypage/sign/modify/process", method = RequestMethod.POST)
	public String signModify(SignVO sign, HttpServletRequest request, Model model) throws Exception {
		System.out.println("Sign Modify Process");
		HttpSession session = request.getSession();

		if (session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		String sign_memb_id = (String) session.getAttribute("memb_id");
		sign.setSign_memb_id(sign_memb_id);

		if (sign.getSignFile() != null && sign.getSignFile().getSize() != 0) {
			System.out.println("----------수정이미지 삽입 =>" + sign.getSignFile());
			String urlPath = UtilConfig.FILE_URL_PATH + sign.getStdFilePath();
			String realPath = UtilConfig.FILE_ROOT_PATH + sign.getStdFilePath();

			// 기존 이미지 파일 삭제
			new File(realPath + request.getParameter("sign_file_path")).delete();

			String resultSignFilePath = FileUpload.upload(urlPath, realPath, sign.getSignFile());
			sign.setSign_file_path(resultSignFilePath);

		} else if (sign.getSign_file_path() != null && sign.getSign_file_path() != "") {
			System.out.println("----------기존이미지 삽입 =>" + request.getParameter("sign_file_path"));
			sign.setSign_file_path(request.getParameter("sign_file_path"));
		}

		service.modifySign(sign);

		return "redirect:/auth/mypage/sign/view";
	}

	@RequestMapping(value = "/mypage/sign/delete", method = RequestMethod.GET)
	public String signDelete(@RequestParam("seq") int sign_num, HttpServletRequest request, Model model)
			throws Exception {
		System.out.println("Sign Delete");
		HttpSession session = request.getSession();

		if(session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}

		service.deleteSign(sign_num);

		return "redirect:/auth/mypage/sign/view";
	}
	
	@RequestMapping(value="/mypage/withdrawal/view", method=RequestMethod.GET)
	public String withdrawal(HttpServletRequest request, Model model) {
		System.out.println("Membership Withdrawal");
		HttpSession session = request.getSession();
		
		if(session.getAttribute("memb_id") == null) {
			return "redirect:/auth/login";
		}
		
		return "/auth/mypage/withdrawal/view";
	}
	
	@RequestMapping(value="/mypage/withdrawal/process", method=RequestMethod.POST)
	public String withdrawalProcess(HttpServletRequest request, Model model) {
		System.out.println("Membership Withdrawal Process");
		HttpSession session = request.getSession();
		
		String memb_email = request.getParameter("memb_email");
		System.out.println("memb_email => " + memb_email);
		
		
		service.deleteMember(memb_email);
		
		return "redirect:/";
	}
}
