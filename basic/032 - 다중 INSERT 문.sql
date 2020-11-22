** 정규식 함수


데이터 검색을 좀 더 상세하게 하려 할 때, 기존의 함수로는 표현할 수 없는

데이터 검색을 할 수 있게 해주는 함수



* Regular expression ( 정규 표현식 )

정규 표현식 코드는 오라클 뿐만 아니라 다른 언어에서도 공통적으로 사용하는 표현식 코드이다.

오라클 10.1 버전부터 정규 표현식을 지원한다.

오라클 데이터베이스는 정규 표현식의 POSIX 연산자를 지원한다.

POSIX는 Portable Operation System Interface 의 약자로,

시스템간 호환성을 위해 미리 정의된 인터페이스를 의미한다.

Posix 연산자에는 기본 연산자, 앵커, 수량사, 서브 표현식, 역참조, 문자 리스트, posix 문자 클래스 등이 있다.


* 기본 연산자


연산자                            영문                            설명



   .                                 dot                        모든 문자와 일치

   |                                  or                         대체 문자를 구분

  \                             backslash            다음 문자를 일반 문자로 처리


예제 : select regexp_substr('aab','a.b') as c1,
	regexp_substr('abb','a.b) as c2,
	regexp_substr('acb','a.b) as c3
	regexp_substr('adc','a.b) as c4
          from dual;


예제 : 이름에 EN, IN 이 들어가는 사원들의 이름과 월급을 출력하기


기본 식

select ename, sal
 from emp
 where ename like '%EN%' or ename like '%IN%';


정규식 함수 사용

select ename, sal
 from emp
  where regexp_like(ename,'EN|IN');


--> 이렇게 하면 where 절을 계속 늘려나가지 않아도 되니
      코드가 복잡할수록 훨씬 더 간결하게 작성할 수 있다.


예제 : 사원들 중 성이 St로 시작하고 en으로 끝나는 사원들 출력하기

기본 식

select first_name
 from employees
 where first_name like 'St%en';

정규식 함수 사용

select first_name
 from employees
 where regexp_like(first_name,'^St(.)+en$');

--[설명]--

^ : 시작을 나타낸다.
$ : 끝을 나타낸다.
--> St로 시작하면서 끝이 en으로 끝난다.

가운데에 있는 (.) 에서 . 은 한 자리를 나타내는데,
+ 가 여러 개를 나타내는 것을 의미하기 때문에
한 자리가 여러개인 것을 나타낸다.


결과적으로 St와 en 사이에 여러 개의 철자가 와도 된다는 것을 의미한다.

* 서브 표현식

서브 표현식은 표현식을 소괄호로 묶은 표현식이다.

서브 표현식은 하나의 단위로 처리된다.



연산자                                        설명

(표현식)                            괄호 안의 표현식을 하나의 단위로 취급

   +                                 1회 또는 그 이상의 횟수로 일치

예제 : select regexp_substr('ababc','(ab)+c') as c1,

regexp_substr('ababc','ab+c') as c2,

regexp_substr('abd','a(b|c)d') as c3,

regexp_substr('abd','ab|cd') as c4

from dual;


c1은 +가 (ab)를 하나의 알파뱃으로 봐서, ababc가 나왔고
c2는 +가 b를 하나의 알파뱃으로 봐서 abc가 나왔다.


* regexp_count 함수 ( count의 업그레이드 버전 )

특정 단어나 철자가 문장에서 몇 번 반복되어서 출력되는지 확인하는 함수


예제 : 다음 문자열에서 gtc가 몇 번 나왔는지 세기

SELECT REGEXP_COUNT(
'ccacctttccctccactcctcacgttctcacctgtaaagcgtccctccctcatccccatgcccccttaccctgcagggtagagtaggctagaaaccagagagctccaagctccatctgtggagaggtgccatccttgggctgcagagagaggagaatttgccccaaagctgcctgcagagcttcaccacccttagtctcacaaagccttgagttcatagcatttcttgagttttcaccctgcccagcaggacactgcagcacccaaagggcttcccaggagtagggttgccctcaagaggctcttgggtctgatggccacatcctggaattgttttcaagttgatggtcacagccctgaggcatgtaggggcgtggggatgcgctctgctctgctctcctctcctgaacccctgaaccctctggctaccccagagcacttagagccag','gtc') AS Count
FROM dual;

예제 : 이름에 O가 들어가는 사원 수 세기

count랑은 다른게 매 행 출력된다.

그래서 정말 그 수가 세고 싶다면

select sum(건수)
 from
    (select ename,regexp_count(ename,'O') as 건수
    from emp);


다음과 같이 서브 쿼리로 한 번 더 세줘야한다.


* regexp_replace ( replace의 업그레이드 버전 )

예제 : 이름과 월급을 출력하는데 월급을 출력할 때 replace 함수를 이용해서
	숫자 0을 *로 출력하기


select ename, replace( sal, 0, '*' )
 from emp;



예제 : 이름과 월급을 출력하는데 월급을 출력할 때
	숫자 0~3을 *로 출력하기

select ename, regexp_replace( sal, '[0-3]', '*')
 from emp;