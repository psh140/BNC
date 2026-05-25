package com.bnc.service;

import java.util.List;

import com.bnc.domain.NoticeVO;
import com.bnc.domain.PaginationVO;

public interface NoticeService {
	
	public List<NoticeVO> noticeList();		//공지사항 목록 조회
	
	public NoticeVO read(int notc_number);     // 글 상세보기
	
	public List<NoticeVO> selectNoticeList(PaginationVO paginationVO);	//페이징
	
	public boolean update(NoticeVO notice);		//
	
	public int selectNoticeListCount(PaginationVO paginationVO);
}
