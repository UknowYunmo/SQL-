SQL 튜닝 기술

1. 인덱스 SQL 튜닝 : 인덱스 엑세스 방법 8가지

** 2. 조인 SQL 튜닝 **

3. 서브쿼리 SQL 튜닝

4. 데이터 분석함수를 이용한 튜닝

5. 자동 SQL 튜닝


현업에서 튜닝을 해야할 쿼리문이 10개라면, 그 중 8개 꼴은 조인 문장이다.


** 조인 SQL 튜닝 기술 **

1. NESTED LOOP 조인

2. HASH 조인

3. SORT MERGE 조인

4. 조인 순서의 중요성

5. OUTER 조인

6. 스칼라 서브 쿼리를 이용한 조인

7. 조인을 내포한 DML 문 튜닝

8. 고급 조인 문장 튜닝


1. 조인을 왜 튜닝해야할까?

예제 : 사원 이름, 월급, 부서 위치를 출력하기

select e.ename, e.sal, d.loc
 from emp e, dept d
 where d.deptno=e.deptno;

근데 생각해보면 

(1) emp -----> dept 조인하는 방법과

(2) dept -----> emp 조인하는 방법

이렇게 두 가지 방법이 있을 것이다.

둘 중 어떤 방법이 더 효율적일까?

정답은 (2)다.

작은 테이블(dept-4건)을 먼저 읽고 큰 테이블(emp-14건)이랑 조인하는 게 더 성능이 좋기 때문.

근데 똑똑한 옵티마이저는 (1)을 시켜도 자동으로 (2)를 수행했을 수도 있다.

한 번 확인해보자.

select /*+ gather_plan_statistics */ e.ename, e.sal, d.loc
 from emp e, dept d
 where e.deptno=d.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


실행 계획을 확인해보면 dept 테이블부터 먼저 읽고 emp 테이블과 조인했다.

(Id가 순서가 아니고, 보면 순서가 라인으로 구별되어 있는데, 동일한 라인은 위부터 실행한 순서이다.)

버퍼의 개수는 6개로 출력되었다.

그렇다면 emp 테이블부터 조인하도록 억지로 바꿔보자


** 조인 순서를 조정하는 힌트 ( ordered )

ordered 힌트 : from 절에서 기술한 테이블 순서대로 조인해라!!

select /*+ gather_plan_statistics ordered */ e.ename, e.sal, d.loc
 from emp e, dept d
 where e.deptno=d.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


확인해보면 emp를 먼저 읽고, dept 테이블을 조인했다.

버퍼의 개수는.. 똑같다...

다른 분들 SQL을 보면 버퍼가 60개까지도 늘어났는데

난 왜 똑같지..? 옵티마이저 성능이 더 좋은것 같다.. 허허

* 어쨌든 현업에서 선배들이 ordered를 사용해서 짜둔 쿼리문을 접하게 될 수 있다.

근데 현업 테이블의 크기는 항상 변하기 때문에, 예전의 ordered 문은 더 효율적이었지만

지금은 그 크기가 서로 변해서 오히려 비효율적이라 ordered를 뺐을 때 더 빨라지는 경우가 있다.

ordered 뿐만 아니고 테이블의 변화로 인해 SQL 힌트를 없애면 더 빠른 경우도 있을 수 있기 때문에

혹시 받은 SQL 문에 힌트가 있으면 힌트를 먼저 빼고 수행해보자.


* 조인 순서를 결정하는 힌트 2가지

1. ordered        --->   from 절에서 기술한 테이블 순서대로 조인해라!

2. leading         --->   leading 힌트 안에 사용한 테이블 순서대로 조인해라!

예제 : leading을 사용해 조인하여 사원 이름, 월급, 급여 등급을 출력하기

select /*+ gather_plan_statistics leading(e s) */ e.ename, e.sal, s.grade
 from salgrade s, emp e
 where e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

기능은 같기 때문에

ordered 와 leading 중에

자신에게 마음에 드는 방법을 하나 정해서 쓰자.

** 조인 튜닝시 중요한 튜닝 방법 2가지 **

1. 조인 순서를 조정하기

(1) ordered 힌트 주기

(2) leading 힌트 주기

2. 조인 방법을 결정하기

(1) nested loop join ( use_nl ): 적은 양의 데이터를 조인할 때 유리한 조인

(2) hash join ( use_hash ): 대용량 데이터를 조인할 때 유리한 조인

(3) sort merge join ( use_merge ): 대용량 데이터를 조인할 때 유리한 조인, hash join으로 수행되지 못하는 SQL에 사용

* 작은 테이블을 조인할 때 쓸데없이 해쉬 조인을 하면서 메모리를 과다하게 사용할 필요는 없기 때문에

  작은 테이블을 조인할 때는 nested loop를 사용하자!


예제 : emp, dept를 조인해서 사원 이름, 월급, 직업, 부서 위치를 출력하기

select /*+ gather_plan_statistics leading(e d) */ e.ename, e.sal, e.job, d.loc
 from dept d, emp e
 where d.deptno=e.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

* nested loop 조인

nested loop는 순차적으로 하나씩 조인을 시도한다.

이렇게 하나씩 조인을 처리하다보니 조인하려는 데이터의 양이 많으면 성능이 많이 느려진다.


예제 : 위의 SQL 문에서 NESTED LOOP 사용하기

use_nl(테이블 명, 테이블 명) 힌트에서

leading에 따라 테이블 순서를 적어주자.

만약 ordered를 사용했다면

from 절에 따라 테이블 순서를 적어주면 된다.

select /*+ gather_plan_statistics leading(e d) use_nl(e d) */ e.ename, e.sal, e.job, d.loc
 from dept d, emp e
 where d.deptno=e.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

해쉬 조인 했을 때와는 다르게 버퍼가 90개로 더 늘어났다.

그치만 emp와 dept 테이블이 서로 조인되는 데이터의 양이 적으므로

nested loop 조인을 사용하는 게 더 바람직하다.


추가 설명 :

지금 내가 연습한 테이블의 데이터가 너무나 작기 때문에 버퍼가 크게 늘어나 엄청 비효율적인 방법인듯 하지만,

현업에 가면 지금까지 했던 hash 조인들에 사용되는 버퍼의 수가 훨씬 많아진다. (데이터 양이 훨씬 크기 때문)

아무래도 nested loop에 기본적으로 사용되는 버퍼의 수가 많을 뿐이지

현업에서 nested loop을 사용한다면 버퍼의 수가 줄을 것이다. (선생님의 답변)


예제 : emp 테이블과 salgrade 테이블을 조인해서 사원 이름, 월급, 급여 등급을 출력하는데, salgrade 먼저 읽게 하기

select /*+ gather_plan_statistics leading(s e) use_nl(s e) */ e.ename, e.sal, s.grade
 from salgrade s, emp e
 where e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


예제 : 사원의 이름과 부서 위치를 출력하기

select e.ename, e.sal, d.loc
 from emp e, dept d
 where e.deptno=d.deptno;

(1) emp ---> dept : 14번 조인 시도 ( 사원이 14명이니까 )

(2) dept ---> emp : 4번 조인 시도 ( 부서 위치가 4종류니까 )

에서 효율이 더 좋은 것이 (2) 이었다면,


예제 : 이름이 'scott'인 사원의 이름과 월급과 부서 위치를 출력하기!

select e.ename, e.sal, d.loc
 from emp e, dept d
 where e.deptno=d.deptno and e.ename='SCOTT';

* 위의 SQL에서 조인 순서가 더 좋은 것은?

(1) emp ---> dept

(2) dept ---> emp

정답 : (1)

왜?

e.ename = 'SCOTT'인 경우는 겨우 1건이다

그래서 그 1건을 DEPT 테이블에 조인하기만 하면 되기 때문에,

위 경우에는 (1)이 더 효율적이다.


예제 : 아래의 SQL문의 조인 순서를 emp--> dept로, 조인 방법은 nested loop로 수행하기

select /*+ gather_plan_statistics leading(e d) use_nl(e d) */ e.ename, e.sal, d.loc
 from dept d, emp e
 where e.deptno=d.deptno and e.ename='SCOTT';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

* 조인 문장에 조인(연결) 조건 말고 검색 조건이 따로 있으면

검색 조건으로 검색되는 건수가 몇 건인지 먼저 확인을 하고

그 건수가 상대쪽 테이블보다 작다면 작은 건수를 검색하는 쪽으로

먼저 읽도록 이렇게 ordered 또는 leading을 작성하자


그럼 이제 테이블이 2개가 아니고, 다수일 때는 어떤 차이가 있을까?


예제 : emp 와 dept와 salgrade 를 조인해서 이름과 월급과 부서위치와 급여 등급을 출력하기 ( 테이블이 다수일 때 )

( dept --> salgrade --> emp  하고 싶지만 dept와 salgrade가 서로 연결 고리가 없어서 이렇게 하면 안 된다.

   4              5             14

select /*+ gather_plan_statistics leading(d s e) use_nl(d s e) */ e.ename, e.sal, d.loc, s.grade
 from dept d, emp e, salgrade s
 where e.deptno=d.deptno and e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


보기와 같이 버퍼가 154개가 쓰인 것을 확인할 수 있다!

위의 버퍼의 수를 줄이려면,

( dept --> emp --> salgrade ) 이렇게 서로 연결고리가 있는 테이블끼리 연결하면서 조인 순서를 정해줘야 한다.
    nested loop   nested loop


조인 순서를 변경해보자

select /*+ gather_plan_statistics leading(d e s) use_nl(d e s) */ e.ename, e.sal, d.loc, s.grade
 from dept d, emp e, salgrade s
 where e.deptno=d.deptno and e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

버퍼가 128개로 줄었다!!

실행 순서 :

(1) dept --> emp 가 nested loop join이 된다.

(2) (1)의 결과와 salgrade가 nested loop join이 된다.

예제 : 이름이 KING인 사원의 이름과 월급과 부서위치와 급여등급을 출력하기 ( 테이블이 다수일 때 + 검색 조건 )

만약 아까와 똑같이 하고, 검색 조건만 추가한다면?

select /*+ gather_plan_statistics leading(d e s) use_nl(d e s) */ e.ename, e.sal, d.loc, s.grade
 from dept d, emp e, salgrade s
 where e.deptno=d.deptno and e.sal between s.losal and s.hisal and e.ename='KING';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

버퍼의 개수는 37개!

그렇다면 이제

검색 조건인

ename='KING' 을 만족하는 결과값이 1개라는 걸 이용해서

emp 테이블부터 조회한 뒤

emp --> dept --> salgrade 순으로 조회하도록 해보면?

select /*+ gather_plan_statistics leading(e d s) use_nl(e d s) */ e.ename, e.sal, d.loc, s.grade
 from dept d, emp e, salgrade s
 where e.deptno=d.deptno and e.sal between s.losal and s.hisal and e.ename='KING';
 
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));
 
버퍼가 19개로 거의 절반 가량 줄어있는 것을 확인할 수 있다!

-----------------
 
정리 :

데이터 튜닝을 해야할 때

1. 조인 순서를 정한다.

2. 조인 방법을 정한다.

이 두 가지 관점으로 대하자

1. 조인 순서는 어느 쪽이 대용량인지를 생각해서

적은 쪽을 먼저 읽도록 순서를 정하면 된다!

만약 where 절이 있다면, 그 절을 모두 실행시켜봐서

어느 쪽이 더 적은 양인지 확인해보고,

마찬가지로 적은 쪽을 먼저 읽도록 순서를 정하자.

2. (조인 방법)은 다음 목차( SQL - HASH JOIN, SORT MERGE JOIN )에서!
