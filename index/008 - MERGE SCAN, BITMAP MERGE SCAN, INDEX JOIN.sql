1. index merge scan (and equal)

*�� ���� �ε����� ���ÿ� ����Ͽ� �ϳ��� �ε����� ������� ������
 �� ���� ������ ���̴� ��ĵ ���

���� : 

create index emp_deptno on emp(deptno);
create index emp_job on emp(job);

select /*+ gather_plan_statistics */
 ename, deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

���� ��Ʈ�� �� �ְ�, where ������ �� �ε����� �´� ������ �༭

deptno�� job�� �ɸ� �ε��� �� �ƹ��ų� ���� �غ���

Ȯ���غ���, ��Ƽ�������� emp_job �ε����� �����ߴ�.

�׷�, deptno �ε����� Ÿ���� ��Ʈ�� �ຸ��.

select /*+ gather_plan_statistics index(emp emp_deptno) */
 ename, deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


�ٵ�, �̷��� �� ���� ���� �ε��� �� �� �ϳ��� �� Ż �� �־��µ�,

�� ��Ƽ�������� job�� �˾Ƽ� ���������?

--> ������ ��� �д� ��(deptno���� ������ ª�� �д� ���� �� ������ ������

 select count(*) from emp where job='SALESMAN';     --> 4���� ���
 select count(*) from emp where deptno=30;            ---> 6���� ���

4���� ������ �а� 4���� ���� ��ȯ�ϴ� �Ͱ�
6���� ������ �а� 4���� ���� ��ȯ�ϴ� ���� ���� ����̴��� �ӵ��鿡�� ���̰� ����.

�ٵ� ó���� �ƹ��ų� �����ϰ� ���� �� �� ȿ������ job �ε����� ������ ����

���� ����ϴ� sql ���α׷��� ��Ƽ�������� �� ���� �н��� ������ �����̰�,

�ٸ� ��ǻ�Ϳ��� �Ȱ��� ���̺�� ���� sql ���� �־��ٸ� Ǯ ��ĵ�� ���� ���� �ִ�.

��·��,

���� ���� �� �� �ϳ��� ��� ����ϴ� ���� �ƴϰ�,

2���� �ε����� ��� ����ؼ� �� ū �ó��� ȿ���� ���� �ʹٸ�

index merge scan�� ����� �� �ִ�.

* index merge scan ���

select /*+ gather_plan_statistics and_equal(emp emp_job emp_deptno) */
 ename, deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

??�ٵ� ������ ���� ���°�??

** ���� merge scan�� ���� ����̴�..

����� �� ���� merge scan�� �����Ѵ�.

2. index bitmap merge scan ( index_combine )

�� ���� �ε����� ���� ��ĵ�ؼ� �ó��� ȿ���� ���� �����

index merge scan�� ���������� ���̴� bitmap�� �̿��ؼ�

�ε����� ����� ���� ���� ���δٴ� ��.  --> ��ĵ �ð��� ª������

�� : å�� ������ �˻��ϱ� ���� �� ���� ������ ���� �а� ����ؼ�

������ A4 �� �������� ����� ������ ������ �� ������ ���캼 �� �ִ�.

��Ʈ�� index_combine�� ���� ���̺� �� �����ָ� �ȴ�.

select /*+ gather_plan_statistics index_combine(emp) */
 ename, deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

�׷��� �˾Ƽ�...

�� ȥ�� ���� ������ �� �� �� �� �� �ִ�..

�׷�.. ���߾�

��·�� ������ ���� �ٰ�, �ð��� �پ�� ���� Ȯ���� �� �ִ�!

3. index join ��ĵ ( index_join )

* �ε������� ������ �ؼ� �ٷ� ����� ����
  ���̺� �������� ���� ���� �ʴ� ��ĵ ���

select /*+ gather_plan_statistics index_join(emp emp_deptno emp_job) */
 deptno, job
 from emp
 where job='SALESMAN' and deptno=30;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

���� �ε����� ���� �� ���� ���� �ε����� ���� ���� �� ������? �� ���� �ʴ� �ε��� �����̴�.