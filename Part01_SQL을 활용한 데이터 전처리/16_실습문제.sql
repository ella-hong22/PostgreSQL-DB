#�ǽ�����

drop table tb_movie_cust;
create table tb_movie_cust 
(
	customer_id varchar(10) primary key
,	customer_name varchar(50) not null
,	sex varchar(6) not null check(sex in ('����', '����') )
,	birth_date date not null
,	address varchar(200) 
,	phone varchar(13) 
,	grade varchar(1) not null check(grade in ('S', 'A','B','C','D') )
,	joined_date date  not null check(joined_date <= expire_date )
,	expire_date date not null default to_date('9999-12-31', 'yyyy-mm-dd') -- ȸ��Ż�����ڴ� �ΰ��� ������ ���� �⺻���� 9999�� 12�� 31�Ϸ� �Ѵ�. 

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
#�ǽ�2

insert into tb_movie_cust (customer_id, customer_name, sex , birth_date, address, phone, grade, joined_date)
values 
( '0000000004', '�̽¿�', '����' , to_date('1984-06-12', 'yyyy-mm-dd'), '��⵵ �Ⱦ�� ���ȱ� ��굿 1-2', '010-1234-1234','A', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000005', '����ȯ', '����' , to_date('1984-06-12', 'yyyy-mm-dd'), '��⵵ �Ⱦ�� ���ȱ� ��굿 1-3', '010-1234-1234','A', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000006', '������', '����' , to_date('1984-06-12', 'yyyy-mm-dd'), '��⵵ �Ⱦ�� ���ȱ� ��굿 1-1', '010-1234-1234','C', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000007', '�⼺��', '����' , to_date('1984-06-12', 'yyyy-mm-dd'), '��⵵ �Ⱦ�� ���ȱ� ��굿 1-1', '010-1234-1234','B', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000008', '��û��', '����' , to_date('1984-06-12', 'yyyy-mm-dd'), '��⵵ �Ⱦ�� ���ȱ� ��굿 1-1', '010-1234-1234','C', to_date('2017-01-01',' yyyy-mm-dd'))
,( '0000000009', '������', '����' , to_date('1984-06-12', 'yyyy-mm-dd'), '��⵵ �Ⱦ�� ���ȱ� ��굿 1-1', '010-1234-1234','D', to_date('2019-01-01',' yyyy-mm-dd'));

select * from tb_movie_cust;


select count(customer_id) "��ü����", count(distinct grade), max(avg_by_grade) " ��޺���� ����"
, max(max_by_grade) "��޺��ִ����", min(min_by_grade) "��޺��ּҰ���", max(grade_by_min_count)  "�ּҰ��� ��� ", max(grade_by_max_count) "�ִ���� ���"
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
	order by cnt, grade desc -- ����� �ٲܼ� �ִ�. 
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


