#Á¶ÀÎ
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
(1, 'Apple'),
(2, 'Orange'),
(3, 'Banana'),
(4, 'Cucumber')
;
------------------------------------
select * from basket_b ;

------------------------------------

