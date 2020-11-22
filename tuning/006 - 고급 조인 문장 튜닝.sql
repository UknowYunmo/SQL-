* 고급 조인 문장 튜닝

뷰 안의 조인 문장의 조인 순서를 변경하고자 할 때 사용하는 튜닝 방법

예제 : 사원 번호, 이름, 월급, 부서 번호, 부서 위치를 담은 emp_dept라는 view를 만들기

create view emp_dept
 as
  select e.empno, e.ename, e.sal, e.deptno, d.loc
   from emp e, dept d
   where e.deptno=d.deptno;


근데 컬럼명을 자세히보면 e.empno, e.ename이 아닌 empno, ename 이다.

나머지도 마찬가지.

예제 : 방금 만든 emp_dept view와 salgrade 테이블을 서로 조인해서 이름과 월급과 부서 위치와 급여 등급을 출력하기

select v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;


그럼 방금 코드의 실행 계획을 한 번 보자


select /*+ gather_plan_statistics */ v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


근데 내가 만든 뷰를 안 쓰고, 왠 emp와 dept를 풀로 access한 모습..

leading으로 고정하고, nested loop하도록 힌트를 주자

select /*+ gather_plan_statistics leading(s v) use_nl(v) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


보면, leading으로 고정하고, nested loop 조인을 하라고 힌트를 줬는데도

nested loop를 하지 않았다.

왜 무시했냐?

view를 해체해버렸기 때문

만약 view가 해체되지 않았다면, 실행 계획에 view가 나타난다.

그래서 view를 해체하지 못하도록 힌트를 줘야하는데, 그 힌트가 no_merge 이다.

방금 실패했던 코드의 힌트 앞에 no_merge 힌트를 추가하자.


select /*+ gather_plan_statistics no_merge(v) leading(s v) use_nl(v) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


드디어 emp_dept view가 실행 계획에 나타났다.


* no_merge : view를 해체하지 말아라~
* merge     :  view를 해체해라~


아까는 no_merge가 없어서, leading (s v)가 닿기도 전에 이미 view가 해체되었었다.

근데 실행 계획을 자세히 보면, view가 늦게 쓰여진게 아니냐. 싶은데,

사실 view 부터~ 맨 밑 줄 table access full - emp 까지 한 묶음이다. ( starts 5 )

그래서 실행 계획을 다시 해석하면,

먼저 salgrade를 full scan 하고, view를 스캔하면서 nested loop 조인을 수행했다는 것을 알 수 있다.

그리고 view 안에서는 dept 테이블을 먼저 읽고, emp 테이블을 그 다음 읽어서 hash join이 이루어졌다.

근데 뷰 안의 조인 문장의 테이블 조인 순서 ( emp --> dept )를 변경하고 싶다면, 어떻게 변경해야 할까?

뷰를 drop 하고 재생성 하면 되지 않나요?  --> 현업에서는 뷰를 담당 부서가 따로 있어서 불가능하거나 요청하더라도 오래 걸리는 경우가 대다수이다.

이런 경우는, leading과 아까 view 안의 실행 방법 중 하나인 use_hash의 안에( 꼭 hash일 필요는 없음! )

뷰의 별칭인 v와, v 안의 컬럼명인 e와 d를 활용해서 더 구체적으로 한 번 더 작성하자


select /*+ gather_plan_statistics no_merge(v) leading(s v) use_nl(v)
	leading(v.e v.d) use_hash(v.d) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


여기에 물론 nested loop 도 가능하다.

select /*+ gather_plan_statistics no_merge(v) leading(s v) use_nl(v)
	leading(v.e v.d) use_nl(v.d) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


예제 : 뷰를 먼저 올리고, 뷰 안의 조인을 해쉬 조인으로 바꾸고 조인 순서는 emp가 먼저 되도록 하기

select /*+ gather_plan_statistics no_merge(v) leading(v s) use_nl(s)
	leading(v.e v.d) use_hash(v.d) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


예제 : salgrade 먼저 올리고, 뷰 내에선 dept 먼저 해서 hash join 시키기

select /*+ gather_plan_statistics no_merge(v) leading(s v) use_nl(v)
            leading(v.d v.e) use_hash(v.e) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


정리 : 뷰와 조인할 때는 no_merge를 먼저 기입해서 뷰를 해체하지 말라고 힌트를 준다. ( 안 주면 자기가 알아서 해체해버려서, 다른 힌트 다 무시한다. )

그리고 뷰 안의 순서나 조인 방법을 지정하고 싶다면 from 절의 뷰에 별칭을 이용해서 별칭과 함께 컬럼명을 지정해서

한 번 더 그 방법에 관한 힌트를 넣어줘서 자유롭게 조정할 수가 있다.