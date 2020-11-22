* index full scan


- �ε��� ��ü�� full�� �о ���ϴ� �����͸� ������ �ϴ� ���


���� :

select /*+ gather_plan_statistics */ count(*)
  from emp;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



�̷��� �غ���, index full scan�� Ȯ���� �� �ִ�.


���� emp ���̺��� count(*)�� �ص� 14�� �����µ�

�����غ��� �� 14�� count �Ǵ� �������� emp�� �ִ� ��� �÷��� �� ���� ��� �Ⱦ �ڷᰡ ������ 1�� ���Ѵ�.

��, ���̺� ��ü�� ���η� ������ ���� ������, ���η� �� ��� �ݺ��ؼ� �ȴ� ���̴�.

�ݸ� index full scan�� �ε����� �ɸ� �÷� ������ ���η� �� �ȴ� �Ͱ� ����.

��, ����� ������, �� ���� �÷� ������ ��ȸ�ϱ� ������ �ӵ� �鿡�� ���̰� ũ��.

�׸��� ������ ������ 1���̴�.

���� full table scan�� �ǵ��� �ٲٰ� �ʹٸ�,

select /*+ gather_plan_statistics full(emp) */ count(*)
  from emp;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� ���� ��Ʈ�� full ( ���̺�� ) �� ����ϸ� full table scan�� �Ѵ�.


�Ȱ��� ����� ������ ������ 6 --> 1 �� �ٲ�� ������ �Ʊ� �� 6�� ���� ������ ���������ٴ� ���� �� �� �ִ�.


** index fast full scan

�ε����� ó������ ������ ��ĵ�ϴ� ����� index full scan �� �Ȱ�����

index fast full scan�� index full scan�� �ٸ� ����

�ε����� full�� ���� �� mult block i/0 �� �Ѵٴ� ���̴�.


* multi block i/o


å�� �տ� ������ 1������ ~ 100��������� �Ѵٸ�,

index full scan�� �� ������ �� �������� �ѱ�� �� index full scan �̰�

index fast full scan�� �� �� �ѱ� �� 10�徿 �ѱ�� ���̴�.


���� : ����, ������ �ο����� ����ϱ�

create index emp_job on emp(job);

select /*+ gather_plan_statistics emp_job */ job, count(job)
  from emp
  group by job;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


** ���� ���� index ��Ʈ�� �൵ ���̺� full scan�� �ϴ� ������ job �÷��� not null ������ ���� �����̴�.

index fast full scan�� �Ϸ��� not null ������ �־�� �Ѵ�.


* job�� not null ���� �����ϱ�

alter table emp
 modify job constraint emp_job_nn not null;


- not null ���� �ɰ�, ����� �غ���

select /*+ gather_plan_statistics index_ffs(emp emp_job) */ job, count(job)
  from emp
  group by job;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


INDEX FAST FULL SCAN, ���۵� 4�� �پ�����.


���� : �μ���ȣ, �μ� ��ȣ�� �ο����� ����ϴµ� index fast full scan �� �� �� �ֵ��� �ε����� �ɰ�

not null ���൵ �ɰ� ��Ʈ�� �༭ ����ǵ��� �ϱ�

create index emp_deptno on emp(deptno);

alter table emp
 modify deptno constraint emp_deptno_nn not null;

 
select /*+ gather_plan_statistics index_ffs(emp emp_deptno) */ deptno, count(deptno)
  from emp
  group by deptno;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


* INDEX FAST FULL SCAN�� INDEX FULL SCAN ���� ��������, ��� ��µ� �� ������ ���� �ʴ´�.