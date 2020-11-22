1. index merge scan (and equal)

*두 개의 인덱스를 동시에 사용하여 하나의 인덱스만 사용했을 때보다
 더 좋은 성능을 보이는 스캔 방법

예제 : 

create index emp_deptno on emp(deptno);
create index emp_job on emp(job);

select /*+ gather_plan_statistics */
 ename, deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

딱히 힌트를 안 주고, where 절에도 각 인덱스와 맞는 조건을 줘서

deptno와 job에 걸린 인덱스 중 아무거나 고르게 해보자

확인해보면, 옵티마이저가 emp_job 인덱스를 선택했다.

그럼, deptno 인덱스를 타도록 힌트를 줘보자.

select /*+ gather_plan_statistics index(emp emp_deptno) */
 ename, deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


근데, 이렇게 두 개의 단일 인덱스 둘 중 하나를 다 탈 수 있었는데,

왜 옵티마이저는 job을 알아서 사용했을까?

--> 목차를 길게 읽는 것(deptno보다 목차를 짧게 읽는 것이 더 빠르기 때문에

 select count(*) from emp where job='SALESMAN';     --> 4개의 결과
 select count(*) from emp where deptno=30;            ---> 6개의 결과

4개의 목차를 읽고 4개의 값을 반환하는 것과
6개의 목차를 읽고 4개의 값을 반환하는 것은 같은 결과이더라도 속도면에서 차이가 난다.

근데 처음에 아무거나 선택하게 했을 때 더 효율적인 job 인덱스를 선택한 것은

내가 사용하는 sql 프로그램의 옵티마이저가 그 동안 학습한 쿼리들 때문이고,

다른 컴퓨터에서 똑같은 테이블과 같은 sql 문을 주었다면 풀 스캔을 했을 수도 있다.

어쨌든,

위와 같이 둘 중 하나를 골라서 사용하는 것이 아니고,

2개의 인덱스를 모두 사용해서 더 큰 시너지 효과를 내고 싶다면

index merge scan을 사용할 수 있다.

* index merge scan 사용

select /*+ gather_plan_statistics and_equal(emp emp_job emp_deptno) */
 ename, deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

??근데 버퍼의 개수 상태가??

** 위의 merge scan은 옛날 방법이다..

현재는 더 좋은 merge scan이 존재한다.

2. index bitmap merge scan ( index_combine )

두 개의 인덱스를 같이 스캔해서 시너지 효과를 보는 방법은

index merge scan과 동일하지만 차이는 bitmap을 이용해서

인덱스의 사이즈를 아주 많이 줄인다는 점.  --> 스캔 시간이 짧아진다

예 : 책의 내용을 검색하기 위해 두 개의 목차를 먼저 읽고 요약해서

목차를 A4 한 페이지로 만들어 버리면 목차를 더 빠르게 살펴볼 수 있다.

힌트에 index_combine를 적고 테이블 명만 적어주면 된다.

select /*+ gather_plan_statistics index_combine(emp) */
 ename, deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

그러면 알아서...

지 혼자 뭔가 열심히 막 한 걸 볼 수 있다..

그래.. 잘했어

어쨌든 버퍼의 수가 줄고, 시간도 줄어든 것을 확인할 수 있다!

3. index join 스캔 ( index_join )

* 인덱스끼리 조인을 해서 바로 결과를 보고
  테이블 엑세스는 따로 하지 않는 스캔 방식

select /*+ gather_plan_statistics index_join(emp emp_deptno emp_job) */
 deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

결합 인덱스는 만들 수 없고 단일 인덱스만 갖고 있을 때 쓸만한? 잘 쓰진 않는 인덱스 조인이다.