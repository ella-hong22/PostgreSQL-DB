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


