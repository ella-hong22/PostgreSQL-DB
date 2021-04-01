#���赥���� _ group by �� ���� 

select 
		customer_id 
	from 				
		payment 
	group by customer_id;

==; �ش� Į���� ���� �ߺ��� ���ִ� ����� ����. 

select 	distinct customer_id
from 	payment;

---------------------------------
#�ŷ����� ���� ���� �������� ���
SELECT 
	CUSTOMER_ID, 
	SUM(AMOUNT) AS AMOUNT_SUM
	FROM 
	PAYMENT 
GROUP BY  CUSTOMER_ID
ORDER BY AMOUNT_SUM DESC; 

--------------------------

select 
	a.staff_id,
	b.staff_id, --������ Į������ �����ռ����� �Ѵ�. 
	b.first_name,
	b.last_name,
	count(a.payment_id) as count 
  from payment a, staff b
  where a.staff_id = b.staff_id 
group by a.staff_id; -- ������ ���´�. 

--�Ʒ��� ������ ���� 1��, 2�� -.> 1���� �̸��� �ϳ�, 2���� �̸��� �ϳ�, staff_id --> 2���� ���� �׷��� ������ 
select 
	a.staff_id,
	b.staff_id,
	b.first_name,
	b.last_name,
	count(a.payment_id) as count 
  from payment a, staff b
  where a.staff_id = b.staff_id 
group by a.staff_id ,b.staff_id,
	b.first_name,
	b.last_name;
	
select distinct staff_id from payment;
=====================================================
#having �� 

SELECT 
	CUSTOMER_ID, 
	SUM(AMOUNT) AS AMOUNT_SUM
	FROM 
	PAYMENT 
GROUP BY  CUSTOMER_ID
having SUM(AMOUNT) >200 ; --amount_sum ���� �ϸ� ������ 

--------------------------------------------------
SELECT 
	A.CUSTOMER_ID, B.EMAIL ,
	SUM(A.AMOUNT) AS AMOUNT_SUM
	FROM 
	PAYMENT A, CUSTOMER B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID 
GROUP BY  A.CUSTOMER_ID, B.EMAIL
HAVING SUM(A.AMOUNT) >200 ;


======================================================
#GROUPING SET �� 

CREATE TABLE SALES 
(
BRAND VARCHAR NOT NULL,
SEGMENT VARCHAR NOT NULL,
QUANTITY INT NOT NULL,
PRIMARY KEY (BRAND, SEGMENT)
);

INSERT INTO SALES 
VALUES
('ABC', 'PREMIUM', 100),
('ABC', 'BASIC', 200),
('XYZ', 'PREMIUM', 100),
('XYZ', 'BASIC', 300)

commit;

select *from sales;

----------------------------
SELECT 
BRAND , SUM(QUANTITY)
FROM SALES
GROUP BY BRAND;


SELECT 
SEGMENT , SUM(QUANTITY)
FROM SALES
GROUP BY SEGMENT;

select sum(QUANTITY) from sales;

==>
#grouping set �̿�

SELECT 
BRAND ,SEGMENT, SUM(QUANTITY)
FROM SALES
GROUP BY 
	GROUPING SETS 
	(
	(BRAND ,SEGMENT),
	(BRAND),
	(SEGMENT),
	()
	);

SELECT 
	grouping(brand) grouping_brand,
	grouping(segment) grouping_segment, -- ���Ǹ� 0 , �ƴϸ� 1
	BRAND ,SEGMENT, SUM(QUANTITY)
FROM SALES
GROUP BY 
	GROUPING SETS 
	(
	(BRAND ,SEGMENT),
	(BRAND),
	(SEGMENT),
	()
	);


