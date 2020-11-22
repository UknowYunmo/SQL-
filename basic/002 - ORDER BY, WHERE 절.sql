��Ÿ �񱳿�����  4����

 1. between .. and
 2. like
 3. is null
 4. in

1. BETWEEN AND

���� A�� B ������ ���鸸 ���Ǻ� ����Ѵ�.

where �÷��� between A and B

���� : ������ 1000, 3000 ������ ������� �̸��� ������ ����ϱ�

select ename, sal
  from emp
  where sal between 1000 and 3000;

�ݴ�� A�� B������ ��츦 �����ϰ� ������ ���� �ִ�.

where not �÷��� between A and B

���� :  ������ 1000, 3000 ���̰� �ƴ� ������� �̸��� ������ ����ϱ�

select ename, sal
  from emp
  where not sal between 1000 and 3000;

select  ename, sal
  from  emp
  where  ename = 'A%';


2. LIKE

like�� ����ϸ� Ư�� ���ڰ� ���ԵǾ� �ִ� ���ڸ� �˻��� �� �ִ�.

like �����ڸ� ����� �� ����ϴ� Ű���� 2���� :

  1.  %  :  ���ϵ� ī�� :  �� �ڸ��� ���� �͵� ������� �� ������ �� ���� �ǵ� �������. 

  2.  _   :  �����        :  �� �ڸ��� ���� �Ͱ� ������µ� �ڸ����� �Ѱ����� �Ѵ�. 

select  ename, sal
  from  emp
  where  ename  like  'M%';

select  ename, sal
  from  emp
  where  ename  like  '%M%';

select  ename, sal
  from  emp
  where  ename  like  '_M%';

 -- M���� �����ϴ� �̸��� ���� ����� �̸��� ������ ���

 -- M�� ���Ե� �̸��� ���� ����� �̸��� ������ ��� 

 -- M�� �̸��� �� ��° �ڸ��� �ִ� ����� �̸��� ������ ���



3. IS NULL

NULL ���� ��ȸ�� �� ����ϴ� ������


���� : ���ʽ��� �Էµ��� ���� ����� ����ϱ�

select ename, comm
   from emp
   where comm = null;


* comm=null �� ��ȸ�� �� ����.

�ֳ��ϸ� null�� �� �� ���� ���̹Ƿ� �� �������� '='�δ� ��ȸ�� �� ����.

��Ÿ �� �������� is null�� ����ؾ� �Ѵ�.


���� : ���ʽ��� �Էµ��� ���� ����� ����ϱ�

select ename, comm
   from emp
   where comm is null;

between ó�� �ݴ��� ��쵵 ������ �� �� �ִ�.

select ename, comm
   from emp
   where comm is not null;


����� null�� �� �� ���� ���̰�, 0�� ��Ȯ�� ������ ���� ���� �ٸ���.


4. IN

where ���� �˻����ǿ��� �������� ���� ���� ���� in �� ����ϴ� �� ���ϴ�.

where �÷��� in ( ����1, ����2, ����3 )

���� : ��� ��ȣ�� 7788, 7902, 6703 �� �ϳ��� ����� ã�� ����ϱ� 

select   empno,  ename
    from   emp
    where   empno  in  ( 7788, 7902, 6703 );

�ݴ��� ��쵵 ���ó� �����ϴ�.

���� : ������ SALESMAN, ANAYLST�� �ƴ� ������� �̸��� ������ ����ϱ�

select  ename, job
  from  emp
  where  job  not in  ('SALESMAN', 'ANALYST'); 