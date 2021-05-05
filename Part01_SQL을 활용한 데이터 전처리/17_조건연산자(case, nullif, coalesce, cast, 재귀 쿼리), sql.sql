##조건연산자
#CASE 

--각각의 등급에 대한 개수를 한 행에 모두 구하기. (행은 1개, 컬럼은 3개로 출력) 
SELECT 
	SUM(
		CASE 	
		WHEN RENTAL_RATE = 0.99 THEN 1
		ELSE  0 END ) AS "C"
,	SUM(
		CASE 	
		WHEN RENTAL_RATE = 2.99 THEN 1
		ELSE  0 END ) AS "B"
,	SUM(
		CASE 	
		WHEN RENTAL_RATE = 4.99 THEN 1
		ELSE  0 END ) AS "A"
	FROM FILM;
	
--== 같은 식 행을 열식으로 바꾸기 

SELECT *
FROM 
 (
	SELECT 
			SUM(CASE WHEN RENTAL_RATE = 0.99 THEN CNT ELSE 0 END) AS C
		,	SUM(CASE WHEN RENTAL_RATE = 2.99 THEN CNT ELSE 0 END) AS B
		,	SUM(CASE WHEN RENTAL_RATE = 4.99 THEN CNT ELSE 0 END) AS A
	FROM 
	(
		SELECT 
				RENTAL_RATE, COUNT(*) CNT 
			FROM FILM 
			GROUP BY RENTAL_RATE 
	
	)A
)A
;		
		
== 차이 ;
--각각의 등급의 개수만큼 행이 발생 
SELECT 
RENTAL_RATE, COUNT(*) CNT
FROM FILM
GROUP BY RENTAL_RATE;


==================================================

#COALESCE '입력한 인자값 중에서 널값이 아닌 첫번째 값을 리턴하다. 널 처리할 때 유용'

CREATE TABLE TB_ITEM_COALESCE_TEST
	(
	ID SERIAL PRIMARY KEY
,	PRODUCT VARCHAR(100) NOT NULL
,	PRICE NUMERIC NOT NULL
,	DISCOUNT NUMERIC
); 

INSERT INTO TB_ITEM_COALESCE_TEST
			(PRODUCT, PRICE, DISCOUNT)
VALUES 
('A', 1000, 10),
('B', 1500, 20),
('C', 800, 5),
('D', 500, NULL);

COMMIT;
--------------------------------------
SELECT
	PRODUCT
, 	(PRICE - DISCOUNT) AS NET_PRICE --상품 D가 NULL이 나온다 
FROM 
TB_ITEM_COALESCE_TEST;

SELECT* FROM TB_ITEM_COALESCE_TEST; 

-- 그래서 NULL 값이 아닌 첫번째 값을 리턴 하기 위해 COALESCE를 사용한다.
SELECT
		PRODUCT,  PRICE, DISCOUNT, COALESCE(DISCOUNT,0)
	, 	(PRICE - COALESCE (DISCOUNT,0)) AS NET_PRICE -- NULL 값일때 0을 반환한다. 
FROM 
TB_ITEM_COALESCE_TEST;


-------------------------------------------
#COALESCE 함수를 CASE 표현식으로 처리

SELECT 
PRODUCT
,	( PRICE - 	
				CASE
				WHEN DISCOUNT IS NULL THEN 0
				ELSE DISCOUNT
				 END ) AS NET_PRICE
	FROM 
	TB_ITEM_COALESCE_TEST; 

===================================================================
#NULLIF '함수는 입력한 두개의 인자의 값이 동일하면 NULL을 리턴하고 그렇지 않으면 첫번째 인자값을 리턴'

CREATE TABLE TB_MEMBER_NULLIF_TEST (
	ID SERIAL PRIMARY KEY 
,	FIRST_NAME VARCHAR (50) NOT NULL
,	LAST_NAME VARCHAR(50) NOT NULL
,	GENDER SMALLINT NOT NULL --1: MALE, 2 FEMALE 
);

INSERT INTO TB_MEMBER_NULLIF_TEST (
	FIRST_NAME
,	LAST_NAME
,	GENDER
)
VALUES
	('JOHN', 'DOE', 1)
,	('DAVID', 'DAVE', 1)
,	('BUSH', 'LILY', 2)
;

SELECT*FROM TB_MEMBER_NULLIF_TEST;

-----------------------------------------
#여자대비 남자의 비율 구하기 ;
SELECT 
(SUM(CASE WHEN GENDER =1 THEN 1 ELSE 0 END) /SUM(CASE WHEN GENDER =2 THEN 1 ELSE 0 END)) * 100 AS ",ALE/FEMALE RATIO"
FROM TB_MEMBER_NULLIF_TEST;

#테스트를 위해 여자를 남자로 변경 해서 X/0으로 나눠 ERROR 발생하게 한다. ;
UPDATE  TB_MEMBER_NULLIF_TEST 	
		SET GENDER =1 
	WHERE GENDER = 2 ;

COMMIT; 

SELECT * FROM TB_MEMBER_NULLIF_TEST; 

--0으로 나누는 ERROR를 해결하는 방법 NULLIF(A,A) 같으면 NULL로 반환 --> 3/null 은 에러가 안남
SELECT 
(SUM(CASE WHEN GENDER =1 THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN GENDER =2 THEN 1 ELSE 0 END), 0)) * 100 AS "MALE/FEMALE RATIO"
FROM TB_MEMBER_NULLIF_TEST;

=================================================================================
#case ' 데이터 값을 특정 데이터 타입으로 형변환이 가능하도록 하는 방법'

select 
cast ('100' as integer) ; --'100'이라는 문자열을 정수형으로 형변화 함. 

--== 같은 표현식 
select 
'100' :: integer; 

-------------------------------------------------------
#문자열을 date 타입으로 형변환 ;
select 
cast('2015-01-01' as date) ;

--==
select 
'2015-01-01' :: date ;
-----------------------------------
#문자열을 실수형으로 형변환 ;
select 
cast('10.2' as double precision) ;

-------------------------------------
#with문의 활용 '너무 중요함' 'select문의 결과를 임시 집합으로 저장해두고 sql문에서 마치 테이블 처럼 해당 집합을 불러올수 있다.'

select 
		film_id
	,	title
	,	(case
		when length < 30 then 'short'
		when length >= 30 and length < 90 then 'medium'
		when length > 90 then 'long'
		end) length 
	from film 
;

WITH TMP1 AS (
SELECT 
		FILM_ID
	,	TITLE
	, (CASE
		WHEN LENGTH < 30 THEN 'SHORT'
		WHEN LENGTH >= 30 AND LENGTH < 90 THEN 'MEDIUM'
		WHEN LENGTH > 90 THEN 'LONG'
	  END) LENGTH 
	FROM 
		FILM 
	
)
select * from tmp1 where length = 'LONG';

===============================================
#재귀 쿼리 '재귀 쿼리랑 데이터 값 기준 부모 자식간의 관계를 표현하는 sql이다.'

실습 준비;
create table tb_emp_recursive_test (
	employee_id serial primary key
,	full_name varchar not null
,	manager_id int  -- 각 사원의 상위 관리자
); 

insert into tb_emp_recursive_test (
	employee_id, full_name, manager_id)
values 
	(1, '이경오', null)
,	(2, '삼', 1)
,	(3, '오', 1)
,	(4, '육', 1)
,	(5, '칠', 2)
,	(6, '팔', 2)
,	(7, '구', 3)
,	(8, '십', 3)
,	(9, '십일', 3)
,	(10, '십이', 3)
,	(11, '십삼', 4)
,	(12, '삽사', 7);

select *from tb_emp_recursive_test;

--with 문을 이용해서 재귀 쿼리를 쓴다. 
WITH RECURSIVE TMP2 AS (
SELECT 		
		EMPLOYEE_ID
	,	MANAGER_ID
	,	FULL_NAME
	, 	0 LVL
	FROM 
		TB_EMP_RECURSIVE_TEST
	WHERE MANAGER_ID IS NULL
UNION 
SELECT 
		E.EMPLOYEE_ID
	,	E.MANAGER_ID
	,	E.FULL_NAME
	, 	S.LVL + 1
	FROM 
		TB_EMP_RECURSIVE_TEST E, TMP2 S
	WHERE S.EMPLOYEE_ID = E.manager_ID --사원 id 와 매니저 id 조인
)
SELECT EMPLOYEE_ID , MANAGER_ID, LPAD(' ',4 * (LVL)) || FULL_NAME AS FULL_NAME
	FROM TMP2;
;)


WITH RECURSIVE TMP2 AS (
SELECT 		
		EMPLOYEE_ID
	,	MANAGER_ID
	,	FULL_NAME
	, 	0 LVL
	FROM 
		TB_EMP_RECURSIVE_TEST
	WHERE employee_id =2  -- 삼부터 재귀 시작 
UNION 
SELECT 
		E.EMPLOYEE_ID
	,	E.MANAGER_ID
	,	E.FULL_NAME
	, 	S.LVL + 1
	FROM 
		TB_EMP_RECURSIVE_TEST E, TMP2 S
	WHERE S.EMPLOYEE_ID = E.manager_ID --사원 id 와 매니저 id 조인
)
SELECT EMPLOYEE_ID , MANAGER_ID, LPAD(' ',4 * (LVL)) || FULL_NAME AS FULL_NAME
	FROM TMP2;
)

=======================================================================
#트랜잭션 begin, commit, rollback

drop table tb_account_transaction_test;

create table tb_account_transaction_test (
	id int generated by default as identity
,	name varchar(100) not null 
, 	balance dec(152) not null 
,	primary key(id)
);
commit; 

select * from tb_account_transaction_test;

insert into tb_account_transaction_test
(name, balance)
values('alice', 10000) ;

commit;
rollback;

select * from tb_account_transaction_test;

insert into tb_account_transaction_test
(name, balance)
values('deny', 20000) ;