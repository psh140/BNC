package com.bnc.service;

import java.util.List;

import com.bnc.domain.BizCategoryVO;
import com.bnc.domain.CompanyVO;
import com.bnc.domain.MemberLogVO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.SignVO;
import com.bnc.domain.TermsVO;

public interface AuthService {

	public boolean selectMember(String memb_id); 			// 회원계정 조회

	public void insertMember(MemberVO member); 				// 로그인 및 회원가입
	
	public void deleteMember(String memb_email);			// 회원탈퇴
	
	public MemberVO selectMemberData(String memb_id); 		// 회원계정 조회 (데이터)
	
	public void insertMemberLog(MemberLogVO memberlog);		// 회원로그 삽입
	
	
	/* 기업정보 */
	public List<BizCategoryVO> bizcodeList(); 				// 기업정보 업종 리스트

	public void insertCompanyInfo(CompanyVO company); 		// 기업정보 등록

	public CompanyVO CompanyInfo(String cmpy_memb_id); 		// 기업정보 상세화면

	public boolean modifyCompanyInfo(CompanyVO company);	// 기업정보 수정
	

	/* 서명관리 */
	public List<SignVO> signList(String sign_memb_id); 		// 서명 리스트

	public void insertSign(SignVO sign); 					// 서명 등록

	public SignVO selectSign(SignVO sign); 					// 선택된 서명

	public boolean modifySign(SignVO sign); 				// 서명 수정

	public boolean deleteSign(int sign_num); 				// 서명 삭제
	

	/* 약관 */
	public TermsVO read(String pol_contents); 				//약관(개인정보처리방침,이용약관)
	

	/* 회원숫자 카운트 */
	public int memberCount();

}
