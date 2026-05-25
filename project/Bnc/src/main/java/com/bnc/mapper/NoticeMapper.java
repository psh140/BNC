package com.bnc.mapper;

import java.util.List;

import com.bnc.domain.Criteria;
import com.bnc.domain.NoticeVO;
import com.bnc.domain.PaginationVO;

public interface NoticeMapper {
	public List<NoticeVO> getList(Criteria cri);		//리스트 페이징
	
	public List<NoticeVO> noticeList();		//공지사항 목록 조회
	
	public int selectNoticeListCount(PaginationVO paginationVO);		//전체 로우 카운팅 메소드
	
	public List<NoticeVO> selectNoticeList(PaginationVO paginationVO);	//리스트 리턴 메소드
	
	public NoticeVO read(int notc_number);			//상세보기
	
	public int getTotal(Criteria cri);

	public boolean update(NoticeVO notice);
}
