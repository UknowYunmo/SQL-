���� ������ Ʃ���ϱ�


���� ������ Ʃ���� ����� ũ�� 2������ �˸� �ȴ�.


1. �����ϰ� ���� ���������� ����ǰ� �ϴ� ��� : ��Ʈ �߰� ( no_unnest )

2. ���� ������ �������� �����ؼ� ����ǰ� �ϴ� ��� : ��Ʈ �߰� ( unnest )

* nest : ���δ�

  unnest : ������ �ʴ�

  no_unnest : ���ζ�

���� : DALLAS���� �ٹ��ϴ� ������� �̸��� ������ ����ϱ�

select ename, sal
 from emp
 where deptno in ( select deptno
from dept
where loc = 'DALLAS');


���� 2 : ���� ���� �������� �������� �����ؼ� ����ϱ�

select e.ename, e.sal
 from emp e, dept d
 where e.deptno=d.deptno and d.loc='DALLAS';


���� :
�� ���̺��� ������ ��ȸ�� �� ���� ������ �ϳ�, �������� �ϳ� ��� ����� �Ȱ��� �� �� �ִ�.

�׷� �� �߿� � �� �� ������?

- ���� �������� ���� ��ȹ Ȯ���ϱ�

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select deptno
                    from dept
                    where loc = 'DALLAS');       

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



���� ��ȹ�� Ȯ���غ���, �˾Ƽ� hash join�� �Ǿ��ִ� ���� �� �� �ִ�.

��Ƽ�������� �˾Ƽ� ���� ���� ���� hash join ���� �ٲ㼭 ������ ���̴�.




* ���� ������ ���� ��ȹ�� ũ�� 2������ �з��ȴ�.

1. �����ϰ� ���� ���������� ����ǰ� �ϴ� ��� : no_unnest

2. �������� ����Ǿ �����ϰ� �ϴ� ��� : unnest



* unnest ���� ( ���� ���� --> �ؽ� ���� ) 

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*= unnest */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



unnest �� ������ ���� ���� �������� ���� ��ȹ�� filter�� �����鼭 ������ �ʹ� ������ ��,

������ ��� �� ���� ������ hash join���� ����ǰ� �ϸ鼭 ������ ���� �� �ִ�.

 

* no_unnest ���� ( ���� ���� ���� )

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*= no_unnest */ deptno
                    from dept
                    where loc = 'DALLAS');         

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



������ ���� ������ ������״���, hash join���� ���۰� 2�� ���� �þ�, ������ ��������.


�׷��ٸ� no_unnest�� ���� ��?

������ ���̺��� ��뷮�� �ƴ� �� ����ϴ� �������, �޸𸮸� ������ �� �ִ�. ( hash join�� �޸𸮸� ��ƸԱ� ������ )


���� :

���̺� 2���� ��뷮�̴� --> ���ɿ� ���� �ӵ� ���̰� ���ϹǷ� hash join�� ������ unnest�� ���

���̺��� ��뷮�� �ƴϴ� --> hash join�� ���� ���ϵ��� no_unnest ���




���� : �μ���ġ�� DALLAS�� ������� �̸��� ���� ����ϱ�

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno = ( select /*+ unnest */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


Ȯ���غ��� ���̺� full scan�� �Ͼ���ȴ�.

��?

���� �������� ���� ������ ������ �����ڸ� =�� �ϸ� unnest�� ������ �ʴ´�.

�ֳ��ϸ� ���� �������� ���� ������ �� �Ǹ� ���ϵȴٰ� �ϸ� ���� �ؽ� �������� Ǯ�� �ʾƵ� �����ϱ� ����

�׷��� ��Ƽ�������� ��Ʈ�� �����ع�����.

�׷��� ���� �ؽ� �������� ����ǰ� �ϰ� �ʹٸ� �����ڸ� =���� in ���� ����������Ѵ�.



���� : ��� ������ = ��ſ�, in���� �ٲ㺸��

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ unnest */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


- '=' ��� 'in' ���� �ٲ����� �ٽ� ���������� hash join�� �̷������.



* ���� �������� ���� ��ȹ 2����

1. �����ϰ� ���� ���������� �����ض�    : no_unnest

             + ���� �������� �����ض�  : push_subq
    
             + ���� �������� �����ض�  : no_push_subq

2. ���� �������� �����ؼ� �����ض�        : unnest

���� ����(semi join)

1. nested loop semi join : nl_sj

2. hash semi join : hash_sj

3. merge semi join : merge_sj


��Ƽ ����(anti join)

1. nested loop anti join : nl_aj

2. hash anti join : hash_aj

3. merge anti join : merge_aj


* semi : �����̶�� ��.


������ �ߴµ� ������ ������ �� �� �ƴ϶� ������ ������ �ߴ�.

�� ������ ������ �� �ϰ� ������ ������ �߳�?

���� SQL ���� ���� ������ �ƴ϶� ���� ���� �����̱� ����.


���� : ���� ������ �����ϰ�, ���� ���������� ����ǰ� �ϱ�

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ no_unnest push_subq */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� : ���� ���� �����ϰ�, ���� �������� ����ǰ� �ϱ�

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ no_unnest no_push_subq */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���� :

no_unnest�� push_subq, no_push_subq �� ���� ¦�� ��Ʈ�̴�.

������ ��ü�� push_subq ��Ʈ�� ���� ���������� ����Ǿ��� �� �� ������ ��Ʈ��� �����ص� �ȴ�.

�ֳ��ϸ� ���� ���������� �����ϸ鼭 �����͸� �˻��� ���� ������ �Ѱ��ֱ⸸ �ϸ� �Ǳ� ����

���� ���� �������� ����ȴٸ� ���� ������ �ִ� �μ���ȣ�߿� ���� ������ �ִ� �μ� ��ȣ�� ã�� ����

������ �ٽ� ��ĵ�ϸ鼭 ã�� �۾��� �ݺ��ؾ��ϱ� ������ ��뷮 ���̺��� ��� ������ ���� ��������.


���� : hash semi join�� ����ǵ��� �ϱ�

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ unnest hash_sj */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


���⼭ hash join�� �׻� ���� ���̺� ���� �޸𸮿� �ö󰡾� ������, �� ū emp ���̺��� �ö� �ִ� ��Ȳ�̴�.

�̷� �� �� ���� dept ���̺��� �޸𸮿� �÷��� �� ���� ���� SQL���̶� �� �� �ִ�.



���� : hash semi join�� �����Ű��, DEPT ���̺��� �޸𸮿� �ö󰡵��� �ϱ�

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ unnest hash_sj swap_join_inputs(dept)*/ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



- ����� ���� ������ �ٷ� swap_join_inputs�� Ȱ���ϸ� �ȴ�.


���� : nested loop semi ������ �ǵ��� �ϱ�

select /*+ gather_plan_statistics */ ename, sal
 from emp
 where deptno in ( select /*+ unnest nl_sj */ deptno
                    from dept
                    where loc = 'DALLAS');

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


- Ȯ���� hash join ������ ������ ������ ���� �þ��. ( hash join ���� > nested loop ���� )



���� : �������� ������� �̸��� ����ϱ� ( �ڱ� �ؿ� ���� ���ϰ� �� ���̶� �ִ� ����� )

select /*+ gather_plan_statistics */ ename
 from emp
 where empno in (select mgr
                    from emp);
                    
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



�ٵ� �̷��� �ڱ� �ڽ��� �����ϸ�, ���̺� �̸��� ���Ƽ� ��� ���� �޸𸮿� �ö󰬴��� �� �� ����.

select /*+ gather_plan_statistics unnest hash_sj swap_join_inputs(e2)*/ ename
 from emp e2
 where empno in (select mgr
                    from emp e1);

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


�̷��� ���̺� ��Ī�� �൵ ���� ��ȹ���� �Ȱ��� emp��� ��µǼ� �����ϱ� �����.

�׷��� �̷� ���� Ȯ���� �� �� �ֵ��� QB_NAME ��Ʈ�� ����ؾ� �Ѵ�.


select /*+ gather_plan_statistics QB_NAME(main) */ ename
 from emp 
 where empno in (select /*+ QB_NAME(sub) */ mgr
                    from emp );

select * from table(dbms_xplan.display_cursor(format=>'advanced'));


** format>='advanced' �� ����ϸ� �� �� ���� ������ �ִ� ���� ��ȹ�� �� �� �ִ�.


�Ȱ��� �� ������ ���� ��ȹ�� ���� �� �� �������� 2, 3 �� ���� ������ Ȯ���� �� �ִµ�,

���� ID 2�� EMP ���� ���̺�, ID 3�� EMP ���� ���� ���̺��� �ǹ��Ѵ�.

���� MAIN�̳� SUB�� �� �ʿ�� ����, �ڽ��� ���ϴ� ��Ī�� �����൵ �ȴ�.



���� : �ؽ� ���� ���, ���� ���� ���̺��� �޸𸮿� �ø���

select /*+ gather_plan_statistics unnest hash_sj swap_join_inputs(emp@sub) QB_NAME(main) */ ename
 from emp 
 where empno in (select /*+ QB_NAME(sub) */ mgr
                    from emp);

select * from table(dbms_xplan.display_cursor(format=>'advanced'));



swap_join_inputs �� ����ϴµ� �� �� ��ȣ �ȿ� �Ʊ� �ؿ� ���Ծ��� emp@sub �� �״�� �ۼ��ؾ��Ѵ�

�׷��� ���� ���� ���̺���� ����ǰ�, hash right semi join���� ����ȴ�.


** not in�� ����� ���� ���� ������ ������ ���̱� ���ؼ��� hash anti ������ ����ϸ� �ȴ�.



���� : �����ڰ� �ƴ� ������� ����ϴµ�, ���� ��ȹ ������ ���� �������� ����ǰ� �ϱ�

select /*+ gather_plan_statistics unnest hash_aj swap_join_inputs(emp@sub) QB_NAME(main) */ ename
 from emp 
 where empno not in (select /*+ QB_NAME(sub) */ mgr
                                    from emp
                                    where mgr is not null);

select * from table(dbms_xplan.display_cursor(format=>'advanced'));




���� :

1. ���� ������ ���� ������ ���̺��� ��뷮�ΰ� �ƴѰ�?

(1) �� �ٴ�뷮�� �ƴϴ� --> ���� ���� ���� �̿� ( �޸� Ȯ�� ) -- no_unnest

(1) - 1 : ���� �������� ��� --> push_subq �߰�

(1) - 2 : ���� �������� ��� --> no_push_subq �߰�


(2) �� �� ��뷮�̴� --> ���� �̿� -- unnest

(2) - 1 : in �� ����ؾ� �ϴ� SQL �� --> hash_sj �߰�

(2) - 2 : not in �� ����ؾ� �ϴ� SQL �� --> hash_aj �߰�

* �޸𸮿� �ø� ���̺��� ���� �����ϰ� �ʹٸ� swap_join_inputs, QB_NAME ���