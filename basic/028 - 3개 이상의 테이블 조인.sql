3�� �̻��� ���̺� �����ϱ�


* 2���� ���̺� ����

              ���� �� 1��

emp ----------------------------- dept


* 3���� ���̺� ����

                ���� ��             (and)              ���� ��

dept ----------------------------- emp ----------------------------- salgrade



         e.deptno=d.deptno        and     e.sal between s.losal and s.hisal


���� : �̸��� �μ���ġ�� ���ް� �μ���ȣ�� ����ϱ�


select d.loc, e.sal, e.deptno
 from emp e, dept d
 where d.deptno=e.deptno



���� : �̸��� �μ���ġ�� �޿������ ����ϱ�

select e.ename, d.loc, s.grade
 from emp e, dept d, salgrade s
 where d.deptno=e.deptno and e.sal between s.losal and s.hisal;



������ ���� ���̺��� 3���̸� 2���� ������� where ���� ���������Ѵ�.



���� : bonus ���̺� �����

create table bonus
 as
  select empno, sal*1.5 as comm2
   from emp;



���� : ���⼭ ��� �̸�, ����, �μ� ��ġ, comm2�� ����ϱ�

select e.ename, e.sal, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;