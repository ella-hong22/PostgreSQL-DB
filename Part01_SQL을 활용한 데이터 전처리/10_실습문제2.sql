#����;
rental ���̺��� �̿��Ͽ� ��, ����, ������, ��ü ������ �������� rental_ID ���� ��Ż�� �Ͼ ȸ���� ���; 
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

#����2 'rental�� customer ���̺��� �̿��Ͽ� ������� ���� ���� rental�� �� ���� ��ID, ��Ż����, ������Żȹ��, �̸��� ����϶�. ';

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

-- ���� ����
SELECT B.CUSTOMER_ID
		, COUNT(*) rental_count
		, row_number () OVER (order by count(a.rental_id  )desc) as rental_rank 
		, B.FIRST_NAME 
		, B.LAST_NAME 
	FROM RENTAL A, CUSTOMER B 
where A.CUSTOMER_ID =B.CUSTOMER_ID -- �̸��� max�� ��� ������ �ȳ����� �ִ�. 
GROUP BY B.CUSTOMER_ID
order by rental_count desc
;


