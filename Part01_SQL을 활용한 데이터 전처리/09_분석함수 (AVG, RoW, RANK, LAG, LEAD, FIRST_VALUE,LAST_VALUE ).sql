# �м� �Լ� 

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

#�����Լ� 
SELECT 
		COUNT(*)
	FROM 
		PRODUCT;
-------------------------------------
#�м� �Լ� '������ ����� ���̺��� ���뵵 �Բ� �����ش�.'
SELECT 
		COUNT(*) OVER(), A.*
	FROM 
		PRODUCT A ;

	
=======================================
# AVG �Լ� ' '

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
"��������� �׷��� ����ϸ鼭 GROUP NAME  ������ ����� ����ϴ� ���"
'�����ٰ� �� �����ָ鼭 �׷� ���Ӻ� ��հ����� ���� ������'
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
--������� ���ϱ� 
SELECT 
	B.GROUP_NAME,
	A.PRICE,
	A.PRODUCT_NAME, 
	AVG (A.PRICE) OVER(PARTITION BY B.GROUP_NAME ORDER BY A.PRICE) --��������
	FROM PRODUCT A 
INNER JOIN PRODUCT_GROUP B
	ON (A.GROUP_ID = B.GROUP_ID);

====================================================================44
ROW_NAMBER �Լ� �ǽ� --������ 1,2,3,4,5 ... 

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
 RANK �Լ� �ǽ� - ���� ������ ���� �����鼭 ���� ���� �ǳʶ� 1,1,3,4,... ;
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
 
DENCE_RANK - ���� ������ ���� �����鼭 ���������� �ǳʶ��� ���� 1,1,2,3,;...

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
fist_value, last_value �Լ� �ǽ� 

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
#last_value �� ��� ���� ������ �����ؾ��Ѵ�. 

 SELECT 
	A.PRODUCT_NAME,
	B.GROUP_NAME,
	A.PRICE,
 	last_VALUE (A.PRICE) OVER 
		(PARTITION BY B.GROUP_NAME ORDER BY A.PRICE 
		RANGE BETWeEN UNBOUNDED PRECEDING -- ��Ƽ���� ù��° �ο����
		AND UNBOUNDED FOLLOWING ) -- ��Ƽ���� ������ �ο����
	AS LOWEST_PRICE_PER_GROUP
  FROM PRODUCT A 
 INNER JOIN PRODUCT_GROUP B
 		ON (A.GROUP_ID = B.GROUP_ID);

---------------------------------------------------------------
===================================================================
lag, lead �Լ� 

lag - ���� ���� ���� ã�´�. 

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
