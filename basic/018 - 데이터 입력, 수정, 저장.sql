������ ���ǹ����� ������ �ְ� ������ ����ϱ�

** ������ ������ ����ϴ� SQL ��

������ �������� Where �� ������ ����ϸ�, from ���� ����� �� ����ȴ�.

start with ���� connect by ���� �����Ǹ�, start with ���� ����� �� connect by ���� ����ȴ�.

���� start with ���� ������ �����ϴ�.

start with ��            --> ��Ʈ ��带 �����ϸ� �� ���� ����ȴ�.
connect by ��          --> ��Ʈ ���� ���� ��带 �����ϸ� ��ȸ ����� ���� ������ �ݺ� ����ȴ�.

���� : 1���� 10������ ���ڸ� ����ϱ�

select level
 from dual
 connect by level <= 10;

* level : connect by ���� ��߸� ��µǴ� �÷�
* dual : ����� ���� ���� ������ ���̺�
* connect by level (����) : ������ �����ϴ� ���� ����ؼ� �����ϰڴ�.

���� : ��� ���̺��� ���� ������ ����ϱ�

(KING - ���� ���� - ���� ���� - ... )

select level, empno, ename, mgr
 from emp
 start with ename='KING'                                    <-- KING�� root�� �ؼ� �����ϰڴ�.
 connect by prior empno=mgr;

���� : select ���� level �̶�� �÷��� emp ���̺��� ���� �÷��̴�.
�׷���, ��µ� �� �־��� ���� connect by ���� ����߱� �����̴�.

���� : BLAKE ���� ������ ����ϱ�

select level, empno, ename, mgr
 from emp
 start with ename='BLAKE'
 connect by prior empno=mgr;

prior : connect by ���� ���� ���� ¦�� ( ������ ����ϰ� ���� �� �ʼ� )

���� : emp ���̺��� ������ SQL�� �ð�ȭ�ϱ�

select rpad(' ',level*2) || ename as employee, level
 from emp
 start with ename='KING'                            
 connect by prior empno=mgr;

���� : ���� ������� BLAKE�� �����ϰ� ����ϱ�

select rpad(' ',level*2) || ename as employee, level
 from emp
 where ename!='BLAKE'
 start with ename='KING'                            
 connect by prior empno=mgr;

BLAKE�� �����ϰ� ������ where ������ �Ÿ��� �ȴ�.

���� : ���� ������� BLAKE�� ��������� �����ϰ� ����ϱ�

BLAKE�� ��������� �����ϰ� �ʹٸ� connect by ������ �Ÿ��� �ȴ�.

BLAKE��� ���� ��尡 �����Ǹ� �� ����(���� ���)���� ���� ������� ����

���� : �ٽ� BLAKE�� BLAKE �������� ���Խ�Ų ������ ����ϴ� SQL��
   ������ ���� ������� ����ϱ�

select rpad(' ',level*2) || ename as employee, level, sal
 from emp
 start with ename='KING'                            
 connect by prior empno=mgr
 order by sal desc;

** ���� ����� ������ ���� ������� ���ĵǸ鼭 ������ ���ĵ� ����� ��������ȴ�.

���� : ���� ����� �ٽ� ������ ���ĵ� ����� �����ϸ鼭 ������ ���� ������� ���ĵǰ� ����ϱ�

select rpad(' ',level*2) || ename as employee, level, sal
 from emp
 start with ename='KING'                            
 connect by prior empno=mgr
 order siblings by sal desc;

** ����� ���� ���� ���� ������ ������ ���� ������� ������ �ǰ� �ִ�.

������ ���ǹ��� ����� �� ORDER BY ���� �� ���� SIBLINGS ��� Ű���带 ¦������ ����ؾ� �Ѵ�.

���� : �̸��� �Ի��ϰ� ���� ������ ����ϴµ�, ���� ������ ���� ���¸� �����ϸ鼭

���� �Ի��� ��� ������ ����ϱ�

select rpad(' ',level*2) || ename as employee, hiredate, level
 from emp
 start with ename='KING'
 connect by prior empno=mgr
 order siblings by hiredate asc;