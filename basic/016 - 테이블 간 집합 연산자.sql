* �����͸� �����ؼ� ����ϴ� ��� 2���� 

 1. ����(join) : �����͸� �翷���� �����ؼ� ����ϴ� ���
 2. ���� ������ : �����͸� ���Ʒ��� �����ؼ� ����ϴ� ���

* ���� �������� ���� 4���� 

     1.  union  all
     2.  union
     3.  intersect
     4.  minus 

1. ���� �����ڷ� �����͸� ���Ʒ��� �����ϱ� 1(UNION ALL)

���� : �� �ΰ��� ����� ���ļ� ����ϱ� :

select    job,  sum(sal)                                                                            select  '��ü��Ż:'  as  job,  sum(sal) 
   from  emp                                                                                          from  emp;
   group  by   job;

select    job,  sum(sal)
   from  emp
   group  by   job
union  all
select  '��ü��Ż:' as  job,  sum(sal)
  from  emp;

�� ���� select ���� union all ���� �����ϸ� �ϳ��� ����� ���ļ� ����� �� �ִ�.

* ���� �����ڸ� ����� �� ���� ����

      1. ���� ������ �� �Ʒ��� �������� �÷��� ������ �����ؾ� �Ѵ�.
      2. ���� ������ �� �Ʒ��� �������� �÷��� ������ Ÿ�Ե� �����ؾ� �ϴ�.
      3. ���� ������ �� �Ʒ��� �������� �÷��� �÷����� �����ؾ� �Ѵ�.
      4. order  by ���� �� �Ʒ����������� �ۼ��� �� �ִ�. 

2. ���� �����ڷ� �����͸� ���Ʒ��� �����ϱ� 2 ( UNION )

union �� union all �� ���� ������ �������ε�

�������� union �� order by ���� ������� �ʾƵ� ������ �Ͻ������� �����ϰ�,

�ߺ��� �����͸� �ϳ��� ����Ѵٴ� ���̴�.

���� : �μ���ȣ, �μ���ȣ�� ��Ż������ ����ϴµ� �� �Ʒ��� ��ü��Ż ������ ��µǰ��ϰ�
        �μ���ȣ�� ��ȣ������ ����ϱ�

select   to_char(deptno) as deptno, sum(sal)
 from emp
 group  by deptno
 union
 select  '��ü��Ż:'  as  deptno,  sum(sal)
   from  emp;

select   to_char(deptno) as deptno, sum(sal)
 from emp
 group  by deptno
 union all
 select  '��ü��Ż:'  as  deptno,  sum(sal)
   from  emp;
    
���̵� union�� ����ϸ� �ڵ����� ��ȣ������ ������ �ȴ�.

3. ���� �����ڷ� �������� �������� ����ϱ� ( INTERSECT )

���� : emp ���̺�� dept ���̺��� �������� ����ϱ�

SELECT deptno
  FROM empINTERSECT
SELECT deptno
  FROM dept;

���ָ� ����� ������ ���� 10,20,30 �� ��µ� ���� Ȯ���� �� �ִ�.

(40���� ��� x)

4. ���� �����ڷ� �������� �������� ����ϱ� ( MINUS )

���� : emp ���̺�� dept ���̺��� �������� ����ϱ�

emp ���̺�� dept ���̺��� �������� ����ϱ�

SELECT DEPTNO
  FROM DEPT
MINUS
SELECT DEPTNO
  FROM EMP;

�ݴ�� ���� EMP���� DEPTNO�� �������� ���ϸ� �ƹ��͵� ��µ��� �ʴ´�.?

(���� �ֱ� ������)

