������ �м��� �ϴٺ��� ���� ���� �ð��� �Ҿ��ϴ� �۾��� ������ ��ó��.

ǰ���� ���� �����͸� ó������ �Է¹޵��� ����ȭ�ϸ� ���߿� ������ ��ó���� ���� �ð��� ������ �ʾƵ� �ȴ�.

�׷��� ������ ǰ���� ���̱� ���� �� ������� ������ ����Ѵ�.

�׷��� ó������ ���̺� �����͸� �Է¹��� ������ ������ �������� �����͸� �Է��ϵ��� ������ �Ǵ�.


* ������ ����


1. PRIMARY KEY : �ߺ��� �����Ϳ� null ���� ������� �ʰ� �ϴ� ����

2. UNIQUE        : �ߺ��� �����͸� ������� �ʰ� �ϴ� ����

3. NOT NULL     : null ���� ������� �ʰ� �ϴ� ����

4. CHECK          : Ư�� ������ �� �ٸ� �����ʹ� �Էµ��� ���ϰ� �ϴ� ����

5. FOREIGN KEY : �����ϴ� �÷��� �Ŵ� ����



* PRIMARY KEY - ������ �� ���̺� �����ϱ�

create table emp307
( empno  number(10) primary key,
  ename   varchar2(20) ) ;


���� ���� ���̺��� �����ϸ� ������ empno���� ������ �ߺ��� �����ͳ� null ���� �Էµ��� �ʴ´�.


�׷� empno�� ������ �־��.


insert into emp307 values(1111,'scott');

insert into emp307 values(2222,'smith');

insert into emp307 values(1111,'allen');

insert into emp307 values(null,'jones');



�׷� ������ ���� empno�� �ߺ��� ���̳� null ���� ����ִ� �����ʹ� ���� �ʴ´�.


������ ǰ�� ���̴� ��� ����Ʈ���� ( 1�� �̻� )�� ����ص�, ó������ ���� �����͸� �޴� �� ����.





* UNIQUE - �ߺ��� �����͸� ������� �ʰ� �ϱ�


create table emp506
 ( empno     number(10),
   ename     varchar2(10) unique );


insert into emp507 values (1111,'scott');

insert into emp507 values (2222,'scott');


SCOTT�� �������� �� ��, ���Ἲ ���� ���� �߸鼭 �ȵȴ�.


* ���� ����


1. ������ ���� �̸��� Ȯ���Ѵ�.


select table_name, constraint_name
 from user_constraints
 where table_name='EMP507';


2. EMP507 ���̺��� UNIQUE ������ �����Ѵ�.

alter table emp507
 drop constraint SYS_C007315;


3. �ߺ��� �����Ͱ� �Է��� �� �Ǵ��� Ȯ���ϱ�


insert into emp507 values(2222,'scott');


** ���� ���� �����̸��� SYS_C007315 ��� ���ͼ� �̸��� ������

�� ������ � �������� Ȯ���ϱⰡ ������

������ ó�� ���� ������ �̸��� �ǹ��ְ� �ο��ؼ� ������ָ� ������ ����


4. ���� �̸��� �ְ� ���̺��� �����ϴ� ���


create table emp508
 ( empno number(10),
   ename varchar2(10) constraint emp508_ename_un unique);
  ���̺��_�÷���_�����̸����


5. EMP508 ���̺��� ename�� �ɸ� UNIQUE ���� Ȯ���ϱ�

select table_name, constraint_name
 from user_constraints
 where table_name='EMP508';


6. emp508 ���̺��� ename�� �ɸ� UNIQUE ���� �����ϱ�

 alter   table  emp508
  drop   constraint  emp508_ename_un;


* ������ �����ϴ� ��� 2���� 

   1.  ���̺� ������ �� 

   2.  �̹� ����� ���� ���̺� ������ �߰�



 * �̹� ����� ���� ���̺� ������ �߰��ϴ� ���

  emp ���̺� ename �� unique ���� �ɱ�


  alter table emp
    add  constraint emp_ename_un unique(ename); 


������ ���̺� �ߺ��� �����Ͱ� �ִٸ� ���� ��ɾ�� ������� �ʴ´�.

���� ��� KING �̶�� �̸��� �� �� �� ������ ������� �ʴ´�.



* NOT NULL - null ���� �Է����� ���ϰ� ���� ����

* CHECK - ������ �����͸� �Էµǰ� �ٸ� �����ʹ� �Էµ��� ���ϰ� ���� ����


���� 1 : ���̺��� ������ �� ������ �Ŵ� ���


create table emp745
           (  ename  varchar2(10),
              loc varchar2(20) constraint  emp745_loc_ck  
              check( loc in  ('DALLAS', 'CHICAGO', 'BOSTON') ) );   


--> ���� loc �÷����� DALLAS, CHICAGO, BOSTON ���� �����Ͱ� �Էµǰų� ������ �� ����.


���� 2 : ������� ���̺� ������ �Ŵ� ���


alter table dept
 add constraint dept_loc_ck   
   check( loc in ('NEW YORK', 'DALLAS', 'CHICAGO','BOSTON') );


���� : between�� ����� check ����


alter table emp
  add constraint emp_sal_ck check( sal between 0 and 9500) ;


* FOREIGN KEY - �����ϴ� �÷��� �Ŵ� ����

dept ���̺� primary key ������ �ɰ� emp ���̺� foreign key ������ �ɸ鼭

emp ���̺��� deptno �� dept ���̺� deptno�� �����ϰڴ� ��� �ϰԵǸ�

������ emp ���̺��� deptno�� �μ���ȣ�� �Է��Ҷ� dept ���̺� �ִ� deptno�� 10,20,30,40�� �����͸�

�Էµ� �� �ִ�. �׸��� dept ���̺� deptno�� �����͸� ��������ϸ�

emp ���̺��� deptno�� �����ϰ� �����Ƿ� �������� �ʴ´�.  


* foreign key�� ����ϴ� ����


1. ������ ǰ���� ���̱� ���ؼ�

2. ������ �� outer join�� �������� �ʱ� ���ؼ�  