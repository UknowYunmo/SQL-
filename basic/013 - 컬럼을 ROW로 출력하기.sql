1. COLUMN�� ROW�� ����ϴ� ��� 1 ( SUM + DECODE )

�ϴ� ����, emp ���̺��� �μ���ȣ (deptno) ���� ������ ������ Ȯ���ϰ� �ʹٰ� ��������.

select deptno, sum(sal)
 from emp
 group by deptno
 order by deptno;

�̰��� ���η� ����ؾ��ϸ� ��� �ұ�?

������ ��� DECODE �Լ��� Ȱ���ؾ� �Ѵ�.

DECODE ( �÷���, ����1, ��� 1, ����2, ��� 2, �� �� ��� 3 ) ���� ����Ǵµ�,

������ 

select  decode( deptno, 10, sal , 0  )  
   from  emp;

�� �����غ���

�̷����ϸ� �μ� ��ȣ�� 10�� ��츸 sal(����) �� ��µǰ� ������ 20, 30 ���� ���� 0�� ��µ� ���� �� �� �ִ�.

�� ���� ���� ������ �����ϴ�.

sum���� �� ��� ���� �����ָ�
������ ���� �� �� �࿡ �μ���ȣ�� 10�� ������� ���� ������ ��������.

select  sum( decode( deptno, 10, sal , 0  )  )  as "10"
   from  emp;

�׷��ٸ� �� ���� �ٸ� �μ��鵵 �غ���.

select  sum( decode( deptno, 10, sal , 0  )  )  as  "10",
         sum( decode( deptno, 20, sal , 0  )  )  as  "20",
         sum( decode( deptno, 30, sal , 0  )  )  as  "30"
   from  emp;

***

select  sum( decode( telecom, 'sk', age, 0  )  )  as  "sk",
         sum( decode( telecom, 'lg', age, 0  )  )  as  "lg",
         sum( decode( telecom, 'kt', age, 0  )  )  as  "kt"
   from  emp12;

�� �ڵ�� ���������� �۵�������, �̰��� ��û�� ũ���� �����Ͷ�� �������� ��, ȿ���� ũ�� ���� �� �ִ� ����� �ִ�.
�� �κи� �ٲ��ָ� �Ǵµ�, ����ϱ�?

select  sum( decode( telecom, 'sk', age )  )  as  "sk",
         sum( decode( telecom, 'lg', age  )  )  as  "lg",
         sum( decode( telecom, 'kt', age,  null )  )  as  "kt"
   from   emp12;

������ 0 ��� ������ų� null ���� �ִ� ���̴�.

������ ����� ���� �ִµ� sum, avg ���� ���� �Լ��� null ���� �ٷ� �ǳʶپ������.

������ �߸��� ����ó�� 0���� �ٲٸ� ���� �� �� ������ �� ��� ������ ���Խ�Ű�� ������ ���� �߸��ǰų� ������ �� �ִ�.

2. COLUMN�� ROW�� ����ϴ� ��� 2 ( PIVOT )

���θ� ���η� ����ϴ� �Լ� PIVOT

select * from (�ǹ��� ������) as result pivot ( �׷��Լ�(�����÷�) for �ǹ�����÷� in ([�ǹ��÷���]...) as pivot_result


���� : 

select   *       <-- pivot �� ����� ���� �׳� * �� ���� �� ����
        from  ( select  deptno, sal  from  emp )  <-- ��� ���̺��� �׳� 
                                                                   �μ���ȣ�� ���޸� �����´�.  (emp ���̺�� �� �� �� ����.)
                                                                   ����� �������ؼ� �ʿ��� �÷��� �����ؼ� �����´�. 
        pivot   (  sum(sal)  for  deptno  in ( 10, 20, 30 )  )  ;
                       ��        
                    ��Ż������ ����ϰڴ�. � ��Ż����?  �μ���ȣ�� ���� 
                    � �μ���ȣ ?  10��, 20��, 30���� �μ���ȣ 