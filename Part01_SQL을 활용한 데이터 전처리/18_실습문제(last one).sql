#실습 문제 1
'basket 테이블에서 fruit 커럼이 중복된 행을 삭제하는 delete문을 작성하시오, 단, row_number()함수를 사용하시오'

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
#실습문제2
'with문과 row_number()를 이용하여 film 테이블에서 rating 컬럼별로 length컬럼이 가장 긴 영화의 목록을 구하는 select문을 작성'

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

--row_number 동일 순위가 없는 반면 rank 동일 순위가 있다. 





