SET client_encoding = 'UTF8';

-- ============================================================
-- SEQUENCES
-- ============================================================
CREATE SEQUENCE IF NOT EXISTS bnc_contract_seq     START WITH 1;
CREATE SEQUENCE IF NOT EXISTS bnc_document_seq     START WITH 5;
CREATE SEQUENCE IF NOT EXISTS bnc_notice_seq       START WITH 5;
CREATE SEQUENCE IF NOT EXISTS bnc_project_file_seq START WITH 27;
CREATE SEQUENCE IF NOT EXISTS bnc_project_seq      START WITH 27;
CREATE SEQUENCE IF NOT EXISTS sign_seq             START WITH 14;

-- ============================================================
-- TABLES
-- ============================================================
CREATE TABLE IF NOT EXISTS bnc_admin (
    admin_id       VARCHAR(20),
    admin_name     VARCHAR(20),
    admin_password VARCHAR(1000),
    admin_grade    INTEGER
);

CREATE TABLE IF NOT EXISTS bnc_biz_category (
    bizc_code        VARCHAR(100),
    bizc_name        VARCHAR(100),
    bizc_parent_code VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bnc_company (
    cmpy_biznum           VARCHAR(20),
    cmpy_biz_doc_file_path VARCHAR(1000),
    cmpy_memb_id          VARCHAR(100),
    cmpy_company_name     VARCHAR(200),
    cmpy_ceo_name         VARCHAR(20),
    cmpy_biz_code         VARCHAR(20),
    cmpy_biz_address      VARCHAR(1000),
    cmpy_biz_phone        VARCHAR(20),
    cmpy_biz_email        VARCHAR(200),
    cmpy_ci_file_path     VARCHAR(1000),
    cmpy_homepage         VARCHAR(200),
    cmpy_contents         VARCHAR(4000),
    cmpy_rdate            VARCHAR(14),
    cmpy_udate            VARCHAR(14)
);

CREATE TABLE IF NOT EXISTS bnc_contract (
    cntr_proj_number  INTEGER,
    cntr_price        INTEGER,
    cntr_flag         VARCHAR(1),
    cntr_req_biznum   VARCHAR(20),
    cntr_acp_biznum   VARCHAR(20),
    cntr_req_sign_path VARCHAR(1000),
    cntr_acp_sign_path VARCHAR(1000),
    cntr_req_ceo_name VARCHAR(20),
    cntr_acp_ceo_name VARCHAR(20),
    cntr_start_date   VARCHAR(10),
    cntr_end_date     VARCHAR(10),
    cntr_contents     TEXT,
    cntr_rdate        VARCHAR(14),
    cntr_udate        VARCHAR(14)
);

CREATE TABLE IF NOT EXISTS bnc_contract_company (
    cntc_cmpy_biznum   VARCHAR(20),
    cntc_contract_form TEXT
);

CREATE TABLE IF NOT EXISTS bnc_document (
    doct_code INTEGER,
    doct_name VARCHAR(50),
    doct_form VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS bnc_mail (
    mail_number INTEGER,
    mail_kind   VARCHAR(20),
    mail_address VARCHAR(20),
    mail_flag   VARCHAR(1),
    mail_rdate  VARCHAR(14)
);

CREATE TABLE IF NOT EXISTS bnc_mail_form (
    malf_kind  VARCHAR(20),
    malf_title VARCHAR(200),
    malf_form  VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS bnc_member (
    memb_id        VARCHAR(100),
    memb_kind      VARCHAR(20),
    memb_email     VARCHAR(100),
    memb_rdate     VARCHAR(14),
    memb_ip        VARCHAR(20),
    memb_auth_flag VARCHAR(1) DEFAULT 'N'
);

CREATE TABLE IF NOT EXISTS bnc_member_log (
    meml_id    VARCHAR(20),
    meml_ldate VARCHAR(20),
    meml_ip    VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS bnc_notice (
    notc_number   INTEGER,
    notc_admin_id VARCHAR(20),
    notc_title    VARCHAR(200),
    notc_rdate    VARCHAR(20),
    notc_udate    VARCHAR(20),
    notc_contents VARCHAR(4000)
);

CREATE TABLE IF NOT EXISTS bnc_project (
    proj_number         INTEGER,
    proj_name           VARCHAR(200),
    proj_kind           VARCHAR(20),
    proj_thumb_file_path VARCHAR(2000),
    proj_req_phone      VARCHAR(200),
    proj_req_biznum     VARCHAR(20),
    proj_acp_phone      VARCHAR(20),
    proj_acp_biznum     VARCHAR(20),
    proj_mov_url        VARCHAR(4000),
    proj_keyword        VARCHAR(1000),
    proj_lead_time      VARCHAR(30),
    proj_price_range    VARCHAR(50),
    proj_contents       VARCHAR(4000),
    proj_req_flag       VARCHAR(1) DEFAULT 'N',
    proj_acp_flag       VARCHAR(1) DEFAULT 'N',
    proj_flag           VARCHAR(1) DEFAULT 'W',
    proj_rdate          VARCHAR(14),
    proj_udate          VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS bnc_project_contract_log (
    pctl_number      INTEGER,
    pctl_proj_number INTEGER,
    pctl_msg         VARCHAR(4000),
    pctl_rdate       VARCHAR(14)
);

CREATE TABLE IF NOT EXISTS bnc_project_file (
    prof_seq         INTEGER,
    prof_proj_number INTEGER,
    prof_file_path   VARCHAR(1000),
    prof_file_name   VARCHAR(1000)
);

CREATE TABLE IF NOT EXISTS bnc_project_participate_list (
    prpl_number    INTEGER,
    prpl_acp_biznum VARCHAR(20),
    prpl_acp_phone  VARCHAR(20),
    prpl_acp_price  INTEGER,
    prpl_rdate      VARCHAR(14),
    prpl_file_path  VARCHAR(1000),
    prpl_file_name  VARCHAR(1000)
);

CREATE TABLE IF NOT EXISTS bnc_sign (
    sign_num      INTEGER,
    sign_file_path VARCHAR(1000),
    sign_memb_id  VARCHAR(100),
    sign_rdate    VARCHAR(14),
    sign_udate    VARCHAR(14)
);

CREATE TABLE IF NOT EXISTS bnc_terms (
    pol_kind     VARCHAR(1),
    pol_contents TEXT,
    pol_rdate    VARCHAR(14),
    pol_udate    VARCHAR(14)
);

-- ============================================================
-- DATA
-- ============================================================
INSERT INTO bnc_admin (ADMIN_ID,ADMIN_NAME,ADMIN_PASSWORD,ADMIN_GRADE) values ('admin','admin','admin',1);
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('108','호텔·여행·항공','1');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('109','외식업·식음료','1');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('111','시설관리·경비·용역','1');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('115','레저·스포츠·여가','1');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('118','AS·카센터·주유','1');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('119','렌탈·임대','1');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('120','웨딩·장례·이벤트','1');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('121','기타서비스업','1');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('122','뷰티·미용','1');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('201','전기·전자·제어','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('202','기계·설비·자동차','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('204','석유·화학·에너지','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('205','섬유·의류·패션','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('207','화장품·뷰티','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('208','생활용품·소비재·사무','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('209','가구·목재·제지','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('210','농업·어업·광업·임업','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('211','금속·재료·철강·요업','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('212','조선·항공·우주','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('213','기타제조업','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('214','식품가공·개발','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('215','반도체·광학·LCD','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('216','환경','2');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('301','솔루션·SI·ERP·CRM','3');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('302','웹에이젼시','3');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('304','쇼핑몰·오픈마켓','3');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('305','포털·인터넷·컨텐츠','3');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('306','네트워크·통신·모바일','3');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('307','하드웨어·장비','3');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('308','정보보안·백신','3');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('313','IT컨설팅','3');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('314','게임','3');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('401','은행·금융·저축','4');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('402','대출·캐피탈·여신','4');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('405','기타금융','4');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('406','증권·보험·카드','4');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('501','신문·잡지·언론사','5');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('502','방송사·케이블','5');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('503','연예·엔터테인먼트','5');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('504','광고·홍보·전시','5');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('505','영화·배급·음악','5');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('506','공연·예술·문화','5');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('509','출판·인쇄·사진','5');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('510','캐릭터·애니메이션','5');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('511','디자인·설계','5');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('601','초중고·대학','6');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('602','학원·어학원','6');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('603','유아·유치원','6');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('604','교재·학습지','6');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('605','전문·기능학원','6');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('701','의료(진료과목별)','7');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('702','의료(병원종류별)','7');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('703','제약·보건·바이오','7');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('704','사회복지','7');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('801','판매(매장종류별)','8');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('802','판매(상품품목별)','8');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('803','유통·무역·상사','8');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('804','운송·운수·물류','8');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('901','건설·건축·토목·시공','9');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('902','실내·인테리어·조경','9');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('903','환경·설비','9');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('904','부동산·임대·중개','9');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('1001','정부·공공기관·공기업','10');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('1002','협회·단체','10');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('1003','법률·법무·특허','10');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('1004','세무·회계','10');
INSERT INTO bnc_biz_category (BIZC_CODE,BIZC_NAME,BIZC_PARENT_CODE) values ('1005','연구소·컨설팅·조사','10');
INSERT INTO bnc_company (CMPY_BIZNUM,CMPY_BIZ_DOC_FILE_PATH,CMPY_MEMB_ID,CMPY_COMPANY_NAME,CMPY_CEO_NAME,CMPY_BIZ_CODE,CMPY_BIZ_ADDRESS,CMPY_BIZ_PHONE,CMPY_BIZ_EMAIL,CMPY_CI_FILE_PATH,CMPY_HOMEPAGE,CMPY_CONTENTS,CMPY_RDATE,CMPY_UDATE) values ('다른코리아','/resources/companyInfo/b69190c9-d3f8-4262-a922-b6517991c32e.jpeg','naver_57280044','다른코리아','김진한','511','대전광역시 유성구 가정북로 96, 4층 1호','042 825 5836','kyung_0725@naver.com','/resources/companyInfo/1c24fe31-8455-4255-ac11-f63562416ac2.png','dareunkorea1.creatorlink.net','<div style="text-align: center;" align="center"><img src="/resources/companyInfo/dbd64468-befe-4399-8d58-d876a22c17a8.png" title="%EB%8B%A4%EB%A5%B8%EC%BD%94%EB%A6%AC%EC%95%84_%EC%83%81%EC%84%B8.png"></div><div style="text-align: center;"><br></div>','20201130110042','20201130110019');
INSERT INTO bnc_company (CMPY_BIZNUM,CMPY_BIZ_DOC_FILE_PATH,CMPY_MEMB_ID,CMPY_COMPANY_NAME,CMPY_CEO_NAME,CMPY_BIZ_CODE,CMPY_BIZ_ADDRESS,CMPY_BIZ_PHONE,CMPY_BIZ_EMAIL,CMPY_CI_FILE_PATH,CMPY_HOMEPAGE,CMPY_CONTENTS,CMPY_RDATE,CMPY_UDATE) values ('122-86-00871','/resources/companyInfo/da8de49d-69b8-4189-9606-8f53a364eae3.png','kakao_1529744104','(주)i-zone','박용선','603','인천광역시 부평구 안남로 402번길80 2층','0505-552-7272','kyung_0725@naver.com','/resources/companyInfo/19998e05-1083-4f44-b7cc-bd91ace93abe.png','http://www.izonetoy.co.kr/','<img src="/resources/companyInfo/91ac88e3-0c28-43e8-9082-2ce6f11a72f6.jpg" title="company_img1.jpg"><br style="clear:both;"><br>','20201130110003','20201130110003');
INSERT INTO bnc_company (CMPY_BIZNUM,CMPY_BIZ_DOC_FILE_PATH,CMPY_MEMB_ID,CMPY_COMPANY_NAME,CMPY_CEO_NAME,CMPY_BIZ_CODE,CMPY_BIZ_ADDRESS,CMPY_BIZ_PHONE,CMPY_BIZ_EMAIL,CMPY_CI_FILE_PATH,CMPY_HOMEPAGE,CMPY_CONTENTS,CMPY_RDATE,CMPY_UDATE) values ('1424772350','/resources/companyInfo/fd167d88-5b69-4a7f-84ee-1b901ee96cf9.jpeg','naver_10177734','(주)메이저월드','박상혁','304','경기 성남시 분당구 판교로 35','010-2275-4222','psh140140@gmail.com','/resources/companyInfo/ba7a6a6a-36a1-4e25-82cc-b66c2c199a51.png','www.major.com','안녕하십니까 메이저월드입니다.','20201130100020','20201130100020');
INSERT INTO bnc_company (CMPY_BIZNUM,CMPY_BIZ_DOC_FILE_PATH,CMPY_MEMB_ID,CMPY_COMPANY_NAME,CMPY_CEO_NAME,CMPY_BIZ_CODE,CMPY_BIZ_ADDRESS,CMPY_BIZ_PHONE,CMPY_BIZ_EMAIL,CMPY_CI_FILE_PATH,CMPY_HOMEPAGE,CMPY_CONTENTS,CMPY_RDATE,CMPY_UDATE) values ('45698214','/resources/companyInfo/c6b8b9b5-0421-4f5f-8305-7ef5a7e86ad6.png','naver_23695574','이카운트','이규영','209','강원 삼척시 가곡면 가곡천로 136','010-0000-0000','abc@naver.com','/resources/companyInfo/f20f9235-be20-4895-acc0-8d0b2e4e7e32.png','www.ecoun.com','이카운트기업입니다.','20201130100026','20201130100026');
INSERT INTO bnc_company (CMPY_BIZNUM,CMPY_BIZ_DOC_FILE_PATH,CMPY_MEMB_ID,CMPY_COMPANY_NAME,CMPY_CEO_NAME,CMPY_BIZ_CODE,CMPY_BIZ_ADDRESS,CMPY_BIZ_PHONE,CMPY_BIZ_EMAIL,CMPY_CI_FILE_PATH,CMPY_HOMEPAGE,CMPY_CONTENTS,CMPY_RDATE,CMPY_UDATE) values ('45671236','/resources/companyInfo/8da46f6a-5de9-4a67-899b-7404940c02fb.png','kakao_1540285291','포스트모던','김재훈','213','서울 송파구 성남대로 1541-27','010-0000-0000','jdbc@naver.com','/resources/companyInfo/435166b5-9d14-4b28-b292-19cbd901813c.png','www.post-mode.com','포스트모던입니다.','20201130100038','20201130100038');
INSERT INTO bnc_company (CMPY_BIZNUM,CMPY_BIZ_DOC_FILE_PATH,CMPY_MEMB_ID,CMPY_COMPANY_NAME,CMPY_CEO_NAME,CMPY_BIZ_CODE,CMPY_BIZ_ADDRESS,CMPY_BIZ_PHONE,CMPY_BIZ_EMAIL,CMPY_CI_FILE_PATH,CMPY_HOMEPAGE,CMPY_CONTENTS,CMPY_RDATE,CMPY_UDATE) values ('557221143','/resources/companyInfo/13143c4c-4b23-4e4b-a7bf-1894c6470a55.jpeg','kakao_1535448805','(주)한샘','조창걸','209','경기 안산시 단원구 번영2로 144','010-1588-0900','psh140@naver.com','/resources/companyInfo/c0f834bc-42ac-448e-9a60-0c2d095f76cf.gif','www.hanssem.com/main/main.do','안녕하십니까 한샘입니다.','20201130100042','20201130100042');
INSERT INTO bnc_company (CMPY_BIZNUM,CMPY_BIZ_DOC_FILE_PATH,CMPY_MEMB_ID,CMPY_COMPANY_NAME,CMPY_CEO_NAME,CMPY_BIZ_CODE,CMPY_BIZ_ADDRESS,CMPY_BIZ_PHONE,CMPY_BIZ_EMAIL,CMPY_CI_FILE_PATH,CMPY_HOMEPAGE,CMPY_CONTENTS,CMPY_RDATE,CMPY_UDATE) values ('1424772355','/resources/companyInfo/2031d033-b147-4274-9c2e-30347769a176.jpeg','naver_56480495','(주)셀랩','박순옥','207','충남 아산시 둔포면 윤보선로 291','010-1588-9292','15889292@naver.com','/resources/companyInfo/bb83b2b6-32db-4344-a0a1-0d7a53ae194d.gif','http://www.icellab.com/','<div style="text-align: center;" align="center"><img src="/resources/companyInfo/b9b8891e-3973-457e-ae5a-36cf6dc40134.jpg" title="com01_2_con01.jpg"></div><div style="text-align: center;"><br></div>','20201130110043','20201130110043');
INSERT INTO bnc_company (CMPY_BIZNUM,CMPY_BIZ_DOC_FILE_PATH,CMPY_MEMB_ID,CMPY_COMPANY_NAME,CMPY_CEO_NAME,CMPY_BIZ_CODE,CMPY_BIZ_ADDRESS,CMPY_BIZ_PHONE,CMPY_BIZ_EMAIL,CMPY_CI_FILE_PATH,CMPY_HOMEPAGE,CMPY_CONTENTS,CMPY_RDATE,CMPY_UDATE) values ('1424772359','/resources/companyInfo/e25aef07-06a1-4f8d-9a09-3b8779ad22dc.jpeg','kakao_1533624762','(주)삼영화학','김삼영','204','서울 종로구 청계천로 35 13층','02-757-2291','7572291@naver.com','/resources/companyInfo/3c346230-4020-48f8-9ed4-bf675f0450b9.gif','http://www.sycc.co.kr/','<div style="text-align: center;" align="center"><img src="/resources/companyInfo/cf27078f-6a73-4949-a619-9aa439688d46.jpg" title="intro_01.jpg"></div><div style="text-align: center;"><br></div>','20201130110018','20201130110018');
INSERT INTO bnc_contract (CNTR_PROJ_NUMBER,CNTR_PRICE,CNTR_FLAG,CNTR_REQ_BIZNUM,CNTR_ACP_BIZNUM,CNTR_REQ_SIGN_PATH,CNTR_ACP_SIGN_PATH,CNTR_REQ_CEO_NAME,CNTR_ACP_CEO_NAME,CNTR_START_DATE,CNTR_END_DATE,CNTR_CONTENTS,CNTR_RDATE,CNTR_UDATE) values (20,7500000,'Y','다른코리아','45671236','/resources/sign/b78fd125-b807-4c46-bdd7-29a76fd7e89d.png','/resources/sign/818ab786-ae48-4f07-bca8-c84794be059b.png','권수경','권지윤','2020-12-01','2020-12-05','<p><b><span style="color: rgb(0, 0, 0);
INSERT INTO bnc_contract (CNTR_PROJ_NUMBER,CNTR_PRICE,CNTR_FLAG,CNTR_REQ_BIZNUM,CNTR_ACP_BIZNUM,CNTR_REQ_SIGN_PATH,CNTR_ACP_SIGN_PATH,CNTR_REQ_CEO_NAME,CNTR_ACP_CEO_NAME,CNTR_START_DATE,CNTR_END_DATE,CNTR_CONTENTS,CNTR_RDATE,CNTR_UDATE) values (15,7500000,'Y','다른코리아','122-86-00871','/resources/sign/159d25fa-09f1-4848-aa51-85c0d275cc76.png','/resources/contract/54d92fc3-4515-4af6-9689-3458e5cd85d6.png','권수경','이성경','2020-11-30','2020-12-31','<p><b><span style="color: rgb(0, 0, 0);
INSERT INTO bnc_contract (CNTR_PROJ_NUMBER,CNTR_PRICE,CNTR_FLAG,CNTR_REQ_BIZNUM,CNTR_ACP_BIZNUM,CNTR_REQ_SIGN_PATH,CNTR_ACP_SIGN_PATH,CNTR_REQ_CEO_NAME,CNTR_ACP_CEO_NAME,CNTR_START_DATE,CNTR_END_DATE,CNTR_CONTENTS,CNTR_RDATE,CNTR_UDATE) values (19,7500000,'Y','다른코리아','45698214','/resources/sign/159d25fa-09f1-4848-aa51-85c0d275cc76.png','/resources/contract/3e9ce186-a978-4d5a-b773-424db1f22869.png','권수경','오윤주','2020-12-01','2020-12-31','<p><b><span style="color: rgb(0, 0, 0);
INSERT INTO bnc_contract (CNTR_PROJ_NUMBER,CNTR_PRICE,CNTR_FLAG,CNTR_REQ_BIZNUM,CNTR_ACP_BIZNUM,CNTR_REQ_SIGN_PATH,CNTR_ACP_SIGN_PATH,CNTR_REQ_CEO_NAME,CNTR_ACP_CEO_NAME,CNTR_START_DATE,CNTR_END_DATE,CNTR_CONTENTS,CNTR_RDATE,CNTR_UDATE) values (25,7500000,'Y','다른코리아','45671236','/resources/sign/159d25fa-09f1-4848-aa51-85c0d275cc76.png','/resources/sign/818ab786-ae48-4f07-bca8-c84794be059b.png','권수경','오윤주','2020-12-01','2020-12-31','<p><b><span style="color: rgb(0, 0, 0);
INSERT INTO bnc_contract (CNTR_PROJ_NUMBER,CNTR_PRICE,CNTR_FLAG,CNTR_REQ_BIZNUM,CNTR_ACP_BIZNUM,CNTR_REQ_SIGN_PATH,CNTR_ACP_SIGN_PATH,CNTR_REQ_CEO_NAME,CNTR_ACP_CEO_NAME,CNTR_START_DATE,CNTR_END_DATE,CNTR_CONTENTS,CNTR_RDATE,CNTR_UDATE) values (17,7500000,'Y','다른코리아','122-86-00871','/resources/sign/159d25fa-09f1-4848-aa51-85c0d275cc76.png','/resources/contract/16702faf-76e2-4de0-98a5-675cee9cffd9.png','권수경','오윤주','2020-12-01','2020-12-31','<p><b><span style="color: rgb(0, 0, 0);
INSERT INTO bnc_contract (CNTR_PROJ_NUMBER,CNTR_PRICE,CNTR_FLAG,CNTR_REQ_BIZNUM,CNTR_ACP_BIZNUM,CNTR_REQ_SIGN_PATH,CNTR_ACP_SIGN_PATH,CNTR_REQ_CEO_NAME,CNTR_ACP_CEO_NAME,CNTR_START_DATE,CNTR_END_DATE,CNTR_CONTENTS,CNTR_RDATE,CNTR_UDATE) values (18,7500000,'Y','다른코리아','122-86-00871','/resources/sign/159d25fa-09f1-4848-aa51-85c0d275cc76.png','/resources/contract/51f2397b-4590-4410-83a5-cf92e4dd0d54.png','권수경','오윤주','2020-12-01','2020-12-31','<p><b><span style="color: rgb(0, 0, 0);
INSERT INTO bnc_contract (CNTR_PROJ_NUMBER,CNTR_PRICE,CNTR_FLAG,CNTR_REQ_BIZNUM,CNTR_ACP_BIZNUM,CNTR_REQ_SIGN_PATH,CNTR_ACP_SIGN_PATH,CNTR_REQ_CEO_NAME,CNTR_ACP_CEO_NAME,CNTR_START_DATE,CNTR_END_DATE,CNTR_CONTENTS,CNTR_RDATE,CNTR_UDATE) values (12,7500000,'Y','557221143','1424772350','/resources/contract/091369c7-0077-4b6b-a623-3282cd31a0ec.png','/resources/contract/216b182f-56d1-4d5e-9c21-1d4240feed62.png','김성재','권지윤','2020-12-02','2021-04-14','<p><b><span style="color: rgb(0, 0, 0);
INSERT INTO bnc_contract_company (CNTC_CMPY_BIZNUM,CNTC_CONTRACT_FORM) values ('다른코리아','<p><b><span style="color: rgb(0, 0, 0);
INSERT INTO bnc_contract_company (CNTC_CMPY_BIZNUM,CNTC_CONTRACT_FORM) values ('557221143','<p><b><span style="color: rgb(0, 0, 0);
INSERT INTO bnc_document (DOCT_CODE,DOCT_NAME,DOCT_FORM) values (1,'공동 프로젝트 계약서','<div class="mg">
	<div class="title">프로젝트 계약서</div>
	<div class="info">
		<div class="contract-info-table">
			<div class="dtr">
				<div class="dth">계약건명</div>
				<div class="dtd"><span id="js_field_proj_name"></span></div>
			</div>
			<div class="dtr">
				<div class="dth">계약기간</div>
				<div class="dtd"><span id="js_field_cntr_start_date"></span> ~ <span id="js_field_cntr_end_date"></span></div>
			</div>
			<div class="dtr">
				<div class="dth">계약금액</div>
				<div class="dtd"><span id="js_field_cntr_price"></span>원</div>
			</div>
		</div>
	</div>
</div>');
INSERT INTO bnc_mail_form (MALF_KIND,MALF_TITLE,MALF_FORM) values ('Y','Brigde N Contract 가입 승인 안내','<div class="container" style="width:900px; border:1px solid #e9e9e9;">
      <div class="header" style="height:67px; background-color:#0e3a6e; position:relative;">
         <p style="padding-top:11px; padding-left:40px;">
            <img src="">
         </p>
      </div>
      <div class="contents" style="width:100%;">
         <ul style="width:815px;">
            <li style="list-style:none;">
               <h2 style="margin:32px 0px; font-size:40px;">Bridge N Contract 가입 승인 안내</h2>
               <p class="intro" style="color:#424242;">
                  Bridge N Contract 가입 안내입니다.
                  <br>
                  <br>
                  사업자등록증과 번호, 업종이 확인되어 계정이 활성화 되었습니다.
                  <br>
                  지금부터 Bridge N Contract의 서비스를 이용하실 수 있습니다.
               </p>
            </li>
            <li class="conts" style="background-color:#f5f5f5; position:relative; list-style:none;">
               <p class="hd" style="font-size:24px; font-weight:bold; margin:0px auto; margin-top:32px; text-align:center; padding-top:32px;">Bridge N Contract</p>
               <p class="link" style="font-size:12px;padding-top:24px; padding-bottom:32px; margin:0px auto; text-align:center;"><a href="http://localhost:8080">BNC로 바로가기</a></p>
            </li>
            <li class="txt" style="margin-top:32px; color:#9e9e9e; list-style:none;">
               <p>- 본 메일은 발신전용입니다. </p>
            </li>
         </ul>
      </div>
      <div class="footer" style="margin-top:56px; background-color:#f5f5f5; height:80px;">
         <p style="margin:0 auto; font-size:14px; color:#9e9e9e; width:450px; display:block; padding:32px;">Copyright ⓒ 충북대학교 Java 웹/앱 과정 B조. ALL rights reserved.</p>
      </div>
    </div>');
INSERT INTO bnc_member (MEMB_ID,MEMB_KIND,MEMB_EMAIL,MEMB_RDATE,MEMB_IP,MEMB_AUTH_FLAG) values ('naver_23695574','naver','hyukbobo@naver.com','20201130100007','0:0:0:0:0:0:0:1','Y');
INSERT INTO bnc_member (MEMB_ID,MEMB_KIND,MEMB_EMAIL,MEMB_RDATE,MEMB_IP,MEMB_AUTH_FLAG) values ('kakao_1529744104','kakao','kyeong_0725@daum.net','20201130100045','127.0.0.1','Y');
INSERT INTO bnc_member (MEMB_ID,MEMB_KIND,MEMB_EMAIL,MEMB_RDATE,MEMB_IP,MEMB_AUTH_FLAG) values ('kakao_1540285291','kakao','salamango@hanmail.net','20201130100053','127.0.0.1','Y');
INSERT INTO bnc_member (MEMB_ID,MEMB_KIND,MEMB_EMAIL,MEMB_RDATE,MEMB_IP,MEMB_AUTH_FLAG) values ('naver_57280044','naver','kyung_0725@naver.com','20201130100041','127.0.0.1','Y');
INSERT INTO bnc_member (MEMB_ID,MEMB_KIND,MEMB_EMAIL,MEMB_RDATE,MEMB_IP,MEMB_AUTH_FLAG) values ('naver_10177734','naver','psh140140@gmail.com','20201130100028','127.0.0.1','Y');
INSERT INTO bnc_member (MEMB_ID,MEMB_KIND,MEMB_EMAIL,MEMB_RDATE,MEMB_IP,MEMB_AUTH_FLAG) values ('kakao_1535448805','kakao','psh140140@gmail.com','20201130100042','127.0.0.1','Y');
INSERT INTO bnc_member (MEMB_ID,MEMB_KIND,MEMB_EMAIL,MEMB_RDATE,MEMB_IP,MEMB_AUTH_FLAG) values ('naver_56480495','naver','ibluesky98@naver.com','20201130100004','127.0.0.1','Y');
INSERT INTO bnc_member (MEMB_ID,MEMB_KIND,MEMB_EMAIL,MEMB_RDATE,MEMB_IP,MEMB_AUTH_FLAG) values ('kakao_1533624762','kakao','ibluesky98@naver.com','20201130110005','127.0.0.1','Y');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_10177734','20201130110057','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_10177734','20201130110050','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201130110023','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1529744104','20201130110053','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201130110040','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201130110046','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201201120050','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1529744104','20201201120044','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201201120023','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201030004','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201030004','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201201030007','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201030059','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_56480495','20201201050042','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1533624762','20201201050051','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201201050027','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202100046','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202100018','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201202100028','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202100008','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202100002','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201202100013','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201202100044','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202110058','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201202110012','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201201100048','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201201110051','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201201020041','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201020010','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201020015','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201201020034','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201020046','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202090004','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_56480495','20201202100005','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1533624762','20201202100052','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201130010047','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1529744104','20201130010015','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201130010046','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1529744104','20201130010000','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1529744104','20201130010035','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201201120016','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201120048','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_56480495','20201201010037','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1533624762','20201201010004','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201020022','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201201040024','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201040038','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201201040057','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201202100002','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1529744104','20201202100000','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201202100002','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201202100048','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201201010040','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_56480495','20201201050052','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201202020022','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202020037','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1529744104','20201130030037','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201201010034','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201201010040','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201010051','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201010019','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201201010022','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201010030','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201201010041','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202080037','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202080021','0:0:0:0:0:0:0:1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202110026','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_23695574','20201202110000','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202110004','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('naver_57280044','20201202110043','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202120031','127.0.0.1');
INSERT INTO bnc_member_log (MEML_ID,MEML_LDATE,MEML_IP) values ('kakao_1540285291','20201202010053','127.0.0.1');
INSERT INTO bnc_notice (NOTC_NUMBER,NOTC_ADMIN_ID,NOTC_TITLE,NOTC_RDATE,NOTC_UDATE,NOTC_CONTENTS) values (3,'admin','[공지] 계약서 작성법 안내','20201130101158','20201130101141','<p>1. "갑"이 계약서를 작성한 후 "을"이 작성할 수 있습니다.</p><p>&nbsp;</p><p>2. "을"은 계약서를 확인 후 계약을 승인/철회할 수 있습니다.</p><p>&nbsp;</p><p>※ 모든 계약을 계약/철회가 가능 합니다.</p>');
INSERT INTO bnc_notice (NOTC_NUMBER,NOTC_ADMIN_ID,NOTC_TITLE,NOTC_RDATE,NOTC_UDATE,NOTC_CONTENTS) values (4,'admin','[공지] BNC 회원탈퇴 안내','20201130101155','20201130101151','<p>&nbsp;</p><p>회원 탈퇴 시 동일한 계정은 사용할 수 없으며, 회원 탈퇴 시 모든 해당 계정의 데이터는 사라지게 됩니다.</p><p>&nbsp;</p><p>회원 탈퇴</p><p>- [마이페이지] → [회원탈퇴] → [이메일입력] → [회원탈퇴]</p><p>&nbsp;</p>');
INSERT INTO bnc_notice (NOTC_NUMBER,NOTC_ADMIN_ID,NOTC_TITLE,NOTC_RDATE,NOTC_UDATE,NOTC_CONTENTS) values (1,'admin','[공지] BNC 이용방법 안내','20201125111148','20201130101135','<p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">안녕하세요 BNC 입니다.</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">사이트 이용방법 안내 드립니다.</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">1. SNS 계정으로 로그인</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">2. 상단 Mypage에서 기업 정보 등록</p><p style="text-align: left;" align="left">- 기업 정보 등록시 사업자 등록증도 같이 업로드 해주셔야 심사 후 가입 승인 처리 됩니다.</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">3. 프로젝트 의뢰</p><p style="text-align: left;" align="left">- 프로젝트를 의뢰하고 싶다면 가입 승인이 된 이후 프로젝트 의뢰 페이지에서</p><p style="text-align: left;" align="left">등록이 가능합니다.</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">4. 매칭 대기</p><p style="text-align: left;" align="left">- 타 기업에서 해당 프로젝트에 관심이 있다면 매칭 신청을 요청합니다.</p><p style="text-align: left;" align="left">- 해당 프로젝트 페이지의 하단에 매칭 신청한 기업의 정보가 노출되니 수락 버튼을 눌러 매칭을 해주세요.</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">5. 협의</p><p style="text-align: left;" align="left">- 매칭이 완료되면 의뢰사 측은 계약서를 작성해 주세요.</p><p style="text-align: left;" align="left">- 계약서는 한번 작성하면 해당 계약서가 자동으로 저장되어 추후 불러오기로 다시 사용하실 수 있습니다.</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">6. 진행</p><p style="text-align: left;" align="left">- 프로젝트를 진행해 주세요.</p><p style="text-align: left;" align="left">- 프로젝트 진행시에 만일 프로젝트를 철회해야한다면 양사가 동의하에 각각 철회 버튼을 눌러 프로젝트를 철회 해야합니다.</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">7. 완료</p><p style="text-align: left;" align="left">- 프로젝트 진행중 양사가 완료버튼을 눌러 프로젝트가 마무리되면</p><p style="text-align: left;" align="left">해당 프로젝트는 완료됩니다.</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">&nbsp;</p><p style="text-align: left;" align="left">감사합니다.</p><p style="text-align: left;" align="left">&nbsp;</p>');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (20,'아두이노 교육도구 시제품 제작','제작','/resources/project/e186efcb-690a-4d10-a605-e48e7e1dffad.jfif','010-0000-0000','다른코리아','010-4782-1369','45671236','rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 미만','<div style="text-align: center;" align="center"><img src="/resources/project/d88120c9-696e-4e17-b842-03f763c51c1f.jpg" title="%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8_%EC%84%A4%EB%AA%85.jpg"></div><div style="text-align: center;"><br></div>','N','Y','P','20201201121258','20201201121258');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (22,'아두이노 시제품','제작','/resources/project/993ed725-02fa-48a3-b527-cf505a13841c.jfif','010-0000-0000','다른코리아','01012341234','45671236','rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 미만','안녕하세요','N','N','W','20201201021223','20201202101221');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (21,'교육도구','제작','/resources/project/f6ecb7a7-47c3-4361-8e86-c7d305d4ef56.jfif','010-0000-0000','다른코리아','01012341234','45671236','rj8R5GbQNDE',null,'약 3개월','100만원 미만','<div style="text-align: center;" align="center"><img src="/resources/project/f021aa6c-3ed9-4582-95dd-886ea47600a8.jpg" title="%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8_%EC%84%A4%EB%AA%85.jpg"></div><br>','N','N','W','20201201021237','20201202101232');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (15,'아두이노 교육도구 시제품 제작','제작','/resources/project/03dcd980-065d-4218-bc36-b41deaa6e895.png','010-0000-0000','다른코리아','01012341234','122-86-00871','rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 미만','<img src="/resources/project/38d42af0-474a-4a23-926a-a19cb5a89a1f.png" title="%EB%8B%A4%EB%A5%B8%EC%BD%94%EB%A6%AC%EC%95%84_%EC%83%81%EC%84%B8.png"><br style="clear:both;"><br>','Y','Y','E','20201130021150','20201130021150');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (14,'아두이노 교육도구 시제품 제작','제작','/resources/project/d26974bb-3810-49c5-8433-79707630de2c.png','010-0000-0000','다른코리아','01012341234','122-86-00871','rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 ~ 500만원','<div style="text-align: center;" align="center"><img src="/resources/project/3278e394-85e9-4c41-ac50-6a19499c8753.png" title="%EB%8B%A4%EB%A5%B8%EC%BD%94%EB%A6%AC%EC%95%84_%EC%83%81%EC%84%B8.png"></div><div style="text-align: center;" align="center"><img src="/resources/project/b69f1b9d-2a4c-4a38-90f2-bd7b887839cf.jpg" title="proto_sup_img1.jpg"></div><div style="text-align: center;"><br></div>','N','N','W','20201130011122','20201201121225');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (16,'아두이노 교육도구 시제품 제작','제작','/resources/project/80612286-012a-42f0-9331-cb9bd1637182.jfif','010-0000-0000','다른코리아','010-0001-0002','122-86-00871','rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 미만','<img src="/resources/project/e7644cca-c427-4b46-a345-a7fc18331831.png" title="%EB%8B%A4%EB%A5%B8%EC%BD%94%EB%A6%AC%EC%95%84_%EC%83%81%EC%84%B8.png"><br style="clear:both;"><br>','N','N','W','20201130021128','20201201121244');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (17,'아두이노 교육키트 시제품 제작','제작','/resources/project/fb7bdbb7-4c9f-4f1d-ab73-57fcadc4e98b.png','010-0000-0000','다른코리아','01012341234','122-86-00871','rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 미만','<img src="/resources/project/a6d58c4a-6808-4ec2-9495-f6441884373c.png" title="%EB%8B%A4%EB%A5%B8%EC%BD%94%EB%A6%AC%EC%95%84_%EC%83%81%EC%84%B8.png"><br style="clear:both;"><br>','C','N','P','20201130021110','20201130021110');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (25,'아두이노 교육도구 시제품 제작','제작','/resources/project/bd63526a-a77f-4104-aabf-b49a7da2fe09.png','010-0000-0000','다른코리아','010-4782-1369','45671236','rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 미만','<div style="text-align: center;" align="center"><img src="/resources/project/48c8f8cd-f7a0-4781-b9d6-2bde76d7c399.jpg" title="%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8_%EC%84%A4%EB%AA%85.jpg"></div><div style="text-align: center;"><br></div>','N','Y','P','20201202101244','20201202101201');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (19,'아두이노 교육도구 시제품 제작','제작','/resources/project/34c47eb6-25e2-4404-8bee-6faff698df36.png','010-0000-0000','다른코리아','01012341234','45698214','rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 미만','<img src="/resources/project/b6eb67cc-3a9b-493a-a577-2a06b5a49882.jpg" title="%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8_%EC%84%A4%EB%AA%85.jpg"><br style="clear:both;"><br>','N','Y','P','20201201111237','20201201111237');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (26,'아두이노 교육도구 시제품 제작','제작','/resources/project/f1f75eec-1f0a-4fce-9b79-e998b632aa37.jfif','010-0000-0000','다른코리아',null,null,'rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 미만','<img src="/resources/project/8a6758a8-a42a-4cf8-bec1-0f9c97a4b6cd.jpg" title="%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8_%EC%84%A4%EB%AA%85.jpg"><br style="clear:both;"><br>','N','N','W','20201202021230','20201202021230');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (9,'책상시제품제작','제작','/resources/project/854ae698-cf80-4617-b28c-1296c8f298fb.png','010-1111-2222','45698214',null,null,null,'책상','1개월','100만원 미만','책상 제작 업체 찾습니다.','N','N','W','20201130101141','20201130101122');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (10,'파이프 견본','견적','/resources/project/9b107be7-e0ca-4b6f-b2e9-a1c38ef6c46e.png','010-2222-3333','45671236',null,null,null,'파이프','2개월','100만원 미만','파이프 견본 업체 찾습니다.','N','N','W','20201130101137','20201130101137');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (11,'IoT 가구 제작','제작','/resources/project/f4241f73-cbaa-420b-893c-75ec88dcbf30.png','010-2263-7511','1424772350',null,null,null,'가구, IoT','2021-02-30','500만원 ~ 1000만원','IoT 가구 제작 요청입니다.','N','N','W','20201130101152','20201130101152');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (12,'드론 제작','제작','/resources/project/b4ed0f5c-d02f-42b9-b017-eded967392f2.gif','010-2263-7442','557221143','010-4258-4465','1424772350',null,'드론, IoT','2021-04-30','500만원 ~ 1000만원','드론 제작 프로젝트 입니다.','Y','Y','E','20201130101101','20201130101101');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (13,'화장품 성분 개발','컨설팅','/resources/project/5f6c4478-fb08-4bcb-9729-040d5f77138a.gif','010-7945-9292','1424772355',null,null,null,'화장품, 뷰티, 성분','약 3개월','100만원 ~ 500만원','<div style="text-align: center;" align="center"><img src="/resources/project/bf8f2b02-1d0b-4791-bdf6-1375cc4729c4.jpg" title="com01_2_con01.jpg"></div><div style="text-align: center;"><br></div>','N','N','W','20201130111153','20201130111153');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (18,'아두이노 교육키트 시제품 제작','제작','/resources/project/7541ec34-e44c-4c72-9ba8-4317e65b3d58.png','010-0000-0000','다른코리아','01012341234','122-86-00871','rj8R5GbQNDE','아두이노, 시제품','약 3개월','100만원 미만','<div style="text-align: center;" align="center"><img src="/resources/project/8a49d18d-e5d4-4bd8-9ee7-a783a5b3fef0.jpg" title="proto_sup_img1.jpg"></div><br>','C','N','P','20201130031127','20201130031127');
INSERT INTO bnc_project (PROJ_NUMBER,PROJ_NAME,PROJ_KIND,PROJ_THUMB_FILE_PATH,PROJ_REQ_PHONE,PROJ_REQ_BIZNUM,PROJ_ACP_PHONE,PROJ_ACP_BIZNUM,PROJ_MOV_URL,PROJ_KEYWORD,PROJ_LEAD_TIME,PROJ_PRICE_RANGE,PROJ_CONTENTS,PROJ_REQ_FLAG,PROJ_ACP_FLAG,PROJ_FLAG,PROJ_RDATE,PROJ_UDATE) values (23,'아두이노','제작','/resources/project/faac45f9-ca60-464f-b270-fe7e4ef79328.jfif','01012341234','다른코리아',null,null,null,'아두이노, 시제품','약 3개월','100만원 미만','안녕하세요','N','N','W','20201201041242','20201201041242');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (19,20,'/resources/project/d304c81d-240e-47c5-ab3f-068a42bf4b78.pdf','프로젝트_일정.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (23,24,'/resources/project/6f33d1dc-8f60-49e9-a9d0-3819f1265ec1.png','test.png');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (20,21,'/resources/project/079034f9-e19a-4c10-b858-27e17febc192.pdf','프로젝트_일정.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (21,22,'/resources/project/c732385d-3c69-4f69-9f83-d5b2c5f06e28.pdf','프로젝트_일정.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (15,16,'/resources/project/757203d0-b474-467e-9410-7d6a0427be88.pdf','프로젝트 진행일정_Java 양성과정.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (16,17,'/resources/project/fe040ab6-96a9-4406-b605-d1a99444203e.pdf','프로젝트 진행일정_Java 양성과정.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (24,25,'/resources/project/4ac920db-8b53-4190-bd8f-c68af8fdb4c2.pdf','프로젝트_일정.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (13,14,'/resources/project/44447357-42c5-41c9-82e0-518ef138576c.pdf','프로젝트 진행일정_Java 양성과정.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (14,15,'/resources/project/91f51f57-2443-4b5a-bf2d-2911128fc45f.pdf','프로젝트 진행일정_Java 양성과정.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (18,19,'/resources/project/a990afe3-064a-4710-828a-394f2624e14c.png','아두이노_키트_예시.png');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (25,26,'/resources/project/daea3185-5a05-4db7-ac1a-ce3c98aaac0a.pdf','프로젝트_일정.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (10,11,'/resources/project/a007d6ad-f171-4fd8-b854-022af0474d20.docx','IoT 가구 제작 프로젝트.docx');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (12,13,'/resources/project/6598e6cf-ab1b-4c1d-9c73-30b10ea4222b.jpg','com01_2_con01.jpg');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (11,12,'/resources/project/cd3bfc13-3170-47d5-a390-175021a89b66.docx','드론 제작 프로젝트.docx');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (17,18,'/resources/project/1ced798b-ae5a-47bf-9520-7bdb9997a168.pdf','아두이노 교육키트 시제품 제작 계약서.pdf');
INSERT INTO bnc_project_file (PROF_SEQ,PROF_PROJ_NUMBER,PROF_FILE_PATH,PROF_FILE_NAME) values (22,23,'/resources/project/d56f6ff6-5fb0-4cd7-8237-24190021c534.jpg','프로젝트_설명.jpg');
INSERT INTO bnc_project_participate_list (PRPL_NUMBER,PRPL_ACP_BIZNUM,PRPL_ACP_PHONE,PRPL_ACP_PRICE,PRPL_RDATE,PRPL_FILE_PATH,PRPL_FILE_NAME) values (13,'1424772359','01-0020-60ㄴㅇ',1000000,'20201201011211',null,null);
INSERT INTO bnc_project_participate_list (PRPL_NUMBER,PRPL_ACP_BIZNUM,PRPL_ACP_PHONE,PRPL_ACP_PRICE,PRPL_RDATE,PRPL_FILE_PATH,PRPL_FILE_NAME) values (22,'45671236','01012341234',800000,'20201201021217',null,null);
INSERT INTO bnc_project_participate_list (PRPL_NUMBER,PRPL_ACP_BIZNUM,PRPL_ACP_PHONE,PRPL_ACP_PRICE,PRPL_RDATE,PRPL_FILE_PATH,PRPL_FILE_NAME) values (13,'다른코리아','010-1234-1234',900000,'20201201011217',null,null);
INSERT INTO bnc_project_participate_list (PRPL_NUMBER,PRPL_ACP_BIZNUM,PRPL_ACP_PHONE,PRPL_ACP_PRICE,PRPL_RDATE,PRPL_FILE_PATH,PRPL_FILE_NAME) values (26,'45671236','01012341234',800000,'20201202021254','/resources/00ab20f7-1cc2-4225-9d5a-ce12cc00881a.pdf','포트폴리오2.pdf');
INSERT INTO bnc_project_participate_list (PRPL_NUMBER,PRPL_ACP_BIZNUM,PRPL_ACP_PHONE,PRPL_ACP_PRICE,PRPL_RDATE,PRPL_FILE_PATH,PRPL_FILE_NAME) values (23,'45671236','010-1234-1234',900000,'20201201041203',null,null);
INSERT INTO bnc_sign (SIGN_NUM,SIGN_FILE_PATH,SIGN_MEMB_ID,SIGN_RDATE,SIGN_UDATE) values (13,'/resources/sign/159d25fa-09f1-4848-aa51-85c0d275cc76.png','naver_57280044','20201130110056','20201130110056');
INSERT INTO bnc_sign (SIGN_NUM,SIGN_FILE_PATH,SIGN_MEMB_ID,SIGN_RDATE,SIGN_UDATE) values (11,'/resources/sign/b78fd125-b807-4c46-bdd7-29a76fd7e89d.png','naver_57280044','20201130100049','20201130100049');
INSERT INTO bnc_sign (SIGN_NUM,SIGN_FILE_PATH,SIGN_MEMB_ID,SIGN_RDATE,SIGN_UDATE) values (12,'/resources/sign/818ab786-ae48-4f07-bca8-c84794be059b.png','kakao_1540285291','20201130100046','20201130100046');
INSERT INTO bnc_terms (POL_KIND,POL_CONTENTS,POL_RDATE,POL_UDATE) values ('P','"<div class="policy">
		        <h2 style="margin: 0px; padding: 0px;"><p class="0"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">1. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">개인정보의 처리 목적</span></p><p class="0"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">BNC</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">는 다음의 목적을 위하여 개인정보를 처리하고 있으며</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">다음의 목적 이외의 용도로는 이용하지 않습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">- </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">고객 가입의사 확인</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">고객에 대한 서비스 제공에 따른 본인 식별</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">인증</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">회원자격 유지</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">관리</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">물품 또는 서비스 공급에 따른 금액 결제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">물품 또는 서비스의 공급</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">배송 등</span></span></p><p class="0">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">2. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">개인정보의 처리 및 보유 기간</span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">① </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">BNC</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">는 정보주체로부터 개인정보를 수집할 때 동의 받은 개인정보 보유</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이용기간 또는 법령에 따른 개인정보 보유</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이용기간 내에서 개인정보를 처리</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">보유합니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;"><br></span></span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">② </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">구체적인 개인정보 처리 및 보유 기간은 다음과 같습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="margin-left:40.0pt;text-indent:-15.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">☞ </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">아래 예시를 참고하여 개인정보 처리업무와 개인정보 처리업무에 대한 보유기간 및 관련 법령</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">근거 등을 기재합니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">. (</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">예시</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">)- </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">고객 가입 및 관리 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">: </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">서비스 이용계약 또는 회원가입 해지시까지</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">다만 채권</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">채무관계 잔존시에는 해당 채권</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">채무관계 정산시까지 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">- </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">전자상거래에서의 계약</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">청약철회</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">대금결제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">재화 등 공급기록 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">: 5</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">년</span></span></p><p class="0" style="margin-left:40.0pt;text-indent:-15.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0" style="margin-left:40.0pt;text-indent:-15.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">3. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">개인정보의 제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">3</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">자 제공에 관한 사항</span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">① </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">BNC</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">는 정보주체의 동의</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">법률의 특별한 규정 등 개인정보 보호법 제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">17</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">조 및 제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">18</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">조에 해당하는 경우에만 개인정보를 제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">3</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">자에게 제공합니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;"><br></span></span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">② </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">BNC </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">개인정보를 제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">3</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">자에게 제공하지 않습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">단</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">다음의 경우에는 이용자의 동의 없이 개인정보를 제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">3</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">자에게 제공할 수 있습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="margin-left:28.4pt;text-indent:-9.2pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">- </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이용자가 서비스를 이용해 타인에게 정신적 또는 물질적 피해를 줌으로써 그에 대한 법적인 조치를 취하기 위해 개인정보를 공개해야 된다고 판단하는 경우 이용자가 법령 또는 약관 위반을 포함한 부정행위 확인 등 정보보호 업무를 위해 필요한 경우 법에 의거해 적법한 절차에 의한 수사기관이나 기타 정부기관으로부터 정보제공을 요청 받은 경우 기타 법률의 특별한 규정 등 개인정보 보호법 제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">17</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">조 및 제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">18</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">조에 해당하는 경우</span></span></p><p class="0" style="margin-left:28.4pt;text-indent:-9.2pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0" style="margin-left:28.4pt;text-indent:-9.2pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">4. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">개인정보처리 위탁</span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">① </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(''BNC'')</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">은</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">는</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">) </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">서비스 제공에 필요한 업무 중 일부를 위탁하고 있습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">- </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">개인정보 위탁업체</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-size: 12pt;">  </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">가비아</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(<a href="http://gabia.net)">http://gabia.net)</a> : </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">개인정보가 보관된 호스팅 서버 운영 및 관리</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;"><br></span></span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">② </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(''<a href="http://alice-in.net">http://alice-in.net</a>''</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이하 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">''BNC'')</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">은</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">는</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">) </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">위탁계약 체결시 개인정보 보호법 제</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">25</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">조에 따라 위탁업무 수행목적 외 개인정보 처리금지</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">기술적</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">관리적 보호조치</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">재위탁 제한</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">수탁자에 대한 관리</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">감독</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;"><br></span></span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">③ </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">위탁업무의 내용이나 수탁자가 변경될 경우에는 지체없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">5. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">정보주체와 법정대리인의 권리</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">·</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">의무 및 그 행사방법 이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">.</span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">① </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">정보주체는 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">BNC </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">1. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">개인정보 열람요구</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">2. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">오류 등이 있을 경우 정정 요구</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">3. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">삭제요구</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">4. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">처리정지 요구</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">6. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">처리하는 개인정보의 항목 작성</span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">① </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(''BNC'')</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">은</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">는</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">) </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">다음의 개인정보 항목을 처리하고 있습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">&lt;</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">회원가입 및 사이트 이용</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">&gt;</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span lang="EN-US" style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">- </span><span style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">필수항목 </span><span lang="EN-US" style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">: </span><span style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이메일</span><span lang="EN-US" style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">비밀번호</span><span lang="EN-US" style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">로그인</span><span lang="EN-US" style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">ID, </span><span style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">서비스 이용 기록</span><span lang="EN-US" style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">접속 로그</span><span lang="EN-US" style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">쿠키</span><span lang="EN-US" style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">접속 </span><span lang="EN-US" style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">IP </span><span style="font-weight: normal; text-indent: -62.9pt; font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">정보</span></p><p class="0" style="margin-left:135.8pt;text-indent:-62.9pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0" style="margin-left:135.8pt;text-indent:-62.9pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">7. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">개인정보의 파기</span></p><p class="0"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(''BNC'')</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">은</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">는</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">) </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">파기의 절차</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">기한 및 방법은 다음과 같습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">-</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">파기절차</span></span></p><p class="0" style="margin-left:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이용자가 입력한 정보는 목적 달성 후 별도의 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">DB</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">에 옮겨져</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">종이의 경우 별도의 서류</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">) </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이 때</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, DB</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="margin-left:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;"><br></span></span></p><p class="0"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">-</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">파기기한</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이용자의 개인정보는 회원탈퇴 즉시 개인정보를 파기합니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">8. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">개인정보 자동 수집 장치의 설치</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">운영 및 거부에 관한 사항</span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">① </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">BNC </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">은 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">‘</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">세션</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(session)’</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">을 사용합니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;"><br></span></span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">② </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">쿠키는 웹사이트를 운영하는데 이용되는 서버</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">(http)</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">PC </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">컴퓨터내의 하드디스크에 저장되기도 합니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="margin-left:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">가</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">쿠키의 사용 목적 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">: </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">인기 검색어</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">보안접속 여부</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="margin-left:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">나</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">쿠키의 설치</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">운영 및 거부 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">: </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">웹브라우저 상단의 도구</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">&gt;</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">인터넷 옵션</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">&gt;</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p><p class="0"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 14pt;">9. </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 14pt;">기타</span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">개인정보 처리방침이 변경되는 경우 는 최소 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">7</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">일 전에 변경사항을 게시합니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0"><span style="font-weight: normal;"><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">다만</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">수집하는 개인정보의 항목</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">, </span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">이용목적의 변경 등과 같이 이용자 권리의 중대한 변경이 발생할 때에는 최소 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">30</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">일 전에 공지합니다</span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">.</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">-</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">공고일자 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">: 2020</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">년 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">11</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">월 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">29</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">일</span></span></p><p class="0" style="text-indent:10.0pt;mso-pagination:none;text-autospace:none;mso-padding-alt:0pt 0pt 0pt 0pt;"><span style="font-weight: normal;"><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">-</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">시행일자 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">: 2020</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">년 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">11</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">월 </span><span lang="EN-US" style="font-family: &quot;맑은 고딕&quot;; letter-spacing: 0pt; font-size: 12pt;">29</span><span style="font-family: &quot;맑은 고딕&quot;; font-size: 12pt;">일</span></span></p><p class="0">  <!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->  <o:p></o:p></p></h2>    
		   	</div>
		
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				"','20201125000000','20201125000000');
INSERT INTO bnc_terms (POL_KIND,POL_CONTENTS,POL_RDATE,POL_UDATE) values ('T','"<div class="policy">
    <h2>제1조 (목적)</h2>
<p>이 약관은 BNC가 제공하는 서비스의 이용과 관련하여 BNC와 회원 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.</p>
<br>
<br>
<h2>제2조 (용어의 정의)</h2>
<p>이 약관에서 사용하는 용어의 정의는 다음과 같으며 이외에는 관계법령 및 기타 일반적인 상관례에 의합니다.</p>
<br>
<p>“회원”이라 함은 본 약관에 동의하고 BNC가 제공하는 서비스의 이용 자격을 부여받은 자를 의미합니다.</p>
<p>“서비스”라 함은 BNC가 회원에게 제공하는, “컨텐츠”를 “업로드”하고 공유, 검색 등을 할 수 있게 하는 일련의 사항을 의미합니다.</p>
<p>“컨텐츠”라 함은 회원이 서비스를 이용함에 있어 회원이 “업로드”한 그림, 사진, 영상 및 이에 속하는 댓글 등 회원이 게시, 편집, 열람 가능한 모든 정보를 말합니다. 회원의 닉네임, 채널명, 채널소개 등도 이에 포함됩니다.</p>
<p>“업로드”라 함은 회원이 컨텐츠를 서비스 상에 표시하기 위해 자신의 저작물을 BNC의 서버에 게시하는 행위를 의미합니다.</p>
<br>
<br>
<h2>제3조 (약관의 명시와 개정)</h2>
<p>BNC는 이 약관의 내용을 회원이 알 수 있도록 서비스 홈페이지에 게시하거나 연결화면을 제공하는 방법으로 회원에게 공지합니다.</p>
<p>BNC는 회원이 이 약관의 내용에 관하여 질의 및 응답을 할 수 있도록 조치를 취합니다.</p>
<p>BNC는 서비스를 이용하고자 하는 자(이하 “이용자”라 한다)가 약관의 내용을 쉽게 알 수 있도록 작성하고 약관에 동의하기에 앞서 약관에 정하여져 있는 내용 중 계약 해제ㆍ해지, BNC의 면책사항 및 회원에 대한 피해보상 등과 같은 중요한 내용을 회원이 쉽게 이해할 수 있도록 굵은 글씨 등으로 처리하거나 별도의 연결화면 또는 팝업화면 등을 제공하고 이용자의 동의를 얻도록 합니다.</p>
<p>BNC는 「전자상거래 등에서의 소비자보호에 관한 법률」, 「약관의 규제에 관한 법률」, 「정보통신망이용촉진 및 정보보호 등에 관한 법률」, 「콘텐츠산업진흥법」 등 관련 법령에 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.</p>
<p>BNC가 약관을 개정할 경우에는 적용일자 및 개정내용, 개정사유 등을 명시하여 그 적용일자로부터 최소한 7일 이전(회원에게 불리하거나 중대한 사항의 변경은 30일 이전)부터 그 적용일자 경과 후 상당한 기간이 경과할 때까지 초기화면 또는 초기화면과의 연결화면을 통해 공지합니다.</p>
<p>BNC가 약관을 개정할 경우에는 개정약관 공지 후 개정약관의 적용에 대한 회원의 동의 여부를 확인합니다. 개정약관 공지 시 회원이 동의 또는 거부의 의사표시를 하지 않으면 승낙한 것으로 간주하겠다는 내용도 함께 공지한 경우에는 회원이 약관 시행일 까지 거부의사를 표시하지 않는다면 개정약관에 동의한 것으로 간주할 수 있습니다.</p>
<p>회원이 개정약관의 적용에 동의하지 않는 경우 BNC 또는 회원은 서비스 이용계약을 해지할 수 있습니다.</p>
<br>
<br>
<h2>제4조 (약관의 해석)</h2>
<p>이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 「전자상거래 등에서의 소비자보호에 관한 법률」, 「약관의 규제에 관한 법률」, 「정보통신망이용촉진 및 정보보호 등에 관한 법률」, 「콘텐츠산업진흥법」 등 관련 법령에 따릅니다.</p>
<br>
<br>
<h2>제5조 (운영정책)</h2>
<p>약관을 적용하기 위하여 필요한 사항과 회원의 권익을 보호하고 서비스 내 질서를 유지하기 위하여 BNC는 약관에서 구체적 범위를 정하여 위임한 사항을 운영정책으로 정할 수 있습니다.</p>
<p>BNC는 운영정책의 내용을 회원이 알 수 있도록 서비스 홈페이지에 게시하거나 연결화면을 제공하는 방법으로 회원에게 공지하여야 합니다.</p>
<p>회원의 권리 또는 의무에 중대한 변경을 가져오거나 약관 내용을 변경하는 것과 동일한 효력이 발생하는 운영정책 개정의 경우에는 제4조의 절차에 따릅니다. 단, 운영정책 개정이 다음 각 호의 어느 하나에 해당하는 경우에는 제2항의 방법으로 사전에 공지합니다.&lt;
</p><p>약관에서 구체적으로 범위를 정하여 위임한 사항을 개정하는 경우</p>
<p>회원의 권리·의무와 관련 없는 사항을 개정하는 경우</p>
<p>운영정책의 내용이 약관에서 정한 내용과 근본적으로 다르지 않고 회원이 예측 가능한 범위 내에서 운영정책을 개정하는 경우</p>
<br>
<br>
<h2>제6조 (이용신청 및 방법)</h2>
<p>BNC가 제공하는 서비스를 이용하고자 하는 자는 서비스에서 제공하는 이용신청서를 작성하는 방법으로 이용신청을 하여야 합니다.</p>
<p>이용자는 이용 신청 시 BNC에서 요구하는 제반 정보를 제공하여야 합니다.</p>
<p>이용자는 제1항의 이용 신청 시 본인의 실제 정보를 기재하여야 합니다. 전자우편주소 등의 식별정보를 허위로 기재하거나 타인의 명의를 도용한 경우 이 약관에 의한 회원의 권리를 주장할 수 없고, BNC는 이용계약을 취소하거나 해지할 수 있습니다.</p>
<p>‘트위터 계정, 카카오 계정, 네이버 계정  로그인’을 이용해 SNS와 연동하는 방법으로도 이용신청이 가능합니다. 이 경우 최초 로그인 시 애플리케이션 승인과 동시에 개인정보 수집에 대해 동의한 것으로 봅니다.</p>
<br>
<br>
<h2>제7조 (이용신청의 승낙과 제한)</h2>
<p>BNC는 이용자에게 요구하는 정보에 대해 이용자가 실제 정보를 정확히 기재하여 이용신청을 한 경우에 상당한 이유가 없는 한 이용신청을 승낙합니다.</p>
<p>BNC는 다음 각 호의 어느 하나에 해당하는 이용신청에 대해서는 승낙을 하지 않을 수 있습니다.</p>
<p>제7조에 위반하여 이용신청을 하는 경우</p>
<p>이용제한 기록이 있는 이용자가 이용신청을 하는 경우</p>
<p>「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 및 그 밖의 관계 법령에서 금지하는 위법행위를 할 목적으로 이용신청을 하는 경우</p>
<p>그 밖에 위 각 호에 준하는 사유로서 승낙이 부적절하다고 판단되는 경우</p>
<p>BNC는 다음 각 호의 어느 하나에 해당하는 경우에는 그 사유가 해소될 때까지 승낙을 유보할 수 있습니다.</p>
<p>BNC의 설비에 여유가 없거나 기술적 장애가 있는 경우</p>
<p>서비스 상의 장애 발생한 경우</p>
<p>그 밖에 위 각 호에 준하는 사유로서 이용신청의 승낙이 곤란한 경우</p>
<br>
<br>
<h2>제8조 (회원 계정(ID) 및 비밀번호)</h2>
<p>BNC는 회원에 대하여 회원의 정보 보호, 서비스 이용안내 등의 편의를 위해 회원이 선정한 일정한 문자, 숫자 또는 특수문자의 조합을 계정으로 부여합니다.</p>
<p>BNC는 계정정보를 통하여 당해 회원의 서비스 이용가능 여부 등의 제반 회원 관리업무를 수행합니다.</p>
<p>회원은 자신의 계정정보를 선량한 관리자로서의 주의 의무를 다하여 관리하여야 합니다.</p>
<p>회원이 본인의 계정정보를 소홀히 관리하거나 제3자에게 이용을 승낙함으로써 발생하는 손해에 대하여는 회원에게 책임이 있습니다.</p>
<p>비밀번호의 관리책임은 회원에게 있으며, 회원이 원하는 경우에는 보안상의 이유 등으로 언제든지 변경이 가능합니다.</p>
<p>회원은 정기적으로 비밀번호를 변경하여야 합니다.</p>
<br>
<br>
<h2>제9조 (회원 정보의 제공 및 변경)</h2>
<p>회원은 이 약관에 의하여 BNC에 정보를 제공하여야 하는 경우에는 진실된 정보를 제공하여야 하며, 허위정보 제공으로 인해 발생한 불이익에 대해서는 보호받지 못합니다.</p>
<p>회원은 개인정보관리화면을 통하여 언제든지 자신의 개인정보를 열람하고 수정할 수 있습니다. 다만, 서비스 관리를 위해 필요한 전자메일주소, 고객번호(고유ID) 등은 수정이 불가능합니다.</p>
<p>회원은 회원가입 신청 시 기재한 사항이 변경되었을 경우 온라인으로 수정을 하거나 기타 방법으로 BNC에 대하여 그 변경사항을 알려야 합니다.</p>
<p>제2항의 변경사항을 BNC에 알리지 않아 발생한 불이익에 대하여 BNC는 책임을 지지 않습니다.</p>
<br>
<br>
<h2>제10조 (개인정보의 보호 및 관리)</h2>
<p>BNC는 관계 법령이 정하는 바에 따라 계정정보를 포함한 회원의 개인정보를 보호하기 위해 노력합니다. 회원 개인정보의 보호 및 사용에 대해서는 관계법령 및 BNC가 별도로 고지하는 개인정보 처리방침이 적용됩니다.</p>
<p>서비스 내 광고 등 제3자 제공의 서비스에 대하여는 BNC의 개인정보 처리방침이 적용되지 않습니다.</p>
<p>BNC는 회원의 귀책사유로 인하여 노출된 회원의 계정정보를 포함한 모든 정보에 대해서 일체의 책임을 지지 않습니다.</p>

<h2>제11조 (BNC의 의무)</h2>
<p>BNC는 관련 법령을 준수하고, 이 약관이 정하는 권리의 행사와 의무의 이행을 신의에 따라 성실하게 합니다.</p>
<p>BNC는 회원이 안전하게 서비스를 이용할 수 있도록 개인정보(신용정보 포함)보호를 위해 보안시스템을 갖추어야 하며 개인정보 처리방침을 공시하고 준수합니다. BNC는 이 약관 및 개인정보 처리방침에서 정한 경우를 제외하고는 회원의 개인정보가 제3자에게 공개 또는 제공되지 않도록 합니다.</p>
<p>BNC는 계속적이고 안정적인 서비스의 제공을 위하여 노력합니다. 천재지변, 비상사태, 현재의 기술로는 해결이 불가능한 결함 및 장애 등 부득이한 사유가 없는 한 지체 없이 서비스 상의 문제를 수리 또는 복구하도록 최선의 노력을 다합니다.</p>
<br>
<br>
<h2>제12조 (회원의 의무)</h2>
<p>일반적 금지 사항 : 회원은 다음 행위를 하여서는 안 됩니다.</p>
<p>이용 신청 또는 개인정보 변경 시 허위내용의 기재</p>
<p>타인의 정보도용</p>
<p>BNC 관리자 및 관계자를 사칭하는 행위</p>
<p>BNC의 비공개 영역이나 시스템에 접근하거나 취약점을 조사하는 행위</p>
<p>BNC가 금지한 정보(바이러스 등)의 송신 또는 게시하는 행위</p>
<p>BNC 및 기타 제3자의 저작권 등 지적재산권에 대한 침해하는 행위</p>
<p>BNC 및 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위</p>
<p>BNC의 동의 없이 영리, 정치활동 등을 목적으로 서비스를 사용하는 행위</p>
<p>문의 창구를 오남용하거나 허위 신고로 정상적 운영을 방해하는 행위</p>
<p>정상 범위를 넘어 서비스의 서버나 네트워크에 부담을 주는 행위</p>
<p>컨텐츠 금지 사항 : 회원은 이하 내용의 컨텐츠를 업로드해서는 안 됩니다.</p>
<p>신체적ㆍ언어적ㆍ정신적을 불문하고 폭력행위 및 이에 준하는 잔인성을 담은 내용</p>
<p>타인에게 명백히 혐오감, 불쾌감을 주거나 스트레스를 유발하는 내용</p>
<p>대한민국 정책 및 관계 법령이 제한하는 음란물, 혹은 의도를 가지고 성적 자극을 유도하거나 조장하는 내용</p>
<p>불특정 다수를 대상으로 광고 또는 선전 목적을 갖는 음란물을 담은 내용</p>
<p>사기, 사칭, 마약, 폭탄, 불법 프로그램 구동 및 홍보 등 반 사회적인 행위를 담은 내용</p>
<p>특정 개인, 단체, 인종, 종교, 장애, 성별, 연령, 정치, 성적 취향 등을 모욕하는 행위나 이를 조장하는 내용</p>
<p>자살, 자해 등의 행위나 이를 미화, 조장하는 내용</p>
<p>기타 미풍양속에 비추어 이를 위반하는 내용</p>
<p>회원은 이 약관의 규정, 이용안내 및 서비스와 관련하여 공지한 주의사항, BNC가 통지하는 사항 등을 확인하고 준수할 의무가 있습니다.</p>
<br>
<br>
<h2>제13조 (서비스의 변경 및 내용수정)</h2>
<p>회원은 BNC가 제공하는 서비스를 이 약관, 운영정책에 따라 이용할 수 있습니다.</p>
<p>BNC는 서비스 내용의 제작, 변경, 유지, 보수에 관한 포괄적인 권한을 가집니다.</p>
<p>BNC는 서비스를 유지하고 서비스 내 질서 유지를 위해 필요한 조치를 취합니다.</p>
<p>BNC는 운영상, 기술상의 필요에 따라 서비스를 수정할 수 있으며, 변경 후 해당 사이트 등을 통하여 공지합니다.</p>
<br>
<br>
<h2>제14조 (서비스의 제공 및 중단 등)</h2>
<p>다음 각 호의 어느 하나에 해당하는 경우에는 일정한 시간동안 서비스가 제공되지 아니할 수 있으며, 해당 시간 동안 BNC는 서비스를 제공할 의무가 없습니다.</p>
<p>컴퓨터 등 정보통신설비의 보수점검, 교체, 정기점검 또는 서비스의 수정을 위하여 필요한 경우</p>
<p>해킹 등의 전자적 침해사고, 통신사고, 회원들의 비정상적인 서비스 이용행태, 미처 예상하지 못한 서비스의 불안정성에 대응하기 위하여 필요한 경우</p>
<p>천재지변, 비상사태, 정전, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 정상적인 서비스 제공이 불가능할 경우</p>
<p>BNC의 분할, 합병, 영업양도, 영업의 폐지, 당해 서비스의 수익 악화 등 경영상 중대한 필요에 의한 경우</p>
<p>제1항 제2호의 경우, BNC는 사전 고지 없이 서비스를 일시 중지할 수 있습니다. 이러한 경우 그 사실을 서비스 홈페이지에 사후 고지할 수 있습니다.</p>
<p>BNC는 BNC가 제공하는 무료서비스 이용과 관련하여 이용자에게 발생한 어떠한 손해에 대해서도 책임을 지지 않습니다. 다만, BNC의 고의 또는 중대한 과실로 인하여 발생한 손해의 경우는 제외합니다.</p>
<p>제1항 제3호 내지 제4호의 경우에 BNC는 기술상, 운영상 필요에 의해 서비스 전부를 중단할 수 있으며, 30일전에 홈페이지에 이를 공지하고 서비스의 제공을 중단할 수 있습니다. 사전에 통지할 수 없는 부득이한 사정이 있는 경우는 사후에 통지를 할 수 있습니다.</p>
<p>BNC가 제4항에 따라 서비스를 종료하는 경우 회원은 서비스에 대하여 손해배상을 청구할 수 없습니다.</p>
<br>
<br>
<h2>제15조 (저작권 등)</h2>
<p>BNC 서비스는 회원이 창작한 창작물의 업로드를 전제로 하고 있습니다. BNC는 회원과 제3자의 저작권을 존중하며 회원들도 그러할 것으로 기대합니다.</p>
<p>서비스 내 BNC가 제작한 콘텐츠(디자인, 인코딩 및 스트리밍에 관한 기술 등 BNC를 구성하는 요소 전반)에 대한 저작권, 기타 지적재산권은 BNC의 소유입니다.</p>
<p>회원은 BNC에 지적재산권이 귀속된 정보를 BNC의 사전승낙 없이 복제, 전송, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안 됩니다.</p>
<p>BNC는 관계 법률을 준수하여 정당하게 BNC에 제기된 저작권 위반 신고에 대해 적절한 대응을 취해야 합니다. BNC는 저작권 침해 소지가 있는 콘텐츠를 재량에 따라 사전 고지 없이 삭제할 수 있습니다.</p>
<p>만약 회원이 저작권법을 위반하는 행위를 한 경우 발생하는 모든 민ㆍ형법적, 재산적 문제는 회원 자신의 책임이며 BNC는 일체의 책임을 지지 않습니다.</p>
<p>회원이 업로드한 적법한 컨텐츠의 저작권은 해당 회원에게 있으며, 회원의 콘텐츠에 대하여 BNC는 회원의 명시적인 동의가 없이 상업적으로 이용하지 않습니다. 회원은 언제든지 이러한 이용자 콘텐츠를 삭제할 수 있습니다.</p>
<p>BNC는 회원이 업로드하는 게시물, 게시 내용에 대해 제 13조에서 규정하는 금지행위에 해당된다고 판단되는 경우, 사전통지 없이 이를 삭제하거나 이동할 수 있습니다.</p>
<p>제3항의 내용은 서비스를 운영하는 동안 유효하며 회원탈퇴 후에도 지속적으로 적용됩니다.</p>
<br>
<br>
<h2>제16조 (회원의 해제 및 해지)</h2>
<p>회원은 서비스 이용계약을 해지(이하 ''회원탈퇴''라 한다)할 수 있습니다. 회원이 회원탈퇴를 신청한 경우 BNC는 회원 본인 여부를 확인할 수 있으며, 해당 회원이 본인으로 확인되는 경우에 회원의 신청에 따른 조치를 취합니다.
</p><p>회원이 회원탈퇴를 원하는 경우에는 문의하기를 통해 회원탈퇴를 할 수 있습니다.
<br>
<br>
</p><h2>제17조 (BNC의 해제 및 해지)</h2>
<p>BNC는 회원이 이 약관에서 정한 회원의 의무를 위반한 경우 회원에 대한 사전 통보 후 계약을 해지할 수 있습니다.</p> 
<p>다만, 회원이 현행법 위반 및 고의 또는 중대한 과실로 BNC에 손해를 입힌 경우에는 사전 통보 없이 이용계약을 해지할 수 있습니다.</p>
<p>BNC가 이용계약을 해지하는 경우 회원에게 서면, 전자우편 또는 이에 준하는 방법으로 다음 각 호의 사항을 회원에게 통보합니다.</p>
<p>해지사유</p>
<p>해지일</p>
<p>제1항 단서의 경우, 회원은 모든 서비스의 사용권한을 상실하고 이로 인한 손해배상을 청구할 수 없습니다.</p>
<br>
<br>
<h2>제18조 (잠정조치로서의 이용제한)</h2>
<p>BNC는 다음 각 호에 해당하는 문제에 대한 조사가 완료될 때까지 계정을 정지할 수 있습니다.</p>
<p>계정이 해킹 또는 도용당하였다는 정당한 신고가 접수된 경우</p>
<p>금지 사항 위반 등 위법행위자로 합리적으로 의심되는 경우</p>
<p>그 밖에 위 각호에 준하는 사유로 계정의 잠정조치가 필요한 경우</p>
<p>제1항에 의한 위법행위자로 판명된 경우 계정 영구적 사용 제한 등 추가적인 조치가 취해질 수 있습니다.</p>
<br>
<br>
<h2>제19조 (손해배상)</h2>
<p>BNC가 고의 또는 중과실로 회원에게 손해를 끼친 경우, 손해에 대하여 배상할 책임이 있습니다.</p>
<p>회원이 본 약관을 위반하여 BNC에 손해를 끼친 경우, 회원은 BNC에 대하여 그 손해에 대하여 배상할 책임이 있습니다.</p>
<br>
<br>
<h2>제20조 (면책)</h2>
<p>BNC는 서비스 내외를 불문하고 회원 간에 이루어지는 모든 통신에 관여하지 않습니다. 분쟁이 일어난 경우 당사자 간 해결을 원칙으로 하며 BNC는 이에 개입하지 않습니다.</p>
<p>BNC는 회원이 업로드한 콘텐츠를 사전에 검열하지 않습니다. 따라서 BNC는 콘텐츠가 가지는 정보, 정확성, 적법성에 대한 책임이 면제됩니다.</p>
<p>BNC는 최상의 서비스 제공을 위해 노력하지만 콘텐츠를 저장ㆍ보존해야 할 의무는 없으며 콘텐츠의 저장ㆍ보존과 관련된 장애가 생긴 경우 이에 대한 책임이 면제됩니다.</p>
<p>BNC는 전시, 사변, 천재지변, 비상사태, 현재의 기술로는 해결이 불가능한 기술적 결함 기타 불가항력적 사유로 서비스를 제공할 수 없는 경우에는 책임이 면제됩니다.</p>
<p>BNC는 회원의 귀책사유로 인한 서비스의 중지, 이용 장애 및 계약해지에 대하여 책임이 면제됩니다.</p>
<p>BNC는 기간통신 사업자가 전기통신서비스를 중지하거나 정상적으로 제공하지 아니하여 회원에게 손해가 발생한 경우에 대해서 BNC의 고의 또는 중대한 과실이 없는 한 책임이 면제됩니다.</p>
<p>BNC는 사전에 공지된 서비스용 설비의 보수, 교체, 정기점검, 공사 등 부득이한 사유로 서비스가 중지되거나 장애가 발생한 경우에 대해서 BNC의 고의 또는 중대한 과실이 없는 한 책임이 면제됩니다.</p>
<p>BNC는 회원의 컴퓨터 환경으로 인하여 발생하는 제반 문제 또는 BNC의 고의 또는 중대한 과실이 없는 네트워크 환경으로 인하여 발생하는 문제에 대해서 책임이 면제됩니다.</p>
<p>BNC가 제공하는 서비스 중 무료서비스의 경우에는 BNC의 고의 또는 중대한 과실이 없는 한 손해배상을 하지 않습니다.</p>
<p>BNC는 회원의 컴퓨터 오류에 의한 손해가 발생한 경우 또는 신상정보 및 전자우편주소를 부정확하게 기재하거나 미기재하여 손해가 발생한 경우에 대하여 BNC의 고의 또는 중대한 과실이 없는 한 책임이 면제됩니다.</p>
<p>본 약관을 위반하거나 위반할 우려가 있는 행위를 했다고 간주할 만한 상당한 근거가 있는 경우 해당 행위를 한 회원에 대해 회원 자격 상실이나 해당 콘텐츠의 일부 또는 전체를 삭제할 수 있습니다. 이 경우 발생하는 손해에 대해 BNC는 책임지지 않습니다.</p>
<br>
<br>
<h2>제21조 (회원의 고충처리 및 분쟁해결)</h2>
<p>BNC는 회원의 편의를 고려하여 회원의 의견이나 불만을 제시하는 방법을 홈페이지에서 안내합니다.</p> 
<p>BNC는 회원으로부터 제기되는 의견이나 불만이 정당하다고 객관적으로 인정될 경우에는 합리적인 기간 내에 이를 신속하게 처리합니다.</p> 
<p>다만, 처리에 장기간이 소요되는 경우에는 회원에게 장기간이 소요되는 사유와 처리일정을 전자우편, 서면 등으로 통보합니다.</p>
<p>BNC와 회원 간에 분쟁이 발생하여 제3의 분쟁조정기관이 조정할 경우 BNC는 이용제한 등 회원에게 조치한 사항을 성실히 증명하고, 조정기관의 조정에 따를 수 있습니다.</p>
<br>
<br>
<h2>제22조 (회원에 대한 통지)</h2>
<p>BNC가 회원에게 통지를 하는 경우 회원이 지정한 전자우편주소, SNS 계정 등으로 할 수 있습니다.</p>
<p>BNC는 회원 전체에게 통지를 하는 경우 7일 이상 사이트의 초기화면에 게시하거나 팝업화면 등을 제시함으로써 제1항의 통지에 갈음할 수 있습니다.</p>
<br>
<br>
<h2>제23조 (재판권 및 준거법)</h2>
<p>본 약관은 대한민국 법률에 따라 규율되고 해석되며, BNC와 회원 간에 발생한 분쟁으로 소송이 제기되는 경우, 법령에 정한 절차에 따른 법원을 관할 법원으로 합니다.</p>    </div>
		
				"','20201125000000','20201125000000');