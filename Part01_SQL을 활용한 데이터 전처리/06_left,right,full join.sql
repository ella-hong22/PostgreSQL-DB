#����
create table basket_a
(
id int primary key,
fruit varchar (100) not null

);

select * from basket_a ;

create table basket_b
(
id int primary key,
fruit varchar (100) not null

);

select * from basket_b ;

---------------------------------
insert into basket_A (id, fruit)
values
(1, 'Apple'),
(2, 'Orange'),
(3, 'Banana'),
(4, 'Cucumber')
;

commit;
-----------------------------------------
insert into basket_B (id, fruit)
values
(1, 'Orange'),
(2, 'Apple'),
(3, 'Watermelon'),
(4, 'Pear')
;
------------------------------------
SELECT * FROM BASKET_B ;
commit;

------------------------------------
#inner ���� 

SELECT 
A.ID ID_A,
A.FRUIT FRUIT_A,
B.ID ID_B,
B.FRUIT FRUIT_B
FROM BASKET_A A
INNER JOIN BASKET_B B
	ON A.FRUIT = B.FRUIT; 

--------------------------------------
SELECT 
A.CUSTOMER_ID, A.FIRST_NAME,
A.LAST_NAME, A.EMAIL,
B.AMOUNT, B.PAyMENT_DATE
FROM CUSTOMER A
INNER JOIN PAYMENT B
ON A.CUSTOMER_ID = B.CUSTOMER_ID ;

--�� �������� ������ �� �� �ִ�. �� 1 : ����M --> 1:M���� 

=============================================
#outer ���� --left ����

SELECT 
A.ID AS ID_A,
A.FRUIT AS FRUIT_A,
B.ID AS ID_B,
B.FRUIT AS FRUIT_B
FROM BASKET_A A 
LEFT JOIN BASKET_B b --basket_a�� ������������ ���� 
ON A.FRUIT = B.FRUIT ;

WHERE B.ID IS NULL; -- left only 

----------------------------------------------------
#right ���� 

SELECT 
A.ID AS ID_A,
A.FRUIT AS FRUIT_A,
B.ID AS ID_B,
B.FRUIT AS FRUIT_B
FROM 
BASKET_A A RIGHT outer JOIN BASKET_B B  --basket_a�� ������������ ���� 
ON A.FRUIT = B.FRUIT ;

====================================================================
#self ���� '���� ���̺� ���� Ư�� �÷��� �������� ��Ī �Ǵ� �÷��� ����ϴ� ���� '

CREATE TABLE EMPLOYEE
(
EMPLOYEE_ID INT PRIMARY KEY,
FIRST_NAME VARCHAR(255) NOT NULL,
LAST_NAME VARCHAR(255) NOT NULL,
MANAGER_ID INT, --������
FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEE (EMPLOYEE_ID) 
ON DELETE CASCADE 
);

insert into employee 
values 
(1, 'Windy', 'Hays', null),
(2, 'Ava', 'Christensen', 1),
(3, 'Hassan', 'Conner', 1),
(4, 'Anna', 'Reeves', 2),
(5, 'Sau', 'Norman', 2),
(6, 'Kelsie', 'Hays', 3),
(7, 'Tory', 'Goff', 3),
(8, 'Salley', 'Lester', 3);

insert into employee 
values 
(9, 'Windysdf', 'Hayssdf', 10); --> ���� ���� ������ ������. 


commit;
-----------------------------
SELECT*FROM EMPLOYEE;

-----------------------------
SELECT 
E.FIRST_NAME || ' ' || E.LAST_NAME EMPLOYEE,
M.FIRST_NAME || ' ' || M.LAST_NAME MANAGER 
FROM 
	EMPLOYEE E
INNER JOIN EMPLOYEE M
ON M.EMPLOYEE_ID = E.MANAGER_ID 
ORDER BY MANAGER;

---------------------------------
#self left outer ���� 

SELECT 
E.FIRST_NAME || ' ' || E.LAST_NAME EMPLOYEE,
M.FIRST_NAME || ' ' || M.LAST_NAME MANAGER 
FROM 
	EMPLOYEE E
LEFT JOIN EMPLOYEE M --�ֻ��� �����ڱ��� ������ 
ON M.EMPLOYEE_ID = E.MANAGER_ID 
ORDER BY MANAGER;

-------------------------------
#self - ������ ���� '���־���'
SELECT 
	F1.TITLE,
	F2.TITLE,
	F1.LENGTH
FROM 
	FILM F1
INNER JOIN FILM F2
ON F1.FILM_ID <> F2.FILM_ID --���� �ٸ� ��ȭ�� ������ ��� 
AND F1.LENGTH = F2.LENGTH; -- ��ȭ�� �� �ð��� ����

������ ���̺������� -> ������ �ٸ� �������� ���� ->�������� -> �� ���� �� �ȿ��� �ڽ��� ���ϴ� ������ ���� 

-----------------------
select *
from film f1
where f1.length = f1.lenth
and f1.film_id <> f1.film_id; -- self ������ ��� ����� ���ü� �ִ�. -- error


======================================
#full outer ���� '������ �� �����̺� ��°����� ��� �����͸� ��� '

SELECT 
A.ID AS ID_A,
A.FRUIT AS FRUIT_A,
B.ID AS ID_B,
B.FRUIT AS FRUIT_B
FROM BASKET_A A 
FULL OUTER JOIN BASKET_B B  --��� ������ ���� �� �ִ�. 
ON A.FRUIT = B.FRUIT ;

---------------------------------------------
#full outer ���� - only outer ���� �̱� ;

SELECT 
	A.ID AS ID_A,
	A.FRUIT AS FRUIT_A,
	B.ID AS ID_B,
	B.FRUIT AS FRUIT_B
FROM BASKET_A A 
FULL OUTER JOIN BASKET_B B 
	ON A.FRUIT = B.FRUIT 
WHERE A.ID IS NULL 
	OR B.ID IS NULL; --�������� �� �������� ���� 
-----------------------------------
#�߰� �ǽ� ���� ;

CREATE TABLE 
IF NOT EXISTS DEPARTMENTS --�������� ������ ���� 
(
	DEPARTMENT_ID SERIAL PRIMARY KEY,
	DEPARTMENT_NAME VARCHAR (255) NOT NULL
);

CREATE TABLE 
IF NOT EXISTS EMPLOYEES --�������� ������ ���� 
(
	EMPLOYEES_ID SERIAL PRIMARY KEY,
	EMPLOYEES_NAME VARCHAR (255),
	DEPARTMENT_ID INTEGER
	
);

INSERT INTO DEPARTMENTS(DEPARTMENT_NAME)
VALUES
('SALES'),
('MARKETING'),
('HR'),
('IT'),
('PRODUCTION');

commit;
insert into employees
(EMPLOYEES_NAME, DEPARTMENT_ID)
values
('Bette Nicholson',1),
('Christian Gable',1),
('Joe Swank',2),
('Fred Costner',3),
('Sandra Kilmer',4),
('Julia Mcqueen',null);
-----------------------------
commit;

SELECT 
	E.EMPLOYEEs_NAME,
	D.DEPARTMENT_NAME
	FROM 
		EMPLOYEES E
FULL OUTER JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID;

----------------------------------
#full outer - right only 

SELECT 
	E.EMPLOYEEs_NAME,
	D.DEPARTMENT_NAME
	FROM 
		EMPLOYEES E
FULL OUTER JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
where e.employees_name  is null; --�Ҽ��� ������ ���� �μ��� ���


full outer + right only = right outer + right only ; --���� �Ʒ� �ڵ尡 ������ ���

SELECT 
	E.EMPLOYEEs_NAME,
	D.DEPARTMENT_NAME
	FROM 
		EMPLOYEES E
right OUTER JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
where e.employees_name  is null;