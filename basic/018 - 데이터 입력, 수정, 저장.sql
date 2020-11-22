계층형 질의문으로 서열을 주고 데이터 출력하기

** 순위와 서열을 출력하는 SQL 문

계층형 질의절은 Where 절 다음에 기술하며, from 절이 수행된 후 수행된다.

start with 절과 connect by 절로 구성되며, start with 절이 수행된 후 connect by 절이 수행된다.

또한 start with 절은 생략이 가능하다.

start with 절            --> 루트 노드를 생성하며 한 번만 수행된다.
connect by 절          --> 루트 노드와 하위 노드를 생성하며 조회 결과가 없을 때까지 반복 수행된다.

예제 : 1부터 10까지의 숫자를 출력하기

select level
 from dual
 connect by level <= 10;

* level : connect by 절을 써야만 출력되는 컬럼
* dual : 결과를 보기 위한 가상의 테이블
* connect by level (조건) : 조건이 만족하는 도안 계속해서 연결하겠다.

예제 : 사원 테이블의 서열 순서를 출력하기

(KING - 부하 직원 - 부하 직원 - ... )

select level, empno, ename, mgr
 from emp
 start with ename='KING'                                    <-- KING을 root로 해서 시작하겠다.
 connect by prior empno=mgr;

설명 : select 절에 level 이라는 컬럼은 emp 테이블에는 없는 컬럼이다.
그런데, 출력될 수 있었던 것은 connect by 절을 사용했기 때문이다.

예제 : BLAKE 기준 서열을 출력하기

select level, empno, ename, mgr
 from emp
 start with ename='BLAKE'
 connect by prior empno=mgr;

prior : connect by 절에 같이 쓰는 짝꿍 ( 서열을 출력하고 싶을 때 필수 )

예제 : emp 테이블의 서열을 SQL로 시각화하기

select rpad(' ',level*2) || ename as employee, level
 from emp
 start with ename='KING'                            
 connect by prior empno=mgr;

예제 : 위의 결과에서 BLAKE만 제외하고 출력하기

select rpad(' ',level*2) || ename as employee, level
 from emp
 where ename!='BLAKE'
 start with ename='KING'                            
 connect by prior empno=mgr;

BLAKE만 제외하고 싶으면 where 절에서 거르면 된다.

예제 : 위의 결과에서 BLAKE의 팀원들까지 제외하고 출력하기

BLAKE의 팀원들까지 제외하고 싶다면 connect by 절에서 거르면 된다.

BLAKE라는 상위 노드가 삭제되면 그 팀원(하위 노드)들은 같이 사라지기 때문

예제 : 다시 BLAKE와 BLAKE 팀원들을 포함시킨 서열을 출력하는 SQL을
   월급이 높은 순서대로 출력하기

select rpad(' ',level*2) || ename as employee, level, sal
 from emp
 start with ename='KING'                            
 connect by prior empno=mgr
 order by sal desc;

** 위의 결과는 월급이 높은 순서대로 정렬되면서 서열로 정렬된 결과가 사라져버렸다.

예제 : 위의 결과를 다시 서열로 정렬된 결과를 유지하면서 월급이 높은 순서대로 정렬되게 출력하기

select rpad(' ',level*2) || ename as employee, level, sal
 from emp
 start with ename='KING'                            
 connect by prior empno=mgr
 order siblings by sal desc;

** 결과를 보면 같은 서열 내에서 월급이 높은 순서대로 정렬이 되고 있다.

계층형 질의문을 사용할 때 ORDER BY 절을 쓸 때는 SIBLINGS 라는 키워드를 짝꿍으로 사용해야 한다.

예제 : 이름과 입사일과 서열 순위를 출력하는데, 서열 순위의 정렬 상태를 유지하면서

먼저 입사한 사원 순으로 출력하기

select rpad(' ',level*2) || ename as employee, hiredate, level
 from emp
 start with ename='KING'
 connect by prior empno=mgr
 order siblings by hiredate asc;