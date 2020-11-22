SELECT 절 중 서브 쿼리를 쓸 수 있는 절

SELECT                 --> O ( 스칼라 서브쿼리 )
 FROM                 --> O ( 인 라인 뷰 )
  WHERE               --> O
   GROUP BY         --> X
    HAVING            --> O
     ORDER BY        --> O ( 스칼라 서브쿼리 )

예제 : 이름, 월급, 사원 테이블에서의 최대 월급 출력하기 ( 스칼라 서브 쿼리 )

select /*+ gather_plan_statistics */ ename, sal, (select max(sal) from emp)
 from emp;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


튜닝 :

select /*+ gather_plan_statistics */ ename, sal, max(sal) over () 최대월급
 from emp;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


over () 를 사용하면 전체를 서브 쿼리를 한 번 돌린 것과 같은 효과를 낼 수 있다!

버퍼는 여기선 똑같지만.. 역시 대용량에선 차이가 있을 것


예제 : 이름, 월급, 최대 월급, 최소 월급을 출력하기

select /*+ gather_plan_statistics */ ename, sal, ( select max(sal) from emp ) 최대월급, (select min(sal) from emp ) 최소월급
 from emp;


튜닝 :

select /*+ gather_plan_statistics */
 ename, sal, max(sal) over () 최대월급, min(sal) over () 최소월급
 from emp;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


이제 보니 버퍼의 수는 같지만, 적용시킨 오퍼레이션의 개수가 확연히 적다.



예제 : 부서번호, 사원, 월급, 부서번호 별 월급의 평균을 출력하는데, 자신의 부서 평균보다 월급이 높은 사원만 출력하기

select /*+ gather_plan_statistics */
 e.deptno, e.ename, e.sal, v.부서평균
 from emp e, (select deptno, avg(sal) 부서평균
                     from emp
                     group by deptno) v
 where e.deptno=v.deptno and e.sal>v.부서평균;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


확인해보면 버퍼의 개수가 51개다..

해결 방법은 조인을 사용하지 않는 대신에 partition by를 사용해서 한 테이블에 전부 박아넣고,

그 테이블 전체를 그대로 조건만 줘서 출력하면 된다.

select /*+ gather_plan_statistics */ *
 from 
  ( select deptno, ename, sal, avg(sal) over (partition by job) 부서평균
        from emp )
where sal>부서평균;


확인해보면, 버퍼의 개수가 7개로 훨씬 줄어들었다!


예제 : 부서번호, 이름, 월급, 순위를 출력하는데 순위가 부서번호별로 각각 월급이 높은 순서대로 순위를 부여해서 출력하고 순위가 1등인 사원들만 출력하기

select /*+ gather_plan_statistics */ *
 from
  (select deptno, ename, sal, dense_rank() over (partition by deptno order by sal asc) 순위
   from emp)
 where 순위=1;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


* DML 문을 이용한 서브 쿼리문의 튜닝


예제 : ALLEN의 월급을 KING의 월급으로 변경하기

update emp
 set sal = ( select sal from emp where ename='KING' )
  where ename='ALLEN'

요건 기존의 서브 쿼리문을 이용한 DML 문이다.


예제 : 사원 테이블에 loc 컬럼을 추가하고 해당 사원이 속한 부서 위치로 값을 갱신하기

alter table emp
 add loc varchar2(20);

--> loc를 추가하고, 데이터는 비어있는 상태

update emp e
 set loc ( select loc
from dept d
   where e.deptno=d.deptno );

select * from emp;


그런데

update emp e
 set loc ( select loc
	 from dept d
	 where e.deptno=d.deptno );

문에서, 서브 쿼리 안에 e가 존재할 수 있는지 의문이 들 것이다.


** emp 테이블의 컬럼이 서브 쿼리 안으로 들어가게 되면

서브 쿼리부터 수행되는 게 아니라 메인 쿼리 ( update )문부터 실행된다.

마치 set 절이 보통 select 절의 from 절의 위치와 비슷해서 순서가 먼저일 것 같지만,

사실 update를 실행할 때 update 될 테이블로부터 시작하기 때문에,

마치 select 절의 from 위치처럼 update 문이 가장 먼저 실행되고, 테이블에 별칭을 붙여서 서브 쿼리가 있는 set 절에 사용할 수도 있는 것이다.

근데 여기서 문제는, 이렇게 하면 update 문 안에서 where 절의 조건에 맞는지 안 맞는지 계~속 반복해서 수행한다.

그래서 마치 update 문을 14번 수행하는 것과 똑같은 효과가 난다.

그래서 튜닝이 필요하다.

update /*+ gather_plan_statistics */ emp e
 set loc = ( select loc
              from dept d
             where e.deptno=d.deptno );

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

select * from emp;


튜닝 후 :

merge into emp e
 using dept d
  on ( e.deptno = d.deptno )
 when matched then
 update set e.loc=d.loc;

merge 문을 사용하면 데이터를 한 번에 갱신할 수 있다.


---

사원 테이블에 sal2 라는 컬럼 추가하기

alter table emp
 add sal2 number(10)


예제 : sal2에 해당 사원의 월급으로 값을 갱신하기

 update emp
  set sal2 = sal;

select ename, sal, sal2 from emp; 

확인해보면 엄청 심플하게, 한 번에 옮긴 것을 볼 수 있다.


예제 1 : emp 테이블에 빈 loc 컬럼을 만들기

alter table emp
 add loc varchar2(20);

예제 2 : 복합뷰를 생성하고 뷰를 쿼리하기

create view emp_dept
 as
  select e.ename, e.loc as emp_loc, d.loc as dept_loc
	from emp e, dept d
  where e.deptno=d.deptno;

select * from emp_dept;

확인해보면, emp_loc은 비워져있고, dept_loc은 채워져있다.

여기서 dept_loc을 그대로 emp_loc에 옮기기만 하면 된다!


예제 3 : 방금 만든 뷰의 emp_loc의 값을 dept_loc의 값으로 갱신하기

update emp_dept
 set emp_loc=dept_loc;

하면 실행이 안 된다.

왜?

SQL : 만약 deptno에 40이 'DALLAS' 도 있고, 'CHICAGO'도 있으면 난 뭘로 해야 되는데? 그냥 안 함

이렇게 데이터가 중복되거나, null 값이 있을 경우를 대비해서 update 문에서 이런 코드는 오류로 막아버린다.

위의 복합 뷰를 갱신하려면

dept 테이블의 deptno에 primary key 제약을 걸어주면 갱신할 수 있다. ( 중복도 없고 NULL도 없으니까 그냥 좀 해줘.. )


예제 4 : deptno에 primary key를 걸고 재실행

alter table dept
 add constraint dept_deptno_pk primary key(deptno);

update emp_dept
 set emp_loc = dept_loc;


select * from emp_dept;

- 갱신 완료!

VIEW를 만들지 않고, 한 번에 만드는 법

update  --> 서브 쿼리 가능 ( 이거를 이용! )

 set      --> 서브 쿼리 가능

  where --> 서브 쿼리 가능

update ( select e.ename, e.loc as emp_loc, d.loc as dept_loc
		from emp e, dept d                                                    --> 아까 만들었던 VIEW 내용 그대로!!
	where e.deptno=d.deptno )
  set emp_loc = dept_loc;


select * from emp;


--> 이렇게 뷰를 사용할 수 없다면 update에 서브 쿼리를 사용해서 뷰의 쿼리문을 직접 작성하고, set 절에서 업데이트 하면 된다.

( 이 때도 마찬가지로 가져올 데이터 테이블에 primary key는 걸려있어야 함! )


예제 : emp 테이블에 dname 컬럼을 추가해서 사원의 부서명(dept 테이블)으로 값을 갱신하기

(1) emp에 dname 컬럼 만들기

alter table emp
 add dname varchar2(10);


(2)

update ( select e.ename, e.dname as emp_dname, d.dname as dept_dname
	  from emp e, dept d
	where e.deptno = d.deptno )
  set emp_dname = dept_dname;


select * from emp;


(3) merge 활용

merge into emp e
 using dept d
 on ( e.deptno = d.deptno )
 when matched then
 update set e.dname = d.dname;

정리 : merge를 사용하거나, update 절의 서브 쿼리를 이용해서 한 번에 만들면 빠르다. ( 개인적으로 merge 문.. )