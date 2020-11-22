non unique index : ���� �ߺ��Ǿ ������� �׳� �����Ǵ� �ε���


UNIQUE INDEX : �ߺ��� �����Ͱ� ���� ��, ����� �� �ִ� �ε���


UNIQUE INDEX�� ������ �� unique ��� ������ֱ⸸ �ϸ� �ȴ�.


���� : empno�� deptno�� non unique index �����


create unique index emp_empno on emp(empno);


create unique index emp_deptno on emp(deptno);


empno���� �� ��������, deptno���� �ۼ��� �� ���ٰ� ������ ���.


�̹� deptno�� �ߺ��� �����͵��� �ֱ� �����̴�.


���� : ��� �̸��� unique index�� �ɰ�, �̸��� scott�� ����� �̸��� ���� ��ȸ�ϱ�


create unique index emp_ename on emp(ename);


select /*+ gather_plan_statistics */ ename, sal
 from emp
 where ename='SCOTT';

 SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� : unique index�� �ƴ�, �Ϲ� �ε����� ��ȸ�ϱ�


drop index emp_ename;


create index emp_ename on emp(ename);

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where ename='SCOTT';


 SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


SCOTT�� ������ �� ���ε�,

�� ���⼱ INDEX RANGE SCAN �̶�� ���ñ�??

���� : �ε������� SCOTT�� ã�Ƽ� ����� ����ص�, SCOTT�� ���� ���ϼ��� �ֱ� ������, �� ���� �� ���� �� �а�, �� ���� �� ���� SCOTT�� �ƴѰ� Ȯ���ؾ� ���߱� ������
�ּ� 2���� Ÿ�� ����

�׸��� �ּ� 2�� �̻� Ÿ�� INDEX RANGE SCAN �̴�.


�ݸ�, unique �ε����� �ε������� �� �����͸� �а� ������ ������ non unique���� �ξ� ���� �ε������ �� �� �ִ�.


���� : ��� ��ȣ�� 7788 ���� ����� ��� ��ȣ�� ��� �̸��� ����ϴ� �������� ���� ��ȹ Ȯ���ϱ�


drop index emp_empno;


create unique index emp_empno on emp(empno);


select /*+ gather_plan_statistics index(emp emp_empno)*/ empno, ename
 from emp
 where empno=7788;


 SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


* ���ݱ��� ���� �ε��� ����Ʈ Ȯ���ϱ�

select =index_name, uniqueness
 from user_indexes
 where table_name='EMP';