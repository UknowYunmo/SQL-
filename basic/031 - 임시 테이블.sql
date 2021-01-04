임시 테이블 생성하기 ( create temporary table)

** 데이터를 영구히 database에 저장하는 게 아니라 임시로 저장하는 테이블

데이터 중에서 영구히 저장할 필요는 없고, 잠깐 테스트를 위해서 볼 데이터라던가

현재만 필요하고 나중에는 필요하지 않은 데이터가 있는데

그 데이터를 잠깐 저장할 때 사용하는 테이블이 임시 테이블.


* 임시 테이블의 종류 2가지

1. on commit delete rows 옵션 : 데이터를 commit 할 때 까지만 보관

2. on commit preserve rows 옵션 : 데이터를 접속한 유저가 로그아웃할때까지만 보관

예제 :

create global temporary table emp700
( empno number(10),
  ename varchar2(10),
  sal       number(10) )
  on commit delete rows;     <-- 임시 테이블 생성

insert into emp700
 select empno, ename, sal
  from emp;                       <-- emp 테이블 값을 임시 테이블에 전부 입력

select * from emp700;

commit;

commit 한 뒤 확인해보면,

select * from emp700;

사라져있다.



예제 2 :

create global temporary table emp800

( empno number(10),

  ename varchar2(10),

  sal       number(10) )

  on commit preserve rows;


insert into emp800

 select empno, ename, sal

  from emp;


select * from emp800;

commit;


commit 한 뒤 확인해보면,

select * from emp800;

이번에는 안 사라져있다.

그러면 이 임시 테이블은 언제 사라지나?

로그아웃하고 재접속하면 사라진다.

exit <-- 로그 아웃하고

sqlplus "/as sysdba" <-- 관리자로 접속하고,

select * from emp800; <-- 조회해보면, 데이터가 사라져있다.