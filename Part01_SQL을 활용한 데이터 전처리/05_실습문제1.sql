#실습문제1
payment 테이블에서 단일 거래의 amount의 액수가 가장 많은 고객들의 customer_id를 추출하라,
단, customer_id의 값은 유일해야 한다. 

SELECT 			
		DISTINCT A.CUSTOMER_ID
	FROM PAYMENT A
WHERE A.AMOUNT IN 
				(
					SELECT K.AMOUNT
					FROM PAYMENT K
					ORDER BY K.AMOUNT DESC
					LIMIT 1 --LIMIT절 한개의 결과만 나오게 한다. 
				)
;

#실습문제 2 
고객들에게 단체 이메일을 전송 하고자 한다. customer ㅔ이블에서 고객의 email 주소를 추출하고, 이메일 형식에 맞지 않는 
이메일 주소는 제외시켜라.

SELECT EMAIL 
	FROM CUSTOMER 
	WHERE EMAIL NOT LIKE '@%'  
	AND EMAIL NOT LIKE '%@'
	AND EMAIL LIKE '%@%';