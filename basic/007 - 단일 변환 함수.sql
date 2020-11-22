null 값 대신에 다른 값을 출력하고 싶을 때 사용하는 함수( nvl 함수)

nvl( 컬럼명, null 대신 출력할 값 )

select ename, comm                                                                
  from emp;                                                                               

select ename, nvl(to_char(comm),'no comm')
  from emp;
                                                         
-- emp 테이블의 사원과 커미션을 확인

if 문을 SQL로 구현할 때 사용하는 함수 1 (decode 함수)

if 문 : 만약에 무슨일이 벌어지면 어떻게 행동하라고 컴퓨터 프로그래밍을 하는것

decode( 컬럼명, 조건1, 출력1, 조건2, 출력2, [그 밖의 경우] 출력 3 ) 


예제 : 부서번호가 10이면 5600을 출력하고 20이면 4500을 출력하고 나머지 부서번호는 0을 출력하기

select ename, sal, deptno, decode(deptno,10,5600,20,4500,0) as 보너스
 from emp;

하지만 decode는 특정 값과 같은 경우(=)만 거를 수 있고, 특정 값 이상일 때, 이하일 때 같은 부등호 비교는 불가능.

그럴 때 사용하는 것이 case 문이다.

if 문을 SQL로 구현할 때 사용하는 함수 2 (case 문)

case when 컬럼명 부등호조건문1 then 출력1 when 부등호조건문2 then 출력 2 else 출력 3 end

예제 : 이름, 월급, 부서번호, 보너스를 출력하는데 보너스가 부서번호가 10번이면 500을 출력하고
	부서번호가 20번이면 300을 출력하고 나머지 부서번호면 0을 출력하시오

select ename, sal, deptno, case when deptno=10 then 500 when deptno=20 then 300 else 0 end as 보너스
   from emp;
