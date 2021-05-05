#�ǽ� ���� 1
'basket ���̺��� fruit Ŀ���� �ߺ��� ���� �����ϴ� delete���� �ۼ��Ͻÿ�, ��, row_number()�Լ��� ����Ͻÿ�'

create table basket(
	id serial primary key
,	fruit varchar(50) not null

);

insert into basket(fruit) values('apple');
insert into basket(fruit) values('apple');
insert into basket(fruit) values('orange');
insert into basket(fruit) values('orange');
insert into basket(fruit) values('orange');
insert into basket(fruit) values('banana');

commit;

DELETE FROM BASKET WHERE ID IN 
(
SELECT  ID
FROM 
(
		SELECT ID, FRUIT, 
			ROW_NUMBER () OVER (PARTITION BY FRUIT ORDER BY ID ASC) AS ROW_NUM
		FROM BASKET

) T 
WHERE ROW_NUM > 1
)  ;

select* from basket;

=========================================================
#�ǽ�����2
'with���� row_number()�� �̿��Ͽ� film ���̺��� rating �÷����� length�÷��� ���� �� ��ȭ�� ����� ���ϴ� select���� �ۼ�'

with test as (
select * from 
(
select title, length, rating, 
	row_number () over(partition by rating order by length desc) as row_num
from film
) a 
where row_num = 1 
) 
select title from test;

--teach result

with test1 as (
select film_id, title, length, rating, 
	rank () over(partition by rating order by length desc) as length_rank
from film
) 
select * from test1
where length_rank = 1;

--row_number ���� ������ ���� �ݸ� rank ���� ������ �ִ�. 





