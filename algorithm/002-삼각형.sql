���� :�ֻ����� 10���� ������ �ֻ����� ���� 6�� ���� Ȯ�� ���ϱ�

select count(*) /100000 as "�ֻ����� 6�� ���� Ȯ��"
  from ( select round ( dbms_random.value(0.5,6.5) ) as �ֻ���
             from dual
              connect by level <= 100000)
  where �ֻ��� = 6;


* dbms_random.value(a,b)�� a,b ���̿��� �������� ������ �����ϴ� �Լ��̴�.

���⼭ round�� ���ձ� ������ �ᱹ 1,2,3,4,5,6�� ���´�.

�ᱹ 10���� �� 6�� ���� Ƚ���� count�� �� ��ü�� 10������ ������ �� Ȯ���� �ȴ�.

�׷��� �� �� round(dbms_random.value(0,6))�� �ϰ� �Ǹ�

1�� 0.5~1.5 ������ �ݸ�

0�� 0~0.5 ���̹ۿ� �������� �����Ƿ�

���� ������ 0�� 6�� 1,2,3,4���� ���� Ȯ���� ������ �Ǿ������ ��������.




���� : �ֻ��� 2���� ������ ���� 10�� Ȯ�� ���ϱ�

select count(*) / 100000 as "���� 10�� Ȯ��"
   from ( select round( dbms_random.value(0.5,6.5) ) as �ֻ���1,
                round( dbms_random.value(0.5,6.5) ) as �ֻ���2
               from dual
               connect by level <= 100000)
   where �ֻ���1 + �ֻ���2 = 10;


����� ���� �ֻ��� �� ���� ���ÿ� ���� ���� �ִ�.




���� : �ֻ��� �� ���� ������ ������, �ֻ����� 5, ������ �ո��� ���� Ȯ�� ���ϱ�

select count(*)/100000
                 from ( select round( dbms_random.value(0.5, 6.5) ) as �ֻ���,
                          round( dbms_random.value(0,1)) as ����
                             from dual
                             connect by level <=100000)
                 where �ֻ��� = 5 and ���� =1;