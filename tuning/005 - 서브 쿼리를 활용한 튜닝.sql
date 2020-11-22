SELECT �� �� ���� ������ �� �� �ִ� ��

SELECT                 --> O ( ��Į�� �������� )
 FROM                 --> O ( �� ���� �� )
  WHERE               --> O
   GROUP BY         --> X
    HAVING            --> O
     ORDER BY        --> O ( ��Į�� �������� )

���� : �̸�, ����, ��� ���̺����� �ִ� ���� ����ϱ� ( ��Į�� ���� ���� )

select /*+ gather_plan_statistics */ ename, sal, (select max(sal) from emp)
 from emp;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


Ʃ�� :

select /*+ gather_plan_statistics */ ename, sal, max(sal) over () �ִ����
 from emp;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


over () �� ����ϸ� ��ü�� ���� ������ �� �� ���� �Ͱ� ���� ȿ���� �� �� �ִ�!

���۴� ���⼱ �Ȱ�����.. ���� ��뷮���� ���̰� ���� ��


���� : �̸�, ����, �ִ� ����, �ּ� ������ ����ϱ�

select /*+ gather_plan_statistics */ ename, sal, ( select max(sal) from emp ) �ִ����, (select min(sal) from emp ) �ּҿ���
 from emp;


Ʃ�� :

select /*+ gather_plan_statistics */
 ename, sal, max(sal) over () �ִ����, min(sal) over () �ּҿ���
 from emp;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� ���� ������ ���� ������, �����Ų ���۷��̼��� ������ Ȯ���� ����.



���� : �μ���ȣ, ���, ����, �μ���ȣ �� ������ ����� ����ϴµ�, �ڽ��� �μ� ��պ��� ������ ���� ����� ����ϱ�

select /*+ gather_plan_statistics */
 e.deptno, e.ename, e.sal, v.�μ����
 from emp e, (select deptno, avg(sal) �μ����
                     from emp
                     group by deptno) v
 where e.deptno=v.deptno and e.sal>v.�μ����;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


Ȯ���غ��� ������ ������ 51����..

�ذ� ����� ������ ������� �ʴ� ��ſ� partition by�� ����ؼ� �� ���̺� ���� �ھƳְ�,

�� ���̺� ��ü�� �״�� ���Ǹ� �༭ ����ϸ� �ȴ�.

select /*+ gather_plan_statistics */ *
 from 
  ( select deptno, ename, sal, avg(sal) over (partition by job) �μ����
        from emp )
where sal>�μ����;


Ȯ���غ���, ������ ������ 7���� �ξ� �پ�����!


���� : �μ���ȣ, �̸�, ����, ������ ����ϴµ� ������ �μ���ȣ���� ���� ������ ���� ������� ������ �ο��ؼ� ����ϰ� ������ 1���� ����鸸 ����ϱ�

select /*+ gather_plan_statistics */ *
 from
  (select deptno, ename, sal, dense_rank() over (partition by deptno order by sal asc) ����
   from emp)
 where ����=1;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


* DML ���� �̿��� ���� �������� Ʃ��


���� : ALLEN�� ������ KING�� �������� �����ϱ�

update emp
 set sal = ( select sal from emp where ename='KING' )
  where ename='ALLEN'

��� ������ ���� �������� �̿��� DML ���̴�.


���� : ��� ���̺� loc �÷��� �߰��ϰ� �ش� ����� ���� �μ� ��ġ�� ���� �����ϱ�

alter table emp
 add loc varchar2(20);

--> loc�� �߰��ϰ�, �����ʹ� ����ִ� ����

update emp e
 set loc ( select loc
from dept d
   where e.deptno=d.deptno );

select * from emp;


�׷���

update emp e
 set loc ( select loc
	 from dept d
	 where e.deptno=d.deptno );

������, ���� ���� �ȿ� e�� ������ �� �ִ��� �ǹ��� �� ���̴�.


** emp ���̺��� �÷��� ���� ���� ������ ���� �Ǹ�

���� �������� ����Ǵ� �� �ƴ϶� ���� ���� ( update )������ ����ȴ�.

��ġ set ���� ���� select ���� from ���� ��ġ�� ����ؼ� ������ ������ �� ������,

��� update�� ������ �� update �� ���̺�κ��� �����ϱ� ������,

��ġ select ���� from ��ġó�� update ���� ���� ���� ����ǰ�, ���̺� ��Ī�� �ٿ��� ���� ������ �ִ� set ���� ����� ���� �ִ� ���̴�.

�ٵ� ���⼭ ������, �̷��� �ϸ� update �� �ȿ��� where ���� ���ǿ� �´��� �� �´��� ��~�� �ݺ��ؼ� �����Ѵ�.

�׷��� ��ġ update ���� 14�� �����ϴ� �Ͱ� �Ȱ��� ȿ���� ����.

�׷��� Ʃ���� �ʿ��ϴ�.

update /*+ gather_plan_statistics */ emp e
 set loc = ( select loc
              from dept d
             where e.deptno=d.deptno );

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

select * from emp;


Ʃ�� �� :

merge into emp e
 using dept d
  on ( e.deptno = d.deptno )
 when matched then
 update set e.loc=d.loc;

merge ���� ����ϸ� �����͸� �� ���� ������ �� �ִ�.


---

��� ���̺� sal2 ��� �÷� �߰��ϱ�

alter table emp
 add sal2 number(10)


���� : sal2�� �ش� ����� �������� ���� �����ϱ�

 update emp
  set sal2 = sal;

select ename, sal, sal2 from emp; 

Ȯ���غ��� ��û �����ϰ�, �� ���� �ű� ���� �� �� �ִ�.


���� 1 : emp ���̺� �� loc �÷��� �����

alter table emp
 add loc varchar2(20);

���� 2 : ���պ並 �����ϰ� �並 �����ϱ�

create view emp_dept
 as
  select e.ename, e.loc as emp_loc, d.loc as dept_loc
	from emp e, dept d
  where e.deptno=d.deptno;

select * from emp_dept;

Ȯ���غ���, emp_loc�� ������ְ�, dept_loc�� ä�����ִ�.

���⼭ dept_loc�� �״�� emp_loc�� �ű�⸸ �ϸ� �ȴ�!


���� 3 : ��� ���� ���� emp_loc�� ���� dept_loc�� ������ �����ϱ�

update emp_dept
 set emp_loc=dept_loc;

�ϸ� ������ �� �ȴ�.

��?

SQL : ���� deptno�� 40�� 'DALLAS' �� �ְ�, 'CHICAGO'�� ������ �� ���� �ؾ� �Ǵµ�? �׳� �� ��

�̷��� �����Ͱ� �ߺ��ǰų�, null ���� ���� ��츦 ����ؼ� update ������ �̷� �ڵ�� ������ ���ƹ�����.

���� ���� �並 �����Ϸ���

dept ���̺��� deptno�� primary key ������ �ɾ��ָ� ������ �� �ִ�. ( �ߺ��� ���� NULL�� �����ϱ� �׳� �� ����.. )


���� 4 : deptno�� primary key�� �ɰ� �����

alter table dept
 add constraint dept_deptno_pk primary key(deptno);

update emp_dept
 set emp_loc = dept_loc;


select * from emp_dept;

- ���� �Ϸ�!

VIEW�� ������ �ʰ�, �� ���� ����� ��

update  --> ���� ���� ���� ( �̰Ÿ� �̿�! )

 set      --> ���� ���� ����

  where --> ���� ���� ����

update ( select e.ename, e.loc as emp_loc, d.loc as dept_loc
		from emp e, dept d                                                    --> �Ʊ� ������� VIEW ���� �״��!!
	where e.deptno=d.deptno )
  set emp_loc = dept_loc;


select * from emp;


--> �̷��� �並 ����� �� ���ٸ� update�� ���� ������ ����ؼ� ���� �������� ���� �ۼ��ϰ�, set ������ ������Ʈ �ϸ� �ȴ�.

( �� ���� ���������� ������ ������ ���̺� primary key�� �ɷ��־�� ��! )


���� : emp ���̺� dname �÷��� �߰��ؼ� ����� �μ���(dept ���̺�)���� ���� �����ϱ�

(1) emp�� dname �÷� �����

alter table emp
 add dname varchar2(10);


(2)

update ( select e.ename, e.dname as emp_dname, d.dname as dept_dname
	  from emp e, dept d
	where e.deptno = d.deptno )
  set emp_dname = dept_dname;


select * from emp;


(3) merge Ȱ��

merge into emp e
 using dept d
 on ( e.deptno = d.deptno )
 when matched then
 update set e.dname = d.dname;

���� : merge�� ����ϰų�, update ���� ���� ������ �̿��ؼ� �� ���� ����� ������. ( ���������� merge ��.. )