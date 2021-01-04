지금까지는 insert 문장으로 한 번에 한 건만 입력할 수 있었다.

예시 :

insert into emp ( empno, ename, sal )
 values ( 1234, 'SCOTT', 3000 ) ;


그러나 다중 insert 문을 이용하면 여러 개의 테이블에 동시에 같은 데이터를 여러 개 입력할 수 있다.



* 다중 insert 문의 종류 4가지

1. 무조건 all insert 문

2. 조건부 all insert 문

3. 조건부 first insert 문

4. pivoting insert 문




1. 무조건 all insert 문


* 여러 개의 테이블에 조건 없이 한 번에 데이터를 입력하는 것


예제 : target_a, target_b, target_c 테이블을 만들고 emp 테이블의 구조와 동일하게 만들기


create table target_a
 as
  select *
   from emp
    where 1=2;

create table target_b
 as
  select *
   from emp
    where 1=2;

create table target_c
 as
  select *
   from emp
    where 1=2;

* where 절의 1=2의 의미

1=2 가 거짓이므로 emp 테이블을 가져오지만

테이블 내의 데이터 값은 가져오지 못한다.

즉, 테이블 구조만 가져와서 테이블을 만드는 것

참고로 where 절의 조건을 안 줬다면, 당연하지만 테이블 전체가 그대로 옮겨졌을 것이다.


이제 구조를 만들었으니, emp 테이블의 데이터를 한 번에 전부 넣어보자.

insert all into target_a
into target_b
into target_c
 select *
  from emp;

emp 행은 14개이고, 3 테이블에 넣었으므로 42행이 삽입되었다고 뜬다.

select count(*) from target_a;
select count(*) from target_b;
select count(*) from target_c;

로 확인하기

2. 조건부 all insert 문

조건에 맞는 데이터만 입력되게 조건을 주는 입력문

예제 : target_a 테이블에는 comm을 받는 사원들만 입력하고, target_b에는 comm을 받지 않는 사원들만 입력하기

insert all
 when 조건 then into 테이블명
 when ~

해주면 된다.

insert all
	when comm is not null then into target_a ( empno, ename, sal, comm )
	when comm is null then into target_b ( empno, ename, sal, comm )
 select empno, ename, sal, comm
  from emp;


3. 조건부 first insert 문

조건에 맞는 데이터가 첫 번째 테이블에 입력되고

나머지 데이터를 가지고 새로운 조건에 맞춰서

두 번째 또는 세 번째에 입력하는 insert 문


예제 : 부서 번호가 20번인 사원들은 target_a에 입력하고, 남은 나머지 부서 번호 사원들 중

월급이 1200 이상은 target_b에 입력하고 1200 이하는 target_c에 저장하기

insert first
	when deptno=20 then into target_a
	when sal>=1200 then into target_b
	when sal<1200 then into target_c
 select *
  from emp;

처음 FIRST 바로 다음 문에서 나뉘고 나머지는 조건부 all insert 문처럼 조건에 맞아야 테이블에 들어간다.