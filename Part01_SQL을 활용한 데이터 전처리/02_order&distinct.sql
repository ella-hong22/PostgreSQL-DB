#Į�� ��ȸ
select * from customer ;

#������ Į�� ��ȸ 

select 
		  first_name
		, last_name
		, email
	from 	
		customer  
;

select 
		a.first_name
		, a.last_name
		, a.email
	from 	
		customer  a
;

ALIAS -> �ڵ��� ������  -> sql ����
DBMS -> ��Ƽ������ -> �����ϱ� -> sql -> ���������, ���� �����, ���� 
---------------------------------------------------------
2.�����ϱ� (�ø�����)
select 
	First_NAME,
	LAST_NAME
	from 
		customer
		
	order by FIRST_NAME asc
	
2-1) desc(��������) ���� 
select 
	First_NAME,
	LAST_NAME
	from 
		customer
		
	order by FIRST_NAME desc
	
2-2)asc + desc(���� ���) 
select 
	First_NAME, --asc �������� -������
	LAST_NAME  --asc �������� -����
	from 
		customer
		
	order by FIRST_NAME ASC
			,LAST_NAME desc

2-3)order by ���� �ֱ� (����õ)
select 
	First_NAME, --asc �������� -������
	LAST_NAME  --asc �������� -����
	from 
		customer
		
	order by 2 ASC
			,1 desc
			
---------------------------------
part3. ������ ��ȸ�� ���͸� [select distinct]	= '������ ����'
select 	
		distinct column_1, column_2
	from TABLE_NAME
order by  column_1, column_2;

create table T1 (ID serial not null primary key, bcolor varchar, fcolor VARCHAR);

insert 
	into T1 (BCOLOR, FCOLOR)
values 
	('RED','RED'),
	('RED', 'RED'),
	('RED', 'NULL'),
	('RED', 'BLUE'),
	('PINK', 'RED')
;

select 	
	distinct BCOLOR ---BCOLOR���� ���ĵ� �͸� ���ؼ� �ߺ� ���� 
from T1
ORDER by 
	BCOLOR
;

--------------------------------------------------------
select 	
	distinct BCOLOR, FCOLOR ---1,2 ���� ���ؼ� �ߺ��Ȱ� ����
from T1
ORDER by 
	BCOLOR, FCOLOR
;
--------------------------------------------------------
--DISTINCT ON ���
select 	
	distinct on (BCOLOR)BCOLOR,
	FCOLOR---1,2 ���� ���ؼ� �ߺ��Ȱ� ����
from T1
ORDER by 
	BCOLOR, FCOLOR
;

