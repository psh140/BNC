# BNC 프로젝트 작업 목록

> Oracle + Windows 환경 → PostgreSQL + Docker + EC2(Linux) 전환 작업
> 로컬(Mac) / Docker / EC2 어디서든 .env 파일만 바꾸면 동작하도록

---

## 1. Git 세팅 (형상관리)

> SVN → Git 전환. 현재 `.svn/` 폴더 잔재 있음, `.git`은 이미 존재

- [ ] `.svn/` 디렉터리 전부 삭제 (`find . -name ".svn" -type d` 로 위치 확인 후 제거)
- [ ] `.gitignore` 작성
  ```
  # Eclipse 잔재
  .classpath
  .project
  .settings/
  .springBeans
  .metadata/
  .svn/

  # IntelliJ
  .idea/
  *.iml

  # Maven 빌드 결과물
  target/

  # 환경변수 (절대 커밋 금지)
  .env

  # OS
  .DS_Store
  Thumbs.db
  ```
- [ ] 첫 커밋 전 `git status`로 불필요한 파일 staged 여부 확인
- [ ] GitHub(또는 원하는 원격 저장소)에 원격 저장소 생성 후 연결

---

## 2. 환경 설정 분리 (코드 변경)

- [ ] `Bnc/UtilConfig.java` — 파일 경로 하드코딩 → `System.getenv()` 환경변수로 교체
- [ ] `Admin/UtilConfig.java` — 동일
- [ ] `Bnc/root-context.xml` — DB 접속정보(URL, username, password) → 환경변수로 교체
- [ ] `Admin/root-context.xml` — 동일
- [ ] `Bnc/OAuthConfig.java` — 네이버/카카오 키, 리다이렉트 URI → 환경변수로 교체
- [ ] `.env.example` 파일 작성 (키 목록 템플릿, 값은 비워서 git에 포함)

---

## 3. IntelliJ 프로젝트 세팅

> 기존 Eclipse STS 프로젝트를 IntelliJ에서 열기

- [ ] IntelliJ에서 Bnc 열기: `File → Open → project/Bnc/pom.xml` 선택 → Open as Project
- [ ] IntelliJ에서 Admin 열기: 동일 방법
- [ ] Maven 의존성 다운로드 확인 (`Reload All Maven Projects`)
- [ ] IntelliJ Tomcat 로컬 실행 설정 (Docker 없이 테스트할 때)
  - `Run/Debug Configurations → + → Tomcat Server → Local`
  - Tomcat 9.0 경로 지정, Deployment 탭에서 WAR 추가

---

## 4. Oracle → PostgreSQL 쿼리 변환 (최소 변경 원칙)

### Bnc 프로젝트
- [ ] `AuthMapper.xml` — `sysdate` → `NOW()`, `sign_seq.nextval` → `nextval('sign_seq')`
- [ ] `ProjectMapper.xml` — `sysdate` → `NOW()`, `ROWNUM` 페이지네이션 → `LIMIT/OFFSET`, `bnc_project_seq.nextval from dual` → `nextval('bnc_project_seq')`, `bnc_project_file_seq.nextval` → `nextval('bnc_project_file_seq')`
- [ ] `ContractMapper.xml` — `sysdate` → `NOW()`
- [ ] `NoticeMapper.xml` — `sysdate` → `NOW()` (Bnc쪽 UPDATE 문법 오류도 같이 수정)
- [ ] `TermsMapper.xml` — 확인 후 필요시 수정

### Admin 프로젝트
- [ ] `AuthMapper.xml` — `sysdate` → `NOW()`, `sign_seq.nextval` → `nextval('sign_seq')`
- [ ] `ProjectMapper.xml` — `sysdate` → `NOW()`, `ROWNUM` 페이지네이션 → `LIMIT/OFFSET`, 시퀀스 변환
- [ ] `NoticeMapper.xml` — `sysdate` → `NOW()`, `ROWNUM` → `LIMIT/OFFSET`, `bnc_notice_seq.nextval` → `nextval('bnc_notice_seq')`
- [ ] `DocumentMapper.xml` — `ROWNUM` → `LIMIT/OFFSET`, `BNC_DOCUMENT_SEQ.nextval` → `nextval('bnc_document_seq')`
- [ ] `MemberMapper.xml` — `ROWNUM` → `LIMIT/OFFSET`, 멀티테이블 DELETE → 단일 DELETE 2개로 분리
- [ ] `ChartMapper.xml` — `DECODE` → `CASE WHEN`, `NVL` → `COALESCE`, `CONNECT BY LEVEL` → `generate_series()`, `ROWNUM` TOP-N → `LIMIT`

---

## 5. 원본 코드 버그 수정

- [ ] `ContractMapper.xml` — `<insert>` 태그로 작성된 UPDATE 3개 → `<update>` 태그로 교체
- [ ] `NoticeMapper.xml` (Bnc) — UPDATE 문에서 WHERE 절 뒤 잘못된 콤마 제거
- [ ] `MemberMapper.xml` — 멀티테이블 DELETE 문법 오류 수정 (2번 항목과 함께)

---

## 6. 코드 정리

- [ ] `LongHandler.java` — Oracle LONG 전용 타입핸들러, PostgreSQL TEXT로 전환 후 불필요 → 삭제
- [ ] `mybatis-config.xml` (Bnc, Admin) — LongHandler 등록 제거
- [ ] `KakaoLoginConn.java` — deprecated `new JsonParser().parse()` → `JsonParser.parseString()`으로 교체

---

## 7. 주석 작업 (복잡하거나 중요한 부분)

- [ ] `Criteria.java` — 페이지네이션 계산 로직 (startRowNumber/endRowNumber/block 계산)
- [ ] `ProjectServiceImpl.java` — 프로젝트 등록/수정 트랜잭션 흐름, 파일 업로드 처리 로직
- [ ] `ProjectServiceImpl.updateProjectWorkingProcess()` — 프로젝트 상태 전이 로직 (철회/완료 분기)
- [ ] `AuthController.java` — 회원가입/기업정보 등록 흐름, 파일 업로드 처리 부분
- [ ] `ContractMapper.xml` — 계약서 상태 흐름 (N→Y 등 flag 의미)
- [ ] `NaverLoginConn.java` / `KakaoLoginConn.java` — OAuth 인증 흐름
- [ ] `ProjectMapper.xml` — 페이지네이션 쿼리 구조
- [ ] `ChartMapper.xml` — 통계 쿼리 로직 (월별 집계, TOP-N 등)
- [ ] `root-context.xml` — DB 연결 구조, 환경변수 연동 방식

---

## 8. 인프라 구성

- [ ] `Bnc/Dockerfile` 작성 (maven:3.8-openjdk-8 빌드 → tomcat:9.0-jdk8 실행)
- [ ] `Admin/Dockerfile` 작성 (동일 구조)
- [ ] `docker-compose.yml` 작성
  - services: postgres, bnc-app, admin-app, nginx
  - named volume: resources (파일 업로드 공유), postgres_data
  - env_file: .env
- [ ] `nginx.conf` 작성
  - `/` → bnc-app:8080 프록시
  - `/admin` → admin-app:8080 프록시
  - `/resources/` → 업로드 파일 볼륨에서 직접 서빙
- [ ] `init.sql` 작성 — Oracle DDL → PostgreSQL DDL 변환
  - VARCHAR2 → VARCHAR, NUMBER → INTEGER, LONG → TEXT
  - Oracle 스토리지 옵션 전부 제거
  - SEQUENCE 문법 변환
  - 기초 데이터 INSERT (BNC_ADMIN, BNC_BIZ_CATEGORY 등)
- [ ] 로컬 docker-compose up 테스트

---

## 9. EC2 배포

- [ ] EC2 인스턴스 생성 (Ubuntu 22.04 LTS, t2.small 이상 권장)
- [ ] EC2 보안 그룹 설정 (80, 443, 22 포트 개방 / 8080·8081·5432 외부 차단)
- [ ] Docker + Docker Compose 설치
- [ ] 코드 업로드 (git clone 또는 scp)
- [ ] `.env` 파일 EC2에 직접 작성 (git에 포함 안 됨)
- [ ] `docker-compose up -d` 실행
- [ ] 네이버/카카오 개발자 콘솔에서 새 앱 등록 + 콜백 URL을 EC2 IP로 등록
- [ ] `OAuthConfig.java` 키값 교체 후 재배포

---

## 참고 사항

- Java 8 빌드는 Docker 내부에서 처리 → 로컬 Java 버전(11) 무관
- 파일 업로드 경로: `FILE_ROOT_PATH` 환경변수 → `/app/resources` (Docker 기본값)
- Bnc(사용자앱): 포트 8080 / Admin(관리자): 포트 8081 → Nginx가 앞단에서 라우팅
- 도메인 없이 EC2 IP로도 동작 가능 (HTTPS는 도메인 확보 후 추가)
- `.env` 파일은 절대 git에 올리지 말 것
