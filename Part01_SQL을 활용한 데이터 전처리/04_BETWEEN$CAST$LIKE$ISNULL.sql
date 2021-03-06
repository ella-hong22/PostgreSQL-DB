02.데이터 조회와 필터링
--#WHERE 절 

SELECT 
	LAST_NAME,
	FIRST_NAME
FROM 
	CUSTOMER
WHERE --필터처리--
	FIRST_NAME ='JAMIE'; --대소문자 구분-- 
	
	
----------------------------------------------
#조건이 어러개 일때

SELECT
	LAST_NAME,
	FIRST_NAME
FROM
	CUSTOMER
WHERE --필터처리--
 	FIRST_NAME = 'JAMIE'; --대소문자 구분-- 
AND LAST_NAME = 'RICE'

----------------------------------------------

#조건이 두개일때

SELECT
	CUSTOMER_ID,
	AMOUNT,
	PAYMENT_DATE
FROM
	PAYMENT
WHERE--필터처리--
 		AMOUNT <= 1
	OR AMOUNT >= 8;

-----------------------------------------------
-----------------------------------------------

#LIMIT 절 (행의 수를 한정하는 역할) '자주사용됨'

SELECT
	FILM_ID,
	TITLE,
	RELEASE_YEAR
FROM
	FILM
ORDER BY --정렬-- 
	FILM_ID
LIMIT 4 --4개만 보여줘--
OFFSET 3; --시작점--
	
-------------------------------------------------
#LIMIT절 - 내림차순 정렬

SELECT
	FILM_ID,
	TITLE,
	RELEASE_YEAR
FROM
	FILM
ORDER BY --정렬-- 
	RENTAL_RATE DESC --역순-- ASC=올림차순 (안적을시 자동 올림차순)
LIMIT 10;

------------------------------------------------
------------------------------------------------
#FETCH 절 '행의 수를 한정' , 부분 범위 처리시 사용

SELECT
	FILM_ID,
	TITLE
FROM
	FILM
ORDER BY TITLE 
FETCH FIRST ROW ONLY --최초의 단 한 건의 행을 리턴-- -- 선입선출 방식을 사용할때--
;

--------------------------------------------------
#숫자 지정 
SELECT
	FILM_ID,
	TITLE
FROM
	FILM
ORDER BY TITLE 
FETCH FIRST 9 ROW ONLY --숫자를 지정-- 
;
------------------------------------
#행 시작 지정 

SELECT
	FILM_ID,
	TITLE
FROM
	FILM
ORDER BY TITLE 
	OFFSET 5 ROWS --6번째 행부터--
FETCH FIRST 5 ROW ONLY --5건의 행 리턴-- 
;
------------------------------------
------------------------------------
#IN 연산자 '특정 집합 혹은 리스트가 존재하는지 판단하는 연산자'

SELECT
	CUSTOMER_ID,
	RENTAL_ID,
	RETURN_DATE
FROM
	RENTAL
WHERE
	CUSTOMER_ID IN(1, 2) -- 1 OR 2인 행을 출력
ORDER BY
	RETURN_DATE DESC; --결과를 내림차순으로 출력 --
	
--가독성
--DBMS 최적화, SQL 최적화) 옵티마이저의 특성상 IN 조건 성능상 유리함
	
-------------------------------------------------
#IN 연산자 - OR 의 사용 'IN 연산자는 OR &&'='과 같다.'

SELECT
	CUSTOMER_ID,
	RENTAL_ID,
	RETURN_DATE
FROM
	RENTAL
WHERE
		CUSTOMER_ID = 1
	OR  CUSTOMER_ID = 2
ORDER BY
	RETURN_DATE DESC;

----------------------------------------------------
# NOT IN 연산자 실습

SELECT
	CUSTOMER_ID,
	RENTAL_ID,
	RETURN_DATE
FROM
	RENTAL
WHERE
	CUSTOMER_ID NOT IN(1, 2) -- 1 과 2를 제외한 모두
ORDER BY 
	RETURN_DATE DESC; 

----------------------------------------------------
#NOT IN 연산자 슬습 - AND 사용


SELECT
	CUSTOMER_ID,
	RENTAL_ID,
	RETURN_DATE
FROM
	RENTAL
WHERE
		CUSTOMER_ID <> 1
	AND CUSTOMER_ID <> 2 -- 1 과 2를 제외한 모두
ORDER BY 
	RETURN_DATE DESC; 

 -- NOT IN 연산자는 'AND' && '<>'과 같다. --
 
------------------------------------------
#NOT IN 연산자 슬습 - 서브쿼리

SELECT
	FIRST_NAME,
	LAST_NAME
FROM
	CUSTOMER
WHERE
	CUSTOMER_ID IN (
										--서브쿼리 
					SELECT
						CUSTOMER_ID
					FROM
						RENTAL
					WHERE
						CAST (RETURN_DATE AS DATE) = '2005-05-27');
					
=======================================================================
#BETWEEN 연산자 

	SELECT 
		CUSTOMER_ID
	,  	PAYMENT_ID
	,	AMOUNT
	FROM 
		PAYMENT 
	WHERE AMOUNT BETWEEN 8 AND 9;

----------------결과가 동일 
	SELECT 
		CUSTOMER_ID
	,  	PAYMENT_ID
	,	AMOUNT
	FROM 
		PAYMENT 
	WHERE AMOUNT >= 8
	AND AMOUNT <=9;
----------------------------------
#NOT BETWEEN 연산자 

	SELECT 
		CUSTOMER_ID
	,  	PAYMENT_ID
	,	AMOUNT
	FROM 
		PAYMENT 
	WHERE AMOUNT NOT BETWEEN 8 AND 9;  -- amount < 8 or amount >9; 동일 표현
---------------------------------------
#cast 를 사용해 일자비교하기 

SELECT 
	CUSTOMER_ID, PAYMENT_ID,
	AMOUNT     , PAYMENT_DATE
FROM PAYMENT 
WHERE
	CAST(PAYMENT_DATE AS DATE)  --yyyy-mm-dd 형식으로 안바꾸면 오류남 
BETWEEN '2007-02-07' AND '2007-02-15' ; 

= 
SELECT 
	CUSTOMER_ID, PAYMENT_ID,
	AMOUNT     , PAYMENT_DATE
FROM PAYMENT 
	where to_char(payment_date, 'yyyy-mm-dd')
BETWEEN '2007-02-07' AND '2007-02-15' ; 

==================================================
#like 연산자 '특정 패턴과 유사할때 '


SELECT 
		FIRST_NAME
	, 	LAST_NAME
FROM 
	CUSTOMER 
WHERE
	FIRST_NAME LIKE 'Jen%';

------------------------------
select 
	 'FOO' like 'FOO'
	, 'FOO' like 'F%'
	, 'FOO' like '_O_'
	, 'BAR' like 'B_'  --false가 나옴 2글자여야함
	, 'BAR' like 'B_%'  --true가 나옴  
	;
=========================================
#null 연산자 
CREATE TABLE CONTACTS 
(
	ID INT GENERATED BY default AS IDENTITY ,
	FRIST_NAME VARCHAR(50) NOT NULL,
	LAST_NAME VARCHAR(50) NOT NULL,
	EMAIL VARCHAR(255) NOT NULL,
	PHONE VARCHAR(15),
	PRIMARY KEY(ID)
);

drop table CONTACTS ;
commit;
	
INSERT 
	INTO 
	CONTACTS(FRIST_NAME, LAST_NAME, EMAIL, PHONE)
values
('John', 'Doe', 'john.doe@example.com', null),
('Lily', 'Bush', 'lily.bush@example.com','(408-234-2764)');


COMMIT;
--------------------------------------
SELECT * FROM CONTACTS;

---------------------------------------
SELECT * FROM  CONTACTS 
WHERE PHONE = NULL; -- 연산이 되지 안는다. 

SELECT * FROM  CONTACTS 
WHERE PHONE IS NULL; -- 연산이 된다.  or is not null 
