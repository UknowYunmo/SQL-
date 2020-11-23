SQL�� ������ �ٸ� SQL�� �����ؼ� Ʃ���ϴ� ���


���� : �μ��� ���� ��, �� ������ ����ϱ�

select /*+ gather_plan_statistics */ deptno, sum(sal)
 from emp
 group by deptno
union all
select null as deptno, sum(sal)
 from emp
 order by deptno asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

������ �� : 12��


* rollup�� Ȱ���� Ʃ��

select /*+ gather_plan_statistics */ deptno, sum(sal)
 from emp
 group by rollup(deptno);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

������ �� : 6��



���� : �μ���, ������ ������ �� ���� ���� ����ϱ�

select /*+ gather_plan_statistics */ deptno, null as job, sum(sal)
 from emp
 group by deptno
 union all
 select null as deptno,job,sum(sal)
  from emp
  group by job
order by deptno asc,job asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


������ �� : 12��



* grouping sets �� �̿��� Ʃ��

select /*+ gather_plan_statistics */ deptno, job, sum(sal)
 from emp
 group by grouping sets ( (deptno), (job) );

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


������ �� : 8��



���� : ��� ��ȣ, ��� �̸�, ����, ���� ����ġ�� ����ϱ�

select /*+ gather_plan_statistics */ empno, ename, sal, ( select sum(sal)
from emp s
where s.empno<=m.empno ) ����ġ
 from emp m
 order by empno asc;


������ �� : 90��



* over �Լ��� ���� Ʃ��

select /*+ gather_plan_statistics */ empno, ename, sal, sum(sal) over( order by empno asc) ����ġ
from emp m
order by empno asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


������ �� : 6��




���� : ���� ������ �μ� ���� ���Խ�Ű��

select /*+ gather_plan_statistics */ deptno, empno, ename, sal,
( select sum(sal)
   from emp s
   where s.empno<=m.empno and s.deptno = m.deptno ) ����ġ
 from emp m
 order by deptno asc, empno asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));




* partition by Ȱ���� Ʃ��

select /*+ gather_plan_statistics */ empno, ename, sal, sum(sal) over( partition by deptno order by empno asc) ����ġ
from emp m
order by empno asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



���� : ��� �̸��� EN, IN�� ����ִ� ����� �̸�, ����, ���� ����ϱ�

create index emp_ename on emp(ename)

select /*+ gather_plan_statistics */ ename, sal, job
 from emp
 where ename like '%EN%' or ename like '%IN%';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


ename�� �ƹ��� �ε����� �ִٰ� �ϴ��� like ������ ����� �� ���ϵ� ī�尡 �տ� ������,

�ε����� ������ ���� ���ϰ� full table scan �ع�����.



* �ذ� ���

1. ���� �̸��� EN �Ǵ� IN�� ���ԵǾ��� �ִ� ����� ROWID�� 

   emp_ename �ε����� ���ؼ� �˾Ƴ���.

2. �˾Ƴ� rowid�� ���� ���̺��� �ش� �����͸� �˻��ϴµ� nested loop �������� �˻��Ѵ�. 

select /*+ gather_plan_statistics leading(v e) use_nl(e) */ e.ename, e.sal, e.job
 from emp e,
(select /*+ gather_plan_statistics index_ffs(emp emp_ename)*/ rowid as rn
 from emp
 where ename like '%EN%' or ename like '%IN%' ) v
where e.rowid=v.rn;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� ��ȹ�� ���� full table emp �� Ǯ���鼭, from ���� ���� ������ in line view�� ��ü�ع��ȴ�.

- �並 ��ü���� ���ϵ��� no_merge ��Ʈ�� �������.

select /*+ gather_plan_statistics leading(v e) use_nl(e) no_merge(v) */ e.ename, e.sal, e.job
 from emp e,
 (select /*+ gather_plan_statistics index_ffs(emp emp_ename)*/ rowid as rn
  from emp
  where ename like '%EN%' or ename like '%IN%' ) v
where e.rowid=v.rn;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));