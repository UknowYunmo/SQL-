계층형 질의문으로 서열을 주고 데이터 출력하기2

계층형 질의문과 짝꿍 함수인 sys_connect_by_path를 이용하면

listagg를 사용한 것처럼 가로로 결과를 출력할 수 있다.

예제 : 사원들의 노드 경로를 가로로 출력하기

select ename, sys_connect_by_path(ename,',') as path
 from emp
 start with ename='KING'
 connect by prior empno=mgr;

이렇게 경로를 이름을 가로로 나열해서 출력할 수 있다.

예제 : 위의 결과에서 맨 앞 기호를 잘라버리시오

select ename, ltrim(sys_connect_by_path(ename,','),',') as path
 from emp
 start with ename='KING'
 connect by prior empno=mgr;

** 계층형 질의문을 작성할 때 반드시 알아야하는 두 가지 짝꿍 키워드

1. order by 절의 siblings
2. 서열을 가로로 출력하는 sys_connect_by_path 함수

계층형 질의문에서도 조인 문장을 같이 쓸 수 있다.

예제 : 이름, 서열, 월급과 부서위치를 출력하기

select rpad(' ',level*2) || ename as employee, level, e.sal, d.loc
 from emp e, dept d
 where e.deptno = d.deptno                                             <-- 조인 조건 (연결 고리 )
 start with ename='KING'
 connect by prior empno = mgr;

예제 : 이름, 서열, 월급, 급여 등급(grade)를 출력하기

select rpad(' ',level*2) || ename as employee, level, e.sal, s.grade
 from emp e, salgrade s
 where e.sal between s.losal and s.hisal
 start with ename='KING'
 connect by prior empno = mgr;

예제 : 위의 결과를 다시 출력하는데 서열의 정렬을 유지하면서 급여등급이 높은 사원부터 출력하기

select rpad(' ',level*2) || ename as employee, level, e.sal, s.grade
 from emp e, salgrade s
 where e.sal between s.losal and s.hisal
 start with ename='KING'
 connect by prior empno = mgr
 order siblings by s.grade desc;

예제 : DALLAS에서 근무하는 사원들의 이름, 서열, 부서위치를 출력하기 ( 서열은 전체 사원을 기준으로 )

select rpad(' ',level*2) || ename as employee, level, d.loc
 from emp e, dept d
 where e.deptno=d.deptno and d.loc = 'DALLAS'
 start with ename='KING'
 connect by prior empno = mgr;