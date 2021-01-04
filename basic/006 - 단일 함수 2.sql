숫자 함수 

  1.  round :  반올림하는 함수

  2.  trunc  :  잘라내서 버리는 함수 

  3.  mod   :  나눈 나머지 값을 출력하는 함수


반올림해서 출력하기(ROUND)            

예제: 

select round( 786.567,  -1 ), round( 786.567 ), round( 786.567, 1 )

 from dual; ** dual 은 이렇게 임시로 값을 확인하고 싶을 때 사용하기 편한 임시 테이블이다.

round( 숫자, n ) --> n번째 자리까지 반올림하여 반환

     7  8   6   .   5  6  7  

    -3 -2  -1  0  1  2  3


숫자를 버리고 출력하기(TRUNC)

예제 : 

select trunc( 786.567,  -1 ), trunc( 786.567 ), trunc( 786.567, 1 )
 from dual;

나눈 나머지 값 출력하기(MOD)

mod( 숫자(a), 나눌 값(b) ) --> a를 b로 나눈 뒤 나머지 c를 반환

select mod(24,2), mod(25,2)
 from dual;

mod 함수 활용 : 주로 짝수, 요일을 확인할 때 활용할 수 있다.


예제 : 나이가 짝수인 학생들의 성별과 나이를 출력하기

select gender, age
   from emp12
   where mod(age,2) = 0;

날짜 함수 

  1.  sysdate :  오늘 날짜

  2.  months_between  :  날짜 사이의 개월 수 

  3.  next_day  :  다음 주 특정 요일의 날짜

  4.  last_day  : 해당 달의 마지막 일


오늘 날짜를 확인하기 (sysdate)

sysdate는 항상 그 날 날짜만 반환하기 때문에 괄호가 필요없는 듯하다.

select  sysdate 
  from  dual;

예제 : emp 사원이 입사한지 몇일이 지났는지 출력하기

select ename, round( sysdate - hiredate) 
 from  emp
 where hiredate is not null;

날짜와 날짜 사이의 개월 수를 반환(months_between)

months_between( 최신날짜, 옛날날짜) 

예제 : 사원이 지금까지 몇 달 근무했는지 출력하기

select ename || ' 은 ' || round(months_between(sysdate, hiredate)) || ' 달을 근무했습니다.'
 from emp;

n개월 수 더한 날짜 출력하기(ADD_MONTHS)

select  add_months( sysdate, 6 ) 
  from  dual;

특정 날짜 뒤에 오는 요일 날짜 출력하기 (NEXT_DAY)

예제 : 오늘 기준 다음 주 월요일의 날짜를 출력하기

select  next_day( sysdate, '월요일')
 from dual;

특정 날짜가 있는 달의 마지막 날짜 출력하기 (LAST_DAY)

예제 : 오늘 날짜와 이번 달의 마지막 날짜를 출력하기

select   sysdate,  last_day(sysdate)
   from  dual;