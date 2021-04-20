#문제;
rental 테이블을 이용하여 연, 연월, 연월일, 전체 각각의 기준으로 rental_ID 기준 렌탈이 일어난 회수를 출력; 
select * from rental;
--ROLLUP 


select 
		TO_CHAR(RENTAL_DATE, 'YYYY')
	,	TO_CHAR(RENTAL_DATE, 'MM' )
	,	TO_CHAR(RENTAL_DATE, 'DD')
	,	count(rental_id)
from rental
group by
	rollup (
			 	TO_CHAR(RENTAL_DATE, 'YYYY'),
			 	TO_CHAR(RENTAL_DATE, 'MM' ),
			 	TO_CHAR(RENTAL_DATE, 'DD')
	
	);
	
select TO_CHAR(RENTAL_DATE, 'YYYY' ), COUNT(*) 
	FROM RENTAL
GROUP BY TO_CHAR(RENTAL_DATE, 'YYYY' ) ;

select TO_CHAR(RENTAL_DATE, 'YYYYMM' ), COUNT(*) 
	FROM RENTAL
GROUP BY TO_CHAR(RENTAL_DATE, 'YYYYMM' ) ;

#문제2 'rental과 customer 테이블을 이용하여 현재까지 가장 많이 rental을 한 고객의 고객ID, 렌탈순위, 누적렌탈획수, 이름을 출력하라. ';

SELECT * FROM CUSTOMER ;
SELECT * FROM RENTAL ;

SELECT B.CUSTOMER_ID
		, COUNT(*) rental_count
		, row_number () OVER 
		(order by count(a.rental_id  )desc ) as rental_rank 
		, B.FIRST_NAME 
		, B.LAST_NAME 
	FROM RENTAL A
INNER JOIN  CUSTOMER B
	ON (A.CUSTOMER_ID =B.CUSTOMER_ID)
GROUP BY B.CUSTOMER_ID
order by rental_count desc
;

SELECT B.CUSTOMER_ID
		, COUNT(*) rental_count
		, row_number () OVER 
		(order by count(a.rental_id  )desc ) as rental_rank 
		, B.FIRST_NAME 
		, B.LAST_NAME 
	FROM RENTAL A
INNER JOIN  CUSTOMER B 
	ON (A.CUSTOMER_ID =B.CUSTOMER_ID)
GROUP BY B.CUSTOMER_ID
order by rental_count desc
;

-- 같은 쿼리
SELECT B.CUSTOMER_ID
		, COUNT(*) rental_count
		, row_number () OVER (order by count(a.rental_id  )desc) as rental_rank 
		, B.FIRST_NAME 
		, B.LAST_NAME 
	FROM RENTAL A, CUSTOMER B 
where A.CUSTOMER_ID =B.CUSTOMER_ID -- 이름에 max를 써야 오류가 안날때도 있다. 
GROUP BY B.CUSTOMER_ID
order by rental_count desc
;


