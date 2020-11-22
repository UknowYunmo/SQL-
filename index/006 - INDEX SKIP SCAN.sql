index skip scan

1. ���� �÷� �ε���

�÷��� �ϳ��� �ؼ� ���� �ε���

create index emp_deptno
 on emp(deptno);

2. ���� �÷� �ε���

�÷��� �������� �ؼ� ���� �ε���

create index emp_deptno_sal
 on emp(deptno,sal);


* emp_deptno_sal �� ���� ���캸��


select deptno, sal, rowid
 from emp
 where deptno >= 0;   --> ��� ��� ���

- ���캸��, deptno�� ���� asc�� �����ϰ�, �װ��� �������� sal�� asc�� �ε����� �����ϰ� �ִ�.


*���� �ε����� �ʿ��� ����


�ε������� �����͸� �о���鼭 ���̺� �������� ���� �� �ֱ� ����
 (����)                                    (å)

���� �˻��ϰ��� �ϴ� �����Ͱ� ������ �־ å �� ������ ���������� �а� �����ٸ�

������ �����͸� �˻��� ��.

å���ٴ� ������ �ξ� �β��� �����Ƿ� �������� ���ϴ� �����͸� ã�� ��

å���� ã�� �ͺ��� �ξ� �ӵ��� ������.



���� : deptno�� 10�� ����� deptno�� ���� ����ϱ�

select /*+ gather_plan_statistics index(emp emp_deptno) */
  deptno
 from emp
 where deptno = 10;
  
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


Ȯ���غ���, �ε��� range scan�� �� ��, ���̺� access �� ���� Ȯ���� �� �ִ�.


�������� -> å �������� �̵��ߴ�.


�׷��ٸ� �Ʊ� ���� emp_deptno_sal �̶�� ���� �ε����� ����غ���


���� : ���� ����� ���� �ε����� Ȱ���ؼ� ����ϱ�

select /*+ gather_plan_statistics index(emp emp_deptno_sal) */
  deptno,sal
 from emp
 where deptno = 10;
  
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


Ȯ���غ���, ������ ���� ���̺� access�� ����� �Ͱ�, ������ ���� �پ�� ���� �� �� �ִ�.


��, ���� �ȿ��� �ٷ� �������ȴٴ� ��.

������ �ʹ� ���� �����Ͷ� �ð� ���̰� ������,

������ ��뷮 �����Ͷ��, �翬�� ���� �ð����� ���̰� �� �� �ۿ� ����.


���� : ��� ��ȣ, �̸�, ����, �μ� ��ȣ�� ���� �ε����� ����� ��ȸ�غ���

 create index emp_empno
 on emp(empno,ename,sal,deptno);
 
select /*+ gather_plan_statistics index(emp emp_empno) */
  empno,ename,sal,deptno
 from emp
 where empno=7788;
  
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� ���� �÷��� ���� ���Ƶ� ���� �ε����� ���ԵǾ� �ִٸ� ���̺��� access ���� �ʾƵ�

�� ���� ����� ��ȸ�� �� �ִ�.


* index skip scan ����ϱ�


index skip scan �� ����ϸ� �ε��� ��ü�� ���� ���� index full scan�� ������

���� ���ǿ� �´� �ε��� ���� ã���� �� ��ȯ�� �� ������ ���� �� ã�ƺ���.


create index emp_deptno_sal
 on emp(deptno,sal);

select /*+ gather_plan_statistics index_ss(emp emp_deptno_sal) */
  ename,deptno, sal
 from emp
 where sal=2975;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

�̷��� �ϸ� index skip scan �̶�� Ȯ���� �� �ִ�.

���� �ڵ带 ���÷� index skip scan�� ���� �ڼ��ϰ� �����غ���,

���� �ε����� deptno�� �������� sal�� ���ĵǾ� �ִ� �����̰� (������ �׷��� �����ϱ�)

�ε������� deptno�� �� ���ٰ� where ���� sal�� 2975��� �� �˾��� ��, deptno�� 20�ε�,

������ deptno�� 20�� ������� �׸� ã�ƺ���,

���� deptno�� 30���� �Ѿ��, �� sal�� 2975�� ����� �ִ��� ã�´�.

�� deptno�� 20�� �����͸� �ణ ��ŵ�� ���̴�.

������ ���� �����Ͷ� ü���� ���� ������, ��뷮 �����Ͷ�� ū ���̰� �ȴ�.

�̰� ������ ������ deptno�� ���� sal�� asc�� ���ĵǾ��ֱ� ����! (���� �ε��� ������ ������)