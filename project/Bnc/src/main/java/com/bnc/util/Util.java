package com.bnc.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class Util {

	public static String projectTypeKr(String projectFlag)
	{
		String result = "";
		
		switch(projectFlag)
		{
			case "W":
				result = "모집중";
			break;
			
			case "C":
				result = "협의중";
			break;
			
			case "P":
				result = "진행중";
			break;
			
			case "E":
				result = "완료";
			break;
		}
		
		return result;
	}
	
	public static String removeTargetParameterQueryString(String requestQueryString, String[] removeParameter)
	{
		String queryString 			= "?";
		Map<String, String> param 	= new HashMap<String, String>();
		
		if(!requestQueryString.equals("")) 
		{
			String[] strArray = requestQueryString.split("&");
			
			for(int i=0; i<strArray.length; i++)
			{
				String[] strParam = strArray[i].split("=");
				
				if(strParam.length == 2) {
					param.put(strParam[0], strParam[1]);
				}
				else {
					param.put(strParam[0], "");
				}
			}
			
			Iterator<String> keys = param.keySet().iterator();
			
			while(keys.hasNext())
			{
				String key = keys.next();
				
				for(int i=0; i<removeParameter.length; i++)
				{
					if(!removeParameter[i].equals(key))
					{
						queryString += key+"="+param.get(key)+"&";
					}
				}
			}
			
			queryString = queryString.substring(0, queryString.length()-1);
		}
		
		return queryString;
	}
}
