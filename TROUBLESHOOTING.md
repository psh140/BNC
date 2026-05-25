# BNC 프로젝트 트러블슈팅 기록

---

## [2026-05-25] init.sql 첫 실행 중단 — DB 데이터 누락

### 증상
`docker-compose up` 후 DB 접속 시 `bnc_member`, `bnc_project` 등 주요 테이블 데이터가 0건.
`bnc_company`=16, `bnc_admin`=2로 중복 삽입된 테이블도 있음.

### 원인
Docker postgres 공식 이미지는 `PGDATA`가 비어있을 때만 `/docker-entrypoint-initdb.d/` 스크립트를 실행한다.
첫 실행 시 `init.sql` 내부에서 에러가 발생해 psql이 중간에 중단됐고, 그 시점까지 INSERT된 데이터만 남았다.
에러 메시지: `syntax error at or near "Y" at line 648` (bnc_terms 테이블의 HTML content 처리 과정에서 발생 추정)

볼륨(`postgres_data`)은 이미 생성되어 있었기 때문에 이후 재시작해도 init.sql이 다시 실행되지 않았다.
→ 데이터가 없는 상태가 계속 유지됨.

### 해결
볼륨을 완전히 삭제하고 재시작해서 init.sql을 처음부터 다시 실행시킴.

```bash
docker-compose down -v
docker-compose up -d
```

### 확인
```bash
docker exec -it bnc-source-postgres-1 psql -U bnc_user -d bnc -c "
  SELECT 'bnc_member' AS tbl, COUNT(*) FROM bnc_member
  UNION ALL SELECT 'bnc_company', COUNT(*) FROM bnc_company
  UNION ALL SELECT 'bnc_admin',   COUNT(*) FROM bnc_admin
  UNION ALL SELECT 'bnc_project', COUNT(*) FROM bnc_project;
"
```
결과: bnc_member=8, bnc_company=8, bnc_admin=1, bnc_project=17 ✅

### 주의
- `docker-compose down`만 실행하면 볼륨이 남아있어 init.sql이 재실행되지 않는다.
- 반드시 `-v` 플래그를 붙여야 볼륨까지 삭제된다.
- 운영 환경에서는 데이터 손실에 주의할 것.

---

## [2026-05-25] Admin 헤더 404 / Bnc 앱으로 잘못 라우팅

### 증상
`http://localhost/admin/` 접속 후 헤더의 CSS, JS, 이미지가 404 또는 Bnc 앱의 리소스로 로드됨.
헤더 nav 링크 클릭 시 Bnc 앱 화면으로 이동함.

### 원인
세 가지 원인이 복합적으로 작용했다.

**원인 1 — admin-app 포트 미노출**
`docker-compose.yml`에서 `admin-app`에 외부 포트 바인딩이 없었음.
nginx를 통하지 않고 직접 `localhost:8081`로 접근할 수 없는 상태.

**원인 2 — head.jsp 정적 리소스 경로 오류**
`head.jsp`의 CSS/JS 경로가 `/common/css/...`, `/common/js/...` 형태였음.
nginx 라우팅 규칙: `/admin/` 접두어가 없으면 Bnc 앱(8080)으로 전달.
→ Admin의 CSS/JS가 Bnc 앱에서 404 반환.

**원인 3 — header.jsp nav 링크 경로 오류**
`header.jsp`의 모든 링크가 `/member/list`, `/company/list` 등 절대 경로.
nginx가 `/admin/` 접두어 없는 경로를 Bnc 앱으로 라우팅.
→ 클릭 시 Bnc 앱 화면으로 이동.

### 해결

**docker-compose.yml** — 포트 외부 노출 추가
```yaml
bnc-app:
  ports:
    - "8080:8080"
admin-app:
  ports:
    - "8081:8080"
```

**head.jsp** — 정적 리소스 경로 수정
```
/common/css/style.css → /admin/common/css/style.css
/common/js/util.js    → /admin/common/js/util.js
(동일 패턴으로 전체 수정)
```

**header.jsp** — nav 링크 prefix 추가
```
/member/list → /admin/member/list
/company/list → /admin/company/list
(모든 링크 동일하게 수정)
```

---

## [2026-05-25] 비로그인 리다이렉트 이중 경로 — `/admin/admin/auth/login`

### 증상
로그인 안 된 상태로 Admin 페이지 접근 시 브라우저가 `http://localhost/admin/admin/auth/login`으로 이동.
(예상 경로: `http://localhost/admin/auth/login`)

### 원인
`LoginInterceptor.java`에서 `response.sendRedirect("/admin/auth/login")`으로 변경했는데,
nginx의 `proxy_redirect` 설정이 admin-app의 `Location` 헤더 값에서 `/`를 자동으로 `/admin/`으로 변환함.

```nginx
proxy_redirect / /admin/;
```

이 설정 때문에:
- admin-app이 `Location: /admin/auth/login` 반환
- nginx가 다시 `/admin/` prefix를 붙여 `Location: /admin/admin/auth/login`으로 변환
- 이중 경로 발생

### 해결
`LoginInterceptor.java`를 원래대로 `/auth/login`으로 되돌림.

```java
response.sendRedirect("/auth/login");
```

nginx `proxy_redirect / /admin/;`가 자동으로 `Location: /auth/login` → `Location: /admin/auth/login`으로 변환해줌.

### 확인
```bash
curl -I http://localhost/admin/member/list
# Location: http://localhost/admin/auth/login ✅
```

### 핵심 원칙
Admin 앱 내부 코드(Controller, Interceptor)에서는 `/admin/` prefix 없이 경로 작성.
nginx의 `proxy_redirect / /admin/;`가 응답 헤더의 Location 값에 자동으로 prefix를 붙여준다.
단, JSP의 `href`/`src` 속성(HTML에 직접 렌더링되는 경로)은 `/admin/` prefix를 명시해야 한다.
→ Location 헤더는 nginx가 처리, HTML 내 링크는 직접 처리.
