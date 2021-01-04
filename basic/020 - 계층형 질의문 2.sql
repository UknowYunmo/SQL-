������ ���ǹ����� ������ �ְ� ������ ����ϱ�2

������ ���ǹ��� ¦�� �Լ��� sys_connect_by_path�� �̿��ϸ�

listagg�� ����� ��ó�� ���η� ����� ����� �� �ִ�.

���� : ������� ��� ��θ� ���η� ����ϱ�

select ename, sys_connect_by_path(ename,',') as path
 from emp
 start with ename='KING'
 connect by prior empno=mgr;

�̷��� ��θ� �̸��� ���η� �����ؼ� ����� �� �ִ�.

���� : ���� ������� �� �� ��ȣ�� �߶�����ÿ�

select ename, ltrim(sys_connect_by_path(ename,','),',') as path
 from emp
 start with ename='KING'
 connect by prior empno=mgr;

** ������ ���ǹ��� �ۼ��� �� �ݵ�� �˾ƾ��ϴ� �� ���� ¦�� Ű����

1. order by ���� siblings
2. ������ ���η� ����ϴ� sys_connect_by_path �Լ�

������ ���ǹ������� ���� ������ ���� �� �� �ִ�.

���� : �̸�, ����, ���ް� �μ���ġ�� ����ϱ�

select rpad(' ',level*2) || ename as employee, level, e.sal, d.loc
 from emp e, dept d
 where e.deptno = d.deptno                                             <-- ���� ���� (���� �� )
 start with ename='KING'
 connect by prior empno = mgr;

���� : �̸�, ����, ����, �޿� ���(grade)�� ����ϱ�

select rpad(' ',level*2) || ename as employee, level, e.sal, s.grade
 from emp e, salgrade s
 where e.sal between s.losal and s.hisal
 start with ename='KING'
 connect by prior empno = mgr;

���� : ���� ����� �ٽ� ����ϴµ� ������ ������ �����ϸ鼭 �޿������ ���� ������� ����ϱ�

select rpad(' ',level*2) || ename as employee, level, e.sal, s.grade
 from emp e, salgrade s
 where e.sal between s.losal and s.hisal
 start with ename='KING'
 connect by prior empno = mgr
 order siblings by s.grade desc;

���� : DALLAS���� �ٹ��ϴ� ������� �̸�, ����, �μ���ġ�� ����ϱ� ( ������ ��ü ����� �������� )

select rpad(' ',level*2) || ename as employee, level, d.loc
 from emp e, dept d
 where e.deptno=d.deptno and d.loc = 'DALLAS'
 start with ename='KING'
 connect by prior empno = mgr;