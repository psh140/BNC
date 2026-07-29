package com.bnc.domain;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/*
 * 페이지네이션 계산 + 페이지 번호 HTML 생성을 함께 담당하는 클래스.
 *
 * [페이지(page)와 블럭(block)]
 *   페이지 : 게시글 listSize개(기본 10) 묶음
 *   블럭   : 페이지 번호 blockSize개(기본 10) 묶음. 화면 하단의 "1 2 3 ... 10" 한 줄이 한 블럭이다.
 *            11페이지로 넘어가면 블럭이 바뀌어 "11 12 ... 20"이 표시된다.
 *
 * [사용 흐름]
 *   Controller가 전체 건수와 현재 페이지를 넘겨 생성 → getStartRowNumber()/getEndRowNumber()를
 *   Mapper에 넘겨 목록 조회 → JSP에서 getPageData()로 페이지 번호 HTML 출력.
 *
 * [주의] 생성자의 setter 호출 순서에 의존성이 있다. 값을 계산하는 setter들이 서로의 결과를
 *        참조하기 때문에 순서를 바꾸면 0이 들어간다. 자세한 내용은 생성자 주석 참고.
 */
public class Criteria {

	//페이당 게시글 개수
	private int listSize 	= 10;

	//블럭당 페이지 수
	private int blockSize 	= 10;

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

	/*
	 * 이전/다음 페이지 — 현재 사용되지 않는 필드.
	 * getter가 없고 setPrevPage()/setNextPage()를 호출하는 곳도 없다.
	 * 화면의 이전/다음 버튼은 getPageData()가 직접 계산한다.
	 */
	private int prevPage;
	private int nextPage;

	//조회 범위 로우 번호 (SQL의 rnum과 비교됨)
	private int startRowNumber 	= 0;
	private int endRowNumber	= 0;

	//게시글 번호 세팅
	private int listNumber;

	private String returnUri;
	private String queryString;

	Map<String, String> param = new HashMap<String, String>();

	public Criteria() {

	}

	/*
	 * listCount   : 조건에 맞는 전체 게시글 수 (COUNT 쿼리 결과)
	 * nowPage     : 현재 페이지 번호 (1부터)
	 * listSize    : 한 페이지에 보여줄 게시글 수
	 * returnUri   : 페이지 번호 링크의 기본 경로 (예: "/project/list")
	 * queryString : 현재 요청의 쿼리스트링. 검색 조건을 페이지 이동 시에도 유지하기 위해 받는다.
	 *
	 * [호출 순서를 바꾸면 안 되는 이유]
	 *   setListSize        → 이후 모든 나눗셈의 분모라서 가장 먼저 와야 한다
	 *   setTotalPageCount  → setTotalBlockCount가 totalPageCount를 나눠 쓴다
	 *   setNowBlock        → setStartPageNumber/setEndPageNumber가 nowBlock을 참조한다
	 *   setStartRowNumber  → setEndRowNumber가 startRowNumber에 listSize를 더해서 구한다
	 */
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

	//쿼리스트링이 없는 요청(첫 진입 등)에서는 null이 들어오므로 빈 문자열로 맞춘다.
	//getQueryString(int)이 equals("")로 분기하기 때문에 null이면 NPE가 난다.
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

	/*
	 * 화면에 표시할 게시글 번호의 시작값.
	 * 최신 글이 큰 번호를 갖도록 전체 건수에서 앞 페이지들의 건수를 뺀다.
	 * (예: 전체 95건, 2페이지 → 85부터 시작해 JSP에서 1씩 줄여가며 출력)
	 */
	public void setListNumber() {
		this.listNumber = this.totalRow - ((this.nowPage-1) * this.listSize);
	}

	public int getListNumber() {
		return this.listNumber;
	}

	/*
	 * 조회할 로우 범위의 시작값. Mapper에서 `rnum > startRowNumber`로 쓰이므로
	 * 이 값 자체는 포함되지 않는다 (0-based OFFSET과 같은 값).
	 * 1페이지 → 0, 2페이지 → 10
	 */
	public void setStartRowNumber()
	{
		 this.startRowNumber = (this.nowPage-1) * listSize;
	}

	public int getStartRowNumber() {
		return this.startRowNumber;
	}

	/*
	 * 조회할 로우 범위의 끝값. Mapper에서 `rnum <= endRowNumber`로 쓰여 이 값은 포함된다.
	 * 결국 조회 범위는 (startRowNumber, endRowNumber] 이고 항상 listSize건이 된다.
	 */
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

	//현재 블럭 세팅 — 1~10페이지는 1블럭, 11~20페이지는 2블럭
	public void setNowBlock() {
		this.nowBlock = (int) Math.ceil( (double)this.nowPage / (double)this.blockSize );
	}


	public int getTotalRow() {
		return totalRow;
	}


	public void setTotalRow(int totalRow) {
		this.totalRow = totalRow;
	}


	public int getTotalPageCount() {
		return totalPageCount;
	}


	//총 페이지수 세팅 — 나머지가 있으면 페이지 하나가 더 필요하므로 올림 처리
	public void setTotalPageCount(int listCount) {
		this.totalPageCount = (int) Math.ceil( (double)listCount / (double)this.listSize );
	}

	//총 블럭수 세팅 — 총 페이지 수를 블럭 크기로 나눈 올림값
	public void setTotalBlockCount() {
		this.totalBlockCount = (int) Math.ceil( (double)this.totalPageCount / (double)this.blockSize);
	}

	//총 블럭수 게터
	public int getTotalBlockCount() {
		return this.totalBlockCount;
	}

	//현재 블럭의 첫 페이지 번호 (2블럭이면 11)
	public void setStartPageNumber() {
		this.startPageNumber = (this.blockSize * (this.nowBlock-1))+1;
	}

	public int getStartPageNumber() {
		return this.startPageNumber;
	}

	/*
	 * 현재 블럭의 마지막 페이지 번호.
	 * 블럭 크기대로라면 10, 20 ... 이 되지만 마지막 블럭은 페이지가 덜 찰 수 있으므로
	 * 실제 총 페이지 수를 넘지 않도록 잘라낸다. (예: 총 13페이지면 2블럭의 끝은 20이 아니라 13)
	 */
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

	//[버그] nextPage가 아니라 prevPage에 대입하고 있다.
	//현재 이 메서드를 호출하는 곳이 없어 실제 화면에는 영향이 없다.
	public void setNextPage(int nowPage) {
		this.prevPage = nowPage + 1;
	}

	/*
	 * 페이지 번호 링크에 붙일 쿼리스트링을 만든다.
	 * 검색 조건(searchType, keyword 등)은 그대로 두고 page 값만 갈아끼우는 것이 목적이다.
	 *
	 * 주의 : 파라미터를 HashMap에 담았다가 다시 꺼내므로 원래 순서가 유지되지 않는다.
	 *        링크 문자열의 파라미터 순서가 요청마다 달라 보일 수 있으나 동작에는 문제없다.
	 */
	public String getQueryString(int pageNumber)
	{
		String queryString = "?";

		//검색 조건이 없으면 page만 붙이면 된다
		if(this.queryString.equals(""))
		{
			queryString += "page="+pageNumber;
		}
		else
		{
			String[] strArray = this.queryString.split("&");

			//기존 파라미터를 key=value로 분해해 담는다
			for(int i=0; i<strArray.length; i++)
			{
				String[] strParam = strArray[i].split("=");

				if(strParam.length == 2)
				{
					param.put(strParam[0], strParam[1]);
				}
				else
				{
					//"key=" 처럼 값이 비어 있는 경우
					param.put(strParam[0], "");
				}

			}

			//기존 page 값이 있으면 덮어쓰고, 없으면 새로 추가된다
			param.put("page", Integer.toString(pageNumber));

			Iterator<String> keys = param.keySet().iterator();

			while(keys.hasNext())
			{
				String key = keys.next();
				queryString += key+"="+param.get(key)+"&";
			}

			//마지막에 붙은 & 제거
			queryString = queryString.substring(0, queryString.length()-1);
		}

		return queryString;
	}

	/*
	 * 페이지 번호 영역 HTML을 통째로 만들어 반환한다. JSP에서 그대로 출력해 쓴다.
	 * 구성 : 《(이전 블럭) + 현재 블럭의 페이지 번호들 + 》(다음 블럭)
	 */
	public String getPageData() {

		String pageStr = "";
		pageStr += "<ul>";

		if(this.getNowBlock() >= 0){

			//이전 블럭의 마지막 페이지로 이동. 1블럭이면 갈 곳이 없으므로 1페이지로 고정한다.
			int lastPage = this.getStartPageNumber() - 1 > 0 ? this.getStartPageNumber() - 1 : 1;
			pageStr += "<a class='prev' href='"+this.returnUri+this.getQueryString(lastPage)+"'>《</a>";

		}

		//게시글이 없거나 한 페이지뿐이면 1번만 활성 상태로 출력
		if(this.getTotalPageCount() == 1 || this.getTotalPageCount() == 0)
		{
			int nPageNumber = 1;
			pageStr += "<a href='"+this.returnUri+this.getQueryString(nPageNumber)+"' class='on'>"+nPageNumber+"</a>";
		}
		else
		{
			//현재 블럭에 속한 페이지 번호만 출력한다
			for(int i=this.getStartPageNumber(); i<=this.getEndPageNumber(); i++){

				//현재 페이지는 링크 없이 활성 표시만
				if(i == this.nowPage){
					pageStr += "<a href='javascript:;' class='on'>"+i+"</a>";
				}
				else{
					pageStr += "<a href='"+this.returnUri+this.getQueryString(i)+"'>"+i+"</a>";
				}
			}
		}


		//다음 블럭의 첫 페이지로 이동. 마지막 블럭이면 더 갈 곳이 없으므로 끝 페이지에 머무른다.
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
