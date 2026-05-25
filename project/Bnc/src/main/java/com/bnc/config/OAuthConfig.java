package com.bnc.config;

public class OAuthConfig {
	
	/* Naver Login */
	/* 인증 요청문을 구성하는 파라미터 */
    //client_id: 애플리케이션 등록 후 발급받은 클라이언트 아이디
    //response_type: 인증 과정에 대한 구분값. code로 값이 고정돼 있습니다.
    //redirect_uri: 네이버 로그인 인증의 결과를 전달받을 콜백 URL(URL 인코딩). 애플리케이션을 등록할 때 Callback URL에 설정한 정보입니다.
    //state: 애플리케이션이 생성한 상태 토큰
    public final static String N_CLIENT_ID     = System.getenv("NAVER_CLIENT_ID");
    public final static String N_CLIENT_SECRET = System.getenv("NAVER_CLIENT_SECRET");
    public final static String N_REDIRECT_URI  = System.getenv("NAVER_REDIRECT_URI");
    public final static String N_SESSION_STATE = "N_oauth_state";
    /* 프로필 조회 API URL */
    public final static String N_PROFILE_API_URL = "https://openapi.naver.com/v1/nid/me";

    /* Kakao Login */
    public final static String K_CLIENT_ID    = System.getenv("KAKAO_CLIENT_ID");
    public final static String K_REDIRECT_URI = System.getenv("KAKAO_REDIRECT_URI");
    /* 프로필 조회 API URL */
    public final static String K_PROFILE_API_URL = "https://kapi.kakao.com/v2/user/me";
}
