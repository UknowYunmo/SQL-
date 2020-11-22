OUTER JOIN 의 튜닝 방법


* outer join의 조인 순서는

outer join sign이 없는 쪽에서 있는 쪽으로 순서가 고정이 된다.

그러다보니 조인 순서를 변경하기가 어려워서 튜닝이 힘든데,

이를 개선할 수 있는 힌트가 있다.

일단 outer join을 연습하기 위해서, deptno가 deptno 테이블에는 없는, 특이한 사원을 하나 넣어보자


insert into emp ( empno, ename, sal, deptno )
 values ( 2921, 'JACK', 4500, 70 ) ;

예제 : deptno로 아우터 조인을 해보자

select /*+ gather_plan_statistics */ e.ename, d.loc
 from emp e, dept d
 where e.deptno=d.deptno(+);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


지금 보면 옵티마이저가 emp 테이블을 선행 테이블로 읽었다.

그러면, dept를 먼저 읽게 강제해보자

select /*+ gather_plan_statistics leading(d e) use_hash(e) */ e.ename, d.loc
 from emp e, dept d
 where e.deptno=d.deptno(+);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


조인 순서를 변경하려고 힌트를 줬지만 확인해보면 옵티마이저가 내 말을 가볍게 무시한 걸 볼 수 있다.

왜냐하면 outer join은 무조건 outer 사인 (sign)이 없는 쪽에서 있는 쪽으로 조인하기 때문.

그런데, dept 테이블이 emp 보다 훨씬 작은 테이블이라, dept를 아무래도 먼저 올려고 싶으면, 어떻게 해야하나?


** 조인 순서를 강제x2 로 dept --> emp가 되게 하기

select /*+ gather_plan_statistics leading(d e) use_hash(e)
            swap_join_inputs(d) */ e.ename, d.loc
 from emp e, dept d
 where e.deptno=d.deptno(+);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



저번에 hash join에서 써먹었던 swap_join_inputs를 사용해서

dept 테이블을 hash 테이블로 구성해서 dept 테이블을 먼저 메모리에 올리나까 성공했다.

실행 계획을 보면 hash right outer 조인으로 바뀐 것을 볼 수 있다.



결론 :

outer join을 튜닝하려면 hash join으로 수행해야 한다.

swap_join_inputs는 hash join에만 사용할 수 있기 때문!




예제 : emp와 bonus를 outer join 해서, 이름과 comm2를 출력하는데 JACK도 출력되도록 하기 ( bonus 먼저! )

select /*+ gather_plan_statistics leading(b e) use_hash(b e)
            swap_join_inputs(b) */ e.ename, b.comm2
 from emp e, bonus b
 where e.empno=b.empno(+);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


현업에서도 swap_join_inputs 안 쓰면 outer join을 튜닝하기 거의 힘들다.

outer join을 피하고 하다보면, 코드가 이상하게 길어지고 효율도 떨어진다.

그러니

swap_join_inputs 기억 또 기억하자