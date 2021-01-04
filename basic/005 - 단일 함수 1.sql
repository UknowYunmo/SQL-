대소문자 변환 함수 (UPPER, LOWER, INITCAP)

upper: 대문자로 출력하는 함수

lower : 소문자로 출력하는 함수

initcap: 첫번째 철자는 대문자로 출력하고 나머지는 다 소문자로 출력하는 함수

select   upper(ename), lower(ename), initcap(ename)
 from  emp;

문자에서 특정 철자를 추출하는 함수(SUBSTR)

예 : SUBSTR( 컬럼명 , 2 , 5 ) --> 컬럼명에 들어있는 값의 2번째 자리 기준으로 5개의 문자를 추출하여 반환.

만약 'BIG DATA'라는 값이 들어있었다면 --> 'IG DA' 를 반환

substr를 활용한 검색

예제 : 성씨가 이씨, 유씨, 김씨 인 학생들의 이름을 출력하시오!

select  ename
 from  emp12
 where substr(ename, 1, 1) in ('이', '김', '유');

문자열의 길이를 출력하는 함수 ( LENGTH )

예 : length(컬럼명) --> 컬럼명 안의 값인 문자열의 길이를 반환

만약 scott 이 들어있었다면 5를 반환한다.

예제 : 이름과 이메일과 이메일의 길이를 출력하는데 이메일의 길이가 가장 긴 것부터 출력하시오

select ename,email,length(email)

 from emp12

 order by length(email) desc;

문자에서 특정 철자의 위치 출력하기(INSTR)

특정 철자의 자릿수를 출력하는 함수

instr( 컬럼명, 특정 철자)

예 : instr('smith', 't') --> 4를 반환 ** 이 경우는 예시를 위해 컬럼명이 아니라 직접 값을 준 경우이다.

예제 : 우리반 테이블에서 이메일을 출력하고 그 옆에 이메일에서 @가 몇 번째 자리에 있는지 출력하시오

select email,instr(email,'@')
 from emp12;

특정 철자를 다른 철자로 변경하기(REPLACE)


특정 철자를 다른 철자로 변경하는 함수

replace( 컬럼명, 특정 철자, 바꿀 철자 )

replace('smith', 'm', 'k') --> skith를 반환 ** 이 때 실제 데이터 테이블 값이 바뀌는 것은 아니다. (출력만)


예제 : 사원들의 이름과 월급을 출력하는데, 0을 *로 출력하기

select ename,  replace(sal, 0, '*')
 from  emp;


특정 철자를 N개 만큼 채우기(LPAD, RPAD)


항상 고정된 자릿수를 보장하기 위해서 필요한 함수


lpad( 컬럼명, 전체 자릿수, 채워넣을값 )

rpad( 컬럼명, 전체 자릿수, 채워넣을값 )

select  sal,  lpad(sal, 10, '*'), rpad(sal, 10, '*') 
  from   emp;


공백 잘라내기(TRIM, RTRIM, LTRIM)

공백을 잘라낼때 많이 사용하는 함수. 
공백 때문에 데이터 검색이 안되는 경우가 종종 있기 때문에 trim 함수를 자주 사용한다. 


ltrim :   왼쪽에 있는 공백을 잘라버리겠다.

rtrim :   오른쪽에 있는 공백을 잘라버리겠다

trim  :   양쪽에 있는 공백을 잘라버리겠다.