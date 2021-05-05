##���ǿ�����
#CASE 

--������ ��޿� ���� ������ �� �࿡ ��� ���ϱ�. (���� 1��, �÷��� 3���� ���) 
SELECT 
	SUM(
		CASE 	
		WHEN RENTAL_RATE = 0.99 THEN 1
		ELSE  0 END ) AS "C"
,	SUM(
		CASE 	
		WHEN RENTAL_RATE = 2.99 THEN 1
		ELSE  0 END ) AS "B"
,	SUM(
		CASE 	
		WHEN RENTAL_RATE = 4.99 THEN 1
		ELSE  0 END ) AS "A"
	FROM FILM;
	
--== ���� �� ���� �������� �ٲٱ� 

SELECT *
FROM 
 (
	SELECT 
			SUM(CASE WHEN RENTAL_RATE = 0.99 THEN CNT ELSE 0 END) AS C
		,	SUM(CASE WHEN RENTAL_RATE = 2.99 THEN CNT ELSE 0 END) AS B
		,	SUM(CASE WHEN RENTAL_RATE = 4.99 THEN CNT ELSE 0 END) AS A
	FROM 
	(
		SELECT 
				RENTAL_RATE, COUNT(*) CNT 
			FROM FILM 
			GROUP BY RENTAL_RATE 
	
	)A
)A
;		
		
== ���� ;
--������ ����� ������ŭ ���� �߻� 
SELECT 
RENTAL_RATE, COUNT(*) CNT
FROM FILM
GROUP BY RENTAL_RATE;


==================================================

#COALESCE '�Է��� ���ڰ� �߿��� �ΰ��� �ƴ� ù��° ���� �����ϴ�. �� ó���� �� ����'

CREATE TABLE TB_ITEM_COALESCE_TEST
	(
	ID SERIAL PRIMARY KEY
,	PRODUCT VARCHAR(100) NOT NULL
,	PRICE NUMERIC NOT NULL
,	DISCOUNT NUMERIC
); 

INSERT INTO TB_ITEM_COALESCE_TEST
			(PRODUCT, PRICE, DISCOUNT)
VALUES 
('A', 1000, 10),
('B', 1500, 20),
('C', 800, 5),
('D', 500, NULL);

COMMIT;
--------------------------------------
SELECT
	PRODUCT
, 	(PRICE - DISCOUNT) AS NET_PRICE --��ǰ D�� NULL�� ���´� 
FROM 
TB_ITEM_COALESCE_TEST;

SELECT* FROM TB_ITEM_COALESCE_TEST; 

-- �׷��� NULL ���� �ƴ� ù��° ���� ���� �ϱ� ���� COALESCE�� ����Ѵ�.
SELECT
		PRODUCT,  PRICE, DISCOUNT, COALESCE(DISCOUNT,0)
	, 	(PRICE - COALESCE (DISCOUNT,0)) AS NET_PRICE -- NULL ���϶� 0�� ��ȯ�Ѵ�. 
FROM 
TB_ITEM_COALESCE_TEST;


-------------------------------------------
#COALESCE �Լ��� CASE ǥ�������� ó��

SELECT 
PRODUCT
,	( PRICE - 	
				CASE
				WHEN DISCOUNT IS NULL THEN 0
				ELSE DISCOUNT
				 END ) AS NET_PRICE
	FROM 
	TB_ITEM_COALESCE_TEST; 

===================================================================
#NULLIF '�Լ��� �Է��� �ΰ��� ������ ���� �����ϸ� NULL�� �����ϰ� �׷��� ������ ù��° ���ڰ��� ����'

CREATE TABLE TB_MEMBER_NULLIF_TEST (
	ID SERIAL PRIMARY KEY 
,	FIRST_NAME VARCHAR (50) NOT NULL
,	LAST_NAME VARCHAR(50) NOT NULL
,	GENDER SMALLINT NOT NULL --1: MALE, 2 FEMALE 
);

INSERT INTO TB_MEMBER_NULLIF_TEST (
	FIRST_NAME
,	LAST_NAME
,	GENDER
)
VALUES
	('JOHN', 'DOE', 1)
,	('DAVID', 'DAVE', 1)
,	('BUSH', 'LILY', 2)
;

SELECT*FROM TB_MEMBER_NULLIF_TEST;

-----------------------------------------
#���ڴ�� ������ ���� ���ϱ� ;
SELECT 
(SUM(CASE WHEN GENDER =1 THEN 1 ELSE 0 END) /SUM(CASE WHEN GENDER =2 THEN 1 ELSE 0 END)) * 100 AS ",ALE/FEMALE RATIO"
FROM TB_MEMBER_NULLIF_TEST;

#�׽�Ʈ�� ���� ���ڸ� ���ڷ� ���� �ؼ� X/0���� ���� ERROR �߻��ϰ� �Ѵ�. ;
UPDATE  TB_MEMBER_NULLIF_TEST 	
		SET GENDER =1 
	WHERE GENDER = 2 ;

COMMIT; 

SELECT * FROM TB_MEMBER_NULLIF_TEST; 

--0���� ������ ERROR�� �ذ��ϴ� ��� NULLIF(A,A) ������ NULL�� ��ȯ --> 3/null �� ������ �ȳ�
SELECT 
(SUM(CASE WHEN GENDER =1 THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN GENDER =2 THEN 1 ELSE 0 END), 0)) * 100 AS "MALE/FEMALE RATIO"
FROM TB_MEMBER_NULLIF_TEST;

=================================================================================
#case ' ������ ���� Ư�� ������ Ÿ������ ����ȯ�� �����ϵ��� �ϴ� ���'

select 
cast ('100' as integer) ; --'100'�̶�� ���ڿ��� ���������� ����ȭ ��. 

--== ���� ǥ���� 
select 
'100' :: integer; 

-------------------------------------------------------
#���ڿ��� date Ÿ������ ����ȯ ;
select 
cast('2015-01-01' as date) ;

--==
select 
'2015-01-01' :: date ;
-----------------------------------
#���ڿ��� �Ǽ������� ����ȯ ;
select 
cast('10.2' as double precision) ;

-------------------------------------
#with���� Ȱ�� '�ʹ� �߿���' 'select���� ����� �ӽ� �������� �����صΰ� sql������ ��ġ ���̺� ó�� �ش� ������ �ҷ��ü� �ִ�.'

select 
		film_id
	,	title
	,	(case
		when length < 30 then 'short'
		when length >= 30 and length < 90 then 'medium'
		when length > 90 then 'long'
		end) length 
	from film 
;

WITH TMP1 AS (
SELECT 
		FILM_ID
	,	TITLE
	, (CASE
		WHEN LENGTH < 30 THEN 'SHORT'
		WHEN LENGTH >= 30 AND LENGTH < 90 THEN 'MEDIUM'
		WHEN LENGTH > 90 THEN 'LONG'
	  END) LENGTH 
	FROM 
		FILM 
	
)
select * from tmp1 where length = 'LONG';

===============================================
#��� ���� '��� ������ ������ �� ���� �θ� �ڽİ��� ���踦 ǥ���ϴ� sql�̴�.'

�ǽ� �غ�;
create table tb_emp_recursive_test (
	employee_id serial primary key
,	full_name varchar not null
,	manager_id int  -- �� ����� ���� ������
); 

insert into tb_emp_recursive_test (
	employee_id, full_name, manager_id)
values 
	(1, '�̰��', null)
,	(2, '��', 1)
,	(3, '��', 1)
,	(4, '��', 1)
,	(5, 'ĥ', 2)
,	(6, '��', 2)
,	(7, '��', 3)
,	(8, '��', 3)
,	(9, '����', 3)
,	(10, '����', 3)
,	(11, '�ʻ�', 4)
,	(12, '���', 7);

select *from tb_emp_recursive_test;

--with ���� �̿��ؼ� ��� ������ ����. 
WITH RECURSIVE TMP2 AS (
SELECT 		
		EMPLOYEE_ID
	,	MANAGER_ID
	,	FULL_NAME
	, 	0 LVL
	FROM 
		TB_EMP_RECURSIVE_TEST
	WHERE MANAGER_ID IS NULL
UNION 
SELECT 
		E.EMPLOYEE_ID
	,	E.MANAGER_ID
	,	E.FULL_NAME
	, 	S.LVL + 1
	FROM 
		TB_EMP_RECURSIVE_TEST E, TMP2 S
	WHERE S.EMPLOYEE_ID = E.manager_ID --��� id �� �Ŵ��� id ����
)
SELECT EMPLOYEE_ID , MANAGER_ID, LPAD(' ',4 * (LVL)) || FULL_NAME AS FULL_NAME
	FROM TMP2;
;)


WITH RECURSIVE TMP2 AS (
SELECT 		
		EMPLOYEE_ID
	,	MANAGER_ID
	,	FULL_NAME
	, 	0 LVL
	FROM 
		TB_EMP_RECURSIVE_TEST
	WHERE employee_id =2  -- ����� ��� ���� 
UNION 
SELECT 
		E.EMPLOYEE_ID
	,	E.MANAGER_ID
	,	E.FULL_NAME
	, 	S.LVL + 1
	FROM 
		TB_EMP_RECURSIVE_TEST E, TMP2 S
	WHERE S.EMPLOYEE_ID = E.manager_ID --��� id �� �Ŵ��� id ����
)
SELECT EMPLOYEE_ID , MANAGER_ID, LPAD(' ',4 * (LVL)) || FULL_NAME AS FULL_NAME
	FROM TMP2;
)

=======================================================================
#Ʈ����� begin, commit, rollback

drop table tb_account_transaction_test;

create table tb_account_transaction_test (
	id int generated by default as identity
,	name varchar(100) not null 
, 	balance dec(152) not null 
,	primary key(id)
);
commit; 

select * from tb_account_transaction_test;

insert into tb_account_transaction_test
(name, balance)
values('alice', 10000) ;

commit;
rollback;

select * from tb_account_transaction_test;

insert into tb_account_transaction_test
(name, balance)
values('deny', 20000) ;