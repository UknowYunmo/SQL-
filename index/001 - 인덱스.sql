오라클 데이터 베이스의 객체(object)의 종류 5가지

1. table : 데이터를 저장하는 기본 저장소

2. view : 데이터를 바라보는 쿼리문

3. index : 검색 속도를 향상시키기 위한 database object

4. sequence : 순서대로 번호를 생성하는 database object

5. synonym : 테이블명에 대한 또 다른 이름


INDEX(인덱스)는 SQL 튜닝을 위해 반드시 알아야 하는 DATABASE object이다.



설명 : 인덱스는 테이블을 책으로 치면 책 앞에 나오는 목차

-- 만약 목차 없이 책에서 내용을 찾는다면, 처음부터 끝까지 다 보아야한다.



예제 1: 이름이 SCOTT 인 사원의 이름과 월급을 출력하기

select ename, sal
 from emp
 where ename='SCOTT';

ename에 인덱스가 없기 때문에 SCOTT을 emp 테이블에서 찾을 때

처음부터 끝까지 full table scan을 했을 것이다.


예제 2 : emp 테이블에 인덱스 생성하기

create index emp_ename
 on emp(ename);


** 인덱스(목차)의 구조

소제목 + 페이지 번호

소제목들이 ㄱ,ㄴ,ㄷ,ㄹ 순으로 구성되어 있다.

** rowid

rowid는 그 행을 대표하는 주소다.

select rowid, ename, sal
 from emp;


나는 rowid를 만든 적이 없지만, 자동적으로 만들어져 있고, 고유한 ID를 갖고 있다.


** emp_ename 의 인덱스의 구조를 보는 쿼리문

select ename, rowid
 from emp;

이것만 하면, abcd 순으로 정렬되지 않고 나온다.

하지만 where 절을 사용한다면?

select ename, rowid
 from emp
 where ename > ' ';    --->> 이걸로 특별히 걸러지는 것은 없다.
    			데이터만 있으면 만족할 수 있는 조건이기 때문


그런데 이번에는 ORDER BY를 사용하지 않았는데도,

abc 순으로 정렬된 것을 볼 수 있다.


정렬된 이유?

아까 조건에 where를 줬기 때문에 ename에 걸린 인덱스를 가져다가 썼기 때문에

인덱스에 있던 정렬된 순서 그대로 출력되었다.