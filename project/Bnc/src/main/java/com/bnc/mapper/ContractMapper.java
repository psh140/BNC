package com.bnc.mapper;

import java.util.Map;

import com.bnc.domain.CompanyVO;
import com.bnc.domain.ContractDTO;
import com.bnc.domain.ProjectVO;

public interface ContractMapper {

	//계약서 존재 여부 확인용 카운트 쿼리
	public int selectContractCount(ProjectVO projectVO);
	
	//계약서 데이터 셀렉트 쿼리
	public ContractDTO selectContractData(ProjectVO projectVO);
	
	//계약서 생성 쿼리
	public void insertReqContractData(ContractDTO contractDTO);
	
	//계약서 의뢰기업 수정 쿼리
	public void updateReqContractData(ContractDTO contractDTO);
	
	//계약서 수주기업 수정 쿼리
	public void updateAcpContractData(ContractDTO contractDTO);
		
	//회사별 계약서 등록한 양식 불러오기
	public Map<String, String> selectContractCompanyData(CompanyVO companyVO);
	//각 회사별 계약서 등록 
	public void insertContractCompanyData(Map<String, String> contractData);
	//각 회사별 계약서 업데이트
	public void updateContractCompanyData(Map<String, String> contractData);

	/* 삭제 관련 */
	public void deleteContract(ProjectVO projectVO);
	
	public void deleteContractLog(ProjectVO projectVO);
}

