package com.bnc.mapper;

import java.util.List;

import com.bnc.domain.NoticeVO;
import com.bnc.domain.PaginationVO;

public interface NoticeMapper {
	public int selectNoticeListCount(PaginationVO paginationVO);			//전체 로우 카운팅 메소드
	
	public List<NoticeVO> selectNoticeList(PaginationVO paginationVO);	//리스트 리턴 메소드
	
	public NoticeVO read(int notc_number);		// 상세보기
	
	public void write(NoticeVO notice);			// 쓰기
	
	public int modify(NoticeVO notice);			// 수정
	
	public int delete(int notc_number);			// 삭제
	
}
