#실습문제;

select 	
		film_id
	,	title
	,	rental_rate
	from film 
where rental_rate >
(  select avg(rental_rate)
		from film 
);
위의 테이블을 한번만 읽어서 퀴리 작성하기 ;

SELECT 
		FILM_ID
	,	TITLE
	,	RENTAL_RATE
	FROM 
(SELECT 	
		A.FILM_ID
	,	A.TITLE
	,	A.RENTAL_RATE, AVG(A.RENTAL_RATE) OVER() AS AVG_FILM --분석함수쓰기!! 
  FROM  
 		FILM A 
 ) A 
 WHERE RENTAL_RATE > AVG_FILM;

===============================================================
#실습문제2;

SELECT 
	A.FILM_ID, A.TITLE
FROM FILM A
WHERE NOT exists (
	SELECT 1 --값의 유무를 의미한다. 1를 결과값으로 가짐. 
	FROM INVENTORY B, film c
	WHERE b.film_id =c.film_id --where 1=1 해도 가능하다.  
	AND A.FILM_ID = B.FILM_ID 
) ;

