1. �����͸� ���η� ����ϴ� �Լ� ( LISTAGG )

���ݱ����� �����͸� ���η� ���������
��� �ٸ� ������� ���� �����͸� ������� �� ��쿡
���η� ����ϴ� ��찡 �� ���� ���� �� �ִ�.

�׷� �� ����ϴ� �Լ��� LISTAGG

�⺻ ������ LISTAGG( �÷���, �÷� ���̿� ���� ������ ) within group ( order by �÷��� asc or desc ) �̴�.

�ϴ� emp ���̺��� deptno�� ���� ������� Ȯ���غ���

select deptno, ename
 from emp
 order by deptno;

�̷��� �ϸ� Ȯ���� �� �ִµ�, �� ���� ���Ⱑ �����.
������ ���� �� ���ٸ�, Ŀ���� �������ؼ� ���� ���� ���� �� ����.

���� listagg�� �Ẹ��.

select  deptno, listagg(ename, ', ' )  within  group ( order by  ename asc ) �̸�
   from emp
   group  by deptno; 

�̷��� �ϸ� deptno ���� �̸��� �� ���� Ȯ���� �� �ִ�.

2. �������� �ٷ� �� ��� ���� �� ����ϴ� �Լ� ( LAG, LEAD )

LAG - ��õ� ���� �������� ���� �ο��� �� ��ȯ
LEAD - ��õ� ���� �������� ���� �ο��� �� ��ȯ

select  ename, hiredate,  
  lag(hiredate,1) over ( order by hiredate asc)   ����,
  lead(hiredate,1) over ( order  by hiredate  asc ) ������
 from  emp;

