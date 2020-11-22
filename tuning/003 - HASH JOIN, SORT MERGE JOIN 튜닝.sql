* HASH JOIN ( 해쉬 조인 )

nested loop 조인은 한 행씩 모든 행을 조인하기 때문에

작은 데이터에서는 효과적이지만, 데이터의 양이 커지면 성능이 아주 안 좋아진다.

데이터의 양이 클 때는 nested loop 조인보다는 hash join을 사용하는 것이 훨씬 성능이 좋다.

해쉬 조인은 해쉬 알고리즘을 이용해서 데이터를 메모리에 올려놓고, 메모리에서 조인하는 조인 방법이다.

예제 : 해쉬 조인을 사용해서 emp 테이블과 dept 테이블을 조인하여, 사원 이름과 부서 위치를 출력하기

select /*+ gather_plan_statistics leading(d e) use_hash(d e) */ e.ename, d.loc
 from dept d, emp e
 where e.deptno=d.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

dept 테이블과 emp 테이블이 둘 다 메모리로 올라가는데,

메모리에 둘 다 한 번에 올라가서 조인을 하면 너무 좋겠지만

그렇게는 안되고

둘 중 하나만 먼저 메모리로 올리고

다른 테이블은 데이터의 일부를 조금씩 올리면서 조인을 실행한다.

* dept 테이블의 물리적 주소 확인하기

select rowid, deptno, dname, loc
 from dept;

rowid는 어느 파일에 어느 블럭이 있다라는 물리적 주소 정보이다.

dept 테이블이 디스크에 있을 때는 이 주소가 유용했는데 ( 조인할 때 )

dept 테이블이 통채로 메모리로 올라가면

위의 주소가 필요 없어지고 새로운 주소가 필요한데 그 주소가 메모리의 주소이다.

만약 empno 가 7788인 데이터를 deptno와 조인해서 하려고 하는데?

deptno가 10인데.. 그와 맞는 dept 테이블의 10의 주소가 어디있지? 하고 찾을 때

dept 테이블이 메모리에 올려져있으면 찾을 수가 없다

그런데 메모리에 올려지더라도 10이라는 위치를 찾을 수 있도록 하는 것이 해쉬 함수이다.

그렇다면 emp와 dept 테이블 중 어느 테이블을 메모리로 올려야 할까?

--> 작은 테이블인 dept를 올려야 한다

이유 : 메모리의 크기가 작으니까!

그렇다면 메모리를 올리는 방법은?

--> use_hash 다음 올라갈 테이블의 순서를 명시한다


예제 : 사원들의 이름, 직업, 보너스를 출력하는데 emp가 bonus를 hash join 하도록 하기

select /*+ gather_plan_statistics leading(e b) use_hash(e b) */ e.ename, e.sal, b.comm2
 from emp e, bonus b
 where e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

버퍼의 수 : 9개


예제 2 : 사원들의 이름, 직업, 보너스를 출력하는데 emp가 bonus를 hash join 하도록 하는데, 직업이 SALESMAN인 사원만!

select /*+ gather_plan_statistics leading(e b) use_hash(e b) */ e.ename, e.sal, b.comm2
 from emp e, bonus b
 where e.empno=b.empno and e.job='SALESMAN';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

확인해보면 SQL문은 살짝 더 복잡해졌는데도 불구하고, 버퍼의 수가 4개로 크게 줄은 것을 확인할 수 있다.

왜?

emp와 bonus 둘 다 14건이지만

직업이 SALESMAN인 사원들의 데이터는 4건이므로

4건만 메모리로 올리고 bonus와 조인했기 때문


예제 : 직업이 SALESMAN이고 부서 위치가 CHICAGO인 사원들의 이름과 부서위치를 출력하는데, hash join을 사용하기
                        4건                        6건
( emp --> dept )

select /*+ gather_plan_statistics leading(d e) use_hash(d e) */ e.ename, d.loc
 from emp e, dept d
 where e.deptno=d.deptno and e.job='SALESMAN' and d.loc='CHICAGO';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


예제 : emp, dept, bonus 테이블을 hash join해서, 사원의 이름, 부서 위치, 보너스를 출력하기

select /*+ gather_plan_statistics leading(d e b) use_hash(d e b) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


예제 2 : ""

select /*+ gather_plan_statistics leading(d e b) use_hash(e) use_hash(b) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

** dept 와 emp 와 hash join 을 먼저 하고
    그 결과를 bonus와 hash join 하였다.


** swap_join_inputs 힌트 : hash table을 결정하는 힌트
    no swap join inputs 힌트 : probe table을 결정하는 힌트

예제 3 :  ""

select /*+ gather_plan_statistics leading(d e b) use_hash(e) use_hash(b) swap_join_inputs(b) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

2개의 테이블을 조인할 때 hash table을 결정하는 것은 leading 힌트만으로도 가능했는데

3개 이상의 테이블을 조인할 때 hash table을 결정할 때는 leading 으로는 제어가 안되고

swap_join_inputs 를 사용해야 한다.

이게 무슨 말이냐!!

hash join을 할 때 

같은 라인 기준으로

맨 위에 있는 테이블이 메모리에 올라가고 ( 작은 테이블 )

그 밑에 있는 테이블은 조인 당하는 테이블이다.

그래서 세 개 이상에서 hash join을 하게 되면,

hash join 한 테이블이 통째로 메모리에 올라가게 되는 경우가 발생한다

근데 그 테이블이랑 다음 hash join할 테이블이 그것보다 작은 테이블이다?

이러면 메모리 적으로 손해를 보게 된다.

그래서 지정해서 이미 hash join이 일어났더라도 다른 테이블이 먼저 메모리에 올라가도록

지정을 해주는 것이 swap_join_inputs 이다.

그러니

bonus 테이블의 크기가 작다면 이 실행 계획이 좋은 실행 계획이다.

예제 : emp, dept, bouns를 hash join 하는데, bonus, emp를 먼저 hash join하고, dept 테이블을 메모리에 올려서 또 hash join하기

select /*+ gather_plan_statistics leading(b e d) use_hash(b,e,d) swap_join_inputs(d) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

또는

select /*+ gather_plan_statistics leading(b e d) use_hash(e) use_hash(d) swap_join_inputs(d) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

** hash join의 유의할 사항!



예제 : 사원의 이름, 월급, 급여 등급을 hash join을 사용하여 출력하기

select /*+ gather_plan_statistics leading(s e) use_hash(s e) */ e.ename, e.sal, s.grade
 from emp e, salgrade s
 where e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

?? 왜 nested loop가 ??

설명 :

위의 SQL을 실행계획이 hash join이 안된다.

왜냐하면 hash join이 되려면 where 절의 조인 조건이 =(이퀄) 이어야 한다.

non equal join은 hash join이 되지 않는다.

- 그렇다면 위와 같은 SQL의 두 테이블이 둘 다 대용량인데 해쉬 조인을 못 쓰면 어떡하죠?

--> SORT MERGE JOIN을 사용해야 한다.

* sort merge join

조인하려는 데이터의 양이 많으면서 조인 조건이 =이 아닐 때 검색 성능을 높이기 위한 조인 방법

sort merge join을 수행하면 연결 고리가 되는 키 컬럼을 오라클이 알아서 정렬해 놓고 조인을 한다.


예제 : 사원의 이름과 부서 위치와 부서 번호를 sort merge join을 사용하여 출력하기

select /*+ gather_plan_statistics leading(s e) use_merge(e) */ e.ename, d.loc, e.deptno
 from emp e, dept d
 where e.deptno=d.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

결과를 보면 order by 절을 사용하지 않았는데, deptno가 정렬이 되어있다.

그 얘기는 sort merge join이 deptno를 정렬해놓고 조인을 수행했다는 것을 의미한다.

그럼 아까 오류가 났던 SQL 문을 다시 sort merge join으로 해보자.

where d.deptno = e.deptno 절 수행 중..
          10                10
          10                10
          10                10
          20                20
          20                20
          30                30
          ...                  ...

이렇게 정렬을 해서 데이터를 모아놨기 때문에 조인이 빨라진다.

select /*+ gather_plan_statistics leading(s e) use_merge(e) */ e.ename, e.sal, s.grade
 from emp e, salgrade s
 where e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

확인해보면, 이퀄 조인이 아니고 between을 사용했는데도, 조인이 성공적으로 이루어졌다.

grade로 순서가 정렬된 것은 덤!

---

OLTP 서버 : 실시간 조회 처리를 위한 데이터가 저장되어 있는 곳

DW 서버 : 대용량 데이터가 저장되어 있는 곳 ( 우리나라 전 국민의 모든 의료 기록 )

                 10년 정보, 20년 정보가 저장되어 있음

OLTP 서버 -> nested loop 조인을 주로 사용 [해쉬 조인, 병렬 처리하면 큰일난다!  왜? 메모리를 잡아먹어서 다른 사람들에게 피해를 준다]

DW 서버 -> 해쉬 조인, merge 조인, 데이터 분석함수를 주로 사용, 파티션 테이블, 병렬 처리?
