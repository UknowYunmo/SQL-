1. COLUMN을 ROW로 출력하는 방법 1 ( SUM + DECODE )

일단 먼저, emp 테이블의 부서번호 (deptno) 별로 월급의 총합을 확인하고 싶다고 가정하자.

select deptno, sum(sal)
 from emp
 group by deptno
 order by deptno;

이것을 가로로 출력해야하면 어떻게 할까?

이전에 배운 DECODE 함수를 활용해야 한다.

DECODE ( 컬럼명, 조건1, 출력 1, 조건2, 출력 2, 그 외 출력 3 ) 으로 실행되는데,

예제로 

select  decode( deptno, 10, sal , 0  )  
   from  emp;

를 실행해보자

이렇게하면 부서 번호가 10인 경우만 sal(월급) 이 출력되고 나머지 20, 30 같은 경우는 0이 출력된 것을 볼 수 있다.

이 행을 띄우면 다음은 간단하다.

sum으로 이 모든 행을 더해주면
다음과 같이 딱 한 행에 부서번호가 10인 사원들의 월급 총합이 구해진다.

select  sum( decode( deptno, 10, sal , 0  )  )  as "10"
   from  emp;

그렇다면 한 번에 다른 부서들도 해보자.

select  sum( decode( deptno, 10, sal , 0  )  )  as  "10",
         sum( decode( deptno, 20, sal , 0  )  )  as  "20",
         sum( decode( deptno, 30, sal , 0  )  )  as  "30"
   from  emp;

***

select  sum( decode( telecom, 'sk', age, 0  )  )  as  "sk",
         sum( decode( telecom, 'lg', age, 0  )  )  as  "lg",
         sum( decode( telecom, 'kt', age, 0  )  )  as  "kt"
   from  emp12;

이 코드는 정상적으로 작동하지만, 이것이 엄청난 크기의 데이터라고 가정했을 때, 효율을 크게 높일 수 있는 방법이 있다.
한 부분만 바꿔주면 되는데, 어디일까?

select  sum( decode( telecom, 'sk', age )  )  as  "sk",
         sum( decode( telecom, 'lg', age  )  )  as  "lg",
         sum( decode( telecom, 'kt', age,  null )  )  as  "kt"
   from   emp12;

정답은 0 대신 비워놓거나 null 값을 넣는 것이다.

이전에 언급한 적이 있는데 sum, avg 같은 집계 함수는 null 값을 바로 건너뛰어버린다.

하지만 잘못된 예시처럼 0으로 바꾸면 집계 할 때 일일이 다 계산 과정에 포함시키기 때문에 값이 잘못되거나 느려질 수 있다.

2. COLUMN을 ROW로 출력하는 방법 2 ( PIVOT )

세로를 가로로 출력하는 함수 PIVOT

select * from (피벗할 쿼리문) as result pivot ( 그룹함수(집계컬럼) for 피벗대상컬럼 in ([피벗컬럼값]...) as pivot_result


예제 : 

select   *       <-- pivot 문 사용할 때는 그냥 * 를 쓰는 게 좋다
        from  ( select  deptno, sal  from  emp )  <-- 사원 테이블에서 그냥 
                                                                   부서번호와 월급만 가져온다.  (emp 테이블명만 딱 쓸 수 없다.)
                                                                   결과를 보기위해서 필요한 컬럼만 선별해서 가져온다. 
        pivot   (  sum(sal)  for  deptno  in ( 10, 20, 30 )  )  ;
                       ↓        
                    토탈월급을 출력하겠다. 어떤 토탈월급?  부서번호를 위한 
                    어떤 부서번호 ?  10번, 20번, 30번의 부서번호 