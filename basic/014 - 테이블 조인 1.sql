* 조인 문법  2가지      1.  오라클 조인 문법
                                                - equi  join
                                                - non equi  join
                                                - outer  join
                                                - self  join
                                  2.  1999 ANSI 조인 문법 
                                                - on 절을 사용한 조인
                                                - using 절을 사용한 조인 
                                                - natural  join
                                                - left/right/full  outer  조인
                                                - cross 조인 

저번에 다룬 것은 오라클 조인 문법.

이번에는 ANSI 조인 문법으로 조인을 해보자.

1. 테이블의 데이터를 조인해서 출력하기 1 ( ON 절 )

1. 오라클 equi  join                                   2. on 절을 사용한 조인

  select  e.ename,  d.loc                             select  e.ename, d.loc
    from  emp  e, dept  d                               from  emp  e  join   dept  d
   where  e.deptno = d.deptno ;                       on  ( e.deptno = d.deptno ) ;

차이점은 콤마가 사라지고, where 절 대신에 on 절을 넣어준 점이다.

근데 이거 왜 함?

예제 : DALLAS 에서 근무하는 사원들의 이름과 월급과 부서위치와 직업을 출력하기

select  e.ename, e.sal, d.loc, e.job
  from  emp  e  join  dept  d
  on  (  e.deptno = d.deptno )
  where  d.loc='DALLAS'; 

다음과 같이 검색 조건을 where 절에 적었을 때 on 절과 구분이 되서

조인 조건과 검색 조건을 명확하게 구분해서 알아보기 편하다는 장점이 있다.

2. 테이블의 데이터를 조인해서 출력하기 2 ( USING 절 )

예제 : 직업이 SALESMAN 인 사원들의 이름과 월급과 직업, 부서위치를 출력하기

select  e.ename, e.sal,  e.job,  d.loc
  from   emp  e   join  dept   d
  using  ( deptno )
  where  e.job='SALESMAN'; 

ON 절과 거의 같다.

차이점은 ON 대신 USING은 컬럼명만 명시해준다.

개인적으로 ON 절보다 더 깔끔한 것 같다.

3. 테이블의 데이터를 조인해서 출력하기 3 ( FULL OUTER JOIN )

그렇다면, 양쪽에 데이터가 부족할 때도 양쪽에 OUTER JOIN을 할 수 있을까?

예제 : 사원의 이름과 부서위치를 출력하시오

select  e.ename, d.loc
 from  emp  e,   dept   d
 where  e.deptno (+) = d.deptno (+);

ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다.

OUTER JOIN을 양쪽에 수행하면 다음과 같은 오류가 발생한다.

그러니 

select  e.ename,  d.loc
  from  emp  e   full  outer   join   dept   d
   on  ( e.deptno = d.deptno );

또는

select  e.ename,  d.loc
  from  emp  e   full  outer   join   dept   d
   using ( deptno );

이렇게 full outer join이라고 선언하고 on 절 또는 using 절을 사용해줘야 한다.

4. 테이블의 데이터를 조인해서 출력하기 4 ( NATURAL JOIN )

** where 절 없이 간단하게 조인하는 조인 문법
   오라클이 알아서 두 테이블 사이에 공통된 컬럼이 있는지 찾아보고 조인한다. 

예제 : 사원과(emp 테이블) 부서 위치를(dept 테이블) 출력하기

select  e.ename,  d.loc
 from  emp  e  natural  join  dept  d; 

분명 편리한 조인인데, 아무래도 기계가 알아서 하니까 현업에서 사용하기에는 좀 찝찝하다고 한다.