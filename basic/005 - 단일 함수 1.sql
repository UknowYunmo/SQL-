���� �Լ� 

  1.  round :  �ݿø��ϴ� �Լ�

  2.  trunc  :  �߶󳻼� ������ �Լ� 

  3.  mod   :  ���� ������ ���� ����ϴ� �Լ�


�ݿø��ؼ� ����ϱ�(ROUND)            

����: 

select round( 786.567,  -1 ), round( 786.567 ), round( 786.567, 1 )

 from dual; ** dual �� �̷��� �ӽ÷� ���� Ȯ���ϰ� ���� �� ����ϱ� ���� �ӽ� ���̺��̴�.

round( ����, n ) --> n��° �ڸ����� �ݿø��Ͽ� ��ȯ

     7  8   6   .   5  6  7  

    -3 -2  -1  0  1  2  3


���ڸ� ������ ����ϱ�(TRUNC)

���� : 

select trunc( 786.567,  -1 ), trunc( 786.567 ), trunc( 786.567, 1 )
 from dual;

���� ������ �� ����ϱ�(MOD)

mod( ����(a), ���� ��(b) ) --> a�� b�� ���� �� ������ c�� ��ȯ

select mod(24,2), mod(25,2)
 from dual;

mod �Լ� Ȱ�� : �ַ� ¦��, ������ Ȯ���� �� Ȱ���� �� �ִ�.


���� : ���̰� ¦���� �л����� ������ ���̸� ����ϱ�

select gender, age
   from emp12
   where mod(age,2) = 0;

��¥ �Լ� 

  1.  sysdate :  ���� ��¥

  2.  months_between  :  ��¥ ������ ���� �� 

  3.  next_day  :  ���� �� Ư�� ������ ��¥

  4.  last_day  : �ش� ���� ������ ��


���� ��¥�� Ȯ���ϱ� (sysdate)

sysdate�� �׻� �� �� ��¥�� ��ȯ�ϱ� ������ ��ȣ�� �ʿ���� ���ϴ�.

select  sysdate 
  from  dual;

���� : emp ����� �Ի����� ������ �������� ����ϱ�

select ename, round( sysdate - hiredate) 
 from  emp
 where hiredate is not null;

��¥�� ��¥ ������ ���� ���� ��ȯ(months_between)

months_between( �ֽų�¥, ������¥) 

���� : ����� ���ݱ��� �� �� �ٹ��ߴ��� ����ϱ�

select ename || ' �� ' || round(months_between(sysdate, hiredate)) || ' ���� �ٹ��߽��ϴ�.'
 from emp;

n���� �� ���� ��¥ ����ϱ�(ADD_MONTHS)

select  add_months( sysdate, 6 ) 
  from  dual;

Ư�� ��¥ �ڿ� ���� ���� ��¥ ����ϱ� (NEXT_DAY)

���� : ���� ���� ���� �� �������� ��¥�� ����ϱ�

select  next_day( sysdate, '������')
 from dual;

Ư�� ��¥�� �ִ� ���� ������ ��¥ ����ϱ� (LAST_DAY)

���� : ���� ��¥�� �̹� ���� ������ ��¥�� ����ϱ�

select   sysdate,  last_day(sysdate)
   from  dual;