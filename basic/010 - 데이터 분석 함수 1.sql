데이터 분석 함수 :  데이터 분석을 용이하게 하기 위해서 제공하는 함수 

1. 순위를 출력하는 함수 1( RANK )

예제: 이름, 월급, 월급에 대한 순위를 출력하기

 select ename, sal, rank()  over ( order  by  sal  desc) as 순위
   from  emp;

예제 : 직업, 이름, 월급,  순위를 출력하는데 [[직업별로]] 각각 월급이 높은 순서대로 순위를 출력하기

 select   job,  ename, sal,  rank()  over ( order by  sal desc )  as 순위
   from emp 
   group by job;

-- GROUP BY 표현식이 아닙니다 ㅠ

rank 함수에는 group by 말고 partition by 를 사용해야 한다.

 select   job,  ename, sal, rank()  over  ( partition by job
                                                    order  by sal desc )  as  순위
  from  emp;


partition by 는 데이터 분석함수에서 괄호 안에 쓰는 문법으로

partition by job 이라고 하면 직업 별로 각각 파티션해서 나누겠다는 것이다. 


그래서 아래의 뜻은 

rank()  over  (  partition   by   job   <-- 직업별로 파티션해서 
                   order  by  sal desc )  <-- 월급이 높은 순서로 순위를 출력하겠다. 가 된다.


2. 순위를 출력하는 함수 2 ( DENSE_RANK )


 select   job,  ename, sal, 
 rank() over ( order by sal desc )  as  순위,
 dense_rank() over ( order by sal desc )  as  순위2
   from emp ;

순위는 rank()를 사용했고, 순위2는 dense_rank()를 사용했는데, 약간의 차이가 있다. 무엇일까?

같은 순위가 여러개 나오면 다음 순위가 그 다음 순위가 중복된 수만큼 더해서 출력되는것이 rank 이고

중복되었더라도 그냥 바로 그 다음 순위가 나오는게 dense_rank() 이다.

3등이 2명이었다면 rank는 5위부터 나오지만, dense_rank는 4위부터 나온다.


3. 등급을 출력하는 함수 ( NTILE )

rank와 거의 비슷하지만 NTILE() --< 여기 괄호 사이에 몇 등급으로 나눌지 명시해줘야한다.

예제 : 직업, 이름, 월급, 등급을 출력하는데 직업별 각각 등급이 3등급으로 나눠지게 하시오 !
                                                                  (월급이 높은 순서로 등급)

select  job, ename, sal,  ntile(3)  over ( partition by job 
                                                  order  by  sal  desc ) 등급
    from  emp;

3등급으로 나눌 때 2명밖에 없어 두 등급으로 밖에 나눌 수 없다면, 2까지만 출력 된다.

4. 순위의 비율을 출력하는 함수 ( CUME_DIST )

select  ename, sal,  
         cume_dist()  over ( order  by  sal  desc ) 비율
  from  emp;

...
round를 활용해서 보기 좋게 만들자.

select  ename, sal,  
       round( cume_dist()  over ( order  by  sal  desc ), 3 ) * 100 || '%' as 비율
  from emp;