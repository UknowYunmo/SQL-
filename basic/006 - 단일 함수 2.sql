문자형으로 데이터 유형 변환하기 ( TO_CHAR )

숫자형 -->> 문자형으로 변환,

날짜형 -->> 문자형으로 변환할 때 사용하는 함수

예제 : 오늘이 무슨 요일인지 출력

select sysdate
   from dual;

select to_char(sysdate, 'day')
   from dual;                

* 날짜형식

년도 : RRRR, YYYY, RR, YY
월 : MM, MON
일 : DD
시간 : HH, HH24
분 : MI
초 : SS
요일 : day, dy, d

예제 : 11월에 입사한 사원들 출력하기

select ename, hiredate
   from emp
   where to_char(hiredate,'MM')='11';

문자열을 날짜로 형 변환하는 함수 (to_date)

예제 :

select to_date ('18700710', 'YYYYMMDDHH24MISS')
  from dual;

select ename, hiredate
   from emp
   where hiredate=to_date('81/11/17','RR/MM/DD');

--> 날짜형 데이터를 검색할 때는 반드시 to_date 함수를 사용할 것이 필수!

(확실한 데이터 검색을 위해)


숫자로 형변환하는 함수 (to_number)

select ename, sal
 from emp
 where sal='3000';

데이터 형식이 숫자인 sal에 문자열 '3000'으로 검색해도 검색이 될까?

친절한 오라클은 자동으로 int로 바꿔줘서 검색을 해준다.

그런데 이러한 게 데이터 양이 큰 경우에는 오히려 독이 될 수 있다.

SQL 실행이 느려지고, '자동'이기 때문에 나는 느려지는 원인을 찾기 힘듬.

현업에서는 차라리 오류가 나는게 낫다고 한다. (고치면 되니까)

그래서 문자열이 들어가게 되는 경우 꼭 to_number를 활용하자

select ename, sal
 from emp
 where sal=to_number('3000');