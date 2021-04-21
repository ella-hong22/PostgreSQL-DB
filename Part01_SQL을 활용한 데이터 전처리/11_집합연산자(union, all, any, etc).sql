#���� ������
1-1 UNION ���� 'A U B �ߺ��� ������ ����';

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
#UNION ���;

SELECT* 
	FROM SALES2007_1
UNION
SELECT* 
	FROM SALES2007_2
ORDER BY AMOUNT DESC; -- �ǾƷ��� �ѹ� �����Ҽ� �ִ�. 
 
SELECT NAME FROM SALES2007_1
UNION
SELECT NAME FROM SALES2007_2;

-----------------------------------------
#union all ���� 'a U b �ߺ� ��� ���/ ����� union ���� ���� ��'

SELECT* 
	FROM SALES2007_1
UNION ALL 
SELECT* 
	FROM SALES2007_2
ORDER BY AMOUNT DESC;
------------------------------------------
#intersect ���� ���� '������' ;

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
 
 --== inner ���ΰ� ���� ����� �Ѵ�.
 SELECT 
 		A.EMPLOYEE_ID
 	FROM 	
 		KEYS A
 	  , HIPOS B
 WHERE A.EMPLOYEE_ID = B.EMPLOYEE_ID;
 
 
--------------------------------------
#except ����
'��� ���� ��ȭ�� �̴� ���';
--��ü��ȭ���� 
SELECT 
		FILM_ID
	  ,	TITLE
	 FROM 
	 		FILM
--��� �����ϴ� ��ȭ�� ����
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

--��������� ��� �������� �ʴ� ��ȭ.

==================================================
#��ø ��������, �ζ��� ��(from �� �ȿ� ����), ��Į�� ��������

--------------------------------------------------
#any ������ '��� ���̶� �����ϸ� ���� ����';

SELECT TITLE, LENGTH
  FROM FILM 
 WHERE LENGTH >= ANY --ANY�� ������ ������ ����. 
 ( 
 		SELECT MAX(LENGTH)
 		FROM FILM A
 			,FILM_CATEGORY B
 		WHERE A.FILM_ID = B.FILM_ID 
 		GROUP BY B.CATEGORY_ID 
 );


SELECT TITLE, LENGTH
  FROM FILM 
 WHERE LENGTH = ANY --IN �� ���� ���  
 ( 
 		SELECT MAX(LENGTH)
 		FROM FILM A
 			,FILM_CATEGORY B
 		WHERE A.FILM_ID = B.FILM_ID 
 		GROUP BY B.CATEGORY_ID 
 );

-----------------------------------------------
#all ������ �ǽ� '��� ������ �����ؾ� �����ȴ�';

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
where length > all  -- ��ձ��� ��հ��麸�� �󿵽ð��� �� ��ȭ���� ���
(   
	SELECT ROUND(AVG (LENGTH),2) 
	FROM FIlM
	GROUP BY RATING
)
order by length;


--------------------------------------------
#exists ������ '���� ���� ���'' �ش� ������ �����ϸ� ������ �������� ������ ����'

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
    