1. ������ �Է��ϱ� ( INSERT )

** ���̺� �����͸� �Է��ϴ� SQL ����

insert into ���̺��(�÷���) values (�� �÷��� ���� ��) 

���� : emp ���̺� ��� ��ȣ : 1234, ��� �̸� : jack ���� : 4500�� ���� �����͸� �Է��ϱ�

insert   into   emp(empno, ename, sal )
        values ( 1234, 'jack', 4500 );

������ �Է��� �÷����� ����� �� ���� �÷� ������� ���� ����ϸ� �ȴ�.

2. ������ �����ϱ� ( UPDATE )

** �����͸� �����ϴ� SQL ����

update ���̺��
 set �÷��� = �÷��� ���� ��
 (where)

���� : KING �� ������ 9000 ���� �����ϱ�

update  emp
  set  sal = 9000
  where  ename='KING';

** commit (Ŀ��) �� rollback (�ѹ�)

commit;  --->  ���ݱ��� ������ ��� �۾��� �� database �� ������ �����ϰڴ�.
rollback;  ---> commit ���Ŀ� �۾��� ��� ��������� ����ϰڴ�. 

3. ������ �����ϱ�( DELETE, TRUNCATE, DROP )

* ����Ŭ���� �����͸� �����ϴ� ��� 3���� 

      1. delete 
      2. truncate
      3. drop 

(1) delete

�����͸� ���� �Ǹ� ���̺� �뷮�� �پ� ���� �ʴ´�.
���� ������ �߸� ������ ���� �ǵ��� �� �ִ�.
Commit�������� Rollback�� �����ϴ�.
��ü �Ǵ� �Ϻθ� ���� �����ϴ�.

alter  table  emp   enable    row   movement; 
--> emp ���̺��� flashback �� ������ ���·� �����Ѵ�. 

�׻� �߿��� ���̺��� �̷��� �����ص���.

�׸��� delete�� �Ͼ�� ���,

flashback  table  emp   to   timestamp  
( systimestamp  -  interval  '15' minute );

--> ����ð��� 15�������� emp ���̺��� �ǵ�����.

��� Ÿ���� 15���̹Ƿ� �������� 15�� �ȿ� �ؾ��Ѵ�.

(2) truncate

���̺��� ���� ������ �ʱ���·� �����.
�뷮�� �پ���.
Rollback �Ұ����ϴ�.
flashback �Ұ����ϴ�.
������ ��ü ������ ���� �ϴ�.

(3) drop

���̺��� ���� ��ü�� ������ �����Ѵ�.
Rollback �Ұ����ϴ�.
������ ����� �־ flashback �� �����ϴ�.

show  recyclebin;   <-- ������ӿ� �ִ� ������ Ȯ�� 
flashback  table  emp  to  before  drop;  <-- �����뿡�� �����ϴ� ��ɾ�

4. ������ �Է�, ����, ���� �ѹ��� �ϱ�( MERGE )

������ �Է°� ������ ������ �ѹ��� �����ϴ� ��ɾ�.

SQL Ʃ���� ���ؼ� ���� ���Ǵ� SQL�̴�.

merge�� ����ϱ� ��

���� �߰��� �÷��� ���� ������ ���ƾ� �Ѵ�

�÷��� �߰��ϴ� ��� :

alter table ���̺��
 add �÷��� ������ ����;

���� : ��� ���̺� �߰��� �μ���ġ(loc) �÷��� �����͸� �ش� ����� �μ���ġ�� ���� �����ϱ�

alter  table  emp
   add  loc   varchar2(10);

--> emp ���̺� ���� loc�̶�� �÷��� �����

merge  into  emp   e 
 using   dept   d --> �����͸� ����� �ٸ� ���̺�
 on   ( e.deptno = d.deptno) --> ���� ��
 when  matched  then
 update   set   e.loc = d.loc; --> �Ʊ� ���� loc �÷��� dept ���̺��� loc �÷��� ����