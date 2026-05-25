package com.bnc.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bnc.config.UtilConfig;
import com.bnc.domain.CompanyVO;
import com.bnc.domain.ContractDTO;
import com.bnc.domain.MemberVO;
import com.bnc.domain.ProjectVO;
import com.bnc.fileupload.FileUpload;
import com.bnc.mapper.CompanyMapper;
import com.bnc.mapper.ContractMapper;
import com.bnc.mapper.DocumentMapper;
import com.bnc.mapper.ProjectMapper;

import lombok.Setter;

@Service
public class ContractServiceImpl implements ContractService{

	@Setter(onMethod_= @Autowired)
	private ProjectMapper projectMapper;
	
	@Setter(onMethod_= @Autowired)
	private CompanyMapper companyMapper;
	
	@Setter(onMethod_= @Autowired)
	private DocumentMapper documentMapper;
	
	@Setter(onMethod_ = @Autowired)
	private ContractMapper contractMapper;
	
	
	public int selectContractCount(ProjectVO projectVO) {

		return contractMapper.selectContractCount(projectVO);
	}
	
	public ContractDTO selectContractData(ProjectVO projectVO) {
		
		return contractMapper.selectContractData(projectVO);
	}
	
	//계약서 생성(등록) 메소드
	@Transactional
	public void insertReqContractData(ProjectVO projectVO, ContractDTO contractDTO, MemberVO memberVO) throws Exception {
		
		CompanyVO companyVO = companyMapper.selectMyCompanyData(memberVO);
		
		//파일 경로 세팅
		String urlPath	= UtilConfig.FILE_URL_PATH + UtilConfig.FILE_CONTRACT_PATH;
		String realPath	= UtilConfig.FILE_ROOT_PATH + UtilConfig.FILE_CONTRACT_PATH;

		if(!contractDTO.getCntr_req_sign_file().getOriginalFilename().equals("")) {
		//FileUpload 클래스는 com.bnc.fileupload 패키지에 있음 FileUpload.java 
			String resultFilePath = FileUpload.upload(urlPath, realPath, contractDTO.getCntr_req_sign_file());
			contractDTO.setCntr_req_sign_path(resultFilePath);
		}

		contractDTO.setCntr_proj_number(projectVO.getProj_number());
		contractDTO.setCntr_req_biznum(companyVO.getCmpy_biznum());
		contractDTO.setCntr_acp_biznum(projectVO.getProj_acp_biznum());
		
		System.out.println("=========서비스==========="+contractDTO);
		
		contractMapper.insertReqContractData(contractDTO);
		
		Map<String, String> contractData = new HashMap<String, String>();
		contractData.put("cntc_cmpy_biznum", contractDTO.getCntr_req_biznum());
		contractData.put("cntc_contract_form", contractDTO.getCntr_contents());
		
		Map<String, String> contractCheck = contractMapper.selectContractCompanyData(companyVO);
		
		if(contractCheck != null) {
			contractMapper.updateContractCompanyData(contractData);
		}
		else {
			contractMapper.insertContractCompanyData(contractData);	
		}
	}
	
	//계약서 업데이트(수정) 메소드
	@Transactional
	public void updateReqContractData(ProjectVO projectVO, ContractDTO contractDTO, MemberVO memberVO) throws Exception{
		
		CompanyVO companyVO = companyMapper.selectMyCompanyData(memberVO);
		
		//파일 경로 세팅
		String urlPath	= UtilConfig.FILE_URL_PATH + UtilConfig.FILE_CONTRACT_PATH;
		String realPath	= UtilConfig.FILE_ROOT_PATH + UtilConfig.FILE_CONTRACT_PATH;

		
		if(!contractDTO.getCntr_req_sign_file().getOriginalFilename().equals("")) {
			//FileUpload 클래스는 com.bnc.fileupload 패키지에 있음 FileUpload.java 
				String resultFilePath = FileUpload.upload(urlPath, realPath, contractDTO.getCntr_req_sign_file());
				contractDTO.setCntr_req_sign_path(resultFilePath);
		}
		
		contractDTO.setCntr_proj_number(projectVO.getProj_number());
		contractDTO.setCntr_req_biznum(companyVO.getCmpy_biznum());
		contractDTO.setCntr_acp_biznum(projectVO.getProj_acp_biznum());
		
		System.out.println("=========updateReqContractData Service==========="+contractDTO);
		
		contractMapper.updateReqContractData(contractDTO);
		
		Map<String, String> contractData = new HashMap<String, String>();
		contractData.put("cntc_cmpy_biznum", contractDTO.getCntr_req_biznum());
		contractData.put("cntc_contract_form", contractDTO.getCntr_contents());
		
		Map<String, String> contractCheck = contractMapper.selectContractCompanyData(companyVO);
		
		if(contractCheck != null) {
			contractMapper.updateContractCompanyData(contractData);
		}
		else {
			contractMapper.insertContractCompanyData(contractData);	
		}
	}
	
	//계약서 수주측 완료 (완료처리) 메소드
	@Transactional
	public void updateAcpContractData(ProjectVO projectVO, ContractDTO contractDTO, MemberVO memberVO) throws Exception
	{
		CompanyVO companyVO = companyMapper.selectMyCompanyData(memberVO);
		
		//파일 경로 세팅
		String urlPath	= UtilConfig.FILE_URL_PATH + UtilConfig.FILE_CONTRACT_PATH;
		String realPath	= UtilConfig.FILE_ROOT_PATH + UtilConfig.FILE_CONTRACT_PATH;

		if(!contractDTO.getCntr_acp_sign_file().getOriginalFilename().equals("")) {
			//FileUpload 클래스는 com.bnc.fileupload 패키지에 있음 FileUpload.java 
				String resultFilePath = FileUpload.upload(urlPath, realPath, contractDTO.getCntr_acp_sign_file());
				contractDTO.setCntr_acp_sign_path(resultFilePath);
		}
		
		contractDTO.setCntr_proj_number(projectVO.getProj_number());
		projectVO.setProj_flag("P");
		
		projectMapper.updateProjectFlag(projectVO);
		projectMapper.deleteProjectParticipateData(projectVO);
		System.out.println("=========updateAcpContractData Service==========="+contractDTO);
		
		contractMapper.updateAcpContractData(contractDTO);
	}
		
	public Map<String, String> selectContractCompanyData(MemberVO memberVO) {
		
		CompanyVO companyVO = companyMapper.selectMyCompanyData(memberVO);
		return contractMapper.selectContractCompanyData(companyVO);
	}
	
}
