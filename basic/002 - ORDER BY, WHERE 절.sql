�����͸� �����ؼ� ����ϱ� (ORDER  BY)

* order by ���� �����͸� �����ϴ� ���̰� select ���忡 �� �������� ����Ѵ�.
* ������ �÷��� ���Ĺ�� :
asc : ���������� ������ ������
desc : ���������� ������ ������

���� : ������ ���� ������ �̸��� ������ ����ϱ�
select ename, sal
  from  emp
  order by sal desc;

select ename, sal
  from  emp
  order by sal asc;

select ename, sal
  from  emp
  order by sal;

���̴� ��ó�� ��������(asc) �Ǵ� ��������(desc)�� ������� ������ ����Ʈ ���� asc��.


����
 select ename, job, hiredate
  from  emp
  order  by 2 asc, 3 asc; 

���� ���� order by�� 2�� �̻� ���ִ� �͵� �����ϸ�, select ���� �÷����� �����ϰ� ������� 1,2,3���� ��ü�ؼ� �ۼ��� �� �ִ�.


where �� (���� ������ �˻�)

* where ���� ����ϸ� Ư�� ���ǿ� ���� �����͸� �����ؼ� ����� �� �ִ�

* �⺻ �� ������

 >, <, >=, <=, =,  !=, <>, ^=
�� �߿� [!=,<>,^=]-->�̰͵� ���� �� ���� �ʴٴ� ��.


���� : ������ 3000 �̻��� ������� �̸��� ������ ����ϱ�

select ename, sal
   from emp
   where sal>=3000;

���� : ������ SALESMAN�� �ƴ� ������� �̸��� ������ ����ϱ�

select ename, job
   from emp
   where job!='SALESMAN';

select  ename, hiredate, deptno
   from  emp
   where deptno = 20
   order by 2 desc;

�μ� ��ȣ�� 20�� ������� �̸�, �����, �μ� ��ȣ�� ����ϰ� �ֱٿ� ���� �������� ����


8. where �� - 2 (���ڿ� ��¥ �˻�)

* ���ڰ� �ƴ� ���ڸ� �˻��� ���� ���� ���ʿ� �̱� �����̼� ��ũ('')�� �ѷ���� �Ѵ�.

select  ename, sal
 from emp
 where ename='SCOTT'; 

���� ���ڿ��� �빮�ڸ� �����ϱ� ������ �ҹ����� scott���� �˻��ϸ� �ٸ� ������ �νĵǾ� �˻� ����� ��µ��� �ʴ´�.