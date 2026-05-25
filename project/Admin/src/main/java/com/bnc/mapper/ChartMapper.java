package com.bnc.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.bnc.domain.ChartVO;

public interface ChartMapper {
	public ChartVO readProjFlag();	// 프로젝트 현황 리스트 파이차트
	
	public List<ChartVO> readForMonthMember(@Param("curMonth") String curMonth, @Param("criteriaMonth") String criteriaMonth); // 월별 회원 가입 수 바차트
	
	public ChartVO topReqCompanyRead();	// 가장 의뢰 많이한 회사 정보
	
	public ChartVO topAcpCompanyRead(); // 가장 수주 많이한 회사 정보
	
	public Integer endProjectAvgPrice(); // 완료된 프로젝트들의 평균 계약 금액
	
	public Integer projectKindCount(String kind); // 종류별 카운트 뽑기 제작, 견적, 컨설팅 파이차트
	
	public Integer totalMemberCount(); // 총 회원가입만 한 숫자
	
	public Integer totalCompanyCount(); // 기업정보 등록된 회원 숫자
	
	public ChartVO topProjectPriceInfo(); // 가장 계약금액 높은 프로젝트 정보
	
	public Integer endProjectPriceTotal(); // 완료된 프로젝트들의 계약된 금액의 총합
}
