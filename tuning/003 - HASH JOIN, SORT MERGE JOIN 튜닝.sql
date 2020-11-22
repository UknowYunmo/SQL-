* HASH JOIN ( �ؽ� ���� )

nested loop ������ �� �྿ ��� ���� �����ϱ� ������

���� �����Ϳ����� ȿ����������, �������� ���� Ŀ���� ������ ���� �� ��������.

�������� ���� Ŭ ���� nested loop ���κ��ٴ� hash join�� ����ϴ� ���� �ξ� ������ ����.

�ؽ� ������ �ؽ� �˰����� �̿��ؼ� �����͸� �޸𸮿� �÷�����, �޸𸮿��� �����ϴ� ���� ����̴�.

���� : �ؽ� ������ ����ؼ� emp ���̺�� dept ���̺��� �����Ͽ�, ��� �̸��� �μ� ��ġ�� ����ϱ�

select /*+ gather_plan_statistics leading(d e) use_hash(d e) */ e.ename, d.loc
 from dept d, emp e
 where e.deptno=d.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

dept ���̺�� emp ���̺��� �� �� �޸𸮷� �ö󰡴µ�,

�޸𸮿� �� �� �� ���� �ö󰡼� ������ �ϸ� �ʹ� ��������

�׷��Դ� �ȵǰ�

�� �� �ϳ��� ���� �޸𸮷� �ø���

�ٸ� ���̺��� �������� �Ϻθ� ���ݾ� �ø��鼭 ������ �����Ѵ�.

* dept ���̺��� ������ �ּ� Ȯ���ϱ�

select rowid, deptno, dname, loc
 from dept;

rowid�� ��� ���Ͽ� ��� ���� �ִٶ�� ������ �ּ� �����̴�.

dept ���̺��� ��ũ�� ���� ���� �� �ּҰ� �����ߴµ� ( ������ �� )

dept ���̺��� ��ä�� �޸𸮷� �ö󰡸�

���� �ּҰ� �ʿ� �������� ���ο� �ּҰ� �ʿ��ѵ� �� �ּҰ� �޸��� �ּ��̴�.

���� empno �� 7788�� �����͸� deptno�� �����ؼ� �Ϸ��� �ϴµ�?

deptno�� 10�ε�.. �׿� �´� dept ���̺��� 10�� �ּҰ� �������? �ϰ� ã�� ��

dept ���̺��� �޸𸮿� �÷��������� ã�� ���� ����

�׷��� �޸𸮿� �÷������� 10�̶�� ��ġ�� ã�� �� �ֵ��� �ϴ� ���� �ؽ� �Լ��̴�.

�׷��ٸ� emp�� dept ���̺� �� ��� ���̺��� �޸𸮷� �÷��� �ұ�?

--> ���� ���̺��� dept�� �÷��� �Ѵ�

���� : �޸��� ũ�Ⱑ �����ϱ�!

�׷��ٸ� �޸𸮸� �ø��� �����?

--> use_hash ���� �ö� ���̺��� ������ ����Ѵ�


���� : ������� �̸�, ����, ���ʽ��� ����ϴµ� emp�� bonus�� hash join �ϵ��� �ϱ�

select /*+ gather_plan_statistics leading(e b) use_hash(e b) */ e.ename, e.sal, b.comm2
 from emp e, bonus b
 where e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

������ �� : 9��


���� 2 : ������� �̸�, ����, ���ʽ��� ����ϴµ� emp�� bonus�� hash join �ϵ��� �ϴµ�, ������ SALESMAN�� �����!

select /*+ gather_plan_statistics leading(e b) use_hash(e b) */ e.ename, e.sal, b.comm2
 from emp e, bonus b
 where e.empno=b.empno and e.job='SALESMAN';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

Ȯ���غ��� SQL���� ��¦ �� ���������µ��� �ұ��ϰ�, ������ ���� 4���� ũ�� ���� ���� Ȯ���� �� �ִ�.

��?

emp�� bonus �� �� 14��������

������ SALESMAN�� ������� �����ʹ� 4���̹Ƿ�

4�Ǹ� �޸𸮷� �ø��� bonus�� �����߱� ����


���� : ������ SALESMAN�̰� �μ� ��ġ�� CHICAGO�� ������� �̸��� �μ���ġ�� ����ϴµ�, hash join�� ����ϱ�
                        4��                        6��
( emp --> dept )

select /*+ gather_plan_statistics leading(d e) use_hash(d e) */ e.ename, d.loc
 from emp e, dept d
 where e.deptno=d.deptno and e.job='SALESMAN' and d.loc='CHICAGO';

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� : emp, dept, bonus ���̺��� hash join�ؼ�, ����� �̸�, �μ� ��ġ, ���ʽ��� ����ϱ�

select /*+ gather_plan_statistics leading(d e b) use_hash(d e b) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� 2 : ""

select /*+ gather_plan_statistics leading(d e b) use_hash(e) use_hash(b) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

** dept �� emp �� hash join �� ���� �ϰ�
    �� ����� bonus�� hash join �Ͽ���.


** swap_join_inputs ��Ʈ : hash table�� �����ϴ� ��Ʈ
    no swap join inputs ��Ʈ : probe table�� �����ϴ� ��Ʈ

���� 3 :  ""

select /*+ gather_plan_statistics leading(d e b) use_hash(e) use_hash(b) swap_join_inputs(b) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

2���� ���̺��� ������ �� hash table�� �����ϴ� ���� leading ��Ʈ�����ε� �����ߴµ�

3�� �̻��� ���̺��� ������ �� hash table�� ������ ���� leading ���δ� ��� �ȵǰ�

swap_join_inputs �� ����ؾ� �Ѵ�.

�̰� ���� ���̳�!!

hash join�� �� �� 

���� ���� ��������

�� ���� �ִ� ���̺��� �޸𸮿� �ö󰡰� ( ���� ���̺� )

�� �ؿ� �ִ� ���̺��� ���� ���ϴ� ���̺��̴�.

�׷��� �� �� �̻󿡼� hash join�� �ϰ� �Ǹ�,

hash join �� ���̺��� ��°�� �޸𸮿� �ö󰡰� �Ǵ� ��찡 �߻��Ѵ�

�ٵ� �� ���̺��̶� ���� hash join�� ���̺��� �װͺ��� ���� ���̺��̴�?

�̷��� �޸� ������ ���ظ� ���� �ȴ�.

�׷��� �����ؼ� �̹� hash join�� �Ͼ���� �ٸ� ���̺��� ���� �޸𸮿� �ö󰡵���

������ ���ִ� ���� swap_join_inputs �̴�.

�׷���

bonus ���̺��� ũ�Ⱑ �۴ٸ� �� ���� ��ȹ�� ���� ���� ��ȹ�̴�.

���� : emp, dept, bouns�� hash join �ϴµ�, bonus, emp�� ���� hash join�ϰ�, dept ���̺��� �޸𸮿� �÷��� �� hash join�ϱ�

select /*+ gather_plan_statistics leading(b e d) use_hash(b,e,d) swap_join_inputs(d) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

�Ǵ�

select /*+ gather_plan_statistics leading(b e d) use_hash(e) use_hash(d) swap_join_inputs(d) */ e.ename, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

** hash join�� ������ ����!



���� : ����� �̸�, ����, �޿� ����� hash join�� ����Ͽ� ����ϱ�

select /*+ gather_plan_statistics leading(s e) use_hash(s e) */ e.ename, e.sal, s.grade
 from emp e, salgrade s
 where e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

?? �� nested loop�� ??

���� :

���� SQL�� �����ȹ�� hash join�� �ȵȴ�.

�ֳ��ϸ� hash join�� �Ƿ��� where ���� ���� ������ =(����) �̾�� �Ѵ�.

non equal join�� hash join�� ���� �ʴ´�.

- �׷��ٸ� ���� ���� SQL�� �� ���̺��� �� �� ��뷮�ε� �ؽ� ������ �� ���� �����?

--> SORT MERGE JOIN�� ����ؾ� �Ѵ�.

* sort merge join

�����Ϸ��� �������� ���� �����鼭 ���� ������ =�� �ƴ� �� �˻� ������ ���̱� ���� ���� ���

sort merge join�� �����ϸ� ���� ���� �Ǵ� Ű �÷��� ����Ŭ�� �˾Ƽ� ������ ���� ������ �Ѵ�.


���� : ����� �̸��� �μ� ��ġ�� �μ� ��ȣ�� sort merge join�� ����Ͽ� ����ϱ�

select /*+ gather_plan_statistics leading(s e) use_merge(e) */ e.ename, d.loc, e.deptno
 from emp e, dept d
 where e.deptno=d.deptno;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

����� ���� order by ���� ������� �ʾҴµ�, deptno�� ������ �Ǿ��ִ�.

�� ���� sort merge join�� deptno�� �����س��� ������ �����ߴٴ� ���� �ǹ��Ѵ�.

�׷� �Ʊ� ������ ���� SQL ���� �ٽ� sort merge join���� �غ���.

where d.deptno = e.deptno �� ���� ��..
          10                10
          10                10
          10                10
          20                20
          20                20
          30                30
          ...                  ...

�̷��� ������ �ؼ� �����͸� ��Ƴ��� ������ ������ ��������.

select /*+ gather_plan_statistics leading(s e) use_merge(e) */ e.ename, e.sal, s.grade
 from emp e, salgrade s
 where e.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

Ȯ���غ���, ���� ������ �ƴϰ� between�� ����ߴµ���, ������ ���������� �̷������.

grade�� ������ ���ĵ� ���� ��!

---

OLTP ���� : �ǽð� ��ȸ ó���� ���� �����Ͱ� ����Ǿ� �ִ� ��

DW ���� : ��뷮 �����Ͱ� ����Ǿ� �ִ� �� ( �츮���� �� ������ ��� �Ƿ� ��� )

                 10�� ����, 20�� ������ ����Ǿ� ����

OLTP ���� -> nested loop ������ �ַ� ��� [�ؽ� ����, ���� ó���ϸ� ū�ϳ���!  ��? �޸𸮸� ��ƸԾ �ٸ� ����鿡�� ���ظ� �ش�]

DW ���� -> �ؽ� ����, merge ����, ������ �м��Լ��� �ַ� ���, ��Ƽ�� ���̺�, ���� ó��?
