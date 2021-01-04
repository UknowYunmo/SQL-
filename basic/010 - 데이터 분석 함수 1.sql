������ �м� �Լ� :  ������ �м��� �����ϰ� �ϱ� ���ؼ� �����ϴ� �Լ� 

1. ������ ����ϴ� �Լ� 1( RANK )

����: �̸�, ����, ���޿� ���� ������ ����ϱ�

 select ename, sal, rank()  over ( order  by  sal  desc) as ����
   from  emp;

���� : ����, �̸�, ����,  ������ ����ϴµ� [[��������]] ���� ������ ���� ������� ������ ����ϱ�

 select   job,  ename, sal,  rank()  over ( order by  sal desc )  as ����
   from emp 
   group by job;

-- GROUP BY ǥ������ �ƴմϴ� ��

rank �Լ����� group by ���� partition by �� ����ؾ� �Ѵ�.

 select   job,  ename, sal, rank()  over  ( partition by job
                                                    order  by sal desc )  as  ����
  from  emp;


partition by �� ������ �м��Լ����� ��ȣ �ȿ� ���� ��������

partition by job �̶�� �ϸ� ���� ���� ���� ��Ƽ���ؼ� �����ڴٴ� ���̴�. 


�׷��� �Ʒ��� ���� 

rank()  over  (  partition   by   job   <-- �������� ��Ƽ���ؼ� 
                   order  by  sal desc )  <-- ������ ���� ������ ������ ����ϰڴ�. �� �ȴ�.


2. ������ ����ϴ� �Լ� 2 ( DENSE_RANK )


 select   job,  ename, sal, 
 rank() over ( order by sal desc )  as  ����,
 dense_rank() over ( order by sal desc )  as  ����2
   from emp ;

������ rank()�� ����߰�, ����2�� dense_rank()�� ����ߴµ�, �ణ�� ���̰� �ִ�. �����ϱ�?

���� ������ ������ ������ ���� ������ �� ���� ������ �ߺ��� ����ŭ ���ؼ� ��µǴ°��� rank �̰�

�ߺ��Ǿ����� �׳� �ٷ� �� ���� ������ �����°� dense_rank() �̴�.

3���� 2���̾��ٸ� rank�� 5������ ��������, dense_rank�� 4������ ���´�.


3. ����� ����ϴ� �Լ� ( NTILE )

rank�� ���� ��������� NTILE() --< ���� ��ȣ ���̿� �� ������� ������ ���������Ѵ�.

���� : ����, �̸�, ����, ����� ����ϴµ� ������ ���� ����� 3������� �������� �Ͻÿ� !
                                                                  (������ ���� ������ ���)

select  job, ename, sal,  ntile(3)  over ( partition by job 
                                                  order  by  sal  desc ) ���
    from  emp;

3������� ���� �� 2��ۿ� ���� �� ������� �ۿ� ���� �� ���ٸ�, 2������ ��� �ȴ�.

4. ������ ������ ����ϴ� �Լ� ( CUME_DIST )

select  ename, sal,  
         cume_dist()  over ( order  by  sal  desc ) ����
  from  emp;

...
round�� Ȱ���ؼ� ���� ���� ������.

select  ename, sal,  
       round( cume_dist()  over ( order  by  sal  desc ), 3 ) * 100 || '%' as ����
  from emp;