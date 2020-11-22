1. 데이터를 가로로 출력하는 함수 ( LISTAGG )

지금까지는 데이터를 세로로 출력했지만
사실 다른 사람에게 많은 데이터를 보여줘야 할 경우에
가로로 출력하는 경우가 더 보기 나을 수 있다.

그럴 때 사용하는 함수가 LISTAGG

기본 문법은 LISTAGG( 컬럼명, 컬럼 사이에 넣을 구분자 ) within group ( order by 컬럼명 asc or desc ) 이다.

일단 emp 테이블의 deptno에 따른 사원들을 확인해보자

select deptno, ename
 from emp
 order by deptno;

이렇게 하면 확인할 수 있는데, 한 번에 보기가 힘들다.
데이터 양이 더 많다면, 커서를 내려야해서 보기 좋지 않을 것 같다.

이제 listagg를 써보자.

select  deptno, listagg(ename, ', ' )  within  group ( order by  ename asc ) 이름
   from emp
   group  by deptno; 

이렇게 하면 deptno 별로 이름을 한 번에 확인할 수 있다.

2. 데이터의 바로 전 행과 다음 행 출력하는 함수 ( LAG, LEAD )

LAG - 명시된 값을 기준으로 이전 로우의 값 반환
LEAD - 명시된 값을 기준으로 이후 로우의 값 반환

select  ename, hiredate,  
  lag(hiredate,1) over ( order by hiredate asc)   전행,
  lead(hiredate,1) over ( order  by hiredate  asc ) 다음행
 from  emp;

