package com.bnc.domain;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class Criteria {

	//페이당 게시글 개수 
	private int listSize 	= 10; // amount
	
	//블럭당 페이지 수
	private int blockSize 	= 10; // pagesize
	
	//현재 페이지
	private int nowPage 	= 1;

	//현재 블럭
	private int nowBlock 	= 1;

	//게시글 전체 로우 수
	private int totalRow;
	
	//모든 페이지 개수
	private int totalPageCount;
	
	//모든 블럭 수
	private int totalBlockCount;
	
	//시작 페이지
	private int startPageNumber = 1;
	
	//끝 페이지
	private int endPageNumber = 1;
	
	//이전 페이지
	private int prevPage;
	
	//다음페이지
	private int nextPage;
	
	private int startRowNumber 	= 0;
	private int endRowNumber	= 0;
	
	//게시글 번호 세팅
	private int listNumber; 
	
	private String returnUri;
	private String queryString;
	
	Map<String, String> param = new HashMap<String, String>();
	
	public Criteria() {
		
	}
	
	public Criteria (int listCount, int nowPage, int listSize, String returnUri, String queryString)
	{
		//페이지당 리스트개수 설정
		setListSize(listSize);
		//현재 페이지 세팅
		setNowPage(nowPage);
		
		//총 게시글 수 (로우수 세팅)
		setTotalRow(listCount);
		
		//총 페이지 수 세팅
		setTotalPageCount(listCount);
		
		//총 블럭 수 세팅
		setTotalBlockCount();
		
		//현재 블럭 세팅
		setNowBlock();
		
		//첫번째 페이지 세팅
		setStartPageNumber();
		
		//마지막 페이지 세팅
		setEndPageNumber();

		//시작 로우넘 세팅
		setStartRowNumber();
		
		//끝 로우넘 세팅
		setEndRowNumber();
		
		//게시글 번호 세팅
		setListNumber();
		
		//URI 세팅
		setReturnUri(returnUri);
		
		//queryString 세팅
		setQueryString(queryString);
				
	}

	public String getReturnUri() {
		return returnUri;
	}

	public void setReturnUri(String returnUri) {
		this.returnUri = returnUri;
	}

	public void setQueryString(String queryString) {
		
		if(queryString != null ) {
			this.queryString = queryString;
		}
		else
		{
			this.queryString = "";
		}
	}

	public void setListSize(int listSize) {
		this.listSize = listSize;
	}
	
	public void setListNumber() {
		this.listNumber = this.totalRow - ((this.nowPage-1) * this.listSize);
	}
	
	public int getListNumber() {
		return this.listNumber;
	}
	
	public void setStartRowNumber()
	{
		 this.startRowNumber = (this.nowPage-1) * listSize;	
	}
	
	public int getStartRowNumber() {
		return this.startRowNumber;
	}
	
	public void setEndRowNumber()
	{
		 this.endRowNumber = this.startRowNumber + listSize;	
	}
	
	public int getEndRowNumber() {
		return this.endRowNumber;
	}
	

	public void setNowPage(int nowPage) {
		this.nowPage = nowPage;
	}


	public int getNowBlock() {
		return nowBlock;
	}

	//현재 블럭 세팅
	public void setNowBlock() {
		this.nowBlock = (int) Math.ceil( (double)this.nowPage / (double)this.blockSize );
	}


	public int getTotalRow() {
		return totalRow;
	}


	public void setTotalRow(int totalRow) {
		this.totalRow = totalRow;
	}


	public int getTotalPageCount() {   //여기
		return totalPageCount;
	}


	//총 게시글수 세팅
	public void setTotalPageCount(int listCount) {
		this.totalPageCount = (int) Math.ceil( (double)listCount / (double)this.listSize );
	}

	//총 블럭수 세팅
	public void setTotalBlockCount() {
		this.totalBlockCount = (int) Math.ceil( (double)this.totalPageCount / (double)this.blockSize);
	}

	//총 블럭수 게터
	public int getTotalBlockCount() {
		return this.totalBlockCount;
	}
		
	//첫번째 페이지 세팅
	public void setStartPageNumber() {
		this.startPageNumber = (this.blockSize * (this.nowBlock-1))+1;
	}
	
	public int getStartPageNumber() {
		return this.startPageNumber;
	}

	//마지막 페이지 세팅
	public void setEndPageNumber() {
		this.endPageNumber = this.blockSize * this.nowBlock;
		
		if(this.endPageNumber > this.totalPageCount)
		{
			this.endPageNumber = this.totalPageCount;
		}
	
	}
	
	public int getEndPageNumber() {
		return this.endPageNumber;
	}

	public void setPrevPage(int nowPage) {
		this.prevPage = nowPage - 1;
	}
	
	public void setNextPage(int nowPage) {
		this.prevPage = nowPage + 1;
	}
	
	public String getQueryString(int pageNumber)
	{
		String queryString = "?";
		
		if(this.queryString.equals("")) 
		{
			queryString += "page="+pageNumber; 
		}
		else
		{
			String[] strArray = this.queryString.split("&");
			
			for(int i=0; i<strArray.length; i++)
			{
				String[] strParam = strArray[i].split("=");
				
				if(strParam.length == 2)
				{
					param.put(strParam[0], strParam[1]);
				}
				else
				{
					param.put(strParam[0], "");
				}
				
			}
			
			param.put("page", Integer.toString(pageNumber));
			
			Iterator<String> keys = param.keySet().iterator();
			
			while(keys.hasNext())
			{
				String key = keys.next();
				queryString += key+"="+param.get(key)+"&";
			}
			
			queryString = queryString.substring(0, queryString.length()-1);
		}
		
		return queryString;
	}
	
	public String getPageData() {
		
		String pageStr = "";
		pageStr += "<ul>";
		
		if(this.getNowBlock() >= 0){

			int lastPage = this.getStartPageNumber() - 1 > 0 ? this.getStartPageNumber() - 1 : 1;
			pageStr += "<a class='prev' href='"+this.returnUri+this.getQueryString(lastPage)+"'>《</a>";
										    
		}
									
		if(this.getTotalPageCount() == 1 || this.getTotalPageCount() == 0)
		{
			int nPageNumber = 1;
			pageStr += "<a href='"+this.returnUri+this.getQueryString(nPageNumber)+"' class='on'>"+nPageNumber+"</a>";
		}
		else
		{
			for(int i=this.getStartPageNumber(); i<=this.getEndPageNumber(); i++){

				if(i == this.nowPage){
					pageStr += "<a href='javascript:;' class='on'>"+i+"</a>";
				}
				else{
					pageStr += "<a href='"+this.returnUri+this.getQueryString(i)+"'>"+i+"</a>";
				}
			}
		}
										
										
		if(this.getNowBlock() <= this.getTotalBlockCount()){
					
			if(this.getNowBlock() == this.getTotalBlockCount() || this.getTotalBlockCount() == 0) {
				pageStr += "<a class='next' href='"+this.returnUri+this.getQueryString(this.getEndPageNumber())+"'>》</a>";
			}
			else
			{
				pageStr += "<a class='next' href='"+this.returnUri+this.getQueryString(this.getEndPageNumber()+1)+"'>》</a>";
			}
		}
		else
		{
			pageStr += "<a class='next' href='"+this.returnUri+this.getQueryString(this.getEndPageNumber()+1)+"'>》</a>";
		}
		
		pageStr += "</ul>";
		
		return pageStr;
	}
	
}
