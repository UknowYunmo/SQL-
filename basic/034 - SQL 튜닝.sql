데이터가 대부분 대용량이기 떄문에

데이터를 빠르게 검색하기 위해서는 

SQL 튜닝을 할 수 있어야한다.


* SQL 튜닝


데이터 검색 속도를 향상시키는 기술


* 인덱스 엑세스 방법 8가지



  인덱스 엑세스 방법                                          힌트            

1. index range scan                                        index

2. index unique scan                                       index

3. index skip scan                                         index_ss

4. index full scan                                         index_fs

5. index fast full scan                                    index_ffs

6. index merge scan                                        and_equal

7. index bitmap merge scan                              index_combine

8. index join                                             index_join



* 오라클 힌트 ( hint )



오라클 옵티마이저가 SQL을 수행할 때 실행 계획을 SQL 사용자가 조정하는 명령어


옵티마이저에게 문법에 맞는 적절한 힌트를 주면, 옵티마이저는 사용자가 요청한 대로 실행 계획을 만든다.



* 실행 계획 보는 법

explain plan for
 select ename, sal
  from emp
  where sal >= 1400;


select * from table ( dbms_xplan.display );  --> SQL 문의 결과를 보는 것이 아니라, 실행 계획만 확인한다




실행 계획에 full table scan 으로 나오면 emp테이블을 처음부터 끝까지 쭉 스캔했다는 뜻이다.




* SQL 문 보면서 실행 계획까지 같이 보고 싶을 떄


select /*+ gather_plan_statistics */ ename, sal
 from emp
 where sal = 1300;

 SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



결과문에 있는 buffers의 개수가 적을수록 튜닝의 성능이 좋다.



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