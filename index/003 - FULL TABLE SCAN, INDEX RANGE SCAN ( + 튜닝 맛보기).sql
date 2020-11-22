데이터가 대부분 대용량이기 떄문에

데이터를 빠르게 검색하기 위해서는 

SQL 튜닝을 할 수 있어야한다.



* SQL 튜닝

데이터 검색 속도를 향상시키는 기술



* 인덱스 엑세스 방법 8가지


  인덱스 엑세스 방법                                          힌트            

1. index range scan                                           index

2. index unique scan                                         index

3. index skip scan                                             index_ss

4. index full scan                                              index_fs

5. index fast full scan                                         index_ffs

6. index merge scan                                          and_equal

7. index bitmap merge scan                                index_combine

8. index join                                                    index_join



* 오라클 힌트 ( hint )

오라클 옵티마이저가 SQL을 수행할 때 실행 계획을 SQL 사용자가 조정하는 명령어

옵티마이저에게 문법에 맞는 적절한 힌트를 주면, 옵티마이저는 사용자가 요청한 대로 실행 계획을 만든다.

힌트는 마치 바둑 두는 데 훈수를 두는 것과 같아서,

만약 내가 말도 안되는 훈수라고 판단하면 무시하고, 합당한 힌트라고 판단하면 그에 따른다.


* 실행 계획 보는 법

explain plan for
 select ename, sal
  from emp
  where sal >= 1400;


select * from table ( dbms_xplan.display );  --> SQL 문의 결과를 보는 것이 아니라, 실행 계획만 확인한다


실행 계획에 full table scan 으로 나오면 emp테이블을 처음부터 끝까지 쭉 스캔했다는 뜻이다.


실행 계획의 종류 2가지

1. 예상 실행 계획 : SQL을 실행하기 전에 실행 계획을 예상한 것


- explain plan for

[+ 확인하고 싶은 SQL 문 작성]


select * from table(dbms_xplan.display);


2. 실제 실행 계획 : SQL을 직접 실행하면서 적용한 것을 바로 보여주는 실행 계획


- gather_plan_statistics 힌트


* SQL 문 보면서 실제 실행 계획까지 같이 보고 싶을 떄


select /*+ gather_plan_statistics */ ename, sal
 from emp
 where sal = 1300;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


buffer의 개수는 그 SQL 문을 처리하기 위해서 읽어들인 메모리 블럭의 개수이다.

따라서

결과문에 있는 buffers의 개수가 적을수록 빠르고, 튜닝의 성능이 좋다고 할 수 있다.




* 인덱스로 튜닝하기


1. sal 컬럼에 인덱스 걸기

create index emp_sal
 on emp(sal);


buffer가 줄고, full scan에서 index range scan으로 바뀌었다.



혹시 옵티마이저 성능이 좋지 않아서, 인덱스를 사용하지 않았다면, 힌트를 더 구체적으로 작성해야한다.

select /*+ gather_plan_statistics index(emp emp_sal) */ ename, sal
 from emp
 where sal = 1300;

 
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



예제 : 사원 번호, 이름, 월급, 직업을 출력하기 ( 튜닝 전 )

select /*+ gather_plan_statistics */ empno, ename, sal. job
 from emp
 where empno = 7788;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));




예제 : 사원 번호, 이름, 월급, 직업을 출력하기 ( 튜닝 후 )

create index emp_empno on emp(empno);


select /*+ gather_plan_statistics */ empno, ename, sal. job
 from emp
 where empno = 7788;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

                                   (패키지)   (프로시져)                (이거 안 써주면 buffers 안 나온다)



컴퓨터의 실행 순서는 거꾸로 2 - 1 - 0 이다.

즉 INDEX RANGE SCAN 으로 시작해서,

INDEX의 ROWID로, 테이블에 접근해서 조회했다는 뜻!

(ROWID를 조회해서 접근하는 인덱스의 구조는 저번에 설명했었다)




* 항상 조건절의 좌변을 수정하지 말자!! 인덱스가 발동되지 않는다.


예제1 : 직업이 SALESMAN인 사원들의 이름과 월급과 직업을 조회하기 ( 좌변 수정 ) 

select /*+ gather_plan_statistics index(emp emp_job)*/ ename, sal, job
  from emp
  where substr(job,1,5)='SALES';
  

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


보기와 같이 힌트에 인덱스를 줬는데도 사용하지 않고 FULL SCAN을 했다.




예제 2 : 직업이 SALESMAN인 사원들의 이름과 월급과 직업을 조회하기 ( 우변 수정 )

select /*+ gather_plan_statistics index(emp emp_job)*/ ename, sal, job
  from emp
  where job like 'S%';


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



인덱스가 정상적으로 발동되었다.





예제 : 사원의 월급이 30으로 시작하는 사원들의 이름과 월급을 출력하기

create index emp_sal on emp(sal);

select /*+ gather_plan_statistics index(emp emp_sal)*/ ename, sal
  from emp
  where sal like '30%';

 
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));




위와 같은 경우에는,

인덱스를 힌트에 직접 주었는데도 불구하고, full scan을 해버렸다.

18행을 보면, SQL에서 숫자형인 sal과 문자형인 '30%'을 맞춰주기 위해서 to_char()를 돌린 것을 확인할 수 있다.

일단 이런 경우, sal 을 테이블을 만들 때부터 문자형을 만들었던 것이 BEST.. ( 테이블 설계의 중요성 ? )

추후의 인덱스까지 고려해서 LIKE를 자주 사용할 것 같은 컬럼은 숫자형이 아닌, 문자형으로 만들자




** 해결책

- 함수 기반 인덱스를 생성해서 튜닝한다.


create index emp_sal_func
 on emp(to_char(sal));                       --> 인덱스를 만들 때 컬럼 자체에 함수로 둘러버리기


select /*+ gather_plan_statistics index(emp emp_sal)*/ ename, sal
  from emp
  where sal like '30%';


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));