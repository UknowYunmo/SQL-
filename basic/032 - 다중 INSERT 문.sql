���ݱ����� insert �������� �� ���� �� �Ǹ� �Է��� �� �־���.

���� :

insert into emp ( empno, ename, sal )
 values ( 1234, 'SCOTT', 3000 ) ;


�׷��� ���� insert ���� �̿��ϸ� ���� ���� ���̺� ���ÿ� ���� �����͸� ���� �� �Է��� �� �ִ�.



* ���� insert ���� ���� 4����

1. ������ all insert ��

2. ���Ǻ� all insert ��

3. ���Ǻ� first insert ��

4. pivoting insert ��




1. ������ all insert ��


* ���� ���� ���̺� ���� ���� �� ���� �����͸� �Է��ϴ� ��


���� : target_a, target_b, target_c ���̺��� ����� emp ���̺��� ������ �����ϰ� �����


create table target_a
 as
  select *
   from emp
    where 1=2;

create table target_b
 as
  select *
   from emp
    where 1=2;

create table target_c
 as
  select *
   from emp
    where 1=2;

* where ���� 1=2�� �ǹ�

1=2 �� �����̹Ƿ� emp ���̺��� ����������

���̺� ���� ������ ���� �������� ���Ѵ�.

��, ���̺� ������ �����ͼ� ���̺��� ����� ��

����� where ���� ������ �� ��ٸ�, �翬������ ���̺� ��ü�� �״�� �Ű����� ���̴�.


���� ������ ���������, emp ���̺��� �����͸� �� ���� ���� �־��.

insert all into target_a
into target_b
into target_c
 select *
  from emp;

emp ���� 14���̰�, 3 ���̺� �־����Ƿ� 42���� ���ԵǾ��ٰ� ���.

select count(*) from target_a;
select count(*) from target_b;
select count(*) from target_c;

�� Ȯ���ϱ�

2. ���Ǻ� all insert ��

���ǿ� �´� �����͸� �Էµǰ� ������ �ִ� �Է¹�

���� : target_a ���̺��� comm�� �޴� ����鸸 �Է��ϰ�, target_b���� comm�� ���� �ʴ� ����鸸 �Է��ϱ�

insert all
 when ���� then into ���̺��
 when ~

���ָ� �ȴ�.

insert all
	when comm is not null then into target_a ( empno, ename, sal, comm )
	when comm is null then into target_b ( empno, ename, sal, comm )
 select empno, ename, sal, comm
  from emp;


3. ���Ǻ� first insert ��

���ǿ� �´� �����Ͱ� ù ��° ���̺� �Էµǰ�

������ �����͸� ������ ���ο� ���ǿ� ���缭

�� ��° �Ǵ� �� ��°�� �Է��ϴ� insert ��


���� : �μ� ��ȣ�� 20���� ������� target_a�� �Է��ϰ�, ���� ������ �μ� ��ȣ ����� ��

������ 1200 �̻��� target_b�� �Է��ϰ� 1200 ���ϴ� target_c�� �����ϱ�

insert first
	when deptno=20 then into target_a
	when sal>=1200 then into target_b
	when sal<1200 then into target_c
 select *
  from emp;

ó�� FIRST �ٷ� ���� ������ ������ �������� ���Ǻ� all insert ��ó�� ���ǿ� �¾ƾ� ���̺� ����.