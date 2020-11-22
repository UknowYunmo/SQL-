* index full scan


- 인덱스 전체를 full로 읽어서 원하는 데이터를 엑세스 하는 방법


예제 :

select /*+ gather_plan_statistics */ count(*)
  from emp;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



이렇게 해보면, index full scan을 확인할 수 있다.


원래 emp 테이블에서 count(*)를 해도 14가 나오는데

생각해보면 이 14는 count 되는 과정에서 emp에 있는 모든 컬럼을 한 번씩 계속 훑어서 자료가 있으면 1을 더한다.

즉, 테이블 전체를 가로로 끝까지 훑은 다음에, 세로로 또 계속 반복해서 훑는 것이다.

반면 index full scan은 인덱스가 걸린 컬럼 내에서 세로로 쭉 훑는 것과 같다.

즉, 기능은 같지만, 한 개의 컬럼 내에서 조회하기 때문에 속도 면에서 차이가 크다.

그리고 버퍼의 개수도 1개이다.

만약 full table scan이 되도록 바꾸고 싶다면,

select /*+ gather_plan_statistics full(emp) */ count(*)
  from emp;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


위와 같이 힌트에 full ( 테이블명 ) 을 명시하면 full table scan을 한다.


똑같은 결과를 버퍼의 개수를 6 --> 1 로 바꿨기 때문에 아까 약 6배 정도 성능이 좋아졌었다는 것을 알 수 있다.


** index fast full scan

인덱스를 처음부터 끝까지 스캔하는 방법은 index full scan 과 똑같으나

index fast full scan이 index full scan과 다른 점은

인덱스를 full로 읽을 때 mult block i/0 를 한다는 점이다.


* multi block i/o


책의 앞에 목차가 1페이지 ~ 100페이지라고 한다면,

index full scan은 한 페이지 한 페이지씩 넘기는 게 index full scan 이고

index fast full scan은 한 번 넘길 때 10장씩 넘기는 것이다.


예제 : 직업, 직업별 인원수를 출력하기

create index emp_job on emp(job);

select /*+ gather_plan_statistics emp_job */ job, count(job)
  from emp
  group by job;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


** 위와 같이 index 힌트를 줘도 테이블 full scan을 하는 이유는 job 컬럼에 not null 제약이 없기 때문이다.

index fast full scan을 하려면 not null 제약이 있어야 한다.


* job에 not null 제약 생성하기

alter table emp
 modify job constraint emp_job_nn not null;


- not null 제약 걸고, 재실행 해보자

select /*+ gather_plan_statistics index_ffs(emp emp_job) */ job, count(job)
  from emp
  group by job;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


INDEX FAST FULL SCAN, 버퍼도 4로 줄어들었다.


예제 : 부서번호, 부서 번호별 인원수를 출력하는데 index fast full scan 이 될 수 있도록 인덱스도 걸고

not null 제약도 걸고 힌트도 줘서 실행되도록 하기

create index emp_deptno on emp(deptno);

alter table emp
 modify deptno constraint emp_deptno_nn not null;

 
select /*+ gather_plan_statistics index_ffs(emp emp_deptno) */ deptno, count(deptno)
  from emp
  group by deptno;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


* INDEX FAST FULL SCAN은 INDEX FULL SCAN 보다 빠르지만, 대신 출력될 때 정렬이 되지 않는다.