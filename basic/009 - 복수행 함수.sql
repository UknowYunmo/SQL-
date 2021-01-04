* 복수행 함수


1. 데이터의 개수를 세는 집계 함수 (count)

예제 : 사원 테이블에 들어있는 사원이 몇 명인지 출력하기

select count(*)
 from emp;

15명의 사원이 들어있는 emp 테이블이기 때문에 15가 출력되었다.

2. 수치 데이터 칼럼의 합계를 출력하는 함수 (SUM)

예제 : 직업이 SALESMAN인 사원의 월급의 총합을 출력하기

select sum(sal)
 from emp
 where job='SALESMAN';

3. 수치 데이터 컬럼의 평균을 출력하는 함수 (AVG)

select avg(comm)                                                                                        
 from emp;                                                                                                 

select avg(nvl(comm,0))
 from emp;                                                                                                 

nvl로 comm을 덮었지만 사실 nvl은 null 값을 0으로 바꾸기 때문에 값에 영향을 줄 수 없을 것 같다.

그런데 왜 두 개의 결과 값이 달라졌을까?

집계 함수는 null 값을 0으로 보지 않고, 계산 자체를 건너뛰어 버린다.

그래서 1번의 경우는 comm이 없는 경우 나누질 않아서 더 크고,

2번은 comm이 없는 경우를 0으로 바꿔서 계산에 포함되었기 때문에 제대로 평균이 구해졌다.

4. 수치 데이터 컬럼의 최대, 최소값을 구하는 함수 ( max, min ) 

select max(sal), min(sal)
 from emp;


5. 그룹 별로 집계 결과를 볼 수 있도록 하는 절 (group by)

select job, max(sal),min(sal),avg(sal)
 from emp
 group by job;

select job, max(sal),min(sal),round(avg(sal))
 from emp
 where job is not null
 group by job
 order by job;

-- 배운 것들을 활용해서 깔끔하게 정렬