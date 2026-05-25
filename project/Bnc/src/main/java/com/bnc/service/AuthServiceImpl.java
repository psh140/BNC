
package com.bnc.service;

import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.BizCategoryVO;
import com.bnc.domain.CompanyVO;
import com.bnc.domain.MemberLogVO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.SignVO;
import com.bnc.domain.TermsVO;
import com.bnc.mapper.AuthMapper;
import com.bnc.mapper.TermsMapper;

import lombok.Setter;

@Service
public class AuthServiceImpl implements AuthService {

	@Setter(onMethod_ = @Autowired)
	private AuthMapper mapper;
	
	/*약관동의 */
	 @Setter(onMethod_ = @Autowired) 
	 TermsMapper termsmapper;

	@Setter(onMethod_ = @Autowired)
	ServletContext servletContext;

	/*약관동의 */ 
	 @Override 
	 public TermsVO read(String pol_kind) { 
		 return termsmapper.read(pol_kind); 
	 };
	
	@Override
	public boolean selectMember(String memb_id) {
		return mapper.selectMember(memb_id) == 1;
	}

	public MemberVO selectMemberData(String memb_id) {
		
		return mapper.selectMemberData(memb_id);
	}
	
	@Override
	public void insertMember(MemberVO member) {
		System.out.println("insertMember Service");
		mapper.insertMember(member);
	}
	
	@Override
	public void insertMemberLog(MemberLogVO memberlog) {
		System.out.println("insertMemberLog Service");
		mapper.insertMemberLog(memberlog);
	}
	
	@Override
	public void deleteMember(String memb_email) {
		System.out.println("Membership Withdrawal");
		mapper.deleteMember(memb_email);
	};

	@Override
	public List<BizCategoryVO> bizcodeList() {
		System.out.println("Bizcode Service");
		return mapper.bizcodeList();
	}

	@Override
	public void insertCompanyInfo(CompanyVO company) {
		System.out.println("insertCompanyInfo Service");
		mapper.insertCompanyInfo(company);
	}

	@Override
	public CompanyVO CompanyInfo(String cmpy_memb_id) {
		// TODO Auto-generated method stub
		System.out.println("selectCompanyInfo Service");
		return mapper.CompanyInfo(cmpy_memb_id);
	}

	@Override
	public boolean modifyCompanyInfo(CompanyVO company) {
		// TODO Auto-generated method stub
		System.out.println("modifyCompanyInfo Service");
		return mapper.modifyCompanyInfo(company) == 1;
	}

	@Override
	public void insertSign(SignVO sign) {
		// TODO Auto-generated method stub
		System.out.println("insertSign Service");
		mapper.insertSign(sign);
	}

	@Override
	public List<SignVO> signList(String sign_memb_id) {
		System.out.println("SignList Service");
		return mapper.signList(sign_memb_id);
	}

	@Override
	public SignVO selectSign(SignVO sign) {
		System.out.println("Sign Select Service");
		return mapper.selectSign(sign);
	}

	@Override
	public boolean modifySign(SignVO sign) {
		// TODO Auto-generated method stub
		System.out.println("modifySign Service");
		return mapper.modifySign(sign) == 1;
	}

	@Override
	public boolean deleteSign(int sign_num) {
		// TODO Auto-generated method stub
		System.out.println("deleteSign Service");
		return mapper.deleteSign(sign_num) == 1;
	}

	@Override
	public int memberCount() {
		// TODO Auto-generated method stub
		return mapper.memberCount();
	}
}
