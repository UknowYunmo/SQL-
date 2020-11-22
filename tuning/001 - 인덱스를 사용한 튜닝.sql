인덱스를 사용하여 튜닝하는 방법


튜닝전 :

 explain plan for
  select /*+ index(emp emp_sal) */ ename, sal
   from emp
   where sal*12=36000;


-- 지금 sal에는 인덱스가 있는 상황이고, 인덱스를 엑세스하라고 힌트를 줬는데도 불구하고

실행 계획이 full table scan을 했다.

왜냐하면

where 절의 인덱스 컬럼이 가공 되었기 때문.



어떻게 튜닝해야 인덱스 scan을 하도록 만들 수 있을까?


explain plan for
  select /*+ index(emp emp_sal) */ ename, sal
  from emp where sal=36000/12;


select * from table(dbms_xplan.display);


튜닝 전 :

select /*+ index(emp emp_job) */ ename, job
 from emp
 where substr(job,1,5) = 'SALES';


튜닝 후 :

select /*+ index(emp emp_job) */ ename, job
  from emp
  where job like 'SALES%';


** 왼쪽(좌변)에 있는 인덱스 컬럼을 가공하면 full table scan 해버리니 우변만 가공하자.



튜닝 전:

select /*+ index(emp emp_hiredate) */ ename, hiredate
 from emp
 where to_char(hiredate,'RRRR') = '1981';

튜닝 후:

select /*+ index(emp emp_hiredate) */ ename, hiredate
 from emp
 where hiredate between to_date('1981/01/01','RRRR/MM/DD')
                    and to_date('1981/12/31','RRRR/MM/DD');


튜닝 전:

select ename, sal, job
 from emp
 where job='SALESMAN'
 order by sal desc;


튜닝 후:

select /*+ index_desc(emp emp_sal) */ ename, sal, job
  from emp
  where sal > 0 and job='SALESMAN';



** 내가 생성한 인덱스 목록을 확인하는 방법


select index_name
 from user_indexes
 where index_name like 'EMP%';


** 인덱스를 삭제하는 법

drop index emp_ename;

