�� ������ : and, or, not

*  True  and  True  ��  True ���� ����� ����� �ȴ�.
   False  and  True  ��  False  ���� ����� ����� �� �ȴ�
   False   or   True   ��  True �̹Ƿ� ����� ����� �ȴ�. 


���� : ������ SALESMAN �̰� ������ 1400 �̻��� ����� ���

select ename, sal,  job
 from emp
 where  job ='SALESMAN' and sal >= 1400;

���� : ������ SALESMAN �̰ų� ������ 1400 �̻��� ��� ���

select ename, sal,  job
 from emp
 where  job ='SALESMAN' or sal >= 1400;

���� : �̸����� �������� naver�� gmail�� �ƴ� �л� ���

select ename, email
    from emp12
    where email not like '%gmail%' and email not like '%naver%';