WITH 절 사용하기


* 복잡한 쿼리내에 동일한 쿼리가 두번 이상 발생한 경우

  사용하면 좋은 성능을 보이는 SQL "


 * 테스트 테이블과 같이 임시로 사용하는 데이터를 가지고 테스트 할 때도 용이하다.


예제1.  1부터 10까지의 숫자를 출력하는 SQL을 작성하기

  select  level  as  num1
    from  dual
    connect  by  level <= 10; 


위의 결과를 테이블로 만들고 싶은데 테이블로 만들려면

DBA에게 부탁을 해야하는데 ...

DBA는 관리하는 테이블이 만들면 힘들어진다.

혹시 안해준다면 with절로 내가 사용하는 SQL 내에서만 임시로 테이블을 만들면 된다. 



예제2.  위의 SQL을 with절로 만들기

with  test_table as ( select level as num1
                              from dual
                              connect by level<=10 )
   select  num1
       from  test_table;  



* as 다음에 나오는 괄호안의 쿼리문의 결과 데이터로 임시 테이블을 생성하는데 그 테이블 이름이 test_table 로 하겠다는 뜻.

  그리고 그 아래에 쿼리에서 test_table 가지고 다양하게 쿼리 문장을 만들어서 테스트 할 수 있다.

  

* with 절로 만든 임시 테이블은 with 절이 끝나면 사라진다.


예제 3.  with절을 사용해서 10 이하의 짝수만 출력하기

with test_table as ( select 2*level as num1
                        from dual
                        connect by level<=5 )
 select num1
  from test_table;