# BNC 프로젝트 작업 목록

> Oracle + Windows 환경 → PostgreSQL + Docker + EC2(Linux) 전환 작업
> 로컬(Mac) / Docker / EC2 어디서든 .env 파일만 바꾸면 동작하도록

---

## 1. Git 세팅 ✅

- [x] `.svn/` 디렉터리 전부 삭제
- [x] `.gitignore` 작성
- [x] `git status`로 불필요한 파일 staged 여부 확인
- [x] GitHub 원격 저장소 연결 및 첫 커밋 push

---

## 2. 환경 설정 분리 ✅

- [x] `Bnc/UtilConfig.java` — 파일 경로 → `System.getenv()`
- [x] `Admin/UtilConfig.java` — 동일
- [x] `Bnc/root-context.xml` — DB 접속정보 → Spring EL 환경변수, PostgreSQL 드라이버로 교체
- [x] `Admin/root-context.xml` — 동일
- [x] `Bnc/OAuthConfig.java` — 네이버/카카오 키, 리다이렉트 URI → `System.getenv()`
- [x] `.env.example` 파일 작성

---

## 3. pom.xml 수정 ✅

- [x] `Bnc/pom.xml` — Oracle JDBC 드라이버 제거, PostgreSQL JDBC 드라이버 추가, Gson 2.10.1 업그레이드
- [x] `Admin/pom.xml` — 동일

---

## 4. 쿼리 변환 + 버그 수정 ✅

### Bnc 프로젝트
- [x] `AuthMapper.xml` — `sysdate` → `NOW()`, `sign_seq.nextval` → `nextval('sign_seq')`
- [x] `ProjectMapper.xml` — `sysdate` → `NOW()`, `ROWNUM` → `ROW_NUMBER() OVER()`, 시퀀스 변환
- [x] `ContractMapper.xml` — `sysdate` → `NOW()`, `<insert>` 태그 UPDATE 3개 → `<update>` 태그로 교체
- [x] `NoticeMapper.xml` — `sysdate` → `NOW()`, WHERE 절 잘못된 콤마 제거, `n_udate` → `notc_udate` 수정
- [x] `CompanyMapper.xml` — `ROWNUM` → `ROW_NUMBER() OVER()` (TODO 누락 파일 추가 변환)
- [x] `TermsMapper.xml` — 변경 불필요 확인

### Admin 프로젝트
- [x] `AuthMapper.xml` — 변경 불필요 확인
- [x] `ProjectMapper.xml` — `ROWNUM` → `ROW_NUMBER() OVER()`
- [x] `NoticeMapper.xml` — `sysdate` → `NOW()`, `ROWNUM` → `ROW_NUMBER() OVER()`, 시퀀스 변환
- [x] `DocumentMapper.xml` — `ROWNUM` → `ROW_NUMBER() OVER()`, 시퀀스 변환
- [x] `MemberMapper.xml` — `ROWNUM` → `ROW_NUMBER() OVER()`, 멀티테이블 DELETE → CTE 방식으로 처리
- [x] `ChartMapper.xml` — `DECODE` → `CASE WHEN`, `NVL` → `COALESCE`, `CONNECT BY LEVEL` → `generate_series()`, `ROWNUM` TOP-N → `LIMIT 1`
- [x] `CompanyMapper.xml` — `ROWNUM` → `ROW_NUMBER() OVER()`, `sysdate` → `NOW()`
- [x] `TermsMapper.xml` — `sysdate` → `NOW()`

---

## 5. 코드 정리 ✅

- [x] `LongHandler.java` — 삭제 (Bnc, Admin 양쪽)
- [x] `mybatis-config.xml` (Bnc, Admin) — LongHandler 등록 제거
- [x] `KakaoLoginConn.java` — deprecated `new JsonParser().parse()` → `JsonParser.parseString()`으로 교체

---

## 6. 인프라 구성

- [x] `Bnc/Dockerfile` 작성
- [x] `Admin/Dockerfile` 작성
- [x] `docker-compose.yml` 작성
- [x] `nginx.conf` 작성 (Admin 라우팅 `/admin/` → `admin-app:8080/` 경로 변환 포함)
- [x] `init.sql` 작성
- [x] 로컬 docker-compose up 테스트 — 메인(`/`), 로그인(`/auth/login`), Admin(`/admin/auth/login`) 모두 200 확인
- [x] `docker-compose.yml` — bnc-app(8080:8080), admin-app(8081:8080) 포트 외부 노출 추가
- [x] `init.sql` 첫 실행 에러로 인한 데이터 누락 수정 — `docker-compose down -v` 볼륨 재초기화 후 정상 확인 (bnc_member=8, bnc_company=8, bnc_admin=1, bnc_project=17)
- [x] Admin `head.jsp` — 정적 리소스 경로 `/common/**` → `/admin/common/**` 전체 수정
- [x] Admin `header.jsp` — 모든 nav 링크에 `/admin/` prefix 추가
- [x] nginx `proxy_redirect` 동작 원리 확인 — `LoginInterceptor`는 `/auth/login` 유지 (nginx가 자동으로 `/admin/auth/login`으로 변환)
- [ ] **OAuth 키 발급 후 .env 수정** — 사용할 제공자 미확정 (아래 6-2 참고)

---

## 6-2. 사용자 직접 처리 항목 (보류 중)

> 코드 작업이 아니라 외부 콘솔/계정에서 발급받아야 하는 값들.

- [ ] **메일 발송 계정 재발급 후 `.env`에 `MAIL_USERNAME` / `MAIL_PASSWORD` 추가** — *사용자가 나중에 직접 처리*
  - 현재 `.env`에 두 값이 없음 → Admin의 **회원 승인 메일 발송이 동작하지 않는 상태**
  - 사용처: `Admin/servlet-context.xml:62-63`, `Admin/MemberController.java:150`
  - `docker-compose.yml`은 `env_file: .env`로 주입하므로 `.env`에 넣기만 하면 됨 (compose 수정 불필요)
  - 배경: 기존 Gmail 계정 비밀번호가 공개 저장소에 노출되어 제거함 → **기존 값 재사용 금지**,
    새 계정이나 새 앱 비밀번호를 발급할 것

- [ ] **소셜 로그인 제공자 확정 후 키 발급** — *제공자 미확정 상태*
  - 현재 코드는 **네이버/카카오**로 구현되어 있음 (`Bnc/oauth/NaverLoginConn.java`,
    `NaverLoginApi.java`, `KakaoLoginConn.java`, `config/OAuthConfig.java`)
  - 네이버/카카오를 그대로 쓸 경우: 개발자 콘솔에서 키 발급 후 redirect URI를
    `http://localhost/auth/naverLogin`, `http://localhost/auth/kakaoLogin`으로 등록
  - 다른 제공자로 교체할 경우: 위 클래스들과 `.env.example`, `login.jsp` 버튼까지 함께 수정 필요

---

## 6-1. Admin JSP 정적 리소스 경로 전수조사 ✅

> `head.jsp` / `header.jsp`는 수정 완료. 그러나 각 페이지별 JSP 파일에서도
> `/common/` 절대경로를 직접 사용하는 경우가 있음 → nginx가 Bnc 앱으로 잘못 라우팅됨.
> 발견된 사례: `member/list.jsp`의 `src="/common/image/icon_search.png"`

- [x] `Admin` 프로젝트 전체 JSP 파일에서 `/common/` 경로 grep — 13개 파일 13건 발견
  - 검색 아이콘 5건: `member/list`, `document/list`, `notice/list`, `project/list`, `company/list`
  - 이미지 2건: `member/modify`(thumb_add), `company/view`(ci_thumb_default)
  - 스마트에디터 스킨 `sSkinURI` 6건: `notice/write`·`notice/modify`, `document/write`·`document/modify`,
    `terms/termsAndConditions/modify`, `terms/privacyPolicy/modify`
- [x] 발견된 모든 경로를 `/admin/common/`으로 수정
  - `<%@ include file="../common/..." %>`(JSP 컴파일 시점 상대경로)와
    `chart/view.jsp`의 `src="../common/..."`(브라우저 상대경로)는 정상 동작 → 수정 대상 아님
  - JS/CSS 파일에는 절대경로 `/common/` 참조 없음 확인
- [x] docker-compose 재빌드 후 각 페이지 정상 렌더링 확인
  - 정적 리소스 4종 200 확인 (수정 전 `/common/image/icon_search.png`는 404였음)
  - 관리자 로그인 후 12개 페이지 전부 200, 렌더된 HTML에 `/common/` 잔존 0건
  - `terms/*/modify`는 `?pol_kind=P|T` 파라미터 필수 (없으면 400 — 정상 동작)

---

## 7. 주석 작업 (복잡하거나 중요한 부분)

- [ ] `Criteria.java` — 페이지네이션 계산 로직
- [ ] `ProjectServiceImpl.java` — 프로젝트 등록/수정 트랜잭션 흐름, 파일 업로드 처리 로직
- [ ] `ProjectServiceImpl.updateProjectWorkingProcess()` — 프로젝트 상태 전이 로직
- [ ] `AuthController.java` — 회원가입/기업정보 등록 흐름
- [ ] `ContractMapper.xml` — 계약서 상태 흐름 (N→Y 등 flag 의미)
- [ ] `NaverLoginConn.java` / `KakaoLoginConn.java` — OAuth 인증 흐름
- [ ] `ProjectMapper.xml` — 페이지네이션 쿼리 구조
- [ ] `ChartMapper.xml` — 통계 쿼리 로직 (월별 집계, TOP-N 등)
- [ ] `root-context.xml` — DB 연결 구조, 환경변수 연동 방식

---

## 8. EC2 배포

- [ ] EC2 인스턴스 생성 (Ubuntu 22.04 LTS, t2.small 이상 권장)
- [ ] EC2 보안 그룹 설정 (80, 443, 22 포트 개방 / 8080·8081·5432 외부 차단)
- [ ] Docker + Docker Compose 설치
- [ ] 코드 업로드 (git clone 또는 scp)
- [ ] `.env` 파일 EC2에 직접 작성 (git에 포함 안 됨)
- [ ] `docker-compose up -d` 실행
- [ ] 네이버/카카오 개발자 콘솔에서 새 앱 등록 + 콜백 URL을 EC2 IP로 등록

---

## 참고 사항

- Java 8 빌드는 Docker 내부에서 처리 → 로컬 Java 버전(11) 무관
- 파일 업로드 경로: `FILE_ROOT_PATH` 환경변수 → `/app/resources` (Docker 기본값)
- Bnc(사용자앱): 포트 8080 / Admin(관리자): 포트 8081 → Nginx가 앞단에서 라우팅
- 도메인 없이 EC2 IP로도 동작 가능 (HTTPS는 도메인 확보 후 추가)
- `.env` 파일은 절대 git에 올리지 말 것

---

## README 작성용 메모 — Oracle → PostgreSQL 전환 이유

> 프로젝트 완성 후 README에 옮길 것

1. **라이선스/비용** — Oracle은 상용 라이선스. PostgreSQL은 완전 무료 오픈소스.
2. **Docker 이미지 크기** — Oracle XE ~2GB vs PostgreSQL ~200MB. EC2 소형 인스턴스에서 Tomcat 2개 + Nginx와 함께 실행해야 하므로 메모리 부담이 큼.
3. **Maven 의존성** — ojdbc6이 Maven Central에 없어 별도 리포지토리 설정 필요. PostgreSQL은 의존성 한 줄로 해결.
4. **클라우드 친화성** — AWS RDS 등 클라우드 서비스에서 네이티브 지원. 현업 채택률도 높음.
5. **쿼리 변환 최소화** — Oracle 전용 문법(sysdate, ROWNUM, CONNECT BY 등)만 표준 SQL로 교체. 비즈니스 로직은 그대로 유지.
