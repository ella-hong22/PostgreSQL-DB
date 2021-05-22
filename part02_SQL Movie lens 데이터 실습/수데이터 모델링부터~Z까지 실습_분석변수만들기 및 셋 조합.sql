select*from rating;


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
	
select*from movie  ;

	-- 04 분석 변수 만들기 
	select m.movieid , m.title_nm , m.realse_year
	         , case when m.genres_nm like '%Action%'      then 1 else 0 end action_yn
	         , case when m.genres_nm like '%Adventure%'   then 1 else 0 end Adventure_yn
	         , case when m.genres_nm like '%Animation%'   then 1 else 0 end Animation_yn
	         , case when m.genres_nm like '%Children%'    then 1 else 0 end Children_yn
	         , case when m.genres_nm like '%Comedy%'      then 1 else 0 end Comedy_yn
	         , case when m.genres_nm like '%Crime%'       then 1 else 0 end Crime_yn
	         , case when m.genres_nm like '%Documentary%' then 1 else 0 end Documentary_yn
	         , case when m.genres_nm like '%Drama%'       then 1 else 0 end Drama_yn
	         , case when m.genres_nm like '%Fantasy%'     then 1 else 0 end Fantasy_yn
	         , case when m.genres_nm like '%Film-Noir%'   then 1 else 0 end Film_Noir_yn
	         , case when m.genres_nm like '%Horror%'      then 1 else 0 end Horror_yn
	         , case when m.genres_nm like '%Musical%'     then 1 else 0 end Musical_yn
	         , case when m.genres_nm like '%Mystery%'     then 1 else 0 end Mystery_yn
	         , case when m.genres_nm like '%Romance%'     then 1 else 0 end Romance_yn
	         , case when m.genres_nm like '%Sci-Fi%'      then 1 else 0 end Sci_Fi_yn       
	         , case when m.genres_nm like '%Thriller%'    then 1 else 0 end Thriller_yn
	         , case when m.genres_nm like '%War%'         then 1 else 0 end War_yn
	         , case when m.genres_nm like '%Western%'     then 1 else 0 end Western_yn
	     from movie m;	

	select *
	from rating r 
	inner join 
	( select m.movieid , m.title_nm , m.realse_year
	         , case when m.genres_nm like '%Action%'      then 1 else 0 end action_yn
	         , case when m.genres_nm like '%Adventure%'   then 1 else 0 end Adventure_yn
	         , case when m.genres_nm like '%Animation%'   then 1 else 0 end Animation_yn
	         , case when m.genres_nm like '%Children%'    then 1 else 0 end Children_yn
	         , case when m.genres_nm like '%Comedy%'      then 1 else 0 end Comedy_yn
	         , case when m.genres_nm like '%Crime%'       then 1 else 0 end Crime_yn
	         , case when m.genres_nm like '%Documentary%' then 1 else 0 end Documentary_yn
	         , case when m.genres_nm like '%Drama%'       then 1 else 0 end Drama_yn
	         , case when m.genres_nm like '%Fantasy%'     then 1 else 0 end Fantasy_yn
	         , case when m.genres_nm like '%Film-Noir%'   then 1 else 0 end Film_Noir_yn
	         , case when m.genres_nm like '%Horror%'      then 1 else 0 end Horror_yn
	         , case when m.genres_nm like '%Musical%'     then 1 else 0 end Musical_yn
	         , case when m.genres_nm like '%Mystery%'     then 1 else 0 end Mystery_yn
	         , case when m.genres_nm like '%Romance%'     then 1 else 0 end Romance_yn
	         , case when m.genres_nm like '%Sci-Fi%'      then 1 else 0 end Sci_Fi_yn       
	         , case when m.genres_nm like '%Thriller%'    then 1 else 0 end Thriller_yn
	         , case when m.genres_nm like '%War%'         then 1 else 0 end War_yn
	         , case when m.genres_nm like '%Western%'     then 1 else 0 end Western_yn
	     from movie m	
	     ) m on r.movieid = m.movieid ;
	    
	    
	    with movie as
	     (
	     select m.movieid , m.title_nm , m.realse_year
	         , case when m.genres_nm like '%Action%'      then 1 else 0 end action_yn
	         , case when m.genres_nm like '%Adventure%'   then 1 else 0 end Adventure_yn
	         , case when m.genres_nm like '%Animation%'   then 1 else 0 end Animation_yn
	         , case when m.genres_nm like '%Children%'    then 1 else 0 end Children_yn
	         , case when m.genres_nm like '%Comedy%'      then 1 else 0 end Comedy_yn
	         , case when m.genres_nm like '%Crime%'       then 1 else 0 end Crime_yn
	         , case when m.genres_nm like '%Documentary%' then 1 else 0 end Documentary_yn
	         , case when m.genres_nm like '%Drama%'       then 1 else 0 end Drama_yn
	         , case when m.genres_nm like '%Fantasy%'     then 1 else 0 end Fantasy_yn
	         , case when m.genres_nm like '%Film-Noir%'   then 1 else 0 end Film_Noir_yn
	         , case when m.genres_nm like '%Horror%'      then 1 else 0 end Horror_yn
	         , case when m.genres_nm like '%Musical%'     then 1 else 0 end Musical_yn
	         , case when m.genres_nm like '%Mystery%'     then 1 else 0 end Mystery_yn
	         , case when m.genres_nm like '%Romance%'     then 1 else 0 end Romance_yn
	         , case when m.genres_nm like '%Sci-Fi%'      then 1 else 0 end Sci_Fi_yn       
	         , case when m.genres_nm like '%Thriller%'    then 1 else 0 end Thriller_yn
	         , case when m.genres_nm like '%War%'         then 1 else 0 end War_yn
	         , case when m.genres_nm like '%Western%'     then 1 else 0 end Western_yn
	     from movie m	
	     )
	     select r.userid,
	     	count(*) movie_cnt, sum(case when action_yn = 1 then r.rating_pnt end) action_rating_pnt ,
	     	count(case when action_yn = 1 then r.movieid end) action_cnt
	     	from rating r inner join movie m  on r.movieid = m.movieid
	     	group by r.userid;
	    
	     
	     
	     select  u.userid 
	         , u.gender
	         , u.age
	         , u.occupation
	         , avg_rating_pnt
	         , action_rating_pnt 	* 1.0 	/  case when action_cnt = 0 	then 1 else action_cnt 		end  action_prefer  	/* a */
	         , Adventure_rating_pnt * 1.0 	/  case when Adventure_cnt = 0 	then 1 else Adventure_cnt 	end  Adventure_prefer 	/* b */       
	         , Animation_rating_pnt * 1.0 	/  case when Animation_cnt = 0 	then 1 else Animation_cnt 	end  Animation_prefer  	/* c */
	         , Children_rating_pnt 	* 1.0 	/  case when Children_cnt = 0 	then 1 else Children_cnt 	end  Children_prefer  	/* d */					
	         , Comedy_rating_pnt 	* 1.0 	/  case when Comedy_cnt = 0 	then 1 else Comedy_cnt 		end  Comedy_prefer  	/* e */
	         , Crime_rating_pnt 	* 1.0 	/  case when Crime_cnt = 0 		then 1 else Crime_cnt 		end  Crime_prefer  		/* f */         
	         , Documentary_rating_pnt * 1.0 /  case when Documentary_cnt = 0 then 1 else Documentary_cnt end Documentary_prefer  /* g */						
	         , Drama_rating_pnt 	* 1.0 	/  case when Drama_cnt = 0 		then 1 else Drama_cnt 		end  Drama_prefer  /* h */					
	         , Fantasy_rating_pnt 	* 1.0 	/  case when Fantasy_cnt = 0 	then 1 else Fantasy_cnt 	end  Fantasy_prefer  /* i */					
	         , Film_Noir_rating_pnt * 1.0 	/  case when Film_Noir_cnt = 0 	then 1 else Film_Noir_cnt 	end  Film_Noir_prefer  /* j */					
			 , Horror_rating_pnt 	* 1.0 	/  case when Horror_cnt = 0 	then 1 else Horror_cnt 		end  Horror_prefer  /* k  */
			 , Musical_rating_pnt 	* 1.0 	/  case when Musical_cnt = 0 	then 1 else Musical_cnt 	end  Musical_prefer  /* l */
			 , Mystery_rating_pnt 	* 1.0 	/  case when Mystery_cnt = 0 	then 1 else Mystery_cnt 	end  Mystery_prefer  /* m */
			 , Romance_rating_pnt 	* 1.0 	/  case when Romance_cnt = 0 	then 1 else Romance_cnt 	end  Romance_prefer  /* n */
			 , Sci_Fi_rating_pnt 	* 1.0 	/  case when Sci_Fi_cnt = 0 	then 1 else Sci_Fi_cnt 		end  Sci_Fi_prefer   /* o */
			 , Thriller_rating_pnt 	* 1.0 	/  case when Thriller_cnt = 0 	then 1 else Thriller_cnt 	end  Thriller_prefer  /* p */
			 , War_rating_pnt 		* 1.0 	/  case when War_cnt = 0 		then 1 else War_cnt 		end  War_prefer      /* q */
			 , Western_rating_pnt 	* 1.0 	/  case when Western_cnt = 0 	then 1 else Western_cnt 	end  Western_prefer  /* r */
	     from 
	    (
	    select r.userid,
	            count(*) movie_cnt 
	          , avg( r.rating_pnt) avg_rating_pnt   
	          , sum(case when action_yn = 1 	then r.rating_pnt end) action_rating_pnt 	, count(case when action_yn = 1 then r.movieid end ) action_cnt
	          , sum(case when Adventure_yn = 1 	then r.rating_pnt end) Adventure_rating_pnt , count(case when Adventure_yn = 1 then r.movieid end ) Adventure_cnt	          
	          , sum(case when Animation_yn = 1 	then r.rating_pnt end) Animation_rating_pnt , count(case when Animation_yn = 1 then r.movieid end ) Animation_cnt	  
	          , sum(case when Children_yn = 1 	then r.rating_pnt end) Children_rating_pnt 	, count(case when Children_yn = 1 then r.movieid end ) Children_cnt						
	          , sum(case when Comedy_yn = 1   	then r.rating_pnt end) Comedy_rating_pnt 	, count(case when Comedy_yn = 1 then r.movieid end ) Comedy_cnt
	          , sum(case when Crime_yn = 1   	then r.rating_pnt end) Crime_rating_pnt 	, count(case when Crime_yn = 1 then r.movieid end ) Crime_cnt	          
	          , sum(case when Documentary_yn = 1  then r.rating_pnt end) Documentary_rating_pnt , count(case when Documentary_yn = 1 then r.movieid end ) Documentary_cnt	 						
	          , sum(case when Drama_yn = 1   	then r.rating_pnt end) Drama_rating_pnt 	, count(case when Drama_yn = 1 then r.movieid end ) Drama_cnt						
	          , sum(case when Fantasy_yn = 1   	then r.rating_pnt end) Fantasy_rating_pnt 	, count(case when Fantasy_yn = 1 then r.movieid end ) Fantasy_cnt						
	          , sum(case when Film_Noir_yn = 1  then r.rating_pnt end) Film_Noir_rating_pnt , count(case when Film_Noir_yn = 1 then r.movieid end ) Film_Noir_cnt						
			  , sum(case when Horror_yn = 1   	then r.rating_pnt end) Horror_rating_pnt 	, count(case when Horror_yn = 1 then r.movieid end ) Horror_cnt
			  , sum(case when Musical_yn = 1   	then r.rating_pnt end) Musical_rating_pnt 	, count(case when Musical_yn = 1 then r.movieid end ) Musical_cnt
			  , sum(case when Mystery_yn = 1   	then r.rating_pnt end) Mystery_rating_pnt 	, count(case when Mystery_yn = 1 then r.movieid end ) Mystery_cnt
			  , sum(case when Romance_yn = 1   	then r.rating_pnt end) Romance_rating_pnt 	, count(case when Romance_yn = 1 then r.movieid end ) Romance_cnt
			  , sum(case when Sci_Fi_yn = 1   	then r.rating_pnt end) Sci_Fi_rating_pnt 	, count(case when Sci_Fi_yn = 1 then r.movieid end ) Sci_Fi_cnt
			  , sum(case when Thriller_yn = 1   then r.rating_pnt end) Thriller_rating_pnt 	, count(case when Thriller_yn = 1 then r.movieid end ) Thriller_cnt
			  , sum(case when War_yn = 1   		then r.rating_pnt end) War_rating_pnt 		, count(case when War_yn = 1 then r.movieid end ) War_cnt
			  , sum(case when Western_yn = 1   	then r.rating_pnt end) Western_rating_pnt 	, count(case when Western_yn = 1 then r.movieid end ) Western_cnt
		 from rating r inner join movie m on r.movieid = m.movieid
	    group by r.userid 
	   )  r inner join users u on r.userid = u.userid   
	  ;
	
	  
	
