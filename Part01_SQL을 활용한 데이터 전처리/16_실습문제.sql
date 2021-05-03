#실습문제

drop table tb_movie_cust;
create table tb_movie_cust 
(
	customer_id varchar(10) primary key
,	customer_name varchar(50) not null
,	sex varchar(6) not null check(sex in ('남자', '여자') )
,	birth_date date not null
,	address varchar(200) 
,	phone varchar(13) 
,	grade varchar(1) not null check(grade in ('S', 'A','B','C','D') )
,	joined_date date  not null check(joined_date <= expire_date )
,	expire_date date not null default to_date('9999-12-31', 'yyyy-mm-dd') -- 회원탈퇴일자는 널값을 가질수 없고 기본값은 9999년 12월 31일로 한다. 

);

 


create table tb_movie_resv
(
	book_number char(10) primary key
,	movie_id char(6) not null
,	room_number char(6) not null
,	customer_id char(10)  
,	start_time timestamp not null check(start_time < end_time)
,	end_time timestamp not null
, 	seat_num char(4) not null

,	FOREIGN KEY (customer_id)
	REFERENCES tb_movie_cust(customer_id)
)

insert into tb_movie_resv 
values 
('9000000001', '000001','000010', '0000000002', to_timestamp('2019-05-01 14:00:00', 'yyyy-mm-dd HH24:MI:SS'), to_timestamp('2019-05-01 17:00:00', 'yyyy-mm-dd HH24:MI:SS'), 'A-01');

select *from tb_movie_resv;


=============================================================================
#실습2

insert into tb_movie_cust (customer_id, customer_name, sex , birth_date, address, phone, grade, joined_date)
values 
( '0000000004', '이승우', '남자' , to_date('1984-06-12', 'yyyy-mm-dd'), '경기도 안양시 동안구 비산동 1-2', '010-1234-1234','A', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000005', '안정환', '남자' , to_date('1984-06-12', 'yyyy-mm-dd'), '경기도 안양시 동안구 비산동 1-3', '010-1234-1234','A', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000006', '고종수', '남자' , to_date('1984-06-12', 'yyyy-mm-dd'), '경기도 안양시 동안구 비산동 1-1', '010-1234-1234','C', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000007', '기성용', '남자' , to_date('1984-06-12', 'yyyy-mm-dd'), '경기도 안양시 동안구 비산동 1-1', '010-1234-1234','B', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000008', '이청용', '남자' , to_date('1984-06-12', 'yyyy-mm-dd'), '경기도 안양시 동안구 비산동 1-1', '010-1234-1234','C', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000009', '박지성', '남자' , to_date('1984-06-12', 'yyyy-mm-dd'), '경기도 안양시 동안구 비산동 1-1', '010-1234-1234','D', to_date('2019-01-01',' yyyy-mm-dd'));

select * from tb_movie_cust;


select count(customer_id) "전체고객수", count(distinct grade), max(avg_by_grade) " 등급별평균 고객수"
, max(max_by_grade) "등급별최대고객수", min(min_by_grade) "등급별최소고객수", max(grade_by_min_count)  "최소고객의 등급 ", max(grade_by_max_count) "최대고객의 등급"
from tb_movie_cust
,
(
select  avg(CNT) avg_by_grade, max(cnt) max_by_grade, min(cnt) min_by_grade
  from 
(
	select count(*) CNT
	from tb_movie_cust
	group by grade
	) b
)b
,
(
select grade as grade_by_min_count
from 
(
	select grade, count(*) cnt 
	from tb_movie_cust
	group by grade
	order by cnt, grade desc -- 등급을 바꿀수 있다. 
) a
limit 1
)c 
,
(
select grade as grade_by_max_count
from 
(
	select grade, count(*) cnt 
	from tb_movie_cust
	group by grade
	order by cnt desc
) a
limit 1
)d


)


