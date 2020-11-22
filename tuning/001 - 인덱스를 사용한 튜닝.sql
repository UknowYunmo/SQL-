�ε����� ����Ͽ� Ʃ���ϴ� ���


Ʃ���� :

 explain plan for
  select /*+ index(emp emp_sal) */ ename, sal
   from emp
   where sal*12=36000;


-- ���� sal���� �ε����� �ִ� ��Ȳ�̰�, �ε����� �������϶�� ��Ʈ�� ��µ��� �ұ��ϰ�

���� ��ȹ�� full table scan�� �ߴ�.

�ֳ��ϸ�

where ���� �ε��� �÷��� ���� �Ǿ��� ����.



��� Ʃ���ؾ� �ε��� scan�� �ϵ��� ���� �� ������?


explain plan for
  select /*+ index(emp emp_sal) */ ename, sal
  from emp where sal=36000/12;


select * from table(dbms_xplan.display);


Ʃ�� �� :

select /*+ index(emp emp_job) */ ename, job
 from emp
 where substr(job,1,5) = 'SALES';


Ʃ�� �� :

select /*+ index(emp emp_job) */ ename, job
  from emp
  where job like 'SALES%';


** ����(�º�)�� �ִ� �ε��� �÷��� �����ϸ� full table scan �ع����� �캯�� ��������.



Ʃ�� ��:

select /*+ index(emp emp_hiredate) */ ename, hiredate
 from emp
 where to_char(hiredate,'RRRR') = '1981';

Ʃ�� ��:

select /*+ index(emp emp_hiredate) */ ename, hiredate
 from emp
 where hiredate between to_date('1981/01/01','RRRR/MM/DD')
                    and to_date('1981/12/31','RRRR/MM/DD');


Ʃ�� ��:

select ename, sal, job
 from emp
 where job='SALESMAN'
 order by sal desc;


Ʃ�� ��:

select /*+ index_desc(emp emp_sal) */ ename, sal, job
  from emp
  where sal > 0 and job='SALESMAN';



** ���� ������ �ε��� ����� Ȯ���ϴ� ���


select index_name
 from user_indexes
 where index_name like 'EMP%';


** �ε����� �����ϴ� ��

drop index emp_ename;

