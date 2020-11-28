rpad�� lpad�� ����ؼ� �ﰢ���� ���� �� �ִ�.



������ �Ѱ����� ���� ���س���,

level�� �̿��ؼ� level�� ����ŭ ����,

�Ѱ������� �������� �������� ä���ִ� ������ �ϸ� �ȴ�.


���� : ���� �ﰢ�� ����ϱ�

select rpad('��',level,'��')
  from dual
  where level <= 5
  connect by level<=100;


- �� ũ�� ����� �ʹٸ� ���� ������ where ���� ���ǿ� ���ڸ� Ű��� �ȴ�.



���� : with ���� ����ϱ�

with temp_table as ( select level as num1
                        from dual
                        connect by level <= 100)
 select rpad('��',num1,'��')
  from temp_table
  where num1 <= 10;



���� : �Ϲ� �ﰢ�� ����ϱ�

select lpad(' ', 10-level, ' ') || lpad('��', level, '��') as �ﰢ��
      from dual
      connect by level<=10;



���� : ���ڸ� �Է¹ް�, �� ���ڸ��� ������ �ﰢ�� ����ϱ� ( + with �� ��� )

undefine ����
with temp_table as (select level as num1
                             from dual
                             connect by level <= &&����)
   select lpad(' ', &���� - num1, ' ') || lpad('��', num1, '��') as �ﰢ��
      from temp_table;

���� : ���ﰢ�� ����ϱ�

select lpad('��', level,'��')
    from dual
    connect by level <= 5
    union all
select rpad('��', 5-level,'��')
    from dual
    connect by level <= 4;