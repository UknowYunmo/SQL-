* ������ �Լ�


1. �������� ������ ���� ���� �Լ� (count)

���� : ��� ���̺� ����ִ� ����� �� ������ ����ϱ�

select count(*)
 from emp;

15���� ����� ����ִ� emp ���̺��̱� ������ 15�� ��µǾ���.

2. ��ġ ������ Į���� �հ踦 ����ϴ� �Լ� (SUM)

���� : ������ SALESMAN�� ����� ������ ������ ����ϱ�

select sum(sal)
 from emp
 where job='SALESMAN';

3. ��ġ ������ �÷��� ����� ����ϴ� �Լ� (AVG)

select avg(comm)                                                                                        
 from emp;                                                                                                 

select avg(nvl(comm,0))
 from emp;                                                                                                 

nvl�� comm�� �������� ��� nvl�� null ���� 0���� �ٲٱ� ������ ���� ������ �� �� ���� �� ����.

�׷��� �� �� ���� ��� ���� �޶�������?

���� �Լ��� null ���� 0���� ���� �ʰ�, ��� ��ü�� �ǳʶپ� ������.

�׷��� 1���� ���� comm�� ���� ��� ������ �ʾƼ� �� ũ��,

2���� comm�� ���� ��츦 0���� �ٲ㼭 ��꿡 ���ԵǾ��� ������ ����� ����� ��������.

4. ��ġ ������ �÷��� �ִ�, �ּҰ��� ���ϴ� �Լ� ( max, min ) 

select max(sal), min(sal)
 from emp;


5. �׷� ���� ���� ����� �� �� �ֵ��� �ϴ� �� (group by)

select job, max(sal),min(sal),avg(sal)
 from emp
 group by job;

select job, max(sal),min(sal),round(avg(sal))
 from emp
 where job is not null
 group by job
 order by job;

-- ��� �͵��� Ȱ���ؼ� ����ϰ� ����