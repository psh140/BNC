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

## 3. pom.xml 수정

- [ ] `Bnc/pom.xml` — Oracle JDBC 드라이버 제거, PostgreSQL JDBC 드라이버 추가
- [ ] `Admin/pom.xml` — 동일

---

## 4. 쿼리 변환 + 버그 수정 (한 번에)

### Bnc 프로젝트
- [ ] `AuthMapper.xml` — `sysdate` → `NOW()`, `sign_seq.nextval` → `nextval('sign_seq')`
- [ ] `ProjectMapper.xml` — `sysdate` → `NOW()`, `ROWNUM` → `LIMIT/OFFSET`, 시퀀스 변환
- [ ] `ContractMapper.xml` — `sysdate` → `NOW()`, `<insert>` 태그로 작성된 UPDATE 3개 → `<update>` 태그로 교체
- [ ] `NoticeMapper.xml` — `sysdate` → `NOW()`, WHERE 절 뒤 잘못된 콤마 제거
- [ ] `TermsMapper.xml` — 확인 후 필요시 수정

### Admin 프로젝트
- [ ] `AuthMapper.xml` — `sysdate` → `NOW()`, `sign_seq.nextval` → `nextval('sign_seq')`
- [ ] `ProjectMapper.xml` — `sysdate` → `NOW()`, `ROWNUM` → `LIMIT/OFFSET`, 시퀀스 변환
- [ ] `NoticeMapper.xml` — `sysdate` → `NOW()`, `ROWNUM` → `LIMIT/OFFSET`, 시퀀스 변환
- [ ] `DocumentMapper.xml` — `ROWNUM` → `LIMIT/OFFSET`, 시퀀스 변환
- [ ] `MemberMapper.xml` — `ROWNUM` → `LIMIT/OFFSET`, 멀티테이블 DELETE → 단일 DELETE 2개로 분리
- [ ] `ChartMapper.xml` — `DECODE` → `CASE WHEN`, `NVL` → `COALESCE`, `CONNECT BY LEVEL` → `generate_series()`, `ROWNUM` TOP-N → `LIMIT`

---

## 5. 코드 정리

- [ ] `LongHandler.java` — Oracle LONG 전용 타입핸들러 → 삭제
- [ ] `mybatis-config.xml` (Bnc, Admin) — LongHandler 등록 제거
- [ ] `KakaoLoginConn.java` — deprecated `new JsonParser().parse()` → `JsonParser.parseString()`으로 교체

---

## 6. 인프라 구성 ✅

- [x] `Bnc/Dockerfile` 작성
- [x] `Admin/Dockerfile` 작성
- [x] `docker-compose.yml` 작성
- [x] `nginx.conf` 작성
- [x] `init.sql` 작성
- [ ] 로컬 docker-compose up 테스트

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
