package com.bnc.oauth;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.bnc.config.OAuthConfig;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/*
 * 카카오 소셜 로그인 연동.
 *
 * 네이버(NaverLoginConn)는 ScribeJava 라이브러리를 쓰지만 이쪽은 HttpURLConnection 으로
 * 카카오 API 를 직접 호출한다. 구현 방식만 다를 뿐 흐름은 같다.
 *   1. getAuthorizationUrl() : 인증 URL 생성
 *   2. 카카오가 K_REDIRECT_URI(/auth/kakaoLogin)로 code 를 붙여 되돌려 보냄
 *   3. getAccessToken(code)  : code 를 액세스 토큰으로 교환
 *   4. getUserInfo(token)    : 토큰으로 프로필 API 를 호출해 id/email 획득
 *
 * [네이버와 다른 점]
 *   - state(CSRF 방지 난수)를 쓰지 않는다. 그래서 getAuthorizationUrl 의 session 파라미터도
 *     실제로는 사용되지 않는다.
 *   - client_secret 없이 client_id 만으로 동작한다.
 *
 * 키가 발급되지 않았으면 OAuthConfig.isKakaoEnabled() 가 false 라 이 클래스는 호출되지 않는다.
 */
@Service
public class KakaoLoginConn {
	private String AuthorizationBaseUrl = "https://kauth.kakao.com/oauth/authorize?";

	//session 파라미터는 NaverLoginConn 과 시그니처를 맞추기 위한 것으로 여기서는 쓰이지 않는다
	public String getAuthorizationUrl(HttpSession session) {
		String kakaoUrl = AuthorizationBaseUrl+"client_id="+OAuthConfig.K_CLIENT_ID
							+"&redirect_uri="+OAuthConfig.K_REDIRECT_URI+"&response_type=code";
		return kakaoUrl;
	}
	
    /*
     * 인가 코드를 액세스 토큰으로 교환한다.
     * 실패 시 예외를 던지지 않고 빈 문자열을 반환하므로, 호출부에서 이어지는 getUserInfo() 가
     * 빈 토큰으로 API 를 호출하게 된다. (원인 파악이 어려운 형태라 로그 확인이 필요하다)
     */
    public String getAccessToken (String authorize_code) {
        String access_Token = "";
        String refresh_Token = "";   //발급은 받지만 저장하지 않는다 (자동 재로그인 미구현)
        String reqURL = "https://kauth.kakao.com/oauth/token";
        
        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            
            //    POST 요청을 위해 기본값이 false인 setDoOutput을 true로
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            
            //    POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
            StringBuilder sb = new StringBuilder();
            sb.append("grant_type=authorization_code");
            sb.append("&client_id="+OAuthConfig.K_CLIENT_ID);
            sb.append("&redirect_uri="+OAuthConfig.K_REDIRECT_URI);
            sb.append("&code=" + authorize_code);
            bw.write(sb.toString());
            bw.flush();
            
            //    결과 코드가 200이라면 성공
            int responseCode = conn.getResponseCode();
//            System.out.println("responseCode : " + responseCode);
 
            //    요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line = "";
            String result = "";
            
            while ((line = br.readLine()) != null) {
                result += line;
            }
//            System.out.println("response body : " + result);
            
            //    Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
            JsonElement element = JsonParser.parseString(result);
            
            access_Token = element.getAsJsonObject().get("access_token").getAsString();
            refresh_Token = element.getAsJsonObject().get("refresh_token").getAsString();
            
//            System.out.println("access_token : " + access_Token);
//            System.out.println("refresh_token : " + refresh_Token);
            
            br.close();
            bw.close();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } 
        
        return access_Token;
    }
	
/*
 * 액세스 토큰으로 카카오 프로필을 조회해 id 와 email 을 꺼낸다.
 *
 * email 은 카카오 앱 설정에서 '동의항목'으로 켜두고 사용자가 동의해야만 내려온다.
 * 동의하지 않으면 kakao_account 에 email 키가 없어 NPE 가 발생하니, 키 발급 시
 * 개발자 콘솔에서 이메일 수집 동의 설정을 반드시 확인할 것.
 */
public HashMap<String, Object> getUserInfo (String access_Token) {
        
        //    요청하는 클라이언트마다 가진 정보가 다를 수 있기에 HashMap타입으로 선언
        HashMap<String, Object> userInfo = new HashMap<>();
        String reqURL = "https://kapi.kakao.com/v2/user/me";
        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            
            //    요청에 필요한 Header에 포함될 내용
            conn.setRequestProperty("Authorization", "Bearer " + access_Token);
            
            int responseCode = conn.getResponseCode();
//            System.out.println("responseCode : " + responseCode);
            
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            
            String line = "";
            String result = "";
            
            while ((line = br.readLine()) != null) {
                result += line;
            }
            
//            System.out.println("response body : " + result);
            
            JsonElement element = JsonParser.parseString(result);
            
            JsonObject kakao_account = element.getAsJsonObject().get("kakao_account").getAsJsonObject();
            
            String id = element.getAsJsonObject().get("id").getAsString();          
            String email = kakao_account.getAsJsonObject().get("email").getAsString();

            
//            System.out.println("id => "+id);
//            System.out.println("email => "+email);
           
            //userInfo에 정보 입력
            userInfo.put("id", id);
            userInfo.put("email", email);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        return userInfo;
    }
}
