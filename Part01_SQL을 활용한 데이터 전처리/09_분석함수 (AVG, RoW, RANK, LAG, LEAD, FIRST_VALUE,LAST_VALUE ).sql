# 분석 함수 

CREATE TABLE PRODUCT_GROUP (
GROUP_ID SERIAL PRIMARY KEY,
GROUP_NAME VARCHAR(255) NOT NULL

);

CREATE TABLE PRODUCT(
PRODUCT_ID SERIAL PRIMARY KEY,
PRODUCT_NAME VARCHAR (255) NOT NULL,
PRICE DECIMAL(11,2),
GROUP_ID INT NOT NULL,
FOREIGN KEY(GROUP_ID)
REFERENCES PRODUCT_GROUP (GROUP_ID)

)

insert into product_group(group_name)
values('smartphone'), ('laptop'), ('tablet');

insert into product (product_name, group_id, price)
values 
('microsoft lumia', 1, 200),
('HTC One', 1, 400),
('Mexus', 1, 500),
('iphone', 1, 900),
('HP elite', 2, 1200),
('lenove Thinkpad', 2, 700),
('sony vaid', 2, 700),
('dell vostro', 2, 800),
('ipad', 3, 700),
('kidle fire', 3, 150),
('samsung', 3, 200);

commit;

select*from product_group ;

#집계함수 
SELECT 
		COUNT(*)
	FROM 
		PRODUCT;
-------------------------------------
#분석 함수 '집계의 결과와 테이블의 내용도 함께 보여준다.'
SELECT 
		COUNT(*) OVER(), A.*
	FROM 
		PRODUCT A ;

	
=======================================
# AVG 함수 ' '

SELECT 
	AVG(PRICE)
FROM 
	PRODUCT;

-----------------------------------------
SELECT 
	B.GROUP_NAME,
	AVG (PRICE)
	FROM PRODUCT A 
INNER JOIN PRODUCT_GROUP B
	ON (A.GROUP_ID = B.GROUP_ID)
GROUP BY 
B.GROUP_NAME;

---------------------
"결과집합을 그래도 출력하면서 GROUP NAME  기준의 평균을 출력하는 방법"
'보여줄거 다 보여주면서 그룹 네임별 평균가격을 보고 싶을떼'
SELECT 
	B.GROUP_NAME,
	A.PRICE,
	A.PRODUCT_NAME, 
	AVG (A.PRICE) OVER(PARTITION BY B.GROUP_NAME)
	FROM PRODUCT A 
INNER JOIN PRODUCT_GROUP B
	ON (A.GROUP_ID = B.GROUP_ID);


---------------------------------------------------------
SELECT 
	B.GROUP_NAME,
	A.PRICE,
	A.PRODUCT_NAME, 
	AVG (A.PRICE) OVER(PARTITION BY B.GROUP_NAME ORDER BY B.GROUP_NAME)
	FROM PRODUCT A 
INNER JOIN PRODUCT_GROUP B
	ON (A.GROUP_ID = B.GROUP_ID);


---------------------------------------------------------------
--누적평균 구하기 
SELECT 
	B.GROUP_NAME,
	A.PRICE,
	A.PRODUCT_NAME, 
	AVG (A.PRICE) OVER(PARTITION BY B.GROUP_NAME ORDER BY A.PRICE) --누적집계
	FROM PRODUCT A 
INNER JOIN PRODUCT_GROUP B
	ON (A.GROUP_ID = B.GROUP_ID);

====================================================================44
ROW_NAMBER 함수 실습 --무조건 1,2,3,4,5 ... 

SELECT 
	A.PRODUCT_NAME,
	B.GROUP_NAME,
	A.PRICE,
	ROW_NUMBER () OVER 
		(PARTITION BY B.GROUP_NAME ORDER BY A.PRICE DESC)
  FROM PRODUCT A 
 INNER JOIN PRODUCT_GROUP B
 		ON (A.GROUP_ID = B.GROUP_ID);
 	
 ----------------------------------------------------------
 RANK 함수 실습 - 같은 순위면 같은 순위면서 다음 순위 건너뜀 1,1,3,4,... ;
 SELECT 
	A.PRODUCT_NAME,
	B.GROUP_NAME,
	A.PRICE,
	RANK () OVER 
		(PARTITION BY B.GROUP_NAME ORDER BY A.PRICE )
  FROM PRODUCT A 
 INNER JOIN PRODUCT_GROUP B
 		ON (A.GROUP_ID = B.GROUP_ID);
 	
 ------------------------------------------------------------
 
DENCE_RANK - 같은 순위면 같은 순위면서 다음순위를 건너뛰지 않음 1,1,2,3,;...

 SELECT 
	A.PRODUCT_NAME,
	B.GROUP_NAME,
	A.PRICE,
	DENSE_RANK () OVER 
		(PARTITION BY B.GROUP_NAME ORDER BY A.PRICE )
  FROM PRODUCT A 
 INNER JOIN PRODUCT_GROUP B
 		ON (A.GROUP_ID = B.GROUP_ID);
 	
================================================================
fist_value, last_value 함수 실습 

  SELECT 
	A.PRODUCT_NAME,
	B.GROUP_NAME,
	A.PRICE,
 	FIRST_VALUE (A.PRICE) OVER 
		(PARTITION BY B.GROUP_NAME ORDER BY A.PRICE )
	AS LOWEST_PRICE_PER_GROUP
  FROM PRODUCT A 
 INNER JOIN PRODUCT_GROUP B
 		ON (A.GROUP_ID = B.GROUP_ID);
 -------------------------------------------------------
   SELECT 
	A.PRODUCT_NAME,
	B.GROUP_NAME,
	A.PRICE,
 	FIRST_VALUE (A.PRICE) OVER 
		(PARTITION BY B.GROUP_NAME ORDER BY A.PRICE desc )
	AS LOWEST_PRICE_PER_GROUP
  FROM PRODUCT A 
 INNER JOIN PRODUCT_GROUP B
 		ON (A.GROUP_ID = B.GROUP_ID);
 	
-----------------------------------------------------------
#last_value 의 경우 값의 범위를 지정해야한다. 

 SELECT 
	A.PRODUCT_NAME,
	B.GROUP_NAME,
	A.PRICE,
 	last_VALUE (A.PRICE) OVER 
		(PARTITION BY B.GROUP_NAME ORDER BY A.PRICE 
		RANGE BETWeEN UNBOUNDED PRECEDING -- 파티션의 첫번째 로우부터
		AND UNBOUNDED FOLLOWING ) -- 파티션의 마지막 로우까지
	AS LOWEST_PRICE_PER_GROUP
  FROM PRODUCT A 
 INNER JOIN PRODUCT_GROUP B
 		ON (A.GROUP_ID = B.GROUP_ID);

---------------------------------------------------------------
===================================================================
lag, lead 함수 

lag - 이전 행의 값을 찾는다. 

SELECT 
	  A.PRODUCT_NAME
	, B.GROUP_NAME
	, A.PRICE
	, 			LAG(A.PRICE, 1) OVER (PARTITION BY B.GROUP_NAME ORDER BY A.PRICE ) AS PREV_PRICE
	, A.PRICE - LAG(PRICE,   1) OVER (PARTITION BY B.GROUP_NAME ORDER BY A.PRICE ) AS CUR_PREV_DIFF
FROM 
	PRODUCT A
INNER JOIN PRODUCT_GROUP B ON (A.GROUP_ID= B.GROUP_ID);

--------------------------------------------------------------------
SELECT 
	  A.PRODUCT_NAME
	, B.GROUP_NAME
	, A.PRICE
	, 			LEAD(A.PRICE, 2) OVER (PARTITION BY B.GROUP_NAME ORDER BY A.PRICE ) AS next_price
	, A.PRICE - LEAD(PRICE,   1) OVER (PARTITION BY B.GROUP_NAME ORDER BY A.PRICE ) AS CUR_NEXT_DIFF
FROM 
	PRODUCT A
INNER JOIN PRODUCT_GROUP B ON 
	(A.GROUP_ID= B.GROUP_ID);
