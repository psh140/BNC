package com.bnc.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bnc.domain.ChartVO;
import com.bnc.mapper.ChartMapper;
import com.bnc.mapper.CompanyMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@AllArgsConstructor
@Log4j
public class ChartServiceImpl implements ChartService{
	@Setter(onMethod_ = @Autowired)
	ChartMapper mapper;
	@Setter(onMethod_ = @Autowired)
	CompanyMapper cmapper;
	
	@Override
	public ChartVO readProjFlag() {
		System.out.println("readProjFlag : " + mapper.readProjFlag());
		return mapper.readProjFlag();
	}

	@Override
	public List<ChartVO> readForMonthMember(String curMonth, String criteriaMonth) {
		System.out.println("curMonth : " + curMonth + " criteriaMonth : " + criteriaMonth);
		List<ChartVO> list = mapper.readForMonthMember(curMonth, criteriaMonth);
		
		for(int i = 0; i < list.size(); i++) {
			ChartVO chart = list.get(i);
			try {
				Date date = new SimpleDateFormat("yyyyMM").parse(chart.getMemb_rdate());
				String newDate = new SimpleDateFormat("MM").format(date);
				chart.setMemb_rdate(newDate);
				list.set(i, chart);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
		}
		return list;
	}

	@Override
	public ChartVO topReqCompanyRead() {
		System.out.println("topReqCompanyRead : " + mapper.topReqCompanyRead());
		return mapper.topReqCompanyRead();
	}

	@Override
	public ChartVO topAcpCompanyRead() {
		System.out.println("topAcpCompanyRead : " + mapper.topAcpCompanyRead());
		return mapper.topAcpCompanyRead();
	}

	@Override
	public Integer endProjectAvgPrice() {
		System.out.println("endProjectAvgPrice : " + mapper.endProjectAvgPrice());
		return mapper.endProjectAvgPrice();
	}

	@Transactional
	@Override
	public List<Integer> projectKindCount() { // 트랜잭션 처리 해야함. 까먹음 책보고 할 것
		List<Integer> kindCount = new ArrayList<>();
		kindCount.add(mapper.projectKindCount("제작"));
		kindCount.add(mapper.projectKindCount("견적"));
		kindCount.add(mapper.projectKindCount("컨설팅"));
		System.out.println("projectKindCount : " + kindCount);
		return kindCount;
	}

	@Override
	public Integer totalMemberCount() {
		System.out.println("totalMemberCount : " + mapper.totalMemberCount());
		return mapper.totalMemberCount();
	}

	@Override
	public Integer totalCompanyCount() {
		System.out.println("totalCompanyCount : " + mapper.totalCompanyCount());
		return mapper.totalCompanyCount();
	}

	@Override
	public ChartVO topProjectPriceInfo() {
		System.out.println("topProjectPriceInfo : " + mapper.topProjectPriceInfo());
		return mapper.topProjectPriceInfo();
	}

	@Override
	public Integer endProjectPriceTotal() {
		System.out.println("endProjectPriceTotal : " + mapper.endProjectPriceTotal());
		return mapper.endProjectPriceTotal();
	}
}
