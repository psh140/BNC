package com.bnc.service;

import java.util.Map;

import com.bnc.domain.ContractDTO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.ProjectVO;

public interface ContractService {
	
	//계약서 존재 여부 로직
	public int selectContractCount(ProjectVO projectVO);
	
	//계약서 데이터 가져오기
	public ContractDTO selectContractData(ProjectVO projectVO);
	
	//계약서 생성(등록) 메소드
	public void insertReqContractData(ProjectVO projectVO, ContractDTO contractDTO, MemberVO memberVO) throws Exception;
	
	//계약서 업데이트(수정) 메소드
	public void updateReqContractData(ProjectVO projectVO, ContractDTO contractDTO, MemberVO memberVO) throws Exception;
	
	//계약서 수주측 완료 (완료처리) 메소드
	public void updateAcpContractData(ProjectVO projectVO, ContractDTO contractDTO, MemberVO memberVO) throws Exception;
	
	//회사별 계약서 등록한 양식 불러오기
	public Map<String, String> selectContractCompanyData(MemberVO memberVO);
}
