���̺��� ��� ��(COLUMN) ����ϱ�

select  *
 from  emp; 
 - emp ���̺��� ��� ��(�÷�)�� ��ȸ�ض�!

select *
 from  dept; 
 - dept ���̺��� ��� ��(�÷�)�� ��ȸ�ض�!
 - * �� ��� �÷��� ��ǥ�Ѵ�.


���̺��� Ư�� ��(COLUMN) �����ϱ�

select  ename, sal -->�÷� 
   from   emp ;  -->���̺�
 -emp ���̺��� ename(��� �̸�), sal(��� ����)�� ��ȸ�ض�!

select  ename, job, hiredate, deptno
   from  emp;
 -emp ���̺��� ename(��� �̸�), job(����), hiredate(�Ի���), deptno(�μ� ��ȣ)�� ��ȸ�ض�!


�÷� ��Ī�� ����Ͽ� ��µǴ� �÷��� �����ϱ�

* �÷��� ��ſ� �ٸ� �÷����� ������ �� ����ϴ� ����

[select �÷� as '�ϰ� ���� �÷���' from ���̺�;]

select ename as �̸�, sal as ����
 from emp;
- ename�� �̸�, sal�� ��ȸ�ϴµ� �̸��� �����̶�� �ѱ۷� ����ض�! 

select ename as "Employee name", sal as "Salary"
  from emp;
- ename�� sal�� Employee name, Salary�� ����ض�!

�� �÷� ��Ī�� ��ҹ��ڸ� �����ϰ� �ʹٰų� ���� ���ڳ� Ư�����ڸ� �������� ���ʿ�
   ���� �����̼� ��ũ�� �ѷ���� �Ѵ�.


���� ������ ����ϱ� (||)

* �� �÷��� �����͸� �����ؼ� ����ϴ� ������

[select �÷� || '�ƹ� ��' || �÷��� from ���̺�;]


select  ename || ' �� ������ '  ||  job  || ' �Դϴ�. '
 from   emp;


�ߺ��� �����͸� �����ؼ� ����ϱ�(DISTINCT)

* �÷��� �տ� �ۼ��ϰ� �����ϸ� �ߺ��� �����͸� �����ϰ� ����Ѵ�.

select job from emp;
select distinct job from emp;