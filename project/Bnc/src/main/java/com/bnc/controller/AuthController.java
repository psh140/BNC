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

import com.bnc.config.OAuthConfig;
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

/*
 * 로그인 / 회원가입 / 마이페이지(기업정보·서명·탈퇴)를 담당하는 컨트롤러.
 *
 * [회원가입 흐름 — 별도의 가입 폼이 없다]
 *   1. /auth/login            소셜 로그인 버튼 노출
 *   2. 네이버/카카오 인증 후 /auth/naverLogin 또는 /auth/kakaoLogin 으로 콜백
 *   3. 제공자에서 받은 id 로 기존 회원인지 확인
 *        기존 회원  → 세션에 memb_id 를 넣고 메인으로 (로그인 완료)
 *        신규 회원  → /auth/login/agreement 로 보내 약관 동의를 받은 뒤 그 시점에 INSERT
 *      즉 약관 동의 화면이 곧 회원가입 단계다.
 *
 * [회원 ID 규칙]  "naver_" 또는 "kakao_" + 제공자가 준 고유 id.
 *                 접두어가 있어 서로 다른 제공자의 id 가 겹치지 않는다.
 *
 * [로그인 판정]  세션의 memb_id 존재 여부로만 판단한다. 마이페이지 계열 메서드들이
 *                각자 null 검사를 반복하는 이유다.
 *
 * [기업정보 등록]  회원가입과는 별개 단계다. 프로젝트를 발주/수주하려면 기업정보가 있어야 하므로
 *                  마이페이지에서 사업자등록증·CI 이미지를 올려 따로 등록한다.
 */
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

		/*
		 * 키가 발급되지 않은 제공자는 인증 URL을 만들지 않는다.
		 * 만들어봤자 client_id가 빈 값이라 제공자 쪽에서 에러 페이지만 뜨기 때문.
		 */
		boolean naverEnabled = OAuthConfig.isNaverEnabled();
		boolean kakaoEnabled = OAuthConfig.isKakaoEnabled();

		if (naverEnabled) {
			model.addAttribute("naver_url", naverLoginConn.getAuthorizationUrl(session));
		}
		if (kakaoEnabled) {
			model.addAttribute("kakao_url", kakaoLoginConn.getAuthorizationUrl(session));
		}

		model.addAttribute("naver_enabled", naverEnabled);
		model.addAttribute("kakao_enabled", kakaoEnabled);

		return "/auth/login";
	}

	/*
	 * 약관 동의 화면 = 신규 회원의 가입 단계.
	 * 소셜 로그인 콜백이 RedirectAttributes 로 넘긴 member 정보가 flash attribute 로 들어와
	 * 화면의 hidden 필드에 실린다. 화면에 뿌릴 약관 본문은 DB 에서 읽어온다 (P:개인정보, T:이용약관).
	 */
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

	/*
	 * 동의 완료 → 여기서 실제 회원 INSERT 가 일어난다. 세션에 memb_id 를 넣어 곧바로 로그인 상태가 된다.
	 * 별도의 가입 폼이 없으므로 이 메서드가 회원가입의 마지막 단계다.
	 */
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
		/* 키 미발급 상태에서 콜백 URL로 직접 접근하는 경우 차단 */
		if (!OAuthConfig.isNaverEnabled()) {
			return "redirect:/auth/login";
		}

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

		//기존 회원이면 바로 로그인, 신규면 약관 동의(=가입) 화면으로 보낸다
		if (stat) {
			session.setAttribute("memb_id", member.getMemb_id());
			service.insertMemberLog(memberlog);
			return "redirect:/";
		} else {
			//리다이렉트 후에도 값이 유지되도록 flash attribute 로 넘긴다
			rttr.addFlashAttribute("member", member);
			return "redirect:/auth/login/agreement";
		}
	}

	@RequestMapping("/kakaoLogin")
	public String kakaoLogin(Model model, @RequestParam("code") String code, HttpServletRequest request, RedirectAttributes rttr) {
		/* 키 미발급 상태에서 콜백 URL로 직접 접근하는 경우 차단 */
		if (!OAuthConfig.isKakaoEnabled()) {
			return "redirect:/auth/login";
		}

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

	/*
	 * 기업정보 등록. 사업자등록증 사본과 CI 이미지 두 파일을 함께 올린다.
	 *
	 * 업로드 경로는 UtilConfig 의 환경변수 값(FILE_ROOT_PATH)에 화면에서 넘어온 하위 경로를 붙여 만든다.
	 * 이 메서드에는 @Transactional 이 없어 파일 업로드 후 INSERT 가 실패하면 파일만 남는다.
	 */
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
