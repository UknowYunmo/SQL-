** ���Խ� �Լ�


������ �˻��� �� �� ���ϰ� �Ϸ� �� ��, ������ �Լ��δ� ǥ���� �� ����

������ �˻��� �� �� �ְ� ���ִ� �Լ�



* Regular expression ( ���� ǥ���� )

���� ǥ���� �ڵ�� ����Ŭ �Ӹ� �ƴ϶� �ٸ� ������ ���������� ����ϴ� ǥ���� �ڵ��̴�.

����Ŭ 10.1 �������� ���� ǥ������ �����Ѵ�.

����Ŭ �����ͺ��̽��� ���� ǥ������ POSIX �����ڸ� �����Ѵ�.

POSIX�� Portable Operation System Interface �� ���ڷ�,

�ý��۰� ȣȯ���� ���� �̸� ���ǵ� �������̽��� �ǹ��Ѵ�.

Posix �����ڿ��� �⺻ ������, ��Ŀ, ������, ���� ǥ����, ������, ���� ����Ʈ, posix ���� Ŭ���� ���� �ִ�.


* �⺻ ������


������                            ����                            ����



   .                                 dot                        ��� ���ڿ� ��ġ

   |                                  or                         ��ü ���ڸ� ����

  \                             backslash            ���� ���ڸ� �Ϲ� ���ڷ� ó��


���� : select regexp_substr('aab','a.b') as c1,
	regexp_substr('abb','a.b) as c2,
	regexp_substr('acb','a.b) as c3
	regexp_substr('adc','a.b) as c4
          from dual;


���� : �̸��� EN, IN �� ���� ������� �̸��� ������ ����ϱ�


�⺻ ��

select ename, sal
 from emp
 where ename like '%EN%' or ename like '%IN%';


���Խ� �Լ� ���

select ename, sal
 from emp
  where regexp_like(ename,'EN|IN');


--> �̷��� �ϸ� where ���� ��� �÷������� �ʾƵ� �Ǵ�
      �ڵ尡 �����Ҽ��� �ξ� �� �����ϰ� �ۼ��� �� �ִ�.


���� : ����� �� ���� St�� �����ϰ� en���� ������ ����� ����ϱ�

�⺻ ��

select first_name
 from employees
 where first_name like 'St%en';

���Խ� �Լ� ���

select first_name
 from employees
 where regexp_like(first_name,'^St(.)+en$');

--[����]--

^ : ������ ��Ÿ����.
$ : ���� ��Ÿ����.
--> St�� �����ϸ鼭 ���� en���� ������.

����� �ִ� (.) ���� . �� �� �ڸ��� ��Ÿ���µ�,
+ �� ���� ���� ��Ÿ���� ���� �ǹ��ϱ� ������
�� �ڸ��� �������� ���� ��Ÿ����.


��������� St�� en ���̿� ���� ���� ö�ڰ� �͵� �ȴٴ� ���� �ǹ��Ѵ�.

* ���� ǥ����

���� ǥ������ ǥ������ �Ұ�ȣ�� ���� ǥ�����̴�.

���� ǥ������ �ϳ��� ������ ó���ȴ�.



������                                        ����

(ǥ����)                            ��ȣ ���� ǥ������ �ϳ��� ������ ���

   +                                 1ȸ �Ǵ� �� �̻��� Ƚ���� ��ġ

���� : select regexp_substr('ababc','(ab)+c') as c1,

regexp_substr('ababc','ab+c') as c2,

regexp_substr('abd','a(b|c)d') as c3,

regexp_substr('abd','ab|cd') as c4

from dual;


c1�� +�� (ab)�� �ϳ��� ���Ĺ����� ����, ababc�� ���԰�
c2�� +�� b�� �ϳ��� ���Ĺ����� ���� abc�� ���Դ�.


* regexp_count �Լ� ( count�� ���׷��̵� ���� )

Ư�� �ܾ ö�ڰ� ���忡�� �� �� �ݺ��Ǿ ��µǴ��� Ȯ���ϴ� �Լ�


���� : ���� ���ڿ����� gtc�� �� �� ���Դ��� ����

SELECT REGEXP_COUNT(
'ccacctttccctccactcctcacgttctcacctgtaaagcgtccctccctcatccccatgcccccttaccctgcagggtagagtaggctagaaaccagagagctccaagctccatctgtggagaggtgccatccttgggctgcagagagaggagaatttgccccaaagctgcctgcagagcttcaccacccttagtctcacaaagccttgagttcatagcatttcttgagttttcaccctgcccagcaggacactgcagcacccaaagggcttcccaggagtagggttgccctcaagaggctcttgggtctgatggccacatcctggaattgttttcaagttgatggtcacagccctgaggcatgtaggggcgtggggatgcgctctgctctgctctcctctcctgaacccctgaaccctctggctaccccagagcacttagagccag','gtc') AS Count
FROM dual;

���� : �̸��� O�� ���� ��� �� ����

count���� �ٸ��� �� �� ��µȴ�.

�׷��� ���� �� ���� ���� �ʹٸ�

select sum(�Ǽ�)
 from
    (select ename,regexp_count(ename,'O') as �Ǽ�
    from emp);


������ ���� ���� ������ �� �� �� ������Ѵ�.


* regexp_replace ( replace�� ���׷��̵� ���� )

���� : �̸��� ������ ����ϴµ� ������ ����� �� replace �Լ��� �̿��ؼ�
	���� 0�� *�� ����ϱ�


select ename, replace( sal, 0, '*' )
 from emp;



���� : �̸��� ������ ����ϴµ� ������ ����� ��
	���� 0~3�� *�� ����ϱ�

select ename, regexp_replace( sal, '[0-3]', '*')
 from emp;