SQL을 완전히 다른 SQL로 변경해서 튜닝하는 방법


예제 : 부서별 월급 합, 총 월급을 출력하기

select /*+ gather_plan_statistics */ deptno, sum(sal)
 from emp
 group by deptno
union all
select null as deptno, sum(sal)
 from emp
 order by deptno asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

버퍼의 수 : 12개


* rollup을 활용한 튜닝

select /*+ gather_plan_statistics */ deptno, sum(sal)
 from emp
 group by rollup(deptno);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

버퍼의 수 : 6개



예제 : 부서별, 직업별 총합을 한 번에 같이 출력하기

select /*+ gather_plan_statistics */ deptno, null as job, sum(sal)
 from emp
 group by deptno
 union all
 select null as deptno,job,sum(sal)
  from emp
  group by job
order by deptno asc,job asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


버퍼의 수 : 12개



* grouping sets 를 이용한 튜닝

select /*+ gather_plan_statistics */ deptno, job, sum(sal)
 from emp
 group by grouping sets ( (deptno), (job) );

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


버퍼의 수 : 8개



예제 : 사원 번호, 사원 이름, 월급, 월급 누적치를 출력하기

select /*+ gather_plan_statistics */ empno, ename, sal, ( select sum(sal)
from emp s
where s.empno<=m.empno ) 누적치
 from emp m
 order by empno asc;


버퍼의 수 : 90개



* over 함수를 통한 튜닝

select /*+ gather_plan_statistics */ empno, ename, sal, sum(sal) over( order by empno asc) 누적치
from emp m
order by empno asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


버퍼의 수 : 6개




예제 : 위의 예제를 부서 별도 포함시키기

select /*+ gather_plan_statistics */ deptno, empno, ename, sal,
( select sum(sal)
   from emp s
   where s.empno<=m.empno and s.deptno = m.deptno ) 누적치
 from emp m
 order by deptno asc, empno asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));




* partition by 활용한 튜닝

select /*+ gather_plan_statistics */ empno, ename, sal, sum(sal) over( partition by deptno order by empno asc) 누적치
from emp m
order by empno asc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



예제 : 사원 이름에 EN, IN이 들어있는 사원의 이름, 월급, 직업 출력하기

create index emp_ename on emp(ename)

select /*+ gather_plan_statistics */ ename, sal, job
 from emp
 where ename like '%EN%' or ename like '%IN%';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


ename에 아무리 인덱스가 있다고 하더라도 like 연산자 사용할 때 와일드 카드가 앞에 있으면,

인덱스를 엑세스 하지 못하고 full table scan 해버린다.



* 해결 방법

1. 먼저 이름에 EN 또는 IN이 포함되어져 있는 사원의 ROWID를 

   emp_ename 인덱스를 통해서 알아낸다.

2. 알아낸 rowid를 통해 테이블에서 해당 데이터를 검색하는데 nested loop 조인으로 검색한다. 

select /*+ gather_plan_statistics leading(v e) use_nl(e) */ e.ename, e.sal, e.job
 from emp e,
(select /*+ gather_plan_statistics index_ffs(emp emp_ename)*/ rowid as rn
 from emp
 where ename like '%EN%' or ename like '%IN%' ) v
where e.rowid=v.rn;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


실행 계획을 보면 full table emp 로 풀리면서, from 절의 서브 쿼리인 in line view를 해체해버렸다.

- 뷰를 해체하지 못하도록 no_merge 힌트를 사용하자.

select /*+ gather_plan_statistics leading(v e) use_nl(e) no_merge(v) */ e.ename, e.sal, e.job
 from emp e,
 (select /*+ gather_plan_statistics index_ffs(emp emp_ename)*/ rowid as rn
  from emp
  where ename like '%EN%' or ename like '%IN%' ) v
where e.rowid=v.rn;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));