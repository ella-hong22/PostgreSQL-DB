#집계데이터 _ group by 절 문법 

select 
		customer_id 
	from 				
		payment 
	group by customer_id;

==; 해당 칼럼에 대한 중복을 없애는 기능이 같다. 

select 	distinct customer_id
from 	payment;

---------------------------------
#거래액이 가장 많은 고객순으로 출력
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
	b.staff_id, --이후의 칼럼들이 집계합수여야 한다. 
	b.first_name,
	b.last_name,
	count(a.payment_id) as count 
  from payment a, staff b
  where a.staff_id = b.staff_id 
group by a.staff_id; -- 오류가 나온다. 

--아래의 쿼리는 직원 1번, 2번 -.> 1번은 이름이 하나, 2번도 이름이 하나, staff_id --> 2건이 나옴 그래서 가능합 
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
#having 절 

SELECT 
	CUSTOMER_ID, 
	SUM(AMOUNT) AS AMOUNT_SUM
	FROM 
	PAYMENT 
GROUP BY  CUSTOMER_ID
having SUM(AMOUNT) >200 ; --amount_sum 으로 하면 오류뜸 

--------------------------------------------------
SELECT 
	A.CUSTOMER_ID, B.EMAIL ,
	SUM(A.AMOUNT) AS AMOUNT_SUM
	FROM 
	PAYMENT A, CUSTOMER B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID 
GROUP BY  A.CUSTOMER_ID, B.EMAIL
HAVING SUM(A.AMOUNT) >200 ;



