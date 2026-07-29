package com.bnc.oauth;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.util.StringUtils;

import com.bnc.config.OAuthConfig;
import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;

/*
 * 네이버 소셜 로그인 연동. ScribeJava 라이브러리로 OAuth 2.0 인가 코드 방식을 처리한다.
 *
 * [전체 흐름]
 *   1. getAuthorizationUrl()  : 로그인 화면에 걸 네이버 인증 URL 생성 (state 난수를 세션에 저장)
 *   2. 사용자가 네이버에서 로그인/동의
 *   3. 네이버가 N_REDIRECT_URI(/auth/naverLogin)로 code + state 를 붙여 되돌려 보냄
 *   4. getAccessToken()       : state 를 검증하고 code 를 액세스 토큰으로 교환
 *   5. getUserProfile()       : 토큰으로 프로필 API 를 호출해 id/email 획득
 *   → 이후 AuthController 가 id 로 기존 회원 여부를 판단해 로그인 또는 약관 동의 화면으로 보낸다.
 *
 * [state 파라미터] CSRF 방지용 난수. 인증 URL 을 만들 때 세션에 넣어두고 콜백에서 돌아온 값과
 *                  비교한다. 공격자가 임의로 만든 콜백 요청은 세션의 값과 달라 걸러진다.
 *
 * 키가 발급되지 않았으면 OAuthConfig.isNaverEnabled() 가 false 라 이 클래스는 호출되지 않는다.
 */
public class NaverLoginConn {
	/* 네이버 아이디로 인증  URL 생성  Method */
    public String getAuthorizationUrl(HttpSession session) {

        /* 세션 유효성 검증을 위하여 난수를 생성 */
        String state = generateRandomString();
        /* 생성한 난수 값을 session에 저장 */
        setSession(session,state);        

        /* Scribe에서 제공하는 인증 URL 생성 기능을 이용하여 네아로 인증 URL 생성 */
        OAuth20Service oauthService = new ServiceBuilder()                                                   
                .apiKey(OAuthConfig.N_CLIENT_ID)
                .apiSecret(OAuthConfig.N_CLIENT_SECRET)
                .callback(OAuthConfig.N_REDIRECT_URI)
                .state(state) //앞서 생성한 난수값을 인증 URL생성시 사용함
                .build(NaverLoginApi.instance());

        return oauthService.getAuthorizationUrl();
    }

    /* 네이버아이디로 Callback 처리 및  AccessToken 획득 Method */
    public OAuth2AccessToken getAccessToken(HttpSession session, String code, String state) throws IOException{

        /* Callback으로 전달받은 세선검증용 난수값과 세션에 저장되어있는 값이 일치하는지 확인 */
        // 일치하지 않으면 아래 return null 로 빠진다. 호출부(AuthController)에서 null 체크를 하지 않으므로
        // 이 경우 프로필 조회 단계에서 NPE 가 발생한다.
        String sessionState = getSession(session);
        if(StringUtils.pathEquals(sessionState, state)){

            OAuth20Service oauthService = new ServiceBuilder()
                    .apiKey(OAuthConfig.N_CLIENT_ID)
                    .apiSecret(OAuthConfig.N_CLIENT_SECRET)
                    .callback(OAuthConfig.N_REDIRECT_URI)
                    .state(state)
                    .build(NaverLoginApi.instance());

            /* Scribe에서 제공하는 AccessToken 획득 기능으로 네아로 Access Token을 획득 */
            OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
            return accessToken;
        }
        return null;
    }

    /* 세션 유효성 검증을 위한 난수 생성기 */
    private String generateRandomString() {
        return UUID.randomUUID().toString();
    }

    /* http session에 데이터 저장 */
    private void setSession(HttpSession session,String state){
        session.setAttribute(OAuthConfig.N_SESSION_STATE, state);     
    }

    /* http session에서 데이터 가져오기 */ 
    private String getSession(HttpSession session){
        return (String) session.getAttribute(OAuthConfig.N_SESSION_STATE);
    }
    /* Access Token을 이용하여 네이버 사용자 프로필 API를 호출 */
    public String getUserProfile(OAuth2AccessToken oauthToken) throws IOException{

        OAuth20Service oauthService =new ServiceBuilder()
                .apiKey(OAuthConfig.N_CLIENT_ID)
                .apiSecret(OAuthConfig.N_CLIENT_SECRET)
                .callback(OAuthConfig.N_REDIRECT_URI).build(NaverLoginApi.instance());

            OAuthRequest request = new OAuthRequest(Verb.GET, OAuthConfig.N_PROFILE_API_URL, oauthService);
        oauthService.signRequest(oauthToken, request);
        Response response = request.send();
        return response.getBody();
    }
}
