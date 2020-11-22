1. �����͸� �����ؼ� �հ��ϴ� ������ �м� �Լ� ( SUM_OVER )

SUM( �÷��� ) OVER ( order by �÷��� desc or asc )

����: �����ȣ, �̸�, ����, ������ ����ġ�� ����ϱ�

select   empno, ename, sal,  sum(sal)  over ( order  by  empno  asc) ����ġ
    from   emp; 

�� �����ʿ� ����ġ�� ���� ���̴� ���� Ȯ��.

over�� ���̸� ���� �� ���̴�.

���� �ٸ� �Լ���� ���������� partition by�� ����� �� �ִ�.

����: ����, ����, ������ ���� ����ġ�� ����ϱ�

select  job,  ename, sal,  sum(sal)  over  (  partition  by  job 
                                                       order  by  ename  )  ����ġ
   from  emp;

2.  ������ ����ϴ� ������ �м� �Լ� (RATIO_TO_REPORT)


��ü ������ �߿��� ������ ��� �Ǵ��� Ȯ���ϴ� �Լ�

���� : ������ SALESMAN�� ������� ������ ������ ���� ����ϱ�

select  ename, sal, round( ratio_to_report(sal)  over() ,2 )   as  ����
            from   emp
            where  job='SALESMAN' ;

3. ���� ��� ����ϴ� ������ �м� �Լ� ( ROLLUP )

������ ����� �� �Ʒ��ʿ� ����ϰ� ���� �� ����ϴ� �Լ�

���� : �μ��� ������ ������ ����ϰ�, ��ü �ο��� ������ ���յ� �� �ؿ� ����ϱ�

��� ����� �Ϲ������� GROUP BY�� �����ϰ�, �÷��� �տ� ROLLUP�� ���� ��ȣ�� �����ش�.

select  deptno, sum(sal)
  from  emp
  where deptno is not null
  group by rollup(deptno);


4. ���� ��� ����ϴ� ������ �м� �Լ� ( CUBE )

���� ����� ���ʿ� ����ϴ� �Լ�

��� ����� ROLLUP�� ����, �������� ���� �ƴ϶� �� ���� ������ ����Ѵٴ� �ͻ��̴�.

select  job, sum(sal)
  from  emp
  where job is not null
  group  by  cube( job );

5.���� ��� ����ϴ� ������ �м� �Լ� ( GROUPING SETS )

GROUPING SETS�� ���� �׷��� ������ �Բ� ǥ���ϱ� ���ϴ�.

�̷��� �ϸ� ���� �����̶� mgr, �μ� ��ȣ�� ���� ���� ī��Ʈ �ȴ�.

grouping sets�� rollup�� �����ϰ� �� �� �ִ�.

�ߺ����� �ʴ� empno�� ename�� grouping sets�� ������, ���� sum�� �Ǵ��� ��ü������ ������,

���������� () �� �־, ��ü ��Ż ������ ����Ѵ�.

select  empno, ename, sum(sal)
   from   emp
   group  by grouping sets((empno,ename),());