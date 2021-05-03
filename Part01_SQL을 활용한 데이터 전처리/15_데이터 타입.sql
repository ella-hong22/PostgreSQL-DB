##������ Ÿ��
#BOOLEAN = '������ Ÿ���� ���� ������ ���� ���� ���� �ϴ� ������ Ÿ��' 

CREATE TABLE STOCK_AVAILABILITY
( 
	PRODUCT_ID INT NOT NULL PRIMARY KEY
, 	AVAILABLE BOOLEAN NOT NULL 

)

INSERT INTO STOCK_AVAILABILITY(PRODUCT_ID, AVAILABLE)
VALUES
(100, TRUE), --'T', 1, YES ��� TRUE �� 
(200, FALSE),
(300, 'T'),
(400, 'F'),
(500, '1'),
(600, 'YES')

SELECT *FROM STOCK_AVAILABILITY ;

SELECT *
FROM 
	STOCK_AVAILABILITY 
WHERE 
AVAILABLE = 'YES';

== --���� ���

SELECT *
FROM 
	STOCK_AVAILABILITY 
WHERE 
AVAILABLE;

=========================================
#CHAR(������), VARCHAR(������),TEXT (���Ѵ� ������ ���ڿ�) #NUMERIC;

CREATE TABLE PRODUCT1
(
	ID SERIAL PRIMARY KEY
,	NAME VARCHAR NOT NULL
,	PRICE NUMERIC (5,2)
);

INSERT INTO PRODUCT1 (NAME, PRICE)
VALUES 
	('PHONE', 500.215),
	('TABLET', 500.214)
;

SELECT *FROM PRODUCT1; --�Ҽ��� �ݿø��� �ϰ� �ȴ�. �̷����� ������ �߻��Ҽ� �ֱ� ������ NUMERIC�� �������ִ°� ����. 

INSERT INTO PRODUCT1 (NAME, PRICE)
VALUES 
	('PHONE', 50012345.215) ; --������ ����. 
=========================================
#INTEGER '������ ������ Ÿ�� ' ,SERIAL 'PK�� ���� ���ȴ�.'

CREATE TABLE TABLE_NAME
(    
	ID SERIAL 
);
== ����. 

drop TABLE  TABLE_NAME;

CREATE SEQUENCE TABLE_NAME_ID_SEQ;

CREATE TABLE TABLE_NAME
(    
	ID INTEGER NOT NULL DEFAULT
NEXTVAL('TABLE_NAME_ID_SEQ')
);

ALTER SEQUENCE TABLE_NAME_ID_SEQ OWNED BY TABLE_NAME.ID;

INSERT INTO TABLE_NAME VALUES(DEFAULT); -- ���ڰ� �ϳ��� �߰��� 

SELECT* FROM TABLE_NAME;

#�ǽ�;
create table FRUITS(
	ID SERIAL primary key
,	NAME VARCHAR not NULL
);

insert into FRUITS(NAME) values ('ORANGE');
insert into FRUITS(ID, NAME) VALUES(default,'APPLE');

select*from FRUITS;

--������ ������ ���� �˰� ������, 
SELECT CURRVAL(PG_GET_SERIAL_SEQUENCE ('FRUITS', 'id')); 

========================================================
#date, time, timestamp

select now()::date; -- 2019-05-07(��������)
select cureent_date;  -- 2019-05-07(��������)
select to_char(now()::date,'dd/mm/yyyy'); --02/05/2021
select to_char(now()::date,'mon dd,yyyy'); --may/02, 2021


select 
	first_name
,	last_name
,	extract (year from create_date) as year -- �⸸ �̰� ������ 
  from 
  		customer;
  	
------------------------------------------
select current_time; -- �ð��� ��ȸ�Ҷ�
select localtime ;

==================================
##���� ����
#�⺻Ű '���̺� ������ ������ ���̾���ϰ� not null�̾�� �Ѵ�. ';

create table tb_product_pk_test (
	product_no integer
,	description text
,	product_cost numeric
);

alter table tb_product_pk_test 
add primary key(product_no);

--�⺻Ű ����
alter table tb_product_pk_test 
drop constraint tb_product_pk_test_pkey;

select* from tb_product_pk_test ;


#�ܷ�Ű '���� ���Ἲ'

#üũ ���� ���� ' Ư�� �÷��� ���� ���� ���� ������ ���ϴ� ���̴�. ��, ���������� ����� ���� ���� ���� ���´�'

create table tb_emp_check_test(
	id serial primary key
,	first_name varchar(50)
,	birth_Date date check(birth_Date> '1900-01-01')
,	joined_Date date check(joined_date > birth_Date)
,	salary numeric check(salary > 0)
);

insert into tb_emp_check_test (
first_name, birth_Date, joined_Date, salary)
values (
'JOHN' ,'1972-01-01','2015-07-01',-100000); -- ������ ���̳ʽ��ϼ� ����. üũ ���� ���� ����



