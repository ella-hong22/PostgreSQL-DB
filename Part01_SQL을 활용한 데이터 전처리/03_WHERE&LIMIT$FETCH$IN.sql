02.������ ��ȸ�� ���͸�
--#WHERE �� 

SELECT 
	LAST_NAME,
	FIRST_NAME
FROM 
	CUSTOMER
WHERE --����ó��--
	FIRST_NAME ='JAMIE'; --��ҹ��� ����-- 
	
	
----------------------------------------------
#������ ��� �϶�

SELECT
	LAST_NAME,
	FIRST_NAME
FROM
	CUSTOMER
WHERE --����ó��--
 	FIRST_NAME = 'JAMIE'; --��ҹ��� ����-- 
AND LAST_NAME = 'RICE'

----------------------------------------------

#������ �ΰ��϶�

SELECT
	CUSTOMER_ID,
	AMOUNT,
	PAYMENT_DATE
FROM
	PAYMENT
WHERE--����ó��--
 		AMOUNT <= 1
	OR AMOUNT >= 8;

-----------------------------------------------
-----------------------------------------------

#LIMIT �� (���� ���� �����ϴ� ����) '���ֻ���'

SELECT
	FILM_ID,
	TITLE,
	RELEASE_YEAR
FROM
	FILM
ORDER BY --����-- 
	FILM_ID
LIMIT 4 --4���� ������--
OFFSET 3; --������--
	
-------------------------------------------------
#LIMIT�� - �������� ����

SELECT
	FILM_ID,
	TITLE,
	RELEASE_YEAR
FROM
	FILM
ORDER BY --����-- 
	RENTAL_RATE DESC --����-- ASC=�ø����� (�������� �ڵ� �ø�����)
LIMIT 10;

------------------------------------------------
------------------------------------------------
#FETCH �� '���� ���� ����' , �κ� ���� ó���� ���

SELECT
	FILM_ID,
	TITLE
FROM
	FILM
ORDER BY TITLE 
FETCH FIRST ROW ONLY --������ �� �� ���� ���� ����-- -- ���Լ��� ����� ����Ҷ�--
;

--------------------------------------------------
#���� ���� 
SELECT
	FILM_ID,
	TITLE
FROM
	FILM
ORDER BY TITLE 
FETCH FIRST 9 ROW ONLY --���ڸ� ����-- 
;
------------------------------------
#�� ���� ���� 

SELECT
	FILM_ID,
	TITLE
FROM
	FILM
ORDER BY TITLE 
	OFFSET 5 ROWS --6��° �����--
FETCH FIRST 5 ROW ONLY --5���� �� ����-- 
;
------------------------------------
------------------------------------
#IN ������ 'Ư�� ���� Ȥ�� ����Ʈ�� �����ϴ��� �Ǵ��ϴ� ������'

SELECT
	CUSTOMER_ID,
	RENTAL_ID,
	RETURN_DATE
FROM
	RENTAL
WHERE
	CUSTOMER_ID IN(1, 2) -- 1 OR 2�� ���� ���
ORDER BY
	RETURN_DATE DESC; --����� ������������ ��� --
	
--������
--DBMS ����ȭ, SQL ����ȭ) ��Ƽ�������� Ư���� IN ���� ���ɻ� ������
	
-------------------------------------------------
#IN ������ - OR �� ��� 'IN �����ڴ� OR &&'='�� ����.'

SELECT
	CUSTOMER_ID,
	RENTAL_ID,
	RETURN_DATE
FROM
	RENTAL
WHERE
		CUSTOMER_ID = 1
	OR  CUSTOMER_ID = 2
ORDER BY
	RETURN_DATE DESC;

----------------------------------------------------
# NOT IN ������ �ǽ�

SELECT
	CUSTOMER_ID,
	RENTAL_ID,
	RETURN_DATE
FROM
	RENTAL
WHERE
	CUSTOMER_ID NOT IN(1, 2) -- 1 �� 2�� ������ ���
ORDER BY 
	RETURN_DATE DESC; 

----------------------------------------------------
#NOT IN ������ ���� - AND ���


SELECT
	CUSTOMER_ID,
	RENTAL_ID,
	RETURN_DATE
FROM
	RENTAL
WHERE
		CUSTOMER_ID <> 1
	AND CUSTOMER_ID <> 2 -- 1 �� 2�� ������ ���
ORDER BY 
	RETURN_DATE DESC; 

 -- NOT IN �����ڴ� 'AND' && '<>'�� ����. --
 
------------------------------------------
#NOT IN ������ ���� - ��������

SELECT
	FIRST_NAME,
	LAST_NAME
FROM
	CUSTOMER
WHERE
	CUSTOMER_ID IN (
										--�������� 
					SELECT
						CUSTOMER_ID
					FROM
						RENTAL
					WHERE
						CAST (RETURN_DATE AS DATE) = '2005-05-27');
					
					


