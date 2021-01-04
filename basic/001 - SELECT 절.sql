테이블에서 모든 열(COLUMN) 출력하기

select  *
 from  emp; 
 - emp 테이블에서 모든 열(컬럼)을 조회해라!

select *
 from  dept; 
 - dept 테이블에서 모든 열(컬럼)을 조회해라!
 - * 은 모든 컬럼을 대표한다.


테이블에서 특정 열(COLUMN) 선택하기

select  ename, sal -->컬럼 
   from   emp ;  -->테이블
 -emp 테이블에서 ename(사원 이름), sal(사원 월급)을 조회해라!

select  ename, job, hiredate, deptno
   from  emp;
 -emp 테이블에서 ename(사원 이름), job(직업), hiredate(입사일), deptno(부서 번호)를 조회해라!


컬럼 별칭을 사용하여 출력되는 컬럼명 변경하기

* 컬럼명 대신에 다른 컬럼명을 지정할 때 사용하는 문법

[select 컬럼 as '하고 싶은 컬럼명' from 테이블;]

select ename as 이름, sal as 월급
 from emp;
- ename을 이름, sal을 조회하는데 이름과 월급이라고 한글로 출력해라! 

select ename as "Employee name", sal as "Salary"
  from emp;
- ename과 sal을 Employee name, Salary로 출력해라!

※ 컬럼 별칭에 대소문자를 구분하고 싶다거나 공백 문자나 특수문자를 넣으려면 양쪽에
   더블 쿼테이션 마크를 둘러줘야 한다.


연결 연산자 사용하기 (||)

* 두 컬럼의 데이터를 연결해서 출력하는 연산자

[select 컬럼 || '아무 말' || 컬럼명 from 테이블;]


select  ename || ' 의 직업은 '  ||  job  || ' 입니다. '
 from   emp;


중복된 데이터를 제거해서 출력하기(DISTINCT)

* 컬럼명 앞에 작성하고 실행하면 중복된 데이터를 제거하고 출력한다.

select job from emp;
select distinct job from emp;