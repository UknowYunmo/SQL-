rpad와 lpad를 사용해서 삼각형을 만들 수 있다.



원리는 한계점을 먼저 정해놓고,

level을 이용해서 level의 수만큼 별을,

한계점까지 나머지는 공백으로 채워넣는 식으로 하면 된다.


예제 : 직각 삼각형 출력하기

select rpad('★',level,'★')
  from dual
  where level <= 5
  connect by level<=100;


- 더 크게 만들고 싶다면 메인 쿼리의 where 절의 조건에 숫자를 키우면 된다.



예제 : with 절을 사용하기

with temp_table as ( select level as num1
                        from dual
                        connect by level <= 100)
 select rpad('★',num1,'★')
  from temp_table
  where num1 <= 10;



예제 : 일반 삼각형 출력하기

select lpad(' ', 10-level, ' ') || lpad('★', level, '★') as 삼각형
      from dual
      connect by level<=10;



예제 : 숫자를 입력받고, 그 숫자만한 길이의 삼각형 출력하기 ( + with 절 사용 )

undefine 숫자
with temp_table as (select level as num1
                             from dual
                             connect by level <= &&숫자)
   select lpad(' ', &숫자 - num1, ' ') || lpad('★', num1, '★') as 삼각형
      from temp_table;

예제 : 역삼각형 출력하기

select lpad('★', level,'★')
    from dual
    connect by level <= 5
    union all
select rpad('★', 5-level,'★')
    from dual
    connect by level <= 4;