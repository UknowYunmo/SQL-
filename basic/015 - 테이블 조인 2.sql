* 데이터를 연결해서 출력하는 방법 2가지 

 1. 조인(join) : 데이터를 양옆으로 연결해서 출력하는 방법
 2. 집합 연산자 : 데이터를 위아래로 연결해서 출력하는 방법

* 집합 연산자의 종류 4가지 

     1.  union  all
     2.  union
     3.  intersect
     4.  minus 

1. 집합 연산자로 데이터를 위아래로 연결하기 1(UNION ALL)

예제 : 위 두개의 결과를 합쳐서 출력하기 :

select    job,  sum(sal)                                                                            select  '전체토탈:'  as  job,  sum(sal) 
   from  emp                                                                                          from  emp;
   group  by   job;

select    job,  sum(sal)
   from  emp
   group  by   job
union  all
select  '전체토탈:' as  job,  sum(sal)
  from  emp;

두 개의 select 문을 union all 으로 연결하면 하나의 결과로 합쳐서 출력할 수 있다.

* 집합 연산자를 사용할 때 주의 사항

      1. 집합 연산자 위 아래의 쿼리문의 컬럼의 갯수가 동일해야 한다.
      2. 집합 연산자 위 아래의 쿼리문의 컬럼의 데이터 타입도 동일해야 하다.
      3. 집합 연산자 위 아래의 쿼리문의 컬럼의 컬럼명이 동일해야 한다.
      4. order  by 절은 맨 아래쿼리문에만 작성할 수 있다. 

2. 집합 연산자로 데이터를 위아래로 연결하기 2 ( UNION )

union 은 union all 과 같은 합집합 연산자인데

차이점은 union 은 order by 절을 사용하지 않아도 정렬을 암시적으로 수행하고,

중복된 데이터를 하나로 출력한다는 점이다.

예제 : 부서번호, 부서번호별 토탈월급을 출력하는데 맨 아래에 전체토탈 월급이 출력되게하고
        부서번호를 번호선으로 출력하기

select   to_char(deptno) as deptno, sum(sal)
 from emp
 group  by deptno
 union
 select  '전체토탈:'  as  deptno,  sum(sal)
   from  emp;

select   to_char(deptno) as deptno, sum(sal)
 from emp
 group  by deptno
 union all
 select  '전체토탈:'  as  deptno,  sum(sal)
   from  emp;
    
보이듯 union을 사용하면 자동으로 번호순으로 정렬이 된다.

3. 집합 연산자로 데이터의 교집합을 출력하기 ( INTERSECT )

예제 : emp 테이블과 dept 테이블의 교집합을 출력하기

SELECT deptno
  FROM empINTERSECT
SELECT deptno
  FROM dept;

해주면 공통된 데이터 값인 10,20,30 만 출력된 것을 확인할 수 있다.

(40번은 출력 x)

4. 집합 연산자로 데이터의 차집합을 출력하기 ( MINUS )

예제 : emp 테이블과 dept 테이블의 차집합을 출력하기

emp 테이블과 dept 테이블의 교집합을 출력하기

SELECT DEPTNO
  FROM DEPT
MINUS
SELECT DEPTNO
  FROM EMP;

반대로 만약 EMP에서 DEPTNO의 차집합을 구하면 아무것도 출력되지 않는다.?

(전부 있기 때문에)

