WITH �� ����ϱ�


* ������ �������� ������ ������ �ι� �̻� �߻��� ���

  ����ϸ� ���� ������ ���̴� SQL "


 * �׽�Ʈ ���̺�� ���� �ӽ÷� ����ϴ� �����͸� ������ �׽�Ʈ �� ���� �����ϴ�.


����1.  1���� 10������ ���ڸ� ����ϴ� SQL�� �ۼ��ϱ�

  select  level  as  num1
    from  dual
    connect  by  level <= 10; 


���� ����� ���̺�� ����� ������ ���̺�� �������

DBA���� ��Ź�� �ؾ��ϴµ� ...

DBA�� �����ϴ� ���̺��� ����� ���������.

Ȥ�� �����شٸ� with���� ���� ����ϴ� SQL �������� �ӽ÷� ���̺��� ����� �ȴ�. 



����2.  ���� SQL�� with���� �����

with  test_table as ( select level as num1
                              from dual
                              connect by level<=10 )
   select  num1
       from  test_table;  



* as ������ ������ ��ȣ���� �������� ��� �����ͷ� �ӽ� ���̺��� �����ϴµ� �� ���̺� �̸��� test_table �� �ϰڴٴ� ��.

  �׸��� �� �Ʒ��� �������� test_table ������ �پ��ϰ� ���� ������ ���� �׽�Ʈ �� �� �ִ�.

  

* with ���� ���� �ӽ� ���̺��� with ���� ������ �������.


���� 3.  with���� ����ؼ� 10 ������ ¦���� ����ϱ�

with test_table as ( select 2*level as num1
                        from dual
                        connect by level<=5 )
 select num1
  from test_table;