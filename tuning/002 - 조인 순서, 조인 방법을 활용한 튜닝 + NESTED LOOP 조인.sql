SQL Ʃ�� ���

1. �ε��� SQL Ʃ�� : �ε��� ������ ��� 8����

** 2. ���� SQL Ʃ�� **

3. �������� SQL Ʃ��

4. ������ �м��Լ��� �̿��� Ʃ��

5. �ڵ� SQL Ʃ��


�������� Ʃ���� �ؾ��� �������� 10�����, �� �� 8�� ���� ���� �����̴�.


** ���� SQL Ʃ�� ��� **

1. NESTED LOOP ����

2. HASH ����

3. SORT MERGE ����

4. ���� ������ �߿伺

5. OUTER ����

6. ��Į�� ���� ������ �̿��� ����

7. ������ ������ DML �� Ʃ��

8. ��� ���� ���� Ʃ��


1. ������ �� Ʃ���ؾ��ұ�?

���� : ��� �̸�, ����, �μ� ��ġ�� ����ϱ�

select e.ename, e.sal, d.loc
 from emp e, dept d
 where d.deptno=e.deptno;

�ٵ� �����غ��� 

(1) emp -----> dept �����ϴ� �����

(2) dept -----> emp �����ϴ� ���

�̷��� �� ���� ����� ���� ���̴�.

�� �� � ����� �� ȿ�����ϱ�?

������ (2)��.

���� ���̺�(dept-4��)�� ���� �а� ū ���̺�(emp-14��)�̶� �����ϴ� �� �� ������ ���� ����.

�ٵ� �ȶ��� ��Ƽ�������� (1)�� ���ѵ� �ڵ����� (2)�� �������� ���� �ִ�.

�� �� Ȯ���غ���.

select /*+ gather_plan_statistics */ e.ename, e.sal, d.loc
 from emp e, dept d
 where e.deptno=d.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� ��ȹ�� Ȯ���غ��� dept ���̺���� ���� �а� emp ���̺�� �����ߴ�.

(Id�� ������ �ƴϰ�, ���� ������ �������� �����Ǿ� �ִµ�, ������ ������ ������ ������ �����̴�.)

������ ������ 6���� ��µǾ���.

�׷��ٸ� emp ���̺���� �����ϵ��� ������ �ٲ㺸��


** ���� ������ �����ϴ� ��Ʈ ( ordered )

ordered ��Ʈ : from ������ ����� ���̺� ������� �����ض�!!

select /*+ gather_plan_statistics ordered */ e.ename, e.sal, d.loc
 from emp e, dept d
 where e.deptno=d.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


Ȯ���غ��� emp�� ���� �а�, dept ���̺��� �����ߴ�.

������ ������.. �Ȱ���...

�ٸ� �е� SQL�� ���� ���۰� 60�������� �þ�µ�

�� �� �Ȱ���..? ��Ƽ������ ������ �� ������ ����.. ����

* ��·�� �������� ������� ordered�� ����ؼ� ¥�� �������� ���ϰ� �� �� �ִ�.

�ٵ� ���� ���̺��� ũ��� �׻� ���ϱ� ������, ������ ordered ���� �� ȿ�����̾�����

������ �� ũ�Ⱑ ���� ���ؼ� ������ ��ȿ�����̶� ordered�� ���� �� �� �������� ��찡 �ִ�.

ordered �Ӹ� �ƴϰ� ���̺��� ��ȭ�� ���� SQL ��Ʈ�� ���ָ� �� ���� ��쵵 ���� �� �ֱ� ������

Ȥ�� ���� SQL ���� ��Ʈ�� ������ ��Ʈ�� ���� ���� �����غ���.


* ���� ������ �����ϴ� ��Ʈ 2����

1. ordered        --->   from ������ ����� ���̺� ������� �����ض�!

2. leading         --->   leading ��Ʈ �ȿ� ����� ���̺� ������� �����ض�!

���� : leading�� ����� �����Ͽ� ��� �̸�, ����, �޿� ����� ����ϱ�

select /*+ gather_plan_statistics leading(e s) */ e.ename, e.sal, s.grade
 from salgrade s, emp e
 where e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

����� ���� ������

ordered �� leading �߿�

�ڽſ��� ������ ��� ����� �ϳ� ���ؼ� ����.

** ���� Ʃ�׽� �߿��� Ʃ�� ��� 2���� **

1. ���� ������ �����ϱ�

(1) ordered ��Ʈ �ֱ�

(2) leading ��Ʈ �ֱ�

2. ���� ����� �����ϱ�

(1) nested loop join ( use_nl ): ���� ���� �����͸� ������ �� ������ ����

(2) hash join ( use_hash ): ��뷮 �����͸� ������ �� ������ ����

(3) sort merge join ( use_merge ): ��뷮 �����͸� ������ �� ������ ����, hash join���� ������� ���ϴ� SQL�� ���

* ���� ���̺��� ������ �� �������� �ؽ� ������ �ϸ鼭 �޸𸮸� �����ϰ� ����� �ʿ�� ���� ������

  ���� ���̺��� ������ ���� nested loop�� �������!


���� : emp, dept�� �����ؼ� ��� �̸�, ����, ����, �μ� ��ġ�� ����ϱ�

select /*+ gather_plan_statistics leading(e d) */ e.ename, e.sal, e.job, d.loc
 from dept d, emp e
 where d.deptno=e.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

* nested loop ����

nested loop�� ���������� �ϳ��� ������ �õ��Ѵ�.

�̷��� �ϳ��� ������ ó���ϴٺ��� �����Ϸ��� �������� ���� ������ ������ ���� ��������.


���� : ���� SQL ������ NESTED LOOP ����ϱ�

use_nl(���̺� ��, ���̺� ��) ��Ʈ����

leading�� ���� ���̺� ������ ��������.

���� ordered�� ����ߴٸ�

from ���� ���� ���̺� ������ �����ָ� �ȴ�.

select /*+ gather_plan_statistics leading(e d) use_nl(e d) */ e.ename, e.sal, e.job, d.loc
 from dept d, emp e
 where d.deptno=e.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

�ؽ� ���� ���� ���ʹ� �ٸ��� ���۰� 90���� �� �þ��.

��ġ�� emp�� dept ���̺��� ���� ���εǴ� �������� ���� �����Ƿ�

nested loop ������ ����ϴ� �� �� �ٶ����ϴ�.


�߰� ���� :

���� ���� ������ ���̺��� �����Ͱ� �ʹ��� �۱� ������ ���۰� ũ�� �þ ��û ��ȿ������ ����ε� ������,

������ ���� ���ݱ��� �ߴ� hash ���ε鿡 ���Ǵ� ������ ���� �ξ� ��������. (������ ���� �ξ� ũ�� ����)

�ƹ����� nested loop�� �⺻������ ���Ǵ� ������ ���� ���� ������

�������� nested loop�� ����Ѵٸ� ������ ���� ���� ���̴�. (�������� �亯)


���� : emp ���̺�� salgrade ���̺��� �����ؼ� ��� �̸�, ����, �޿� ����� ����ϴµ�, salgrade ���� �а� �ϱ�

select /*+ gather_plan_statistics leading(s e) use_nl(s e) */ e.ename, e.sal, s.grade
 from salgrade s, emp e
 where e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� : ����� �̸��� �μ� ��ġ�� ����ϱ�

select e.ename, e.sal, d.loc
 from emp e, dept d
 where e.deptno=d.deptno;

(1) emp ---> dept : 14�� ���� �õ� ( ����� 14���̴ϱ� )

(2) dept ---> emp : 4�� ���� �õ� ( �μ� ��ġ�� 4�����ϱ� )

���� ȿ���� �� ���� ���� (2) �̾��ٸ�,


���� : �̸��� 'scott'�� ����� �̸��� ���ް� �μ� ��ġ�� ����ϱ�!

select e.ename, e.sal, d.loc
 from emp e, dept d
 where e.deptno=d.deptno and e.ename='SCOTT';

* ���� SQL���� ���� ������ �� ���� ����?

(1) emp ---> dept

(2) dept ---> emp

���� : (1)

��?

e.ename = 'SCOTT'�� ���� �ܿ� 1���̴�

�׷��� �� 1���� DEPT ���̺� �����ϱ⸸ �ϸ� �Ǳ� ������,

�� ��쿡�� (1)�� �� ȿ�����̴�.


���� : �Ʒ��� SQL���� ���� ������ emp--> dept��, ���� ����� nested loop�� �����ϱ�

select /*+ gather_plan_statistics leading(e d) use_nl(e d) */ e.ename, e.sal, d.loc
 from dept d, emp e
 where e.deptno=d.deptno and e.ename='SCOTT';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

* ���� ���忡 ����(����) ���� ���� �˻� ������ ���� ������

�˻� �������� �˻��Ǵ� �Ǽ��� �� ������ ���� Ȯ���� �ϰ�

�� �Ǽ��� ����� ���̺��� �۴ٸ� ���� �Ǽ��� �˻��ϴ� ������

���� �е��� �̷��� ordered �Ǵ� leading�� �ۼ�����


�׷� ���� ���̺��� 2���� �ƴϰ�, �ټ��� ���� � ���̰� ������?


���� : emp �� dept�� salgrade �� �����ؼ� �̸��� ���ް� �μ���ġ�� �޿� ����� ����ϱ� ( ���̺��� �ټ��� �� )

( dept --> salgrade --> emp  �ϰ� ������ dept�� salgrade�� ���� ���� ���� ��� �̷��� �ϸ� �� �ȴ�.

   4              5             14

select /*+ gather_plan_statistics leading(d s e) use_nl(d s e) */ e.ename, e.sal, d.loc, s.grade
 from dept d, emp e, salgrade s
 where e.deptno=d.deptno and e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


����� ���� ���۰� 154���� ���� ���� Ȯ���� �� �ִ�!

���� ������ ���� ���̷���,

( dept --> emp --> salgrade ) �̷��� ���� ������� �ִ� ���̺��� �����ϸ鼭 ���� ������ ������� �Ѵ�.
    nested loop   nested loop


���� ������ �����غ���

select /*+ gather_plan_statistics leading(d e s) use_nl(d e s) */ e.ename, e.sal, d.loc, s.grade
 from dept d, emp e, salgrade s
 where e.deptno=d.deptno and e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

���۰� 128���� �پ���!!

���� ���� :

(1) dept --> emp �� nested loop join�� �ȴ�.

(2) (1)�� ����� salgrade�� nested loop join�� �ȴ�.

���� : �̸��� KING�� ����� �̸��� ���ް� �μ���ġ�� �޿������ ����ϱ� ( ���̺��� �ټ��� �� + �˻� ���� )

���� �Ʊ�� �Ȱ��� �ϰ�, �˻� ���Ǹ� �߰��Ѵٸ�?

select /*+ gather_plan_statistics leading(d e s) use_nl(d e s) */ e.ename, e.sal, d.loc, s.grade
 from dept d, emp e, salgrade s
 where e.deptno=d.deptno and e.sal between s.losal and s.hisal and e.ename='KING';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

������ ������ 37��!

�׷��ٸ� ����

�˻� ������

ename='KING' �� �����ϴ� ������� 1����� �� �̿��ؼ�

emp ���̺���� ��ȸ�� ��

emp --> dept --> salgrade ������ ��ȸ�ϵ��� �غ���?

select /*+ gather_plan_statistics leading(e d s) use_nl(e d s) */ e.ename, e.sal, d.loc, s.grade
 from dept d, emp e, salgrade s
 where e.deptno=d.deptno and e.sal between s.losal and s.hisal and e.ename='KING';
 
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));
 
���۰� 19���� ���� ���� ���� �پ��ִ� ���� Ȯ���� �� �ִ�!

-----------------
 
���� :

������ Ʃ���� �ؾ��� ��

1. ���� ������ ���Ѵ�.

2. ���� ����� ���Ѵ�.

�� �� ���� �������� ������

1. ���� ������ ��� ���� ��뷮������ �����ؼ�

���� ���� ���� �е��� ������ ���ϸ� �ȴ�!

���� where ���� �ִٸ�, �� ���� ��� ������Ѻ���

��� ���� �� ���� ������ Ȯ���غ���,

���������� ���� ���� ���� �е��� ������ ������.

2. (���� ���)�� ���� ����( SQL - HASH JOIN, SORT MERGE JOIN )����!
