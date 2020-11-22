* ��� ���� ���� Ʃ��

�� ���� ���� ������ ���� ������ �����ϰ��� �� �� ����ϴ� Ʃ�� ���

���� : ��� ��ȣ, �̸�, ����, �μ� ��ȣ, �μ� ��ġ�� ���� emp_dept��� view�� �����

create view emp_dept
 as
  select e.empno, e.ename, e.sal, e.deptno, d.loc
   from emp e, dept d
   where e.deptno=d.deptno;


�ٵ� �÷����� �ڼ������� e.empno, e.ename�� �ƴ� empno, ename �̴�.

�������� ��������.

���� : ��� ���� emp_dept view�� salgrade ���̺��� ���� �����ؼ� �̸��� ���ް� �μ� ��ġ�� �޿� ����� ����ϱ�

select v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;


�׷� ��� �ڵ��� ���� ��ȹ�� �� �� ����


select /*+ gather_plan_statistics */ v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


�ٵ� ���� ���� �並 �� ����, �� emp�� dept�� Ǯ�� access�� ���..

leading���� �����ϰ�, nested loop�ϵ��� ��Ʈ�� ����

select /*+ gather_plan_statistics leading(s v) use_nl(v) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


����, leading���� �����ϰ�, nested loop ������ �϶�� ��Ʈ�� ��µ���

nested loop�� ���� �ʾҴ�.

�� �����߳�?

view�� ��ü�ع��ȱ� ����

���� view�� ��ü���� �ʾҴٸ�, ���� ��ȹ�� view�� ��Ÿ����.

�׷��� view�� ��ü���� ���ϵ��� ��Ʈ�� ����ϴµ�, �� ��Ʈ�� no_merge �̴�.

��� �����ߴ� �ڵ��� ��Ʈ �տ� no_merge ��Ʈ�� �߰�����.


select /*+ gather_plan_statistics no_merge(v) leading(s v) use_nl(v) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� emp_dept view�� ���� ��ȹ�� ��Ÿ����.


* no_merge : view�� ��ü���� ���ƶ�~
* merge     :  view�� ��ü�ض�~


�Ʊ�� no_merge�� ���, leading (s v)�� ��⵵ ���� �̹� view�� ��ü�Ǿ�����.

�ٵ� ���� ��ȹ�� �ڼ��� ����, view�� �ʰ� �������� �ƴϳ�. ������,

��� view ����~ �� �� �� table access full - emp ���� �� �����̴�. ( starts 5 )

�׷��� ���� ��ȹ�� �ٽ� �ؼ��ϸ�,

���� salgrade�� full scan �ϰ�, view�� ��ĵ�ϸ鼭 nested loop ������ �����ߴٴ� ���� �� �� �ִ�.

�׸��� view �ȿ����� dept ���̺��� ���� �а�, emp ���̺��� �� ���� �о hash join�� �̷������.

�ٵ� �� ���� ���� ������ ���̺� ���� ���� ( emp --> dept )�� �����ϰ� �ʹٸ�, ��� �����ؾ� �ұ�?

�並 drop �ϰ� ����� �ϸ� ���� �ʳ���?  --> ���������� �並 ��� �μ��� ���� �־ �Ұ����ϰų� ��û�ϴ��� ���� �ɸ��� ��찡 ��ټ��̴�.

�̷� ����, leading�� �Ʊ� view ���� ���� ��� �� �ϳ��� use_hash�� �ȿ�( �� hash�� �ʿ�� ����! )

���� ��Ī�� v��, v ���� �÷����� e�� d�� Ȱ���ؼ� �� ��ü������ �� �� �� �ۼ�����


select /*+ gather_plan_statistics no_merge(v) leading(s v) use_nl(v)
	leading(v.e v.d) use_hash(v.d) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���⿡ ���� nested loop �� �����ϴ�.

select /*+ gather_plan_statistics no_merge(v) leading(s v) use_nl(v)
	leading(v.e v.d) use_nl(v.d) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� : �並 ���� �ø���, �� ���� ������ �ؽ� �������� �ٲٰ� ���� ������ emp�� ���� �ǵ��� �ϱ�

select /*+ gather_plan_statistics no_merge(v) leading(v s) use_nl(s)
	leading(v.e v.d) use_hash(v.d) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� : salgrade ���� �ø���, �� ������ dept ���� �ؼ� hash join ��Ű��

select /*+ gather_plan_statistics no_merge(v) leading(s v) use_nl(v)
            leading(v.d v.e) use_hash(v.e) */
        v.ename, v.sal, v.loc, s.grade
 from emp_dept v, salgrade s
 where v.sal between s.losal and s.hisal;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� : ��� ������ ���� no_merge�� ���� �����ؼ� �並 ��ü���� ����� ��Ʈ�� �ش�. ( �� �ָ� �ڱⰡ �˾Ƽ� ��ü�ع�����, �ٸ� ��Ʈ �� �����Ѵ�. )

�׸��� �� ���� ������ ���� ����� �����ϰ� �ʹٸ� from ���� �信 ��Ī�� �̿��ؼ� ��Ī�� �Բ� �÷����� �����ؼ�

�� �� �� �� ����� ���� ��Ʈ�� �־��༭ �����Ӱ� ������ ���� �ִ�.