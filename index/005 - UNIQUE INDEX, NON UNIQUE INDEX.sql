non unique index : 값이 중복되어도 상관없이 그냥 생성되는 인덱스


UNIQUE INDEX : 중복된 데이터가 없을 때, 사용할 수 있는 인덱스


UNIQUE INDEX를 생성할 때 unique 라고 명시해주기만 하면 된다.


예제 : empno와 deptno에 non unique index 만들기


create unique index emp_empno on emp(empno);


create unique index emp_deptno on emp(deptno);


empno에는 잘 생겼지만, deptno에는 작성할 수 없다고 오류가 뜬다.


이미 deptno에 중복된 데이터들이 있기 때문이다.


예제 : 사원 이름에 unique index를 걸고, 이름이 scott인 사원의 이름과 월급 조회하기


create unique index emp_ename on emp(ename);


select /*+ gather_plan_statistics */ ename, sal
 from emp
 where ename='SCOTT';

 SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


예제 : unique index가 아닌, 일반 인덱스로 조회하기


drop index emp_ename;


create index emp_ename on emp(ename);

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where ename='SCOTT';


 SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


SCOTT은 어차피 한 명인데,

왜 여기선 INDEX RANGE SCAN 이라고 나올까??

이유 : 인덱스에서 SCOTT을 찾아서 결과를 출력해도, SCOTT이 여러 명일수도 있기 때문에, 그 다음 한 명을 더 읽고, 그 다음 한 명이 SCOTT이 아닌걸 확인해야 멈추기 때문에
최소 2명을 타기 때문

그리고 최소 2명 이상 타면 INDEX RANGE SCAN 이다.


반면, unique 인덱스는 인덱스에서 그 데이터만 읽고 끝내기 때문에 non unique보다 훨씬 좋은 인덱스라고 할 수 있다.


예제 : 사원 번호가 7788 번인 사원의 사원 번호와 사원 이름을 출력하는 쿼리문의 실행 계획 확인하기


drop index emp_empno;


create unique index emp_empno on emp(empno);


select /*+ gather_plan_statistics index(emp emp_empno)*/ empno, ename
 from emp
 where empno=7788;


 SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


* 지금까지 만든 인덱스 리스트 확인하기

select =index_name, uniqueness
 from user_indexes
 where table_name='EMP';