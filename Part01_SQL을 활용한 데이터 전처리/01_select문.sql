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