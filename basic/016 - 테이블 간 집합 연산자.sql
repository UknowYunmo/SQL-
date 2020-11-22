1. 서브 쿼리 사용하기 1 ( 단일행 서브쿼리 )

예제 : JONES의 월급보다 더 많은 월급을 받는 사원들의 이름과 월급을 출력하기

select  ename, sal
  from  emp
  where  sal > ( select  sal
                          from  emp
                          where  ename='JONES' );

복잡해보이지만,

where 절 속의 서브 쿼리 문을 해석하면 단순히 2975라는 값을 반환할 뿐이라는 것을 알 수 있다.

쿼리를 두 번 실행해야 할 수 있는 것을 한 번에 가능하게 하는 것이 서브 쿼리이다.

2. 서브 쿼리 사용하기 2 ( 다중 행 서브쿼리 ) 

* 서브쿼리의 종류 3가지 :

             1. 단일행 서브 쿼리 : 서브쿼리에서 메인쿼리로 하나의 값이 리턴되는 경우

                 연산자: =, >, <, >=, <=, !=, <>, ^=

             2. 다중행 서브 쿼리 : 서브쿼리에서 메인쿼리로 여러개의 값이 리턴되는 경우

                 연산자:  in, not in,  >all, <all, >any, <any

             3. 다중 컬럼 서브쿼리 : 서브쿼리에서 메인쿼리로 여러개의 컬럼값이 리턴되는 경우 

예제 : 사원들 중 SALESMAN과 월급이 같은 사원 출력하기

update emp
set sal = 1500
where ename='KING';

월급이 같은 사원이 아무도 없어서 임시로 KING의 월급을 SALESMAN 중 한 명의 월급인 1500으로 수정하고, 검색

select ename, sal
  from  emp
  where  sal  in  ( select  sal
                         from  emp
                         where  job='SALESMAN')
        and job != 'SALESMAN';

위와 같이 다중 행 서브쿼리는 한 번에 여러 값을 반환하기 때문에

부등호가 아니라 여러 개의 값이 들어있어도 반환할 수 있는 in을 사용하여 처리할 수 있다.

3. 서브 쿼리 사용하기 3 ( NOT IN )

예제 : SALESMAN과 월급이 같지 않는 사원들의 이름과 월급을 출력하기

select ename, sal
  from  emp
  where  sal  not in  ( select  sal
                         from  emp
                         where  job='SALESMAN')
        and job != 'SALESMAN';

이번에는 not in 으로 다중 행을 처리했다.

※ 서브쿼리문에 not in 연산자 사용시 주의할 사항

   서브쿼리에서 null 값이 하나라도 리턴되면 결과가 출력되지 않는다

   만약 null 값이 리턴될 수 밖에 없는 경우라면 서브 쿼리 조건문 안에 where 컬럼 is not null을 추가하여

   절대 null이 나올 수 없도록 제한하자.

4. 서브 쿼리 사용하기 4 ( EXISTS와 NOT EXISTS )

** 서브쿼리문에서  exists 와 not exists 를 사용해서 메인쿼리에 있는 데이터 중에

    서브쿼리에 존재하는지 존재 유무를 파악할 때 사용하는 SQL 문법

예제 : 부서 테이블에 있는 부서번호중에 사원 테이블에도 존재하는 부서번호와 부서위치를 출력하기

select deptno,  loc
from dept d
where exists (select *
                    from emp e
	        where e.deptno = d.deptno);

예제 : 부서 테이블에 있는 부서번호중에 사원 테이블에 존재하지 않는 부서번호와 부서위치를 출력하기

select deptno,  loc
from dept d
where not exists (select *
                    from emp e
	        where e.deptno = d.deptno);