# 마이그레이션 기록

2020년 Oracle + Windows 환경에서 개발된 BNC를 2026년에 PostgreSQL + Docker 환경으로 이관한 기록이다. [README](README.md)의 "레거시 재생 작업" 절을 상세화한 문서다.

원칙은 하나였다. **비즈니스 로직은 건드리지 않는다.** Oracle 전용 문법과 실행 환경 의존성만 걷어내고, 화면·서비스·트랜잭션 구조는 원본을 유지했다.

---

## 1. 왜 PostgreSQL인가

| 이유 | 내용 |
|---|---|
| 라이선스·비용 | Oracle은 상용 라이선스. PostgreSQL은 제약 없는 오픈소스 |
| 이미지 크기 | Oracle XE 약 2GB vs PostgreSQL 약 200MB. Tomcat 2개 + Nginx를 한 머신에 함께 띄우는 구성이라 차이가 체감된다 |
| 의존성 확보 | `ojdbc6`은 Maven Central에 없어 외부 리포지토리를 따로 등록해야 한다. PostgreSQL 드라이버는 의존성 한 줄로 끝난다 |
| 클라우드 친화성 | AWS RDS 등에서 네이티브 지원. 현업 채택률도 높다 |
| 전환 비용 | 표준 SQL 비중이 높아, Oracle 전용 문법만 교체하면 로직은 그대로 유지된다 |

세 번째 항목이 결정적이었다. 원본 `pom.xml`은 `ojdbc6` 때문에 `datanucleus.org`의 HTTP 리포지토리를 등록해 두고 있었는데, 이 외부 저장소에 의존하는 한 빌드 재현성이 없다. 드라이버 교체가 곧 빌드 복구였다.

---

## 2. SQL 방언 변환

매퍼 XML **17개 중 12개**를 수정했다. 나머지 5개(`Bnc/TermsMapper`, `Admin/AuthMapper`, `MailFormMapper`, `TestMapper` 등)는 표준 SQL만 사용해 변경이 필요 없었다.

### 2-1. 날짜·시간

| Oracle | PostgreSQL | 영향 파일 |
|---|---|---|
| `TO_CHAR(sysdate, 'YYYYMMDDHHmmss')` | `TO_CHAR(NOW(), 'YYYYMMDDHH24MISS')` | Bnc: `AuthMapper`(7) `ContractMapper`(4) `ProjectMapper`(4) `NoticeMapper`(1)<br>Admin: `NoticeMapper`(3) `CompanyMapper`(1) `TermsMapper`(1) |

이 프로젝트는 날짜를 `timestamp`가 아니라 `VARCHAR(14)` 문자열(`YYYYMMDDHHMISS`)로 저장한다. 원본 설계를 유지하기로 했으므로 컬럼 타입은 바꾸지 않고 `sysdate` → `NOW()`만 교체했다.

**포맷 마스크도 함께 고쳤다.** 원본의 `'YYYYMMDDHHmmss'`는 Oracle에서도 의도대로 동작하지 않는다. Oracle과 PostgreSQL 모두 포맷 모델에서 `MM`은 **월**, 분은 `MI`다. 대소문자를 구분하지 않으므로 `mm` 역시 월로 해석된다. 즉 원본은 분이 들어갈 자리에 월을 한 번 더 쓰고 있었고, `HH`는 12시간제라 오전·오후 구분도 없었다.

```
원본  'YYYYMMDDHHmmss'   → 2020 12 02 03 12 45   (분 자리에 월, 12시간제)
수정  'YYYYMMDDHH24MISS' → 2020 12 02 15 27 45   (24시간제, 분)
```

**이 오류는 원본 데이터로도 확인된다.** 시드 데이터의 14자리 타임스탬프 122개(고유값)에서 분 자리에 나타나는 값은 단 세 가지다.

| 분 자리 값 | 건수 | 해당 레코드의 월 |
|---|---|---|
| `00` | 89 | — (수동 입력된 정각 값) |
| `12` | 17 | 12월 |
| `11` | 16 | 11월 |

분이 실제로 기록됐다면 00~59에 고르게 퍼져야 하는데, 앱이 INSERT한 레코드는 예외 없이 **분 자리 값이 그 레코드의 월과 일치**한다. 2020년 당시부터 분은 한 번도 저장된 적이 없었다는 뜻이다.

기존 데이터는 소급 수정하지 않았다. 정렬과 범위 조회가 상위 8자리(`YYYYMMDD`)에만 의존해 화면 동작에 영향이 없고, 시드 데이터를 고치면 2020년 원본 데이터가 아니게 되기 때문이다.

### 2-2. 시퀀스

| Oracle | PostgreSQL | 영향 파일 |
|---|---|---|
| `seq.nextval` | `nextval('seq')` | Bnc: `AuthMapper` `ProjectMapper`(2)<br>Admin: `DocumentMapper` `NoticeMapper` |
| `select seq.nextval from dual` | `select nextval('seq')` | Bnc: `ProjectMapper` |

`IDENTITY` 컬럼으로 바꾸는 선택지도 있었으나 채택하지 않았다. 이 프로젝트는 `proj_number`(PK)를 INSERT 전에 미리 확보해서 첨부파일 테이블에 함께 넣는 구조라, 시퀀스를 명시적으로 호출하는 흐름을 유지하는 편이 코드 변경을 최소화한다.

`FROM DUAL`은 PostgreSQL에 없으므로 `FROM` 절 자체를 제거했다.

### 2-3. 페이징

| Oracle | PostgreSQL | 영향 파일 |
|---|---|---|
| `ROWNUM` 기반 3중 서브쿼리 | `ROW_NUMBER() OVER(ORDER BY ...)` | Bnc: `ProjectMapper`(2) `NoticeMapper` `CompanyMapper`<br>Admin: `ProjectMapper` `NoticeMapper` `MemberMapper` `DocumentMapper` `CompanyMapper` |

`LIMIT` / `OFFSET`으로 바꾸지 않고 기존 `rnum` 구조를 유지했다. 호출부인 `Criteria`가 `startRowNumber` / `endRowNumber`를 직접 계산해서 넘기는데, `LIMIT`/`OFFSET`으로 옮기면 이 계산 로직과 이를 쓰는 화면 전체를 함께 손봐야 한다. 서브쿼리 한 줄만 교체하는 쪽이 변경 범위가 훨씬 좁았다.

```sql
-- Oracle
SELECT * FROM (
    SELECT ROWNUM AS RNUM, list.* FROM (
        SELECT * FROM bnc_project
    ) list
) WHERE RNUM > #{startRowNumber} AND RNUM <= #{endRowNumber}

-- PostgreSQL
SELECT * FROM (
    SELECT ROW_NUMBER() OVER(ORDER BY proj_number DESC) AS rnum, list.* FROM (
        SELECT * FROM bnc_project
    ) list
) sub WHERE rnum > #{startRowNumber} AND rnum <= #{endRowNumber}
```

두 가지가 함께 필요했다. PostgreSQL은 **서브쿼리에 별칭(`sub`)이 필수**라 익명 서브쿼리가 문법 오류가 된다. 그리고 `ROWNUM`은 정렬 전에 매겨지는 값이라 `ORDER BY`를 어디에 두든 결과가 비슷하게 보였지만, `ROW_NUMBER() OVER()`는 `OVER` 절의 정렬 기준을 명시해야 페이지 간 순서가 안정적으로 유지된다.

### 2-4. 조건·NULL 함수

| Oracle | PostgreSQL | 영향 파일 |
|---|---|---|
| `DECODE(col, 'W', 1)` | `CASE WHEN col = 'W' THEN 1 END` | Admin: `ChartMapper`(4) |
| `NVL(cnt, 0)` | `COALESCE(cnt, 0)` | Admin: `ChartMapper` |

`DECODE`는 상태별 건수를 한 행으로 집계하는 통계 쿼리에 쓰였다. `COUNT`가 NULL을 세지 않는 성질을 이용해 한 번의 스캔으로 4개 상태를 집계하는 구조인데, `CASE WHEN`으로 바꿔도 동작이 같아 그대로 옮겼다.

### 2-5. 행 생성 (`CONNECT BY` → `generate_series`)

가장 크게 바뀐 쿼리다. 월별 신규 회원 통계에서, 가입자가 없는 달은 `GROUP BY` 결과에 나오지 않아 그래프가 끊긴다. 그래서 조회 구간의 모든 달을 먼저 만들어 두고 실제 집계를 `LEFT JOIN`한다.

```sql
-- Oracle: DUAL + CONNECT BY LEVEL 로 월 목록 생성
SELECT TO_CHAR(TO_DATE(#{criteriaMonth},'YYYYMM') + LEVEL - 1, 'YYYYMM') AS rdate
FROM DUAL
CONNECT BY LEVEL <= TO_DATE(#{curMonth},'YYYYMM') - TO_DATE(#{criteriaMonth},'YYYYMM') + 1

-- PostgreSQL: generate_series 로 대체
SELECT TO_CHAR(s, 'YYYYMM') AS rdate
FROM generate_series(TO_DATE(#{criteriaMonth},'YYYYMM'),
                     TO_DATE(#{curMonth},'YYYYMM'),
                     INTERVAL '1 month') s
```

Oracle 쪽은 두 날짜의 **일수** 차이만큼 `LEVEL`을 돌린 뒤 `GROUP BY rdate`로 중복을 걷어내는 방식이었다. `generate_series`는 `INTERVAL '1 month'` 간격을 직접 지정할 수 있어 중복 제거 단계와 바깥 `GROUP BY`가 통째로 필요 없어졌다.

### 2-6. TOP-N 조회

| Oracle | PostgreSQL | 영향 파일 |
|---|---|---|
| `SELECT * FROM (SELECT ROWNUM rn, ...) WHERE rn > 0 AND rn <= 1` | `ORDER BY ... LIMIT 1` | Admin: `ChartMapper`(3) |

발주 1위 기업, 수주 1위 기업, 최고 계약금액 프로젝트를 뽑는 쿼리다. Oracle에서는 정렬 결과에 번호를 매기기 위해 서브쿼리를 한 겹 더 씌워야 했지만, PostgreSQL에서는 `LIMIT` 한 줄로 끝난다.

### 2-7. MyBatis TypeHandler 제거

원본에는 Oracle `LONG` 타입 컬럼을 다루기 위한 `LongHandler`가 등록되어 있었다.

```xml
<typeHandlers>
    <typeHandler handler="com.bnc.handler.LongHandler" javaType="String" jdbcType="LONGVARCHAR"/>
</typeHandlers>
```

이 핸들러는 `setParameter`만 `StringReader`로 구현하고 `getResult` 3개는 전부 `return null`인 반쪽짜리였다. PostgreSQL의 `text` 타입은 JDBC 표준 매핑으로 그대로 처리되므로 등록을 해제하고 클래스도 삭제했다(양쪽 앱).

### 2-8. 해당 사항이 없었던 항목

Oracle → PostgreSQL 전환에서 흔히 문제되지만 **이 프로젝트에는 존재하지 않아 다루지 않은** 것들이다.

`(+)` 외부조인 · `MERGE INTO` · `seq.currval` · `SYSTIMESTAMP` · 매퍼 내 `VARCHAR2`/`NUMBER`/`CLOB` 캐스팅 · 계층 쿼리(`START WITH`) · 빈 문자열과 NULL 취급 차이

식별자 대소문자 폴딩도 문제가 되지 않았다. 원본 매퍼가 이미 소문자 컬럼명을 쓰고 있어 PostgreSQL의 소문자 폴딩과 충돌하지 않았다.

---

## 3. 전환 중 발견한 원본 버그

방언 변환과 무관하게, 원본에 있던 결함을 전환 과정에서 발견해 함께 고쳤다.

### 3-1. `Bnc/NoticeMapper` — 공지사항 수정이 동작하지 않음

```sql
-- 원본
update bnc_notice set notc_number = #{notc_number}, notc_admin_id = #{notc_admin_id},
    notc_title = #{notc_title}, n_udate = sysdate
    where notc_number = #{notc_number}, notc_contents = #{notc_contents}
```

문제가 세 개 겹쳐 있다.

1. `WHERE` 절에 `notc_contents = #{notc_contents}`가 **콤마로 이어져** 있다. `SET` 항목이 `WHERE`로 넘어간 것으로, 문법 오류다.
2. 갱신 대상 `n_udate`는 **스키마에 없는 컬럼**이다. 실제 이름은 `notc_udate`다.
3. `notc_udate`는 `VARCHAR(20)`인데 `sysdate`(DATE)를 그대로 대입하고 있다.

본문 수정이 `SET`에 없어 애초에 반영될 수 없는 구조였다. 세 가지를 모두 고쳤다.

### 3-2. `Bnc/ContractMapper` — UPDATE 문이 `<insert>` 태그로 선언됨

```xml
<insert id="updateReqContractData">   <!-- 내용은 UPDATE 문 -->
```

계약서 수정 관련 3개 구문이 `<insert>` 태그 안에 UPDATE 문을 담고 있었다. MyBatis는 태그 종류로 반환값 처리를 결정하므로 의도와 다르게 동작할 수 있다. `<update>`로 교체했다.

### 3-3. `Admin/MemberMapper` — 멀티테이블 DELETE

```sql
-- 원본: Oracle에서도 PostgreSQL에서도 실행되지 않는다
DELETE FROM bnc_member m, bnc_company c WHERE c.cmpy_memb_id = #{memb_id}
```

한 번에 두 테이블을 지우려 했으나 두 DBMS 모두 지원하지 않는 문법이다. 회원 탈퇴가 실행될 수 없는 상태였다. CTE로 재작성해 한 문장 안에서 두 테이블을 지우도록 했다.

```sql
WITH deleted_company AS (
    DELETE FROM bnc_company WHERE cmpy_memb_id = #{memb_id}
)
DELETE FROM bnc_member WHERE memb_id = #{memb_id}
```

### 3-4. `Bnc/NoticeMapper` — 페이징 정렬 위치

목록 쿼리의 `ORDER BY notc_number desc`가 `rnum`을 매긴 **바깥쪽**에 있었다. 정렬 전에 번호가 매겨지므로 페이지를 넘길 때마다 순서가 어긋난다. 정렬을 안쪽 서브쿼리로 옮기고 `ROW_NUMBER() OVER(ORDER BY notc_number DESC)`로 기준을 명시했다.

### 3-5. `Admin/MemberMapper` — 사용되지 않는 서브쿼리

회원 로그 조회는 페이징하지 않는데 `ROWNUM` 래퍼만 씌워져 있었다. 결과에 영향이 없는 죽은 코드라 제거했다.

---

## 4. 빌드 환경 복구

### 4-1. 외부 리포지토리 의존 제거

```xml
<!-- 원본 pom.xml -->
<dependency>
    <groupId>oracle</groupId>
    <artifactId>ojdbc6</artifactId>
    <version>11.2.0.3</version>
</dependency>
...
<repositories>
    <repository>
        <id>Datanucleus</id>
        <url>http://www.datanucleus.org/downloads/maven2/</url>
    </repository>
</repositories>
```

`ojdbc6`은 라이선스 문제로 Maven Central에 없다. 원본은 서드파티 미러를 리포지토리로 등록해 우회하고 있었는데, 이 방식은 해당 저장소가 사라지거나 HTTP 접근이 차단되면 빌드가 통째로 깨진다. 드라이버를 PostgreSQL로 교체하면서 `<repositories>` 블록을 삭제해 **Maven Central만으로 빌드**되게 했다.

### 4-2. 드라이버·라이브러리 교체

| 항목 | 원본 | 현재 | 이유 |
|---|---|---|---|
| JDBC | `ojdbc6` 11.2.0.3 | `postgresql` 42.7.3 | DBMS 전환 |
| 드라이버 래퍼 | `log4jdbc-log4j2-jdbc4` 1.16 | 제거 | SQL 로깅용 래퍼. `jdbc:log4jdbc:oracle:...` URL과 `DriverSpy` 클래스에 묶여 있어 함께 정리 |
| Gson | 2.8.5 | 2.10.1 | `new JsonParser().parse()`가 deprecated. `JsonParser.parseString()`으로 교체 |

### 4-3. 컨테이너 빌드

```dockerfile
FROM maven:3.8-openjdk-8 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests -B

FROM tomcat:9.0-jdk8
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
```

`pom.xml`을 먼저 복사해 의존성을 받아두고 소스를 나중에 복사한다. 소스만 바뀌었을 때 의존성 다운로드 레이어가 캐시에서 재사용된다.

`webapps/*`를 비우고 `ROOT.war`로 배포하는 이유는 컨텍스트 경로를 `/`로 만들기 위해서다. 원본 코드가 `/auth/login` 같은 절대경로를 그대로 쓰고 있어 컨텍스트 경로가 붙으면 링크가 전부 깨진다.

---

## 5. 설정 외부화

원본은 특정 개발 PC와 훈련센터 서버에 묶여 있었다. 값을 전부 환경변수로 빼서 `.env` 하나로 환경을 전환할 수 있게 했다.

| 위치 | 원본 | 현재 |
|---|---|---|
| `root-context.xml` (양쪽) | Oracle 서버 주소·계정 하드코딩 | `#{systemEnvironment['DB_URL' / 'DB_USERNAME' / 'DB_PASSWORD']}` |
| `UtilConfig.java` (양쪽) | `D:/project/resources`, `D:/project` | `System.getenv("FILE_ROOT_PATH")`, `FILE_DOWNLOAD_PATH` (기본값 있음) |
| `OAuthConfig.java` (Bnc) | 네이버·카카오 키 하드코딩 | `System.getenv(...)` |
| `servlet-context.xml` (Admin) | Gmail SMTP 계정·비밀번호 하드코딩 | `#{systemEnvironment['MAIL_USERNAME' / 'MAIL_PASSWORD']}` |

`Admin/OAuthConfig.java`에도 같은 키가 하드코딩되어 있었으나, 관리자앱은 OAuth를 쓰지 않고 이 클래스를 참조하는 코드도 없었다. 사용자앱을 복사해 관리자앱을 만들 때 딸려온 파일이라 환경변수 외부화 대신 삭제했다.

원본 코드에 노출되어 있던 키·계정은 전부 폐기했고, 저장소 히스토리에서도 제거했다.

---

## 6. 컨테이너 구성

4개 서비스를 `docker-compose.yml` 하나로 묶었다. 구성도는 [README](README.md#아키텍처) 참고.

**Nginx 경로 분리** — `/`는 사용자앱, `/admin/`은 접두어를 떼고 관리자앱으로 보낸다. 응답의 `Location` 헤더에는 `proxy_redirect / /admin/;`가 접두어를 다시 붙인다. 덕분에 관리자앱 내부 코드(Controller, Interceptor)는 `/admin/`을 몰라도 되지만, **HTML에 직접 렌더링되는 `href`/`src`는 nginx가 손댈 수 없으므로** JSP에서 명시해야 한다. 이 경계를 몰라 겪은 장애가 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)에 두 건 기록되어 있다.

**공유 볼륨** — 업로드 파일은 `resources` 볼륨에 저장하고 Nginx가 `/resources/` 경로로 직접 서빙한다. 사용자앱이 올린 사업자등록증·CI 이미지를 관리자 화면에서 조회해야 하고, 관리자앱도 에디터 이미지와 기업정보 파일을 같은 경로에 쓴다. 두 앱과 Nginx가 같은 볼륨을 마운트하는 이유다.

**기동 순서** — HikariCP는 기동 시점에 커넥션을 미리 확보하는 fail-fast 방식이라, DB가 준비되기 전에 앱이 뜨면 Spring 컨텍스트 초기화가 통째로 실패한다. Tomcat은 살아 있고 앱만 배포되지 않아 **컨테이너 상태는 `Up`인데 모든 요청이 404**가 되는 형태로 나타난다. postgres에 healthcheck를 두고 `depends_on: condition: service_healthy`로 순서를 강제했다.

**SQL 파일 정리** — 원본 Oracle 익스포트(`bnc database.sql`)와 PostgreSQL 초기화 스크립트(`init.sql`)를 `sql/` 아래로 옮기고 역할이 드러나는 이름으로 바꿨다.

```
sql/oracle-original.sql   2020-12-03 Oracle SQL Developer 익스포트 원본 (보관용)
sql/init.sql              PostgreSQL 초기화 스크립트 (최초 기동 시 자동 실행)
```

---

## 7. 검증

각 단계를 마칠 때마다 두 앱을 재빌드하고 주요 화면의 응답 코드를 확인했다.

- 사용자앱 메인 / 로그인 / 프로젝트 목록
- 관리자앱 로그인 후 12개 화면 전체
- 정적 리소스 4종 (경로 수정 전 404였던 것 포함)
- 렌더된 HTML에 `/admin/` 접두어 누락이 남아 있지 않은지 대조
- 시드 데이터 적재 건수 (`bnc_member`=8, `bnc_company`=8, `bnc_admin`=1, `bnc_project`=17)

주석만 추가한 커밋은 "주석 외 코드 동일"을 파일 단위로 대조해 확인했다.

전환 중 겪은 장애 5건의 증상·원인·해결은 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)에 따로 정리했다.
