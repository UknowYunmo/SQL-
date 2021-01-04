* ���� ����  2����      1.  ����Ŭ ���� ����
                                                - equi  join
                                                - non equi  join
                                                - outer  join
                                                - self  join
                                  2.  1999 ANSI ���� ���� 
                                                - on ���� ����� ����
                                                - using ���� ����� ���� 
                                                - natural  join
                                                - left/right/full  outer  ����
                                                - cross ���� 

������ �ٷ� ���� ����Ŭ ���� ����.

�̹����� ANSI ���� �������� ������ �غ���.

1. ���̺��� �����͸� �����ؼ� ����ϱ� 1 ( ON �� )

1. ����Ŭ equi  join                                   2. on ���� ����� ����

  select  e.ename,  d.loc                             select  e.ename, d.loc
    from  emp  e, dept  d                               from  emp  e  join   dept  d
   where  e.deptno = d.deptno ;                       on  ( e.deptno = d.deptno ) ;

�������� �޸��� �������, where �� ��ſ� on ���� �־��� ���̴�.

�ٵ� �̰� �� ��?

���� : DALLAS ���� �ٹ��ϴ� ������� �̸��� ���ް� �μ���ġ�� ������ ����ϱ�

select  e.ename, e.sal, d.loc, e.job
  from  emp  e  join  dept  d
  on  (  e.deptno = d.deptno )
  where  d.loc='DALLAS'; 

������ ���� �˻� ������ where ���� ������ �� on ���� ������ �Ǽ�

���� ���ǰ� �˻� ������ ��Ȯ�ϰ� �����ؼ� �˾ƺ��� ���ϴٴ� ������ �ִ�.

2. ���̺��� �����͸� �����ؼ� ����ϱ� 2 ( USING �� )

���� : ������ SALESMAN �� ������� �̸��� ���ް� ����, �μ���ġ�� ����ϱ�

select  e.ename, e.sal,  e.job,  d.loc
  from   emp  e   join  dept   d
  using  ( deptno )
  where  e.job='SALESMAN'; 

ON ���� ���� ����.

�������� ON ��� USING�� �÷��� ������ش�.

���������� ON ������ �� ����� �� ����.

3. ���̺��� �����͸� �����ؼ� ����ϱ� 3 ( FULL OUTER JOIN )

�׷��ٸ�, ���ʿ� �����Ͱ� ������ ���� ���ʿ� OUTER JOIN�� �� �� ������?

���� : ����� �̸��� �μ���ġ�� ����Ͻÿ�

select  e.ename, d.loc
 from  emp  e,   dept   d
 where  e.deptno (+) = d.deptno (+);

ORA-01468: outer-join�� ���̺��� 1���� ������ �� �ֽ��ϴ�.

OUTER JOIN�� ���ʿ� �����ϸ� ������ ���� ������ �߻��Ѵ�.

�׷��� 

select  e.ename,  d.loc
  from  emp  e   full  outer   join   dept   d
   on  ( e.deptno = d.deptno );

�Ǵ�

select  e.ename,  d.loc
  from  emp  e   full  outer   join   dept   d
   using ( deptno );

�̷��� full outer join�̶�� �����ϰ� on �� �Ǵ� using ���� �������� �Ѵ�.

4. ���̺��� �����͸� �����ؼ� ����ϱ� 4 ( NATURAL JOIN )

** where �� ���� �����ϰ� �����ϴ� ���� ����
   ����Ŭ�� �˾Ƽ� �� ���̺� ���̿� ����� �÷��� �ִ��� ã�ƺ��� �����Ѵ�. 

���� : �����(emp ���̺�) �μ� ��ġ��(dept ���̺�) ����ϱ�

select  e.ename,  d.loc
 from  emp  e  natural  join  dept  d; 

�и� ���� �����ε�, �ƹ����� ��谡 �˾Ƽ� �ϴϱ� �������� ����ϱ⿡�� �� �����ϴٰ� �Ѵ�.