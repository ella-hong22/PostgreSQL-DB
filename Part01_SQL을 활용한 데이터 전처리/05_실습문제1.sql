#�ǽ�����1
payment ���̺��� ���� �ŷ��� amount�� �׼��� ���� ���� ������ customer_id�� �����϶�,
��, customer_id�� ���� �����ؾ� �Ѵ�. 

SELECT 			
		DISTINCT A.CUSTOMER_ID
	FROM PAYMENT A
WHERE A.AMOUNT IN 
				(
					SELECT K.AMOUNT
					FROM PAYMENT K
					ORDER BY K.AMOUNT DESC
					LIMIT 1 --LIMIT�� �Ѱ��� ����� ������ �Ѵ�. 
				)
;

#�ǽ����� 2 
���鿡�� ��ü �̸����� ���� �ϰ��� �Ѵ�. customer ���̺��� ���� email �ּҸ� �����ϰ�, �̸��� ���Ŀ� ���� �ʴ� 
�̸��� �ּҴ� ���ܽ��Ѷ�.

SELECT EMAIL 
	FROM CUSTOMER 
	WHERE EMAIL NOT LIKE '@%'  
	AND EMAIL NOT LIKE '%@'
	AND EMAIL LIKE '%@%';