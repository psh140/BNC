package com.bnc.service;

import java.util.List;

import com.bnc.domain.NoticeVO;
import com.bnc.domain.PaginationVO;

public interface NoticeService {

	public int selectNoticeListCount(PaginationVO paginationVO);
	
	public List<NoticeVO> selectNoticeList(PaginationVO paginationVO);
	
	public NoticeVO read(int notc_number);
	
	public void write(NoticeVO notice);
	
	public boolean modify(NoticeVO notice); 
	
	public boolean delete(int notc_number);
}
