* ���� �����ϱ�

create user king                   ----> ���� �̸�
 identified by tiger;               ----> ��й�ȣ


* ������ �� �ִ� ���� �ֱ�

grant connect to king;


--> king���� connect ������ �ְڴ�!


* king���� �����غ���


cmd â�� ����,


sqlplus king/tiger �Է�



* ������ �̸� Ȯ���ϱ�


show user;


* �α� �ƿ��ϱ�


exit

�翬������ �̷���

�α� �ƿ��� ����� �ٸ� ������ �ٽ� �� �� �ִ�



* ���� ���¿��� ���̺� �����

create table emp407 ( empno number(10), ename varchar2(10) );


-- ���̺��� ����� ������ ��� ���̺��� ���� �� ���ٰ� ���´�.


�׷�, �ϴ� �α׾ƿ��ϰ�, �����ڷ� ����.

exit

sqlplus/ "/ as sysdba" --> �����ڷ� ����


show user  --> ���� Ȯ��


grant create table to king  --> ���̺��� ����� ������ king���� �ְڴ�


exit --> �α׾ƿ�


sqlplus king/tiger --> king���� ����


create table emp407 ( empno number(10), ename varchar2(10) ); --> ���̺� ������



* ���� ���� �ִ� ��� ������ �˾ƺ���


select * from session_privs;


* ��� ���� ����ϱ� ( revoke )


sys �������� king���� �־��� create table ������ ����ϰ� �ʹٸ�?


revoke create table from king;


* ���� �����ϱ�


drop user king cascade;