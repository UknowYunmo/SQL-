1. 데이터를 누적해서 합계하는 데이터 분석 함수 ( SUM_OVER )

SUM( 컬럼명 ) OVER ( order by 컬럼명 desc or asc )

예제: 사원번호, 이름, 월급, 월급의 누적치를 출력하기

select   empno, ename, sal,  sum(sal)  over ( order  by  empno  asc) 누적치
    from   emp; 

맨 오른쪽에 누적치가 점점 쌓이는 것을 확인.

over가 보이면 감이 올 것이다.

물론 다른 함수들과 마찬가지로 partition by를 사용할 수 있다.

예제: 직업, 월급, 직업별 총합 누적치를 출력하기

select  job,  ename, sal,  sum(sal)  over  (  partition  by  job 
                                                       order  by  ename  )  누적치
   from  emp;

2.  비율을 출력하는 데이터 분석 함수 (RATIO_TO_REPORT)


전체 데이터 중에서 비율이 어떻게 되는지 확인하는 함수

예제 : 직업이 SALESMAN인 사원들의 월급의 비율을 각각 출력하기

select  ename, sal, round( ratio_to_report(sal)  over() ,2 )   as  비율
            from   emp
            where  job='SALESMAN' ;

3. 집계 결과 출력하는 데이터 분석 함수 ( ROLLUP )

집계한 결과를 맨 아래쪽에 출력하고 싶을 때 사용하는 함수

예제 : 부서별 월급의 총합을 출력하고, 전체 인원의 월급의 총합도 맨 밑에 출력하기

사용 방법은 일반적으로 GROUP BY를 실행하고, 컬럼명 앞에 ROLLUP을 쓰고 괄호로 감싸준다.

select  deptno, sum(sal)
  from  emp
  where deptno is not null
  group by rollup(deptno);


4. 집계 결과 출력하는 데이터 분석 함수 ( CUBE )

집계 결과를 위쪽에 출력하는 함수

사용 방법도 ROLLUP과 같고, 차이점은 밑이 아니라 맨 위에 총합을 출력한다는 것뿐이다.

select  job, sum(sal)
  from  emp
  where job is not null
  group  by  cube( job );

5.집계 결과 출력하는 데이터 분석 함수 ( GROUPING SETS )

GROUPING SETS는 여러 그룹핑 쿼리를 함께 표현하기 편하다.

이렇게 하면 같은 직업이라도 mgr, 부서 번호에 따라 각각 카운트 된다.

grouping sets로 rollup과 동일하게 할 수 있다.

중복되지 않는 empno와 ename을 grouping sets로 묶으면, 각각 sum이 되더라도 개체값으로 나오고,

마지막으로 () 을 넣어서, 전체 토탈 월급을 출력한다.

select  empno, ename, sum(sal)
   from   emp
   group  by grouping sets((empno,ename),());