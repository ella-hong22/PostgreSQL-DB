#�ǽ�����;

select 	
		film_id
	,	title
	,	rental_rate
	from film 
where rental_rate >
(  select avg(rental_rate)
		from film 
);
���� ���̺��� �ѹ��� �о ���� �ۼ��ϱ� ;

SELECT 
		FILM_ID
	,	TITLE
	,	RENTAL_RATE
	FROM 
(SELECT 	
		A.FILM_ID
	,	A.TITLE
	,	A.RENTAL_RATE, AVG(A.RENTAL_RATE) OVER() AS AVG_FILM --�м��Լ�����!! 
  FROM  
 		FILM A 
 ) A 
 WHERE RENTAL_RATE > AVG_FILM;

===============================================================
#�ǽ�����2;

SELECT 
	A.FILM_ID, A.TITLE
FROM FILM A
WHERE NOT exists (
	SELECT 1 --���� ������ �ǹ��Ѵ�. 1�� ��������� ����. 
	FROM INVENTORY B, film c
	WHERE b.film_id =c.film_id --where 1=1 �ص� �����ϴ�.  
	AND A.FILM_ID = B.FILM_ID 
) ;

