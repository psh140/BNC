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

@Log4j
@Service
@AllArgsConstructor
public class NoticeServiceImpl implements NoticeService{	
	@Setter(onMethod_ = @Autowired)
	private NoticeMapper mapper;
	
	
	public int selectNoticeListCount(PaginationVO paginationVO) {
		
		return mapper.selectNoticeListCount(paginationVO);
	}
	
	public List<NoticeVO> selectNoticeList(PaginationVO paginationVO){
		
		return mapper.selectNoticeList(paginationVO);
	}
	
	
	@Override
	public List<NoticeVO> noticeList() {
		log.info("Notice Service List");
		return mapper.noticeList();
	}
	
	@Override
	public NoticeVO read(int notc_number) {
		log.info("Notice Service Read");
		return mapper.read(notc_number);
	}
	
	@Override
	public boolean update(NoticeVO notice) {
		log.info("Notice Service Update");
		return mapper.update(notice);
	}
	
//	public int getTotal(Criteria cri) {
//		log.info("total count..................");
//		return mapper.getTotal(cri);
//	}
	
		
		
}
