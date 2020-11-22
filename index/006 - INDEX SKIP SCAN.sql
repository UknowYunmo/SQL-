index skip scan

1. 단일 컬럼 인덱스

컬럼을 하나로 해서 만든 인덱스

create index emp_deptno
 on emp(deptno);

2. 결합 컬럼 인덱스

컬럼을 여러개로 해서 만든 인덱스

create index emp_deptno_sal
 on emp(deptno,sal);


* emp_deptno_sal 의 구조 살펴보기


select deptno, sal, rowid
 from emp
 where deptno >= 0;   --> 모든 결과 출력

- 살펴보면, deptno를 먼저 asc로 정렬하고, 그것을 기준으로 sal을 asc로 인덱스를 구성하고 있다.


*결합 인덱스가 필요한 이유


인덱스에서 데이터를 읽어오면서 테이블 엑세스를 줄일 수 있기 때문
 (목차)                                    (책)

내가 검색하고자 하는 데이터가 목차에 있어서 책 안 뒤지고 목차에서만 읽고 끝났다면

빠르게 데이터를 검색한 것.

책보다는 목차가 훨씬 두께가 얇으므로 목차에서 원하는 데이터를 찾는 게

책에서 찾는 것보다 훨씬 속도가 빠르다.



예제 : deptno가 10인 사원의 deptno와 월급 출력하기

select /*+ gather_plan_statistics index(emp emp_deptno) */
  deptno
 from emp
 where deptno = 10;
  
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


확인해보면, 인덱스 range scan을 한 뒤, 테이블에 access 한 것을 확인할 수 있다.


목차에서 -> 책 페이지로 이동했다.


그렇다면 아까 만든 emp_deptno_sal 이라는 결합 인덱스를 사용해보자


예제 : 위의 결과를 결합 인덱스를 활용해서 출력하기

select /*+ gather_plan_statistics index(emp emp_deptno_sal) */
  deptno,sal
 from emp
 where deptno = 10;
  
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


확인해보면, 다음과 같이 테이블 access가 사라진 것과, 버퍼의 수가 줄어든 것을 볼 수 있다.


즉, 목차 안에서 바로 끝내버렸다는 뜻.

지금은 너무 작은 데이터라 시간 차이가 없지만,

현업의 대용량 데이터라면, 당연히 수행 시간에서 차이가 날 수 밖에 없다.


예제 : 사원 번호, 이름, 직업, 부서 번호를 결합 인덱스로 만들고 조회해보기

 create index emp_empno
 on emp(empno,ename,sal,deptno);
 
select /*+ gather_plan_statistics index(emp emp_empno) */
  empno,ename,sal,deptno
 from emp
 where empno=7788;
  
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


위와 같이 컬럼의 수가 많아도 결합 인덱스에 포함되어 있다면 테이블을 access 하지 않아도

한 번에 결과를 조회할 수 있다.


* index skip scan 사용하기


index skip scan 을 사용하면 인덱스 전체를 보는 것은 index full scan과 같지만

만약 조건에 맞는 인덱스 행을 찾았을 때 반환한 뒤 나머지 행을 또 찾아본다.


create index emp_deptno_sal
 on emp(deptno,sal);

select /*+ gather_plan_statistics index_ss(emp emp_deptno_sal) */
  ename,deptno, sal
 from emp
 where sal=2975;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

이렇게 하면 index skip scan 이라고 확인할 수 있다.

위의 코드를 예시로 index skip scan에 대해 자세하게 설명해보면,

먼저 인덱스는 deptno를 기준으로 sal이 정렬되어 있는 상태이고 (생성을 그렇게 했으니까)

인덱스에서 deptno를 쭉 보다가 where 절의 sal이 2975라는 걸 알았을 때, deptno는 20인데,

나머지 deptno가 20인 사원들은 그만 찾아보고,

다음 deptno인 30으로 넘어가서, 또 sal이 2975인 사원이 있는지 찾는다.

즉 deptno가 20인 데이터를 약간 스킵한 것이다.

지금은 작은 데이터라 체감이 되지 않지만, 대용량 데이터라면 큰 차이가 된다.

이게 가능한 이유는 deptno에 따라 sal도 asc로 정렬되어있기 때문! (결합 인덱스 생성할 때부터)