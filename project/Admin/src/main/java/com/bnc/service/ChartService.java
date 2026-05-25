package com.bnc.service;

import java.util.List;

import com.bnc.domain.ChartVO;

public interface ChartService {
	public ChartVO readProjFlag();
	
	public List<ChartVO> readForMonthMember(String curMonth, String criteriaMonth);
	
	public ChartVO topReqCompanyRead();
	
	public ChartVO topAcpCompanyRead();
	
	public Integer endProjectAvgPrice();
	
	public List<Integer> projectKindCount(); // 트랜잭션 붙일 필요 있나?
	
	public Integer totalMemberCount();
	
	public Integer totalCompanyCount();
	
	public ChartVO topProjectPriceInfo();
	
	public Integer endProjectPriceTotal();
}
