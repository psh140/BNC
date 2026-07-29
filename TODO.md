# BNC 프로젝트 작업 목록

> Oracle + Windows 환경 → PostgreSQL + Docker 전환 작업
> 어느 환경에서든 .env 파일만 바꾸면 동작하도록
>
> 실제 서버 배포는 하지 않는다. git 저장소로만 보관한다.

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

## 6. 인프라 구성 ✅

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
- [x] 소셜 로그인은 비활성 상태로 운영하기로 결정 → 6-2 / 6-3 참고

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

## 6-2. 사용자 직접 처리 항목 (보류 중)

> 코드 작업이 아니라 외부 콘솔/계정에서 발급받아야 하는 값들.

- [ ] **메일 발송 계정 재발급 후 `.env`에 `MAIL_USERNAME` / `MAIL_PASSWORD` 추가** — *사용자가 나중에 직접 처리*
  - 현재 `.env`에 두 값이 없음 → Admin의 **회원 승인 메일 발송이 동작하지 않는 상태**
  - 사용처: `Admin/servlet-context.xml:62-63`, `Admin/MemberController.java:150`
  - `docker-compose.yml`은 `env_file: .env`로 주입하므로 `.env`에 넣기만 하면 됨 (compose 수정 불필요)
  - 배경: 기존 Gmail 계정 비밀번호가 공개 저장소에 노출되어 제거함 → **기존 값 재사용 금지**,
    새 계정이나 새 앱 비밀번호를 발급할 것

- [ ] **네이버/카카오 키 발급** — *당분간 비활성 운영, 필요해지면 그때 발급* ✅ 코드 준비 완료
  - 결정: 소셜 로그인 코드는 **그대로 남겨두고 비활성 상태로 운영**. 나중에 키만 넣으면 즉시 동작.
  - 켜는 방법 (**코드 수정 불필요**):
    1. 네이버/카카오 개발자 콘솔에서 앱 등록 후 키 발급
    2. 콘솔의 Callback URL을 `.env`의 `*_REDIRECT_URI`와 동일하게 등록
    3. `.env`에 값 채우고 `docker compose up -d --force-recreate bnc-app` + `docker compose restart nginx`
  - 제공자별 독립 — 한쪽만 켜도 됨
    (네이버는 `CLIENT_ID`/`CLIENT_SECRET`/`REDIRECT_URI` 3개, 카카오는 `CLIENT_ID`/`REDIRECT_URI` 2개 필요)

---

## 6-3. 소셜 로그인 비활성화 처리 ✅

> 키 미발급 상태에서 로그인 화면에 네이버/카카오 버튼이 그대로 노출되고 있었음.
> `.env`에 `.env.example` 예시값(`your_naver_client_id`)이 그대로 들어 있어서
> 버튼을 누르면 제공자 쪽 에러 페이지로 넘어가는 상태였음.

- [x] `OAuthConfig.java` — `isNaverEnabled()` / `isKakaoEnabled()` 추가
  - 필요한 환경변수가 전부 채워졌을 때만 활성. null·공백·`your_` 예시값은 미설정으로 취급
- [x] `AuthController.login()` — 비활성 제공자는 인증 URL 자체를 생성하지 않음
- [x] `AuthController` 콜백 2개 — 비활성 상태에서 직접 접근 시 `/auth/login`으로 리다이렉트
- [x] `login.jsp` — `<c:if>`로 버튼 조건부 노출, 둘 다 꺼지면 안내 문구 표시
- [x] `.env` 예시값 제거(빈 값), `.env.example`에 켜는 방법 주석 추가
- [x] 검증 — 비활성/네이버만/양쪽 3가지 상태 전환 확인, 콜백 직접 접근 302 확인
  - 코드 재빌드 없이 `.env` 값 + 컨테이너 재생성만으로 전환되는 것 확인함

---

## 7. 주석 작업 (복잡하거나 중요한 부분) ✅

- [x] `Criteria.java` — 페이지네이션 계산 로직 (Bnc/Admin 양쪽)
  - 페이지/블럭 개념, 생성자의 setter 호출 순서 의존성, SQL rnum 과의 대응 관계
  - 미사용 필드 `prevPage`/`nextPage` 와 `setNextPage()` 의 대입 오류를 주석으로 표시
- [x] `ProjectServiceImpl.java` — 프로젝트 등록/수정 트랜잭션 흐름, 파일 업로드 처리 로직
  - 등록은 proj_number(PK) 때문에 INSERT 순서에 제약이 있음을 명시
  - 수정의 첨부파일은 "화면에 남은 것만 유지" 방식임을 설명
  - @Transactional 이 디스크 파일까지 롤백하지 못한다는 점 기록
- [x] `ProjectServiceImpl.updateProjectWorkingProcess()` — 프로젝트 상태 전이 로직
  - 양측 플래그가 일치할 때만 전이 (Y+Y→종료 E / C+C→철회 W), 불일치 시 대기
- [x] `AuthController.java` — 회원가입/기업정보 등록 흐름
  - 별도 가입 폼 없이 약관 동의 화면이 곧 가입 단계라는 점, 회원 ID 접두어 규칙
- [x] `ContractMapper.xml` — 계약서 상태 흐름 (N→Y 등 flag 의미)
  - 발주사 재작성 시 수주사 서명을 지우고 'N' 으로 되돌리는 이유 설명
- [x] `NaverLoginConn.java` / `KakaoLoginConn.java` — OAuth 인증 흐름
  - state(CSRF 방지) 용도, 두 제공자의 구현 차이, 카카오 이메일 동의항목 주의사항
- [x] `ProjectMapper.xml` — 페이지네이션 쿼리 구조
  - 3중 서브쿼리 구조와 rnum 범위, `${searchType}` 의 SQL 인젝션 주의점
- [x] `ChartMapper.xml` — 통계 쿼리 로직 (월별 집계, TOP-N 등)
  - generate_series + LEFT JOIN 으로 빈 달을 0으로 채우는 이유
- [x] `root-context.xml` — DB 연결 구조, 환경변수 연동 방식 (Bnc/Admin 양쪽)
  - HikariCP fail-fast 때문에 DB 미기동 시 전체 404 가 되는 연결고리 설명

> 검증 : 두 앱 재빌드 후 Bnc 3개·Admin 6개 페이지 200 확인.
> 변경분 9개 파일 전부 "주석만 변경, 코드 동일"을 기계적으로 대조해 확인함.

---

## 8. README 작성 ← 다음 작업

> 저장소를 처음 보는 사람이 프로젝트를 파악하고 직접 띄워볼 수 있는 수준으로 작성.
> 현재 저장소 루트의 `readme.txt.txt` 는 2020년 원본 파일이므로 정리 대상.

- [ ] 프로젝트 소개 — 어떤 서비스인지, 사용자앱(Bnc)과 관리자앱(Admin) 구성
- [ ] 기술 스택 — Spring MVC 5.2 / MyBatis / PostgreSQL 16 / Tomcat 9 / Java 8 / Docker / Nginx
- [ ] 아키텍처 — Nginx 가 앞단에서 `/` → Bnc, `/admin/` → Admin 으로 라우팅하는 구조 (다이어그램)
- [ ] 실행 방법 — `.env.example` 복사 → `docker compose up -d --build` → 접속 경로
- [ ] Oracle + Windows → PostgreSQL + Docker 전환 작업 정리
  - **아래 "README 작성용 메모" 5개 항목을 여기로 옮길 것**
  - 주요 변환 내역 : `sysdate`→`NOW()`, `ROWNUM`→`ROW_NUMBER() OVER()`,
    `DECODE`→`CASE WHEN`, `NVL`→`COALESCE`, `CONNECT BY LEVEL`→`generate_series()`
  - 전환 과정에서 발견해 고친 기존 버그 (NoticeMapper WHERE 절, ContractMapper 태그 오용 등)
- [ ] 환경변수 표 — `.env.example` 기준으로 각 항목의 용도 정리
- [ ] 소셜 로그인이 비활성 상태이며 키만 넣으면 동작한다는 점 명시
- [ ] 기존 `readme.txt.txt` 삭제 또는 내용 흡수

---

## 참고 사항

- Java 8 빌드는 Docker 내부에서 처리 → 로컬 Java 버전(11) 무관
- 파일 업로드 경로: `FILE_ROOT_PATH` 환경변수 → `/app/resources` (Docker 기본값)
- Bnc(사용자앱): 포트 8080 / Admin(관리자): 포트 8081 → Nginx가 앞단에서 라우팅
- `.env` 파일은 절대 git에 올리지 말 것

### 실행 방법

```bash
docker compose up -d --build     # 전체 기동
docker compose down              # 중지 (볼륨 유지)
docker compose down -v           # 중지 + DB 볼륨 삭제 (init.sql 재실행됨)
```

접속 : 메인 `http://localhost/` · 관리자 `http://localhost/admin/`

> 앱 컨테이너만 재생성한 경우 nginx 도 함께 재시작해야 한다 (`docker compose restart nginx`).
> 이유는 TROUBLESHOOTING.md 참고.

---

## README 작성용 메모 — Oracle → PostgreSQL 전환 이유

> 프로젝트 완성 후 README에 옮길 것

1. **라이선스/비용** — Oracle은 상용 라이선스. PostgreSQL은 완전 무료 오픈소스.
2. **Docker 이미지 크기** — Oracle XE ~2GB vs PostgreSQL ~200MB. Tomcat 2개 + Nginx와 한 머신에서 함께 띄워야 하므로 차이가 크게 체감됨.
3. **Maven 의존성** — ojdbc6이 Maven Central에 없어 별도 리포지토리 설정 필요. PostgreSQL은 의존성 한 줄로 해결.
4. **클라우드 친화성** — AWS RDS 등 클라우드 서비스에서 네이티브 지원. 현업 채택률도 높음.
5. **쿼리 변환 최소화** — Oracle 전용 문법(sysdate, ROWNUM, CONNECT BY 등)만 표준 SQL로 교체. 비즈니스 로직은 그대로 유지.
