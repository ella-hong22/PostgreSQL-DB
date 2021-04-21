#집합 연산자
1-1 UNION 연산 'A U B 중복된 데이터 제거';

CREATE TABLE SALES2007_1
(
  NAME VARCHAR(50)
, AMOUNT NUMERIC(15,2)
);


INSERT INTO SALES2007_1
VALUES
	( 'MIKE', 150000.25)
,	('JON', 132000.75)
, 	('MARY', 100000)
;

COMMIT;

SELECT* FROM SALES2007_2;

---------------------------------------
#UNION 사용;

SELECT* 
	FROM SALES2007_1
UNION
SELECT* 
	FROM SALES2007_2
ORDER BY AMOUNT DESC; -- 맨아래에 한번 기입할수 있다. 
 
SELECT NAME FROM SALES2007_1
UNION
SELECT NAME FROM SALES2007_2;

-----------------------------------------
#union all 연산 'a U b 중복 모두 출력/ 사용이 union 보다 많이 됨'

SELECT* 
	FROM SALES2007_1
UNION ALL 
SELECT* 
	FROM SALES2007_2
ORDER BY AMOUNT DESC;
------------------------------------------
#intersect 연산 문법 '교집합' ;

drop table EMPLOYEES;
CREATE TABLE EMPLOYEES 
(
	EMPLOYEE_ID SERIAL PRIMARY KEY
,	EMPLOYEE_NAME VARCHAR (255) NOT NULL

);
CREATE TABLE KEYS 
(
	EMPLOYEE_ID INT PRIMARY KEY
,	EFFECTIVE_DATE DATE NOT NULL
,	FOREIGN KEY (EMPLOYEE_ID)
	REFERENCES EMPLOYEES(EMPLOYEE_ID)
	
);

CREATE TABLE HIPOS 
(
	EMPLOYEE_ID INT PRIMARY KEY
,	EFFECTIVE_DATE DATE NOT NULL
,	FOREIGN KEY (EMPLOYEE_ID)
	REFERENCES EMPLOYEES(EMPLOYEE_ID)
	
);


insert into employees (employee_name)
values
  ('Joyce'),
  ('Diane'),
  ('Alice'),
  ('Julie'),
  ('Heather'),
  ('Teresa'),
  ('Doris'),
  ('Gloria'),
  ('Evelyn'),
  ('Jean');

 insert into keys 
 values
 	(1, '2000-02-01'),
 	(2, '2001-06-01'),
 	(5, '2002-02-01'),
 	(7, '2005-06-01');
 
insert into hipos 
 values
 	(9, '2000-02-01'),
 	(2, '2002-06-01'),
 	(5, '2006-06-01'),
 	(10, '2005-06-01');

 -------------------------------------
 SELECT 
 	EMPLOYEE_ID
 	FROM 	
 		KEYS
 INTERSECT
 SELECT
 	EMPLOYEE_ID 
 	FROM 	
 		HIPOS;
 
 --== inner 조인과 같은 기능을 한다.
 SELECT 
 		A.EMPLOYEE_ID
 	FROM 	
 		KEYS A
 	  , HIPOS B
 WHERE A.EMPLOYEE_ID = B.EMPLOYEE_ID;
 
 
--------------------------------------
#except 연산
'재고가 없는 영화를 뽑는 방법';
--전체영화에서 
SELECT 
		FILM_ID
	  ,	TITLE
	 FROM 
	 		FILM
--재고가 존재하는 영화를 뺀다
EXCEPT
SELECT 
		DISTINCT INVENTORY.FILM_ID
	,   TITLE 
	FROM 
		INVENTORY 
INNER JOIN
		FILM 
ON FILM.FILM_ID = INVENTORY .FILM_ID 
ORDER BY TITLE;

--결과집합은 재고가 존재하지 않는 영화.

==================================================
#중첩 서브쿼리, 인라인 뷰(from 절 안에 존재), 스칼라 서브쿼리

--------------------------------------------------
#any 연산자 '어떠한 값이라도 만족하면 조건 성립';

SELECT TITLE, LENGTH
  FROM FILM 
 WHERE LENGTH >= ANY --ANY가 없으면 에러가 난다. 
 ( 
 		SELECT MAX(LENGTH)
 		FROM FILM A
 			,FILM_CATEGORY B
 		WHERE A.FILM_ID = B.FILM_ID 
 		GROUP BY B.CATEGORY_ID 
 );


SELECT TITLE, LENGTH
  FROM FILM 
 WHERE LENGTH = ANY --IN 과 같은 기능  
 ( 
 		SELECT MAX(LENGTH)
 		FROM FILM A
 			,FILM_CATEGORY B
 		WHERE A.FILM_ID = B.FILM_ID 
 		GROUP BY B.CATEGORY_ID 
 );

-----------------------------------------------
#all 연산자 실습 '모든 조건을 만족해야 성립된다';

select * from film;

SELECT TITLE, LENGTH-
  FROM FILM 
 WHERE LENGTH >= ALL 
 ( 
 		SELECT MAX(LENGTH)
 		FROM FILM A
 			,FILM_CATEGORY B
 		WHERE A.FILM_ID = B.FILM_ID 
 		GROUP BY B.CATEGORY_ID 
 );

SELECT B.CATEGORY_ID, MAX(LENGTH)
 		FROM FILM A
 			,FILM_CATEGORY B
 		WHERE A.FILM_ID = B.FILM_ID 
 		GROUP BY B.CATEGORY_ID 
 		order by B.CATEGORY_ID;
-----------------------------------------
 
SELECT ROUND(AVG (LENGTH),2) 
	FROM FIlM
GROUP BY RATING;


select film_id, title, length
from film 
where length > all  -- 평균기준 평균값들보다 상영시간이 긴 영화정보 출력
(   
	SELECT ROUND(AVG (LENGTH),2) 
	FROM FIlM
	GROUP BY RATING
)
order by length;


--------------------------------------------
#exists 연산자 '가장 자주 사용'' 해당 집합이 존재하면 연산을 멈춤으로 성능이 좋다'

select 
		first_name
	,	last_name
	from 	
		customer c
where
  exists ( select 1
  				from payment p
  			   where p.customer_id=c.customer_id
  			    and p.amount >11
  			    )
 order by first_name, last_name;


select 
		first_name
	,	last_name
	from 	
		customer c
where
  not exists ( select 1
  				from payment p
  			   where p.customer_id=c.customer_id
  			    and p.amount >11
  			    )
 order by first_name, last_name;


select first_name
	from payment p
   where p.customer_id=c.customer_id
    and p.amount >11;
   
select *from customer ;
    