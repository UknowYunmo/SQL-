�����Ͱ� ��κ� ��뷮�̱� ������

�����͸� ������ �˻��ϱ� ���ؼ��� 

SQL Ʃ���� �� �� �־���Ѵ�.



* SQL Ʃ��

������ �˻� �ӵ��� ����Ű�� ���



* �ε��� ������ ��� 8����


  �ε��� ������ ���                                          ��Ʈ            

1. index range scan                                           index

2. index unique scan                                         index

3. index skip scan                                             index_ss

4. index full scan                                              index_fs

5. index fast full scan                                         index_ffs

6. index merge scan                                          and_equal

7. index bitmap merge scan                                index_combine

8. index join                                                    index_join



* ����Ŭ ��Ʈ ( hint )

����Ŭ ��Ƽ�������� SQL�� ������ �� ���� ��ȹ�� SQL ����ڰ� �����ϴ� ��ɾ�

��Ƽ���������� ������ �´� ������ ��Ʈ�� �ָ�, ��Ƽ�������� ����ڰ� ��û�� ��� ���� ��ȹ�� �����.

��Ʈ�� ��ġ �ٵ� �δ� �� �Ƽ��� �δ� �Ͱ� ���Ƽ�,

���� ���� ���� �ȵǴ� �Ƽ���� �Ǵ��ϸ� �����ϰ�, �մ��� ��Ʈ��� �Ǵ��ϸ� �׿� ������.


* ���� ��ȹ ���� ��

explain plan for
 select ename, sal
  from emp
  where sal >= 1400;


select * from table ( dbms_xplan.display );  --> SQL ���� ����� ���� ���� �ƴ϶�, ���� ��ȹ�� Ȯ���Ѵ�


���� ��ȹ�� full table scan ���� ������ emp���̺��� ó������ ������ �� ��ĵ�ߴٴ� ���̴�.


���� ��ȹ�� ���� 2����

1. ���� ���� ��ȹ : SQL�� �����ϱ� ���� ���� ��ȹ�� ������ ��


- explain plan for

[+ Ȯ���ϰ� ���� SQL �� �ۼ�]


select * from table(dbms_xplan.display);


2. ���� ���� ��ȹ : SQL�� ���� �����ϸ鼭 ������ ���� �ٷ� �����ִ� ���� ��ȹ


- gather_plan_statistics ��Ʈ


* SQL �� ���鼭 ���� ���� ��ȹ���� ���� ���� ���� ��


select /*+ gather_plan_statistics */ ename, sal
 from emp
 where sal = 1300;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


buffer�� ������ �� SQL ���� ó���ϱ� ���ؼ� �о���� �޸� ���� �����̴�.

����

������� �ִ� buffers�� ������ �������� ������, Ʃ���� ������ ���ٰ� �� �� �ִ�.




* �ε����� Ʃ���ϱ�


1. sal �÷��� �ε��� �ɱ�

create index emp_sal
 on emp(sal);


buffer�� �ٰ�, full scan���� index range scan���� �ٲ����.



Ȥ�� ��Ƽ������ ������ ���� �ʾƼ�, �ε����� ������� �ʾҴٸ�, ��Ʈ�� �� ��ü������ �ۼ��ؾ��Ѵ�.

select /*+ gather_plan_statistics index(emp emp_sal) */ ename, sal
 from emp
 where sal = 1300;

 
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



���� : ��� ��ȣ, �̸�, ����, ������ ����ϱ� ( Ʃ�� �� )

select /*+ gather_plan_statistics */ empno, ename, sal. job
 from emp
 where empno = 7788;


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));




���� : ��� ��ȣ, �̸�, ����, ������ ����ϱ� ( Ʃ�� �� )

create index emp_empno on emp(empno);


select /*+ gather_plan_statistics */ empno, ename, sal. job
 from emp
 where empno = 7788;

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

                                   (��Ű��)   (���ν���)                (�̰� �� ���ָ� buffers �� ���´�)



��ǻ���� ���� ������ �Ųٷ� 2 - 1 - 0 �̴�.

�� INDEX RANGE SCAN ���� �����ؼ�,

INDEX�� ROWID��, ���̺� �����ؼ� ��ȸ�ߴٴ� ��!

(ROWID�� ��ȸ�ؼ� �����ϴ� �ε����� ������ ������ �����߾���)




* �׻� �������� �º��� �������� ����!! �ε����� �ߵ����� �ʴ´�.


����1 : ������ SALESMAN�� ������� �̸��� ���ް� ������ ��ȸ�ϱ� ( �º� ���� ) 

select /*+ gather_plan_statistics index(emp emp_job)*/ ename, sal, job
  from emp
  where substr(job,1,5)='SALES';
  

SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));


����� ���� ��Ʈ�� �ε����� ��µ��� ������� �ʰ� FULL SCAN�� �ߴ�.




���� 2 : ������ SALESMAN�� ������� �̸��� ���ް� ������ ��ȸ�ϱ� ( �캯 ���� )

select /*+ gather_plan_statistics index(emp emp_job)*/ ename, sal, job
  from emp
  where job like 'S%';


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));



�ε����� ���������� �ߵ��Ǿ���.





���� : ����� ������ 30���� �����ϴ� ������� �̸��� ������ ����ϱ�

create index emp_sal on emp(sal);

select /*+ gather_plan_statistics index(emp emp_sal)*/ ename, sal
  from emp
  where sal like '30%';

 
SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));




���� ���� ��쿡��,

�ε����� ��Ʈ�� ���� �־��µ��� �ұ��ϰ�, full scan�� �ع��ȴ�.

18���� ����, SQL���� �������� sal�� �������� '30%'�� �����ֱ� ���ؼ� to_char()�� ���� ���� Ȯ���� �� �ִ�.

�ϴ� �̷� ���, sal �� ���̺��� ���� ������ �������� ������� ���� BEST.. ( ���̺� ������ �߿伺 ? )

������ �ε������� ����ؼ� LIKE�� ���� ����� �� ���� �÷��� �������� �ƴ�, ���������� ������




** �ذ�å

- �Լ� ��� �ε����� �����ؼ� Ʃ���Ѵ�.


create index emp_sal_func
 on emp(to_char(sal));                       --> �ε����� ���� �� �÷� ��ü�� �Լ��� �ѷ�������


select /*+ gather_plan_statistics index(emp emp_sal)*/ ename, sal
  from emp
  where sal like '30%';


SELECT * FROM TABLE(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));