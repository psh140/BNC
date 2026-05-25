package com.bnc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.NoticeVO;
import com.bnc.domain.PaginationVO;
import com.bnc.mapper.NoticeMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@AllArgsConstructor
@Log4j
public class NoticeServiceImpl implements NoticeService{
	@Setter(onMethod_ = @Autowired)
	NoticeMapper mapper;

	@Override
	public int selectNoticeListCount(PaginationVO paginationVO) {
		
		return mapper.selectNoticeListCount(paginationVO);
	}

	@Override
	public List<NoticeVO> selectNoticeList(PaginationVO paginationVO) {
		
		return mapper.selectNoticeList(paginationVO);
	}

	@Override
	public NoticeVO read(int notc_number) {
		
		return mapper.read(notc_number);
	}

	@Override
	public void write(NoticeVO notice) {
		mapper.write(notice);
		
	}


	@Override
	public boolean delete(int notc_number) {
		
		return mapper.delete(notc_number) == 1;
	}

	@Override
	public boolean modify(NoticeVO notice) {
		
		return mapper.modify(notice) == 1;
	}
	
	
}
