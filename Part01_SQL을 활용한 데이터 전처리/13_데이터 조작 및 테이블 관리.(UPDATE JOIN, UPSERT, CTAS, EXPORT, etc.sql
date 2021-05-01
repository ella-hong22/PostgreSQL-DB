#데이터 조작 
1-1 insert into 

INSERT 
	INTO LINK
(URL, NAME)
values
('HTTP://','NAVER')
('''HTTP://''','''NAVER'''); --''가 '로 삽입된다. 

commit;
-----------------------------------
#데이블을 테이블에 입력;
create table LINK_TMP as
select *from LINK where 0=1; -- LINK_TMP테이블은 구조는 LINK와 같고 데이터는 0건이 된다. 

INSET 
	into LINK_TMP
select *
  from LINK ; --테이블 전체를 복사해서 넣어줌
===================================================
#update '수정작업이고 동시성에 유의한다. ';

update LINK
	set REL = 'NO DATA'; -- REL 칼럼에 잇는 데이터를 모두 NODATA로 바꿔줌 WHERE절이 없으므로 테이블의 전체 행을 대상으로한다. 

commit; --바로 해야 데이터의 동시성에 문제가 생기지 않는다

========================================================
'#UPDATE JOIN문' '굉장히 복잡한 쿼리를 간단하게 해줌 아주 자주 사용'

CREATE TABLE PRODUCT_SEGMENT
(  
	ID SERIAL PRIMARY KEY
,	SEGMENT VARCHAR NOT NULL
,	DISCOUNT NUMERIC(4,2)
);

insert into product_SEGMENT
(SEGMENT, DISCOUNT)
values
		('GRAND LUXURY', 0.05)
	,	('LUXURY', 0.06)
	,	('MASS', 0.1)

	commit;
select *from product;
CREATE TABLE PRODUCT (
	ID SERIAL PRIMARY KEY
,	NAME VARCHAR NOT NULL
,	PRICE NUMERIC(10,2)
,	NET_PRICE NUMERIC(10,2)
,	SEGMENT_ID INT NOT NULL
,	FOREIGN KEY(SEGMENT_ID)
	REFERENCES PRODUCT_SEGMENT(ID)
);

insert into product (NAME, PRICE, SEGMENT_ID)
values
		('k5', 804.89, 1)
	,	('K7', 228.89, 3)
	,	('K9', 336.89, 2)
	,	('SONATA', 145.89, 3)
	,	('SPARK', 551.89, 2)
	,	('AVANTE', 261.89, 3)
	,	('SANTAFE', 843.89, 1)
	,	('TUSON', 427.89, 2)
	,	('ORANDO', 963.89, 1)
	,	('RAY', 910.89, 1)
	,	('MORING', 208.89, 3)
	,	('VERNA', 985.89, 1)
	,	('K8',841.89, 1)
	,	('TICO', 896.89, 1)
	,	('MATIZ', 575.89, 2)
	,	('SPORTAGE', 530.89, 2);
	

-----------------------------------------------

update product A
	set NET_PRICE = A.PRICE - (A.PRICE*B.DISCOUNT)
	from product_SEGMENT B
  where A.SEGMENT_ID =B.ID; 
  
select*from PRODUCT;

=======================================================
#delete 문법 --테이블의 행을 삭제하는 방법

delete
  from 
  		LINK
 where ID =5 ; 
 
commit; 

delete from LINK_TMP A
	using LINK B --LINK 테이블과 조인 
where A.ID = B.ID; --ID가 중복되는 것은 행이 삭제된다. 

========================================================
#UPSERT 문 

cREATE TABLE CUSTOMERS 
(
	CUSTOMER_ID SERIAL PRIMARY KEY
,	NAME VARCHAR UNIQUE
,	EMAIL VARCHAR NOT NULL
,	ACTIVE BOOL NOT NULL DEFAULT TRUE
);

INSERT INTO CUSTOMERS(NAME, EMAIL)
VALUES
('IMB','CONTACT@COM'),
('MICRO','CONTACT@MCIRO.COM'),
('INTEL','CONTACT@INTEL.COM');

select*from customerS;

insert into CUSTOMERS (NAME, EMAIL)
values
( 
'MICRO',
'HOTLINE@COM')
on conflict (NAME) --아래의 두문장이 없으면 SQL 에러
do nothing;

-------------------------------------------
'#UPSERT문 실습 - update 사용' 
insert into CUSTOMERS (NAME, EMAIL)
values
( 
'MICRO',
'HOTLINE@COM')
on conflict (NAME) 
do update 	
		set EMAIL = EXCLUDED.EMAIL || ';' || CUSTOMERS.EMAIL; --HOTLINE@COM;CONTACT@MCIRO.COM 넣어줌
==================================================================
#EXPORT 작업 '다른 형태의 데이터로 추출하는 작업 CSV 형식으로 추출' ;

COPY CATEGORY(CATEGORY_ID, NAME, LAST_UPDATE) --추출할 테이블 칼럼 지정
	TO 'C:\TMP\DB_CATEGORY.CSV' --저장할 파일 경로 지정
DELIMITER ',' --구분자 지정
CSV HEADER --파일형식 지정 AND 칼럼명도 같이 나옴

===================================================================
#import 작업 '파일을 테이블에 넣는다 ';

COPY CATEGORY(CATEGORY_ID, NAME, LAST_UPDATE) --추출할 테이블 칼럼 지정
	FROM 'C:\TMP\DB_CATEGORY.CSV' --저장할 파일 경로 지정
DELIMITER ',' --구분자 지정
CSV HEADER --파일형식 지정 AND 칼럼명도 같이 나옴 HEADER 안지우면 1번째 해더로 인식해서 1개의 행이 누락됨

===============================================================
#데이터 타입

drop table DATA_TYPE_TEST_1;
create table 
DATA_TYPE_TEST_1
( 
	A_BOOLEAN BOOLEAN
,	B_CHAR CHAR (10)
,	C_VARCHAR VARCHAR(10)
, 	D_TEXT text
,	E_INT INT
,	F_SMALLINT smallint
,	G_FLOAT FLOAT
,	H_NUMERIC numeric(15,2)
);

insert into
DATA_TYPE_TEST_1
values
( 
	TRUE
,	'ABCDE' --공백이 들어감
,	'ABCDE'
,	'TEXT'
,	1000
, 	10
,	10.12345
, 	10.25	);

commit;

select* from DATA_TYPE_TEST_1;

------------------------------
create table 
DATA_TYPE_TEST_2
( 
	A_DATE DATE
,	B_TIME TIME
,	C_TIMESTAMP TIMESTAMP
, 	D_ARRAY text[]
, 	E_JSON JSON
);

insert  into DATA_TYPE_TEST_2
VALUES
(  
CURRENT_DATE
, LOCALTIME
, CURRENT_TIMESTAMP
, array ['010-1234-1234', '010-4321-4321']
, '{"CUSTOMER" : "JOHN DOE", "ITEMS": {"PRODUCT" : "BEER","QTY":6}}'
);

select*from DATA_TYPE_TEST_2;
===========================================================
#테이블 생성 

create table ACCOUNT
( 
	USER_ID SERIAL primary key
,	USERNAME VARCHAR(50) unique not null
,	password VARCHAR(50) not null
,	EMAIL VARCHAR (355) unique not null
,	CREATED_ON TIMESTAMP not null
,	LAST_LOGIN TIMESTAMP
);

create table role 
( ROLE_ID SERIAL primary key 
	,ROLE_NAME VARCHAR(255) unique not NULL);

)

create table ACCOUNT_ROLE
(   
	USER_ID INTEGER not null
,	ROLE_ID INTEGER not null
,	GRANT_DATE TIMESTAMP without TIME zone
, 	primary key (USER_ID, ROLE_ID)
,	constraint ACCOUNT_ROLE_ROLE_ID_FKKY foreign key (ROLE_ID)
	references role (role_ID) match simple
	on update no action on delete no action
, 	constraint ACCOUNT_ROLE_USER_ID_FKEY foreign KEY(USER_ID)
	references ACCOUNT (USER_ID) match simple on
	update no action on delete  no action 
	);


insert into ACCOUNT VALUES(1,'이경오','1234','DBEXPERT@NAVER.COM', CURRENT_TIMESTAMP, NULL);
commit;

select*from ACCOUNT;

insert into role VALUES(1,'DBA');

insert into ACCOUNT_ROLE VALUES(1,1, CURRENT_TIMESTAMP);

select*from account_role ;

====================================================
#CTAS 'CREATE TABLE AS SELECT 약어'

SELECT 
	A.FILM_ID,
	A.TITLE,
	A.RELEASE_YEAR,
	A.LENGTH,
	A.RATING
FROM 	
	FILM A, FILM_CATEGORY B
WHERE A.FILM_ID = B.FILM_ID 
AND B.CATEGORY_ID = 1
;

select *from category where category_id =1;

--자동으로 신규 테이블 생성방법 CTAS
create table action_film as
SELECT 
	A.FILM_ID,
	A.TITLE,
	A.RELEASE_YEAR,
	A.LENGTH,
	A.RATING
FROM 	
	FILM A, FILM_CATEGORY B
WHERE A.FILM_ID = B.FILM_ID 
AND B.CATEGORY_ID = 1
;

drop table action_film;

select*from action_film ;

=====================
#테이블 구조 변경 실습 

ALTER TABLE LINKS ADD COLUMN TARGET VARCHAR(10);
ALTER TABLE LINKS ADD COLUMN TARGET boolean; --칼럼 추가
ALTER TABLE LINKS drop COLUMN TARGET ;
ALTER TABLE LINKS rename COLUMN title to link_title;
ALTER TABLE LINKS ALTER COLUMN TARGET -- TARGET 컬럼의 DEFAULT 값을"_BLANK"로 설정 
SET DEFAULT '_BLACK' ; 

INSERT INTO LINKS (LINK_TITLE, URL)
VALUES
('POSTGRESQL TUTORIAL','HTTP://COM/'); --TARGET 컬럼은 NULL로 새로운행을 입력했지만, TARGET 값으로 DEFAULT 값으로 들어간다
-------------------------------------------------------------
ALTER TABLE LINKS ADD CHECK(TARTGET IN('_SELF', '_BLANK','_PARENT','_TOP') 
--이때
INSERT INTO LINKS(LINK_TITLE, URL, TARGET)
VALUES('POSTGRESQL','HTTP','WHATEVER'); -- ERROR --> CHECK 제약 조건에 맞지 않아서, 


INSERT INTO LINKS (LINK_TITLE, URL)
VALUES('POSTGRESQL TUTORIAL', 'HTTP://WWW.POSTGRESQLTUTORIAL.COM/');

=========================================================================
#테이블 이름 변경 

CREATE TABLE VENDORS
(
	ID SERIAL PRIMARY KEY
  ,	NAME VARCHAR NOT NULL
);

ALTER TABLE VENDORS RENAME TO SUPPLIERS;
select * from suppliers;

CREATE TABLE SUPPLIER_GROUPS
( 
	ID SERIAL PRIMARY KEY 
  , NAME VARCHAR NOT NULL
);
--테이블명 변경
ALTER TABLE SUPPLIERS ADD COLUMN GROUP_ID INT NOT NULL;
ALTER TABLE SUPPLIERS ADD FOREIGN KEY(GROUP_ID)
REFERENCES SUPPLIER_GROUPS(ID);
--뷰 생성
CREATE VIEW SUPPLIER_DATE AS 
SELECT 
		S.ID
	, 	S.NAME
	,	G.NAME "GROUP"
	FROM 
		SUPPLIERS S, SUPPLIER_GROUPS G
WHERE G.ID = S.GROUP_ID;


ALTER TABLE SUPPLIER_GROUPS RENAME TO GROUPS; '이름이 바뀌어도 자동으로 제약조건에 참조가 된다.'

SELECT*FROM SUPPLIER_DATE ;

=======================================================
#13 컬럼 추가

--두개 추가시 
ALTER TABLE TB_CUST 
ADD COLUMN PHON VARCHAR(13);
ADD COLUMN CELL VARCHAR(13);

=======================
#14 컬럼 제거 

ALTER TABLE BOOKS 
DROP COLUMN PUBLISHER_ID
DROP COLUMN PUBLISHER_IDB; 

ALTER TABLE BOOKS DROP COLUMN PUBLISHER_ID CASCADE; --참조제약 조건으로 컬럼 제거가 안될때, 그냥 지우는 방법 하지만 위험한 방법임으로 쓰지 않는게 좋다. 

=========================================================
#15 컬럼 데이터 타입 변경 

--실습준비 
CREATE TABLE ASSETS (
	ID SERIAL PRIMARY KEY 
  ,	NAME TEXT NOT NULL
  ,	ASSET_NO VARCHAR(10) NOT NULL
  ,	DESCRIPTION TEXT 
  , LOCATION TEXT
  , ACQUIRED_DATE DATE NOT NULL
);

INSERT INTO ASSETS(
	NAME
  , ASSET_NO
  , LOCATION
  , ACQUIRED_DATE
)
VALUES
('SERVER','10001','SERVER ROOM','2017-01-01'),
('SERVER2','10002','SERVER ROOM2','2017-01-02');

COMMIT;

SELECT * FROM ASSETS;

--칼럼 변경 실습
ALTER TABLE ASSETS ALTER COLUMN NAME TYPE VARCHAR(50);

ALTER TABLE ASSETS ALTER COLUMN ASSET_NO TYPE INT; --ERROR 뜬다. 

'SQL ERROR [42804]: 오류: "ASSET_NO" 칼럼의 자료형을 INTEGER 형으로 형변환할 수 없음
  HINT: "USING ASSET_NO::INTEGER" 구문을 추가해야 할 것 같습니다.';

--위의 에러가 뜰때, ;
ALTER TABLE ASSETS 
  ALTER COLUMN ASSET_NO TYPE INT USING ASSET_NO ::INTEGER; --타입변경 성공
 
=======================================================================
#16 칼럼 이름 변경 

ALTER TABLE 테이블명
RENAME COLUMN 칼럼명 TO 바꿀명 ; 

====================================================================
#17테이블 제거 

CREATE TABLE AUTHOR 
( 
	AUTHOR_ID INT NOT NULL PRIMARY KEY
,	FIRSTNAME VARCHAR(50)
,	LASTNAME VARCHAR(50)
);

CREATE TABLE PAGE (
	PAGE_ID serial PRIMARY KEY 
,	TITLE VARCHAR (255) NOT NULL
,	CONTENT TEXT
,	AUTHOR_ID INT NOT NULL 
,	FOREIGN KEY (AUTHOR_ID) REFERENCES AUTHOR (AUTHOR_ID)
);

insert into author
values (1, 'minji','haa');

insert into page
values (1, 'sql','drop',1);

select *from page;

commit;

--부모 날려보기 
DROP TABLE AUTHOR;
'SQL ERROR [2BP01]: 오류: 기타 다른 개체들이 이 개체에 의존하고 있어, AUTHOR 테이블 삭제할 수 없음
  DETAIL: PAGE_AUTHOR_ID_FKEY 제약 조건(해당 개체: PAGE 테이블) 의존대상: AUTHOR 테이블
  HINT: 이 개체와 관계된 모든 개체들을 함께 삭제하려면 DROP ... CASCADE 명령을 사용하십시오'

DROP TABLE AUTHOR CASCADE; --PAGE의 참조무결성 조건이 사라진다. 

SELECT*FROM PAGE;

======================================================
#18 임시테이블 

CREATE TEMP TABLE TB_CUST_TEMP_TEST(CUST_ID INT);  --일반테이블과 동일한 이름일때, 임시테이블을 더 먼저 불러온다. DISCONNECT를 하면 테이블이 사라진다. 

SELECT *FROM TB_CUST_TEMP_TEST;

=======================================================

#19 TRUNCATE '대용량의 테이블을 내용을 빠르게 지우는 방법 ' '오라클은 TRUNCATE 는 ROLLBACK이 불가하지만, POSTGRESQL은 가능하다. '

TRUNCATE TABLE BIG_TABLE;

ROLLBACK; --데이터가 돌아온다. 




