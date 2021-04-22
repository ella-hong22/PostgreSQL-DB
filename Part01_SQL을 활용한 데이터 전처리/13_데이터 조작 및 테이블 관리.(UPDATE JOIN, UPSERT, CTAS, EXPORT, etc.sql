#������ ���� 
1-1 insert into 

INSERT 
	INTO LINK
(URL, NAME)
values
('HTTP://','NAVER')
('''HTTP://''','''NAVER'''); --''�� '�� ���Եȴ�. 

commit;
-----------------------------------
#���̺��� ���̺� �Է�;
create table LINK_TMP as
select *from LINK where 0=1; -- LINK_TMP���̺��� ������ LINK�� ���� �����ʹ� 0���� �ȴ�. 

INSET 
	into LINK_TMP
select *
  from LINK ; --���̺� ��ü�� �����ؼ� �־���
===================================================
#update '�����۾��̰� ���ü��� �����Ѵ�. ';

update LINK
	set REL = 'NO DATA'; -- REL Į���� �մ� �����͸� ��� NODATA�� �ٲ��� WHERE���� �����Ƿ� ���̺��� ��ü ���� ��������Ѵ�. 

commit; --�ٷ� �ؾ� �������� ���ü��� ������ ������ �ʴ´�

========================================================
'#UPDATE JOIN��' '������ ������ ������ �����ϰ� ���� ���� ���� ���'

CREATE TABLE PRODUCT_SEGMENT
(  
	ID SERIAL PRIMARY KEY
,	SEGMENT VARCHAR NOT NULL
,	DISCOUNT NUMERIC(4,2)
);

insert into product_SEGMENT
(SEGMENT, DISCOUNT)
values
		('GRAND LUXURY', 0.05)
	,	('LUXURY', 0.06)
	,	('MASS', 0.1)

	commit;
select *from product;
CREATE TABLE PRODUCT (
	ID SERIAL PRIMARY KEY
,	NAME VARCHAR NOT NULL
,	PRICE NUMERIC(10,2)
,	NET_PRICE NUMERIC(10,2)
,	SEGMENT_ID INT NOT NULL
,	FOREIGN KEY(SEGMENT_ID)
	REFERENCES PRODUCT_SEGMENT(ID)
);

insert into product (NAME, PRICE, SEGMENT_ID)
values
		('k5', 804.89, 1)
	,	('K7', 228.89, 3)
	,	('K9', 336.89, 2)
	,	('SONATA', 145.89, 3)
	,	('SPARK', 551.89, 2)
	,	('AVANTE', 261.89, 3)
	,	('SANTAFE', 843.89, 1)
	,	('TUSON', 427.89, 2)
	,	('ORANDO', 963.89, 1)
	,	('RAY', 910.89, 1)
	,	('MORING', 208.89, 3)
	,	('VERNA', 985.89, 1)
	,	('K8',841.89, 1)
	,	('TICO', 896.89, 1)
	,	('MATIZ', 575.89, 2)
	,	('SPORTAGE', 530.89, 2);
	

-----------------------------------------------

update product A
	set NET_PRICE = A.PRICE - (A.PRICE*B.DISCOUNT)
	from product_SEGMENT B
  where A.SEGMENT_ID =B.ID; 
  
select*from PRODUCT;

=======================================================
#delete ���� --���̺��� ���� �����ϴ� ���

delete
  from 
  		LINK
 where ID =5 ; 
 
commit; 

delete from LINK_TMP A
	using LINK B --LINK ���̺�� ���� 
where A.ID = B.ID; --ID�� �ߺ��Ǵ� ���� ���� �����ȴ�. 

========================================================
#UPSERT �� 

cREATE TABLE CUSTOMERS 
(
	CUSTOMER_ID SERIAL PRIMARY KEY
,	NAME VARCHAR UNIQUE
,	EMAIL VARCHAR NOT NULL
,	ACTIVE BOOL NOT NULL DEFAULT TRUE
);

INSERT INTO CUSTOMERS(NAME, EMAIL)
VALUES
('IMB','CONTACT@COM'),
('MICRO','CONTACT@MCIRO.COM'),
('INTEL','CONTACT@INTEL.COM');

select*from customerS;

insert into CUSTOMERS (NAME, EMAIL)
values
( 
'MICRO',
'HOTLINE@COM')
on conflict (NAME) --�Ʒ��� �ι����� ������ SQL ����
do nothing;

-------------------------------------------
'#UPSERT�� �ǽ� - update ���' 
insert into CUSTOMERS (NAME, EMAIL)
values
( 
'MICRO',
'HOTLINE@COM')
on conflict (NAME) 
do update 	
		set EMAIL = EXCLUDED.EMAIL || ';' || CUSTOMERS.EMAIL; --HOTLINE@COM;CONTACT@MCIRO.COM �־���
==================================================================
#EXPORT �۾� '�ٸ� ������ �����ͷ� �����ϴ� �۾� CSV �������� ����' ;

COPY CATEGORY(CATEGORY_ID, NAME, LAST_UPDATE) --������ ���̺� Į�� ����
	TO 'C:\TMP\DB_CATEGORY.CSV' --������ ���� ��� ����
DELIMITER ',' --������ ����
CSV HEADER --�������� ���� AND Į���� ���� ����

===================================================================
#import �۾� '������ ���̺� �ִ´� ';

COPY CATEGORY(CATEGORY_ID, NAME, LAST_UPDATE) --������ ���̺� Į�� ����
	FROM 'C:\TMP\DB_CATEGORY.CSV' --������ ���� ��� ����
DELIMITER ',' --������ ����
CSV HEADER --�������� ���� AND Į���� ���� ���� HEADER ������� 1��° �ش��� �ν��ؼ� 1���� ���� ������

===============================================================
#������ Ÿ��

drop table DATA_TYPE_TEST_1;
create table 
DATA_TYPE_TEST_1
( 
	A_BOOLEAN BOOLEAN
,	B_CHAR CHAR (10)
,	C_VARCHAR VARCHAR(10)
, 	D_TEXT text
,	E_INT INT
,	F_SMALLINT smallint
,	G_FLOAT FLOAT
,	H_NUMERIC numeric(15,2)
);

insert into
DATA_TYPE_TEST_1
values
( 
	TRUE
,	'ABCDE' --������ ��
,	'ABCDE'
,	'TEXT'
,	1000
, 	10
,	10.12345
, 	10.25	);

commit;

select* from DATA_TYPE_TEST_1;

------------------------------
create table 
DATA_TYPE_TEST_2
( 
	A_DATE DATE
,	B_TIME TIME
,	C_TIMESTAMP TIMESTAMP
, 	D_ARRAY text[]
, 	E_JSON JSON
);

insert  into DATA_TYPE_TEST_2
VALUES
(  
CURRENT_DATE
, LOCALTIME
, CURRENT_TIMESTAMP
, array ['010-1234-1234', '010-4321-4321']
, '{"CUSTOMER" : "JOHN DOE", "ITEMS": {"PRODUCT" : "BEER","QTY":6}}'
);

select*from DATA_TYPE_TEST_2;
===========================================================
#���̺� ���� 

create table ACCOUNT
( 
	USER_ID SERIAL primary key
,	USERNAME VARCHAR(50) unique not null
,	password VARCHAR(50) not null
,	EMAIL VARCHAR (355) unique not null
,	CREATED_ON TIMESTAMP not null
,	LAST_LOGIN TIMESTAMP
);

create table role 
( ROLE_ID SERIAL primary key 
	,ROLE_NAME VARCHAR(255) unique not NULL);

)

create table ACCOUNT_ROLE
(   
	USER_ID INTEGER not null
,	ROLE_ID INTEGER not null
,	GRANT_DATE TIMESTAMP without TIME zone
, 	primary key (USER_ID, ROLE_ID)
,	constraint ACCOUNT_ROLE_ROLE_ID_FKKY foreign key (ROLE_ID)
	references role (role_ID) match simple
	on update no action on delete no action
, 	constraint ACCOUNT_ROLE_USER_ID_FKEY foreign KEY(USER_ID)
	references ACCOUNT (USER_ID) match simple on
	update no action on delete  no action 
	);


insert into ACCOUNT VALUES(1,'�̰��','1234','DBEXPERT@NAVER.COM', CURRENT_TIMESTAMP, NULL);
commit;

select*from ACCOUNT;

insert into role VALUES(1,'DBA');

insert into ACCOUNT_ROLE VALUES(1,1, CURRENT_TIMESTAMP);

select*from account_role ;

====================================================
#CTAS 'CREATE TABLE AS SELECT ���'

SELECT 
	A.FILM_ID,
	A.TITLE,
	A.RELEASE_YEAR,
	A.LENGTH,
	A.RATING
FROM 	
	FILM A, FILM_CATEGORY B
WHERE A.FILM_ID = B.FILM_ID 
AND B.CATEGORY_ID = 1
;

select *from category where category_id =1;

--�ڵ����� �ű� ���̺� ������� CTAS
create table action_film as
SELECT 
	A.FILM_ID,
	A.TITLE,
	A.RELEASE_YEAR,
	A.LENGTH,
	A.RATING
FROM 	
	FILM A, FILM_CATEGORY B
WHERE A.FILM_ID = B.FILM_ID 
AND B.CATEGORY_ID = 1
;

drop table action_film;

select*from action_film ;

=====================
#���̺� ���� ���� �ǽ� 


