** ����Ŭ�� ���̺� ����


1. �Ϲ� ���̺� ( heap table )
2. �ӽ� ���̺� ( temp table )
3. �ܺ� ���̺� ( external table )
4. ��Ƽ�� ���̺� ( partition table )


�ܺ� ���̺�(external table) �����


(1) emp.txt�� c ����̺� �ؿ� data��� ������ ����� �� �ȿ� �ֱ�


(2) c ����̺꿡 data ������ ����Ŭ ���丮�� �����ϱ�

create directory emp_dir as 'c:\data';

(3) �ܺ� ���̺� �����ϱ�

organiztion external --> external table�� �����ϰڴ�.

type oracle_loader --> data�� �ε��ϴ� ������ sql*loader�� ����ϰڴ�.

 (�ڵ����� insert���� ������ִ� �༮)

default directory emp_dir --> emp_dir �� �⺻ ���丮�� �ϰڴ�.

access parameters --> ���� text ������ ������ ���̺� �Է��ϱ� ���� ������ �����ϰڴ�.

(records delimited by newline --> ��� �� ���̴� ���ͷ� �����ϰڴ�

fields terminated by "," --> �����Ϳ� �����ʹ� �޸�(,)�� �����ϰڴ�.

(empno char, --> �ܺ� ���̺��� �÷����� ���� �����ʹ� �����ε�

ename char, --> �ε� ����Ŭ���� ���ڷ� �Է��Ѵ�.

...

...

deptno char))

location ('emp.txt')); --> ��ũ�� �� ������ ��ġ


(4) ���̺� Ȯ��


** �ܺ� ���̺��� ����


1. database�� ���� ������ �ʿ� ����.

2. ��뷮 �������� ��� ���̺� �Է��ϴ� �ð��� ���� �� �ִ�.

���� : ext_emp11 ���̺��� ��ȸ�ؼ� ������ SALESMAN�� ������� �̸��� ������ ������ ����ϱ�

select ename, job, sal
 from ext_emp11
 where job ='SALESMAN';


���ó�� ���̺� �� �ܺ� ���̺� �̸��� �־��ָ� �ȴ�.

���� : �̸��� �μ���ġ�� ����ϱ�

select e.ename, d.loc
 from ext_emp11 e, dept d
 where e.deptno=d.deptno;


** �ܺ� ���̺��� ����


1. DML �۾��� �ȵǰ� ���� SELECT�� �����ϴ�.

2. �ε����� ������ ���� ����.

���� : ext_emp11�� scott�� ������ 6000���� �����ϱ� 

update ext_emp11
 set sal=6000
 where ename='scott';


�׷��� �̷��� ������ �߻��Ѵ�. don't do that!

* �ܺ� ���̺��� � �� �ִ��� Ȯ���ϰ� �����ϴ� ���

select table_name, external
 from user_tables
 where external = 'YES';



�̷��� Ȯ���� ������, �����ϰ� ���� ���̺���

drop table ext_emp11
drop table ext_dept
drop table ext_dept2

���ָ� �ȴ�.