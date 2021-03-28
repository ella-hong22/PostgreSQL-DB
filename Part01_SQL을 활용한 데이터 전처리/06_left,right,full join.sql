#조인
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
#inner 조인 

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

--고객 여러건의 결제를 할 수 있다. 고객 1 : 결제M --> 1:M관계 

=============================================
#outer 조인 --left 조인

SELECT 
A.ID AS ID_A,
A.FRUIT AS FRUIT_A,
B.ID AS ID_B,
B.FRUIT AS FRUIT_B
FROM BASKET_A A 
LEFT JOIN BASKET_B b --basket_a를 기준집합으로 조인 
ON A.FRUIT = B.FRUIT ;

WHERE B.ID IS NULL; -- left only 

----------------------------------------------------
#right 조인 

SELECT 
A.ID AS ID_A,
A.FRUIT AS FRUIT_A,
B.ID AS ID_B,
B.FRUIT AS FRUIT_B
FROM 
BASKET_A A RIGHT outer JOIN BASKET_B B  --basket_a를 기준집합으로 조인 
ON A.FRUIT = B.FRUIT ;

====================================================================
#self 조인 '같은 테이블 끼리 특정 컬럼을 기준으로 매칭 되는 컬럼을 출력하는 조인 '

CREATE TABLE EMPLOYEE
(
EMPLOYEE_ID INT PRIMARY KEY,
FIRST_NAME VARCHAR(255) NOT NULL,
LAST_NAME VARCHAR(255) NOT NULL,
MANAGER_ID INT, --관리자
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
(9, 'Windysdf', 'Hayssdf', 10); --> 고유 제약 조건을 위반함. 


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
#self left outer 조인 

SELECT 
E.FIRST_NAME || ' ' || E.LAST_NAME EMPLOYEE,
M.FIRST_NAME || ' ' || M.LAST_NAME MANAGER 
FROM 
	EMPLOYEE E
LEFT JOIN EMPLOYEE M --최상의 관리자까지 보여줌 
ON M.EMPLOYEE_ID = E.MANAGER_ID 
ORDER BY MANAGER;

-------------------------------
#self - 부정형 조건 '자주쓰임'
SELECT 
	F1.TITLE,
	F2.TITLE,
	F1.LENGTH
FROM 
	FILM F1
INNER JOIN FILM F2
ON F1.FILM_ID <> F2.FILM_ID --서로 다른 영화인 집합을 출력 
AND F1.LENGTH = F2.LENGTH; -- 영화의 상영 시간은 동일

동일한 테이블이지만 -> 각각의 다른 집합으로 구성 ->셀프조인 -> 그 다음 그 안에서 자신이 원하는 정보를 추출 

-----------------------
select *
from film f1
where f1.length = f1.lenth
and f1.film_id <> f1.film_id; -- self 조인을 써야 결과가 나올수 있다. -- error


======================================
#full outer 조인 '합집합 즉 두테이블간 출력가능한 모든 데이터를 출력 '

SELECT 
A.ID AS ID_A,
A.FRUIT AS FRUIT_A,
B.ID AS ID_B,
B.FRUIT AS FRUIT_B
FROM BASKET_A A 
FULL OUTER JOIN BASKET_B B  --모든 집합을 뽑을 수 있다. 
ON A.FRUIT = B.FRUIT ;

---------------------------------------------
#full outer 조인 - only outer 조인 뽑기 ;

SELECT 
	A.ID AS ID_A,
	A.FRUIT AS FRUIT_A,
	B.ID AS ID_B,
	B.FRUIT AS FRUIT_B
FROM BASKET_A A 
FULL OUTER JOIN BASKET_B B 
	ON A.FRUIT = B.FRUIT 
WHERE A.ID IS NULL 
	OR B.ID IS NULL; --교집합을 뺀 나머지를 추출 
-----------------------------------
#추가 실습 예제 ;

CREATE TABLE 
IF NOT EXISTS DEPARTMENTS --존재하지 않으면 생성 
(
	DEPARTMENT_ID SERIAL PRIMARY KEY,
	DEPARTMENT_NAME VARCHAR (255) NOT NULL
);

CREATE TABLE 
IF NOT EXISTS EMPLOYEES --존재하지 않으면 생성 
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
where e.employees_name  is null; --소속한 직원이 없는 부서만 출력


full outer + right only = right outer + right only ; --위와 아래 코드가 동일한 결과

SELECT 
	E.EMPLOYEEs_NAME,
	D.DEPARTMENT_NAME
	FROM 
		EMPLOYEES E
right OUTER JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
where e.employees_name  is null;