
--00. 데이터 확인 

select * from movie;
select * from users;
select * from rating;

-- 01. 식별자 찾기 (데이터구조 정상화란 식별자 찾기)
	-- A.movie

select * from information_schema.columns c  where c.table_name = 'movie';

--movie table column list - movieid, title_nm, genres_nm
	--> pk : movieid
	select movieid , count(*) cnt
	  from movie
	 group by movieid
	having count(*) >1; --아무것도 안나오면 식별자 이다. 	 
	
	select title_nm , count(*) cnt
	  from movie
	 group by title_nm
	having count(*) >1; 
	
	select title_nm ,genres_nm, movieid, count(*) cnt
	  from movie m
	 group by title_nm ,genres_nm, movieid
	having count(*) >1; --일정규화 위반 
	
	
	-- B.users

select * from information_schema.columns c  where c.table_name = 'users';
--users table column list - userid, age ,occupation, gender, zip_code
	--> pk : userid
	
	select userid , count(*) cnt
	  from users
	 group by userid
	having count(*) >1;  --빈값 

	select age , count(*) cnt
	  from users
	 group by age
	having count(*) >1; 

	select zip_code , count(*) cnt
	  from users
	 group by zip_code
	having count(*) >1; 

select * from information_schema.columns c  where c.table_name = 'rating';
--users table column list - userid, movieid ,rating_pnt, timestamp
	--> pk : movieid , userid
	
	select userid , count(*) cnt
	  from rating
	 group by userid
	having count(*) >1;  -- 

	select movieid , count(*) cnt
	  from rating
	 group by movieid
	having count(*) >1; 

	select rating_pnt , count(*) cnt
	  from rating
	 group by rating_pnt
	having count(*) >1; 

	select movieid , userid, count(*) cnt
	  from rating
	 group by movieid,userid
	having count(*) >1;  -- 빈값
	
	--02. 참조키 찾기 
		-- A.users  <--> rating  = 1: n, 선택관계 
		
	/* Step 1 */
	select *
		from users  T1
			inner join rating T2
		  on T1.userid = T2.userid
		limit 1 ;
	
	/* Step 2 */
	select count(distinct T1.userid) D_X1,
				count(distinct T2.userid) D_X2
			,	count(T2.userid) X2 -- 1:N
	from  users T1 
		left outer join rating T2
		on T1.userid = T2.userid ;
			
		-- A.movie  <--> rating  = 1: n, 선택관계
		
		/* Step 1 */
	select *
		from movie  T1
			inner join rating T2
		  on T1.movieid = T2.movieid
		limit 1 ;
	
	/* Step 2 */
	select count(distinct T1.movieid) D_X1,
				count(distinct T2.movieid) D_X2
			,	count(T2.movieid) X2 -- 1:N
	from  movie T1 
		left outer join rating T2
		on  T1.movieid = T2.movieid ;
	
	
	-- 03. 컬럼 값 범위 점검 
	
		select  * from movie ;
		
		--split_part
	select col1 
		, 	split_part(col1, ',', 1) part1 
		, 	split_part(col1, ',', 2) part2
		, 	split_part(col1, ',', 3) part3
		
	from ( select '1,2,3' col1 ) c;
		
		--right
	
		select right('123456789', 3) right_result ;
		select right('123456789', 1) right_result ;
		
	  create table  movie2 as 
		select m.movieid, 
				case when m.title_nm like '%(1%' then split_part(m.title_nm, '(1', 1)
					when m.title_nm like '%(2%' then split_part(m.title_nm, '(2', 1) end title_nm 
		,	replace(replace(right(m.title_nm, 6) , ')',''),'(','') realse_year
		,	m.genres_nm 
			from movie m
		;
		--where m.title_nm like '%(2%'; 
		
	select * from movie;
		

	alter table movie rename to movie_old;
	alter table movie2 rename to movie;
	

	-- 03. 컬럼 값 범위 점검 
