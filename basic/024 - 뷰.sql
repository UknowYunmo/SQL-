���� : 1���� 6���� ���� ���� ������ �����ϱ�

create sequence seq1
 start with 1                    
 maxvalue 6;


�� �� start with�� �������� ���� ��ȣ,

maxvalue�� �������� �ִ� ��ȣ�� ���Ѵ�.


�̷��� ���������,


select seq1.nextval
 from dual;


�� ������Ѻ���.


1�� ��µǾ���.


�׸��� �Ʊ� �����Ų


select seq1.nextval
 from dual;


�� ������ ��~�� �ݺ� �����غ��� ��� 1�� �����ϴ� ���� ���δ�.


�׷��ٰ� 6���� ����ǰ�,

�� �� �� �ϸ�

������ �߻��ϸ鼭 �� �ȴ�.

�Ʊ� maxvalue �� 6���� �����صξ��� ����.




** �������� �̿��ϸ� ���� ��


��ȣ�� �ߺ����� �ʰ� �ϰ��ǰ� ���̺� �Է��� �� �ִ�.



��ȣ�� �ߺ��Ǹ� �ȵǴ� �÷���?


�ֽ� ���̺� �ŸŹ�ȣ, ��� ���̺��� ��� ��ȣ ��..


���̺�  emp534 ����

create table emp534
( empno number(10),
  ename varchar2(20),
  sal   number(10) );


seq2�� �̿��ؼ� emp534�� empno�� �ϰ��� ��ȣ�� �Էµǰ� �ϱ�


insert into emp534
values(seq2.nextval,'scott',3000);


select * from emp534;


Ȯ���غ���, ������ ��ȣ�� empno�� ����.



* �������� ���簪 Ȯ���ϴ� ���

select seq2.currval
 from dual;


* ���� ������ �ִ� ������ Ȯ���ϴ� ���


select sequence_name
 from user_sequences;


* ������ �����ϴ� ���

drop sequence ������ �̸�