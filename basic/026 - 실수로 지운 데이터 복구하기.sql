1. �Ǽ��� ���� ������ �����ϱ� ( FLASHBACK QUERY )


����Ŭ�� 10g �������� Ÿ�� �ӽ� ����� �����.


�׷��� Ÿ�� �ӽ� ����� �̿��ؼ� ������ �����͸� Ȯ���� �� �ְ�

���̺��� ���ŷ� �ǵ��� ���� �ִ�.


flashback query�� ������ �����͸� Ȯ���ϴ� ����̴�.


�� :

delete from emp;


commit;


��������� emp ���̺�

commit ���� �ع��ȴ�.



* 10�� ���� �־��� emp ���̺� ���¸� Ȯ���ϱ�


select *
 from emp as of timestamp( systimestamp - interval '10' minute );



�׷� �ϴ� �̰� �״�� emp ��� ���̺� �����ϰ�,


create table emp_backup_20201111
 as
  select *
    from emp as of timestamp( systimestamp - interval '10' minute );




emp ��� ���̺��� emp ���̺� ���� �ٽ� �ű���


insert into emp
 select *
  from emp_backup_20201111;



select * from emp;



2. �Ǽ��� ���� ������ �����ϱ� ( FLASHBACK TABLE )


* Ư�� ���̺��� ���ŷ� ������ �ǵ��� ������ ���

delete from dept;

commit;


(1) dept ���̺��� flashback �� �� �ֵ��� �����Ѵ�.


alter table dept enable row movement;


(2) dept ���̺��� ���ŷ� �ǵ�����.

flashback table dept to timestamp
(systimestamp - interval '5' minute);


(3) dept ���̺��� ��ȸ�Ѵ�.

select * from dept;


** ���ŷ� �ǵ����� ���ϴ� ���

1. sys �������� �۾����� ���

2. delete �ϰ� commit �� ���Ŀ� DDL ��ɾ ���������� �ȵȴ�.



* ���ŷ� �ǵ��� �� �ִ� ��� Ÿ�� Ȯ���ϴ� ���

SHOW PARAMETER UNDO_RETENTION;


��µ� VALUE�� 900�ʸ� �ǹ��Ѵ�. (15��)



*** flashback table ��ɾ �����ؼ� ���ŷ� �ǵ������� �ݵ�� commit�� �ؾ��Ѵ�.
     �ڵ� commit�� �ȵǱ� ������ ����ϸ� �ȵȴ�.


3. �Ǽ��� ���� ������ �����ϱ� 3 ( FLASHBACK DROP )

���̺��� drop ���� ��쿡�� ������ �� �ִµ�

10g ���� ���ĺ��ʹ� drop�� ���̺��� �����뿡 �Էµȴ�.

�׷��� �����뿡�� ������ ���⸸ �ϸ� ������ ���� �ִ�.


drop table dept;



[1] show recyclebin;



[2] select *

     from

      recyclebin;

�� �� �ϳ��� ��� �ϸ� �ȴ�.


�׷� �̷��� �������� ����� �ȴ�.

�� �������� ������� ������ ����ؼ� �����뿡 ���̺��� �ֱ� ������ ������ ���� �ִ�.


flashback table dept to before drop;


* �������� ���� ��ɾ�

purge recyclebin;

* �����뿡 ���� �ʰ� ���̺��� �����ϴ� ���

drop table ���̺�� purge;


4. �Ǽ��� ���� ������ �����ϱ� 4 ( FLASHBACK VERSION QUERY )


Ư�� ���̺��� ���ŷκ��� ������� ��� ������ �Ǿ�Դ���

�� �̷� ������ Ȯ���� �� ����ϴ� ������

(1) ���� �ð� Ȯ���ϱ� (���ص� ��)

select systimestamp from dual;

20/11/11 15:50:14.581000000 +09:00   --->> ���� �ð� Ȯ��


(2) KING�� �̸��� ���ް� �μ���ȣ�� ��ȸ�ϱ�

select ename, sal, deptno
 from emp
 where ename='KING';

(3) KING�� ������ 8000���� ������ �� COMMIT �ϱ�

update emp
 set sal=8000
 where ename='KING';

COMMIT;

(4) KING�� �μ���ȣ�� 20������ ������ �� COMMIT


update emp
 set deptno=20
 where ename='KING';

 COMMIT;

(5) �׵��� KING�� �����Ͱ� ��� ����Ǿ� �Դ��� �� �̷� ������ ȭ���ϱ�


select  ename, sal, deptno, versions_starttime, versions_endtime,
         versions_operation
 from   emp 
 versions  between  timestamp 
              to_timestamp('20/11/11 15:50:10','RR/MM/DD HH24/MI/SS')  --> (1)���� Ȯ���ߴ� �ð�
             and  maxvalue
 where  ename='KING'
 order  by  versions_endtime;


(6) ���� �ð� �߿� �ϳ��� Ȯ���ؼ� �� �ð����� emp ���̺��� ���¸� Ȯ���ϱ�

select *
 from emp as of timestamp
 to_timestamp('20/11/11 15:53:19', 'RR/MM/DD HH24/MI/SS'); --> (5)���� �ô� �ð��� �� �ϳ� ����


(7) �� �ð����� emp ���̺��� �����ϱ�

alter table emp enable row movement;

flashback table emp to timestamp
 to_timestamp('20/11/11 15:53:19', 'RR/MM/DD HH24/MI/SS');

select * from emp;

commit;


* �ϴ� ���ŷ� ���� ����� ���ƿ� �� ����.

  �׷��� �ð��� ��Ȯ�ϰ� Ȯ���ؼ� �����ϰ� �ǵ����� �Ѵ�.


5. �Ǽ��� ���� ������ �����ϱ� 5 ( FLASHBACK TRANSACTION QUERY )

�ǽ��� �� �ȵǰ� DBA ������ ������� ���� �ǽ� X

- �׵��� �۾��ߴ� DML ������ Ȯ���� �� �� �ִ�.