서브 쿼리문 튜닝하기


서브 쿼리문 튜닝의 기술은 크게 2가지만 알면 된다.


1. 순수하게 서브 쿼리문으로 수행되게 하는 방법 : 힌트 추가 ( no_unnest )

2. 서브 쿼리를 조인으로 변경해서 수행되게 하는 방법 : 힌트 추가 ( unnest )

* nest : 감싸다

  unnest : 감싸지 않다

  no_unnest : 감싸라

예제 : DALLAS에서 근무하는 사원들의 이름과 월급을 출력하기

select ename, sal
 from emp
 where deptno in ( select deptno
from dept
where loc = 'DALLAS');


예제 2 : 위의 서브 쿼리문을 조인으로 수행해서 출력하기

select e.ename, e.sal
 from emp e, dept d
 where e.deptno=d.deptno and d.loc='DALLAS';


정리 :
두 테이블의 정보를 조회할 때 서브 쿼리로 하나, 조인으로 하나 출력 결과는 똑같게 할 수 있다.

그럼 둘 중에 어떤 게 더 빠를까?

- 서브 쿼리문의 실행 계획 확인하기

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select deptno
                    from dept
                    where loc = 'DALLAS');       

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



실행 계획을 확인해보면, 알아서 hash join이 되어있는 것을 볼 수 있다.

옵티마이저가 알아서 서브 쿼리 문을 hash join 으로 바꿔서 수행한 것이다.




* 서브 쿼리의 실행 계획은 크게 2가지로 분류된다.

1. 순수하게 서브 쿼리문으로 수행되게 하는 방법 : no_unnest

2. 조인으로 변경되어서 수행하게 하는 방법 : unnest



* unnest 사용법 ( 서브 쿼리 --> 해쉬 조인 ) 

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*= unnest */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



unnest 가 유리한 경우는 서브 쿼리문의 실행 계획이 filter가 나오면서 성능이 너무 느려질 때,

조인의 방법 중 가장 강력한 hash join으로 수행되게 하면서 성능을 높일 수 있다.

 

* no_unnest 사용법 ( 서브 쿼리 지속 )

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*= no_unnest */ deptno
                    from dept
                    where loc = 'DALLAS');         

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



강제로 서브 쿼리로 진행시켰더니, hash join보다 버퍼가 2배 가량 늘어, 성능이 느려졌다.


그렇다면 no_unnest의 좋은 점?

양쪽의 테이블이 대용량이 아닐 때 사용하는 방법으로, 메모리를 절약할 수 있다. ( hash join은 메모리를 잡아먹기 때문에 )


정리 :

테이블 2개가 대용량이다 --> 성능에 따른 속도 차이가 심하므로 hash join을 쓰도록 unnest를 사용

테이블이 대용량이 아니다 --> hash join을 쓰지 못하도록 no_unnest 사용




예제 : 부서위치가 DALLAS인 사원들의 이름과 월급 출력하기

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno = ( select /*+ unnest */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


확인해보면 테이블 full scan이 일어나버렸다.

왜?

서브 쿼리문과 메인 쿼리문 사이의 연산자를 =로 하면 unnest가 먹히지 않는다.

왜냐하면 서브 쿼리에서 메인 쿼리로 한 건만 리턴된다고 하면 굳이 해쉬 조인으로 풀지 않아도 가능하기 때문

그래서 옵티마이저가 힌트를 무시해버린다.

그래서 만약 해쉬 조인으로 수행되게 하고 싶다면 연산자를 =에서 in 으로 변경해줘야한다.



예제 : 방금 예제를 = 대신에, in으로 바꿔보기

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ unnest */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


- '=' 대신 'in' 으로 바꿔주자 다시 정상적으로 hash join이 이루어졌다.



* 서브 쿼리문의 실행 계획 2가지

1. 순수하게 서브 쿼리문으로 수행해라    : no_unnest

             + 서브 쿼리부터 수행해라  : push_subq
    
             + 메인 쿼리부터 수행해라  : no_push_subq

2. 조인 문장으로 변경해서 수행해라        : unnest

세미 조인(semi join)

1. nested loop semi join : nl_sj

2. hash semi join : hash_sj

3. merge semi join : merge_sj


안티 조인(anti join)

1. nested loop anti join : nl_aj

2. hash anti join : hash_aj

3. merge anti join : merge_aj


* semi : 절반이라는 뜻.


조인을 했는데 완전한 조인을 한 게 아니라 절반의 조인을 했다.

왜 완전한 조인을 안 하고 절반의 조인을 했나?

위의 SQL 문이 조인 문장이 아니라 서브 쿼리 문장이기 때문.


예제 : 서브 쿼리를 유지하고, 서브 쿼리문부터 수행되게 하기

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ no_unnest push_subq */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


예제 : 서브 쿼리 유지하고, 메인 쿼리부터 수행되게 하기

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ no_unnest no_push_subq */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


정리 :

no_unnest와 push_subq, no_push_subq 는 서로 짝꿍 힌트이다.

하지만 대체로 push_subq 힌트가 서브 쿼리문으로 수행되었을 때 더 유리한 힌트라고 생각해도 된다.

왜냐하면 서브 쿼리문부터 수행하면서 데이터를 검색해 메인 쿼리로 넘겨주기만 하면 되기 때문

만약 메인 쿼리부터 수행된다면 메인 쿼리에 있는 부서번호중에 서브 쿼리에 있는 부서 번호를 찾기 위해

일일이 다시 스캔하면서 찾는 작업을 반복해야하기 때문에 대용량 테이블의 경우 성능이 많이 느려진다.


예제 : hash semi join이 수행되도록 하기

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ unnest hash_sj */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


여기서 hash join은 항상 작은 테이블 쪽이 메모리에 올라가야 좋은데, 더 큰 emp 테이블이 올라가 있는 상황이다.

이럴 때 더 작은 dept 테이블을 메모리에 올려야 더 성능 좋은 SQL문이라 할 수 있다.



예제 : hash semi join을 수행시키고, DEPT 테이블이 메모리에 올라가도록 하기

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ unnest hash_sj swap_join_inputs(dept)*/ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



- 보기와 같이 저번에 다룬 swap_join_inputs를 활용하면 된다.


예제 : nested loop semi 조인이 되도록 하기

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ unnest nl_sj */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


- 확실히 hash join 때보다 버퍼의 개수가 많이 늘어났다. ( hash join 성능 > nested loop 성능 )



예제 : 관리자인 사원들의 이름을 출력하기 ( 자기 밑에 직속 부하가 한 명이라도 있는 사원들 )

select /*+ gather_plan_statistics */ ename
 from emp
 where empno in (select mgr
                    from emp);
                    
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



근데 이렇게 자기 자신을 조인하면, 테이블 이름이 같아서 어느 쪽이 메모리에 올라갔는지 알 수 없다.

select /*+ gather_plan_statistics unnest hash_sj swap_join_inputs(e2)*/ ename
 from emp e2
 where empno in (select mgr
                    from emp e1);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


이렇게 테이블에 별칭을 줘도 실행 계획에는 똑같이 emp라고 출력되서 구분하기 힘들다.

그래서 이럴 때는 확실히 알 수 있도록 QB_NAME 힌트를 사용해야 한다.


select /*+ gather_plan_statistics QB_NAME(main) */ ename
 from emp 
 where empno in (select /*+ QB_NAME(sub) */ mgr
                    from emp );

select * from table(dbms_xplan.display_cursor(format=>'advanced'));


** format>='advanced' 를 사용하면 좀 더 많은 정보가 있는 실행 계획을 볼 수 있다.


똑같은 것 같지만 실행 계획의 밑을 좀 더 내려보면 2, 3 에 대한 정보를 확인할 수 있는데,

각각 ID 2는 EMP 메인 테이블, ID 3은 EMP 서브 쿼리 테이블을 의미한다.

굳이 MAIN이나 SUB라 할 필요는 없고, 자신이 원하는 별칭을 지어줘도 된다.



예제 : 해쉬 조인 사용, 서브 쿼리 테이블을 메모리에 올리기

select /*+ gather_plan_statistics unnest hash_sj swap_join_inputs(emp@sub) QB_NAME(main) */ ename
 from emp 
 where empno in (select /*+ QB_NAME(sub) */ mgr
                    from emp);

select * from table(dbms_xplan.display_cursor(format=>'advanced'));



swap_join_inputs 를 사용하는데 이 때 괄호 안에 아까 밑에 나왔었던 emp@sub 로 그대로 작성해야한다

그러면 서브 쿼리 테이블부터 수행되고, hash right semi join으로 수행된다.


** not in을 사용한 서브 쿼리 문장의 성능을 높이기 위해서는 hash anti 조인을 사용하면 된다.



예제 : 관리자가 아닌 사원들을 출력하는데, 실행 계획 순서가 서브 쿼리부터 수행되게 하기

select /*+ gather_plan_statistics unnest hash_aj swap_join_inputs(emp@sub) QB_NAME(main) */ ename
 from emp 
 where empno not in (select /*+ QB_NAME(sub) */ mgr
                                    from emp
                                    where mgr is not null);

select * from table(dbms_xplan.display_cursor(format=>'advanced'));




정리 :

1. 서브 쿼리와 메인 쿼리의 테이블이 대용량인가 아닌가?

(1) 둘 다대용량이 아니다 --> 순수 서브 쿼리 이용 ( 메모리 확보 ) -- no_unnest

(1) - 1 : 서브 쿼리부터 사용 --> push_subq 추가

(1) - 2 : 메인 쿼리부터 사용 --> no_push_subq 추가


(2) 둘 다 대용량이다 --> 조인 이용 -- unnest

(2) - 1 : in 을 사용해야 하는 SQL 문 --> hash_sj 추가

(2) - 2 : not in 을 사용해야 하는 SQL 문 --> hash_aj 추가

* 메모리에 올릴 테이블을 직접 결정하고 싶다면 swap_join_inputs, QB_NAME 사용