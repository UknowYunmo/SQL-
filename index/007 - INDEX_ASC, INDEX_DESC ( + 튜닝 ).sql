index_asc 와 index_desc 를 활용해서

order by 절보다 성능이 좋은 쿼리를 짤 수 있다.

대용량 데이터베이스일수록 차이가 크다.

예제 : 사원들의 이름과 월급을 출력하는데 월급 순으로!

튜닝 전:

create index emp_sal on emp(sal);

select /*+ gather_plan_statistics (emp emp_sal) */
 ename, sal
 from emp
 order by sal desc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

튜닝 후:

create index emp_sal on emp(sal);

select /*+ gather_plan_statistics index_desc(emp emp_sal) */
 ename, sal
 from emp
 where sal >= 0;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

** sal에 있는 index를 사용하려면

where 절 조건에 무조건 sal이 있어야한다.

예제 : 사원 최대 월급을 출력하기

튜닝 전 :

select /*+ gather_plan_statistics index(emp emp_sal) */
 max(sal)
 from emp;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

버퍼는 1이지만 sort가 일어나는 것은 정렬이 일어났다는 것인데,

정렬을 한다는 것은 데이터 용량이 클 때는 시간이 꽤 걸리는 작업이므로 없는 것이 좋다.

튜닝 후 :

select /*+ gather_plan_statistics index_desc(emp emp_sal) */
 sal
 from emp
 where sal >= 0 and rownum =1;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

예제 : 최대 월급을 가진 사원의 이름과 월급을 출력하기

튜닝 전:

select /*+ gather_plan_statistics index(emp emp_sal) */
 ename, sal
 from emp
 where sal = ( select max(sal)
from emp );

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

튜닝 후 :

select /*+ gather_plan_statistics index_desc(emp emp_sal) */
 ename, sal
 from emp
 where sal >= 0 and rownum=1;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

예제 : 부서번호가 20인 사원들의 사원 번호, 부서 번호, 월급을 출력하는데 월급 순으로!

create index emp_deptno_sal on emp(deptno,sal);

튜닝 전 : 

select /*+ gather_plan_statistics index(emp emp_deptno_sal) */
 ename, deptno, sal
 from emp
 where deptno=20
 order by sal desc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

** 버퍼는 2지만, sort order by가 있다.

sort는 데이터를 쫙 정렬하기 때문에 성능을 위해서 되도록 없는 것이 좋다.

튜닝 후 :

select /*+ gather_plan_statistics index_desc(emp emp_deptno_sal) */
 ename, deptno, sal
 from emp
 where deptno=20;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


예제 : 1981년에 입사한 사원의 이름과 입사일을 최근 입사한 사원 순으로 출력하기

create index emp_hiredate on emp(hiredate);

튜닝 전 :

select /*+ gather_plan_statistics index(emp emp_hiredate) */
 ename, hiredate
 from emp
 where to_char(hiredate,'RRRR')='1981'
 order by hiredate desc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

일단 기본적인 규칙인 where 절의 좌변을 건드리지 말아야하는 걸 지키지 않아서

인덱스가 발동되지도 않아서 테이블을 풀로 access 했고,

order by 까지 해버려서

사실상 아무런 의미가 없는 튜닝이었다.


튜닝 후 :

select /*+ gather_plan_statistics index_desc(emp emp_hiredate) */
 ename, hiredate
 from emp
 where hiredate between to_date('1981/01/01','RRRR/MM/DD')
   and   to_date('1981/12/31','RRRR/MM/DD');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));