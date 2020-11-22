OUTER JOIN �� Ʃ�� ���


* outer join�� ���� ������

outer join sign�� ���� �ʿ��� �ִ� ������ ������ ������ �ȴ�.

�׷��ٺ��� ���� ������ �����ϱⰡ ������� Ʃ���� ���絥,

�̸� ������ �� �ִ� ��Ʈ�� �ִ�.

�ϴ� outer join�� �����ϱ� ���ؼ�, deptno�� deptno ���̺��� ����, Ư���� ����� �ϳ� �־��


insert into emp ( empno, ename, sal, deptno )
 values ( 2921, 'JACK', 4500, 70 ) ;

���� : deptno�� �ƿ��� ������ �غ���

select /*+ gather_plan_statistics */ e.ename, d.loc
 from emp e, dept d
 where e.deptno=d.deptno(+);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� ���� ��Ƽ�������� emp ���̺��� ���� ���̺�� �о���.

�׷���, dept�� ���� �а� �����غ���

select /*+ gather_plan_statistics leading(d e) use_hash(e) */ e.ename, d.loc
 from emp e, dept d
 where e.deptno=d.deptno(+);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� ������ �����Ϸ��� ��Ʈ�� ������ Ȯ���غ��� ��Ƽ�������� �� ���� ������ ������ �� �� �� �ִ�.

�ֳ��ϸ� outer join�� ������ outer ���� (sign)�� ���� �ʿ��� �ִ� ������ �����ϱ� ����.

�׷���, dept ���̺��� emp ���� �ξ� ���� ���̺��̶�, dept�� �ƹ����� ���� �÷��� ������, ��� �ؾ��ϳ�?


** ���� ������ ����x2 �� dept --> emp�� �ǰ� �ϱ�

select /*+ gather_plan_statistics leading(d e) use_hash(e)
            swap_join_inputs(d) */ e.ename, d.loc
 from emp e, dept d
 where e.deptno=d.deptno(+);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



������ hash join���� ��Ծ��� swap_join_inputs�� ����ؼ�

dept ���̺��� hash ���̺�� �����ؼ� dept ���̺��� ���� �޸𸮿� �ø����� �����ߴ�.

���� ��ȹ�� ���� hash right outer �������� �ٲ� ���� �� �� �ִ�.



��� :

outer join�� Ʃ���Ϸ��� hash join���� �����ؾ� �Ѵ�.

swap_join_inputs�� hash join���� ����� �� �ֱ� ����!




���� : emp�� bonus�� outer join �ؼ�, �̸��� comm2�� ����ϴµ� JACK�� ��µǵ��� �ϱ� ( bonus ����! )

select /*+ gather_plan_statistics leading(b e) use_hash(b e)
            swap_join_inputs(b) */ e.ename, b.comm2
 from emp e, bonus b
 where e.empno=b.empno(+);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���������� swap_join_inputs �� ���� outer join�� Ʃ���ϱ� ���� �����.

outer join�� ���ϰ� �ϴٺ���, �ڵ尡 �̻��ϰ� ������� ȿ���� ��������.

�׷���

swap_join_inputs ��� �� �������