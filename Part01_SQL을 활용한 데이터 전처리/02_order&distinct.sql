#칼럼 조회
select * from customer ;

#지정한 칼럼 조회 

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

ALIAS -> 코드의 가독성  -> sql 성능
DBMS -> 옵티마이저 -> 최적하기 -> sql -> 가장빠르게, 가장 저비용, 실행 
---------------------------------------------------------
2.정렬하기 (올림차순)
select 
	First_NAME,
	LAST_NAME
	from 
		customer
		
	order by FIRST_NAME asc
	
2-1) desc(내림차순) 정렬 
select 
	First_NAME,
	LAST_NAME
	from 
		customer
		
	order by FIRST_NAME desc
	
2-2)asc + desc(같이 사용) 
select 
	First_NAME, --asc 오름차순 -순차적
	LAST_NAME  --asc 내림차순 -역순
	from 
		customer
		
	order by FIRST_NAME ASC
			,LAST_NAME desc

2-3)order by 정수 넣기 (비추천)
select 
	First_NAME, --asc 오름차순 -순차적
	LAST_NAME  --asc 내림차순 -역순
	from 
		customer
		
	order by 2 ASC
			,1 desc
			
---------------------------------
part3. 데이터 조회와 필터링 [select distinct]	= '증복값 제거'
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
	distinct BCOLOR ---BCOLOR에서 정렬된 것만 비교해서 중복 제거 
from T1
ORDER by 
	BCOLOR
;

--------------------------------------------------------
select 	
	distinct BCOLOR, FCOLOR ---1,2 서로 비교해서 중복된것 삭제
from T1
ORDER by 
	BCOLOR, FCOLOR
;
--------------------------------------------------------
--DISTINCT ON 사용
select 	
	distinct on (BCOLOR)BCOLOR,
	FCOLOR---1,2 서로 비교해서 중복된것 삭제
from T1
ORDER by 
	BCOLOR, FCOLOR
;

