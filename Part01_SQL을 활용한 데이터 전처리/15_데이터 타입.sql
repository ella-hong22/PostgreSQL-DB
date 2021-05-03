##데이터 타입
#BOOLEAN = '데이터 타입은 참과 거짓에 대한 값을 저장 하는 데이터 타입' 

CREATE TABLE STOCK_AVAILABILITY
( 
	PRODUCT_ID INT NOT NULL PRIMARY KEY
, 	AVAILABLE BOOLEAN NOT NULL 

)

INSERT INTO STOCK_AVAILABILITY(PRODUCT_ID, AVAILABLE)
VALUES
(100, TRUE), --'T', 1, YES 모두 TRUE 임 
(200, FALSE),
(300, 'T'),
(400, 'F'),
(500, '1'),
(600, 'YES')

SELECT *FROM STOCK_AVAILABILITY ;

SELECT *
FROM 
	STOCK_AVAILABILITY 
WHERE 
AVAILABLE = 'YES';

== --같은 결과

SELECT *
FROM 
	STOCK_AVAILABILITY 
WHERE 
AVAILABLE;

=========================================
#CHAR(고정형), VARCHAR(가변형),TEXT (무한대 길이의 문자열) #NUMERIC;

CREATE TABLE PRODUCT1
(
	ID SERIAL PRIMARY KEY
,	NAME VARCHAR NOT NULL
,	PRICE NUMERIC (5,2)
);

INSERT INTO PRODUCT1 (NAME, PRICE)
VALUES 
	('PHONE', 500.215),
	('TABLET', 500.214)
;

SELECT *FROM PRODUCT1; --소수점 반올림을 하게 된다. 이로인한 문제가 발생할수 있기 때문에 NUMERIC을 수정해주는게 좋다. 

INSERT INTO PRODUCT1 (NAME, PRICE)
VALUES 
	('PHONE', 50012345.215) ; --오류가 난다. 
=========================================
#INTEGER '정수형 데이터 타입 ' ,SERIAL 'PK에 자주 사용된다.'

CREATE TABLE TABLE_NAME
(    
	ID SERIAL 
);
== 같다. 

drop TABLE  TABLE_NAME;

CREATE SEQUENCE TABLE_NAME_ID_SEQ;

CREATE TABLE TABLE_NAME
(    
	ID INTEGER NOT NULL DEFAULT
NEXTVAL('TABLE_NAME_ID_SEQ')
);

ALTER SEQUENCE TABLE_NAME_ID_SEQ OWNED BY TABLE_NAME.ID;

INSERT INTO TABLE_NAME VALUES(DEFAULT); -- 숫자가 하나씩 추가됨 

SELECT* FROM TABLE_NAME;

#실습;
create table FRUITS(
	ID SERIAL primary key
,	NAME VARCHAR not NULL
);

insert into FRUITS(NAME) values ('ORANGE');
insert into FRUITS(ID, NAME) VALUES(default,'APPLE');

select*from FRUITS;

--현재의 시퀀스 값을 알고 싶을때, 
SELECT CURRVAL(PG_GET_SERIAL_SEQUENCE ('FRUITS', 'id')); 

========================================================
#date, time, timestamp

select now()::date; -- 2019-05-07(현재일자)
select cureent_date;  -- 2019-05-07(현재일자)
select to_char(now()::date,'dd/mm/yyyy'); --02/05/2021
select to_char(now()::date,'mon dd,yyyy'); --may/02, 2021


select 
	first_name
,	last_name
,	extract (year from create_date) as year -- 년만 뽑고 싶을때 
  from 
  		customer;
  	
------------------------------------------
select current_time; -- 시간을 조회할때
select localtime ;

==================================
##제약 조건
#기본키 '테이블 내에서 유일한 값이어야하고 not null이어야 한다. ';

create table tb_product_pk_test (
	product_no integer
,	description text
,	product_cost numeric
);

alter table tb_product_pk_test 
add primary key(product_no);

--기본키 제거
alter table tb_product_pk_test 
drop constraint tb_product_pk_test_pkey;

select* from tb_product_pk_test ;


#외래키 '참조 무결성'

#체크 제약 조건 ' 특정 컬럼에 들어가는 값에 대한 제약을 가하는 것이다. 즉, 업무적으로 절대로 들어갈수 없는 값을 막는다'

create table tb_emp_check_test(
	id serial primary key
,	first_name varchar(50)
,	birth_Date date check(birth_Date> '1900-01-01')
,	joined_Date date check(joined_date > birth_Date)
,	salary numeric check(salary > 0)
);

insert into tb_emp_check_test (
first_name, birth_Date, joined_Date, salary)
values (
'JOHN' ,'1972-01-01','2015-07-01',-100000); -- 연봉이 마이너스일순 없다. 체크 제약 조건 위반



