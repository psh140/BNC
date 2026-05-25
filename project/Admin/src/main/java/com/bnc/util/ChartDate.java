package com.bnc.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
/************************************************
*메서드명 : getCalsDate

*메서드 기능 : 원하는 시점의 날짜를 찾는다.


*PARAM : string


* getCalsDate(0,1) :오늘


* getCalsDate(1,1) :년, -1(1년전 오늘),-2(2년전 오늘)


* getCalsDate(2,1) :개월, -1(1개월전 오늘),-2(2개월전 오늘), 1(1개월후 오늘)


* getCalsDate(3 or 4 or 8,1) :주, -1(일주일전 같은요일), 1(1주일후 같은요일)


* getCalsDate(5 or 6 or 7,1) :하루, -1(오늘부터 하루전), 1(오늘부터 하루후)


* getCalsDate(9,1) :12시간, -1(12시간전) 1(12시간후) 2(24시간후)


*PARAM date_type : 출력을 원하는 날짜형식


*RETURN VALUE : string


*************************************************/
public class ChartDate {
	
	public static String getCalsDate(int y,int z,String date_type) throws Exception {

	Calendar cal=Calendar.getInstance(Locale.KOREAN);
	TimeZone timezone=cal.getTimeZone();
	timezone = timezone.getTimeZone("Asia/Seoul");
	cal = Calendar.getInstance(timezone);

	cal.add(y,z);
	Date currentTime=cal.getTime();
	SimpleDateFormat formatter=new SimpleDateFormat(date_type,Locale.KOREAN);
	String timestr=formatter.format(currentTime);

	return timestr;
	}
}
