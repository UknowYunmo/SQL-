���������� ������ ���� ��ȯ�ϱ� ( TO_CHAR )

������ -->> ���������� ��ȯ,

��¥�� -->> ���������� ��ȯ�� �� ����ϴ� �Լ�

���� : ������ ���� �������� ���

select sysdate
   from dual;

select to_char(sysdate, 'day')
   from dual;                

* ��¥����

�⵵ : RRRR, YYYY, RR, YY
�� : MM, MON
�� : DD
�ð� : HH, HH24
�� : MI
�� : SS
���� : day, dy, d

���� : 11���� �Ի��� ����� ����ϱ�

select ename, hiredate
   from emp
   where to_char(hiredate,'MM')='11';

���ڿ��� ��¥�� �� ��ȯ�ϴ� �Լ� (to_date)

���� :

select to_date ('18700710', 'YYYYMMDDHH24MISS')
  from dual;

select ename, hiredate
   from emp
   where hiredate=to_date('81/11/17','RR/MM/DD');

--> ��¥�� �����͸� �˻��� ���� �ݵ�� to_date �Լ��� ����� ���� �ʼ�!

(Ȯ���� ������ �˻��� ����)


���ڷ� ����ȯ�ϴ� �Լ� (to_number)

select ename, sal
 from emp
 where sal='3000';

������ ������ ������ sal�� ���ڿ� '3000'���� �˻��ص� �˻��� �ɱ�?

ģ���� ����Ŭ�� �ڵ����� int�� �ٲ��༭ �˻��� ���ش�.

�׷��� �̷��� �� ������ ���� ū ��쿡�� ������ ���� �� �� �ִ�.

SQL ������ ��������, '�ڵ�'�̱� ������ ���� �������� ������ ã�� ����.

���������� ���� ������ ���°� ���ٰ� �Ѵ�. (��ġ�� �Ǵϱ�)

�׷��� ���ڿ��� ���� �Ǵ� ��� �� to_number�� Ȱ������

select ename, sal
 from emp
 where sal=to_number('3000');