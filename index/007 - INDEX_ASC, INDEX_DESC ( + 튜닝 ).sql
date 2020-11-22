index_asc �� index_desc �� Ȱ���ؼ�

order by ������ ������ ���� ������ © �� �ִ�.

��뷮 �����ͺ��̽��ϼ��� ���̰� ũ��.

���� : ������� �̸��� ������ ����ϴµ� ���� ������!

Ʃ�� ��:

create index emp_sal on emp(sal);

select /*+ gather_plan_statistics (emp emp_sal) */
 ename, sal
 from emp
 order by sal desc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

Ʃ�� ��:

create index emp_sal on emp(sal);

select /*+ gather_plan_statistics index_desc(emp emp_sal) */
 ename, sal
 from emp
 where sal >= 0;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

** sal�� �ִ� index�� ����Ϸ���

where �� ���ǿ� ������ sal�� �־���Ѵ�.

���� : ��� �ִ� ������ ����ϱ�

Ʃ�� �� :

select /*+ gather_plan_statistics index(emp emp_sal) */
 max(sal)
 from emp;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

���۴� 1������ sort�� �Ͼ�� ���� ������ �Ͼ�ٴ� ���ε�,

������ �Ѵٴ� ���� ������ �뷮�� Ŭ ���� �ð��� �� �ɸ��� �۾��̹Ƿ� ���� ���� ����.

Ʃ�� �� :

select /*+ gather_plan_statistics index_desc(emp emp_sal) */
 sal
 from emp
 where sal >= 0 and rownum =1;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

���� : �ִ� ������ ���� ����� �̸��� ������ ����ϱ�

Ʃ�� ��:

select /*+ gather_plan_statistics index(emp emp_sal) */
 ename, sal
 from emp
 where sal = ( select max(sal)
from emp );

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

Ʃ�� �� :

select /*+ gather_plan_statistics index_desc(emp emp_sal) */
 ename, sal
 from emp
 where sal >= 0 and rownum=1;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

���� : �μ���ȣ�� 20�� ������� ��� ��ȣ, �μ� ��ȣ, ������ ����ϴµ� ���� ������!

create index emp_deptno_sal on emp(deptno,sal);

Ʃ�� �� : 

select /*+ gather_plan_statistics index(emp emp_deptno_sal) */
 ename, deptno, sal
 from emp
 where deptno=20
 order by sal desc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

** ���۴� 2����, sort order by�� �ִ�.

sort�� �����͸� �� �����ϱ� ������ ������ ���ؼ� �ǵ��� ���� ���� ����.

Ʃ�� �� :

select /*+ gather_plan_statistics index_desc(emp emp_deptno_sal) */
 ename, deptno, sal
 from emp
 where deptno=20;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� : 1981�⿡ �Ի��� ����� �̸��� �Ի����� �ֱ� �Ի��� ��� ������ ����ϱ�

create index emp_hiredate on emp(hiredate);

Ʃ�� �� :

select /*+ gather_plan_statistics index(emp emp_hiredate) */
 ename, hiredate
 from emp
 where to_char(hiredate,'RRRR')='1981'
 order by hiredate desc;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

�ϴ� �⺻���� ��Ģ�� where ���� �º��� �ǵ帮�� ���ƾ��ϴ� �� ��Ű�� �ʾƼ�

�ε����� �ߵ������� �ʾƼ� ���̺��� Ǯ�� access �߰�,

order by ���� �ع�����

��ǻ� �ƹ��� �ǹ̰� ���� Ʃ���̾���.


Ʃ�� �� :

select /*+ gather_plan_statistics index_desc(emp emp_hiredate) */
 ename, hiredate
 from emp
 where hiredate between to_date('1981/01/01','RRRR/MM/DD')
   and   to_date('1981/12/31','RRRR/MM/DD');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));