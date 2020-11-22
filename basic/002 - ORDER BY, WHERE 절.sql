기타 비교연산자  4가지

 1. between .. and
 2. like
 3. is null
 4. in

1. BETWEEN AND

값이 A와 B 사이인 값들만 조건부 출력한다.

where 컬럼명 between A and B

예제 : 월급이 1000, 3000 사이인 사원들의 이름과 월급을 출력하기

select ename, sal
  from emp
  where sal between 1000 and 3000;

반대로 A와 B사이인 경우를 제외하고 선택할 수도 있다.

where not 컬럼명 between A and B

예제 :  월급이 1000, 3000 사이가 아닌 사원들의 이름과 월급을 출력하기

select ename, sal
  from emp
  where not sal between 1000 and 3000;

select  ename, sal
  from  emp
  where  ename = 'A%';


2. LIKE

like를 사용하면 특정 문자가 포함되어 있는 문자를 검색할 수 있다.

like 연산자를 사용할 때 사용하는 키워드 2가지 :

  1.  %  :  와일드 카드 :  이 자리에 뭐가 와도 관계없고 그 갯수가 몇 개가 되든 관계없다. 

  2.  _   :  언더바        :  이 자리에 뭐가 와고 관계없는데 자릿수는 한개여야 한다. 

select  ename, sal
  from  emp
  where  ename  like  'M%';

select  ename, sal
  from  emp
  where  ename  like  '%M%';

select  ename, sal
  from  emp
  where  ename  like  '_M%';

 -- M으로 시작하는 이름을 가진 사원의 이름과 월급을 출력

 -- M이 포함된 이름을 가진 사원의 이름과 월급을 출력 

 -- M이 이름의 두 번째 자리에 있는 사원의 이름과 월급을 출력



3. IS NULL

NULL 값을 조회할 때 사용하는 연산자


예제 : 보너스가 입력되지 않은 사원을 출력하기

select ename, comm
   from emp
   where comm = null;


* comm=null 로 조회할 수 없다.

왜냐하면 null은 알 수 없는 값이므로 비교 연산자인 '='로는 조회할 수 없다.

기타 비교 연산자인 is null을 사용해야 한다.


예제 : 보너스가 입력되지 않은 사원을 출력하기

select ename, comm
   from emp
   where comm is null;

between 처럼 반대의 경우도 조건을 줄 수 있다.

select ename, comm
   from emp
   where comm is not null;


참고로 null은 알 수 없는 값이고, 0은 명확한 값으로 둘은 전혀 다르다.


4. IN

where 절의 검색조건에서 여러개의 행을 비교할 때는 in 을 사용하는 게 편하다.

where 컬럼명 in ( 조건1, 조건2, 조건3 )

예제 : 사원 번호가 7788, 7902, 6703 중 하나인 사원을 찾아 출력하기 

select   empno,  ename
    from   emp
    where   empno  in  ( 7788, 7902, 6703 );

반대의 경우도 역시나 가능하다.

예제 : 직업이 SALESMAN, ANAYLST가 아닌 사원들의 이름과 직업을 출력하기

select  ename, job
  from  emp
  where  job  not in  ('SALESMAN', 'ANALYST'); 