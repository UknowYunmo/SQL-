1. 데이터 입력하기 ( INSERT )

** 테이블에 데이터를 입력하는 SQL 문장

insert into 테이블명(컬럼명) values (각 컬럼에 넣을 값) 

예제 : emp 테이블에 사원 번호 : 1234, 사원 이름 : jack 월급 : 4500을 가진 데이터를 입력하기

insert   into   emp(empno, ename, sal )
        values ( 1234, 'jack', 4500 );

데이터 입력할 컬럼들을 기술한 뒤 위의 컬럼 순서대로 값을 기술하면 된다.

2. 데이터 수정하기 ( UPDATE )

** 데이터를 수정하는 SQL 문장

update 테이블명
 set 컬럼명 = 컬럼에 넣을 값
 (where)

예제 : KING 의 월급을 9000 으로 변경하기

update  emp
  set  sal = 9000
  where  ename='KING';

** commit (커밋) 과 rollback (롤백)

commit;  --->  지금까지 변경한 모든 작업을 다 database 에 영구히 저장하겠다.
rollback;  ---> commit 이후에 작업한 모든 변경사항을 취소하겠다. 

3. 데이터 삭제하기( DELETE, TRUNCATE, DROP )

* 오라클에서 데이터를 삭제하는 방법 3가지 

      1. delete 
      2. truncate
      3. drop 

(1) delete

데이터만 삭제 되며 테이블 용량은 줄어 들지 않는다.
또한 삭제후 잘못 삭제한 것을 되돌릴 수 있다.
Commit이전에는 Rollback이 가능하다.
전체 또는 일부만 삭제 가능하다.

alter  table  emp   enable    row   movement; 
--> emp 테이블을 flashback 이 가능한 상태로 변경한다. 

항상 중요한 테이블은 이렇게 설정해두자.

그리고 delete가 일어났을 경우,

flashback  table  emp   to   timestamp  
( systimestamp  -  interval  '15' minute );

--> 현재시간의 15분전으로 emp 테이블을 되돌린다.

골든 타임이 15분이므로 삭제한지 15분 안에 해야한다.

(2) truncate

테이블을 최초 생성된 초기상태로 만든다.
용량도 줄어든다.
Rollback 불가능하다.
flashback 불가능하다.
무조건 전체 삭제만 가능 하다.

(3) drop

테이블의 정의 자체를 완전히 삭제한다.
Rollback 불가능하다.
휴지통 기능이 있어서 flashback 은 가능하다.

show  recyclebin;   <-- 휴지통속에 있는 데이터 확인 
flashback  table  emp  to  before  drop;  <-- 휴지통에서 복원하는 명령어

4. 데이터 입력, 수정, 삭제 한번에 하기( MERGE )

데이터 입력과 수정과 삭제를 한번에 수행하는 명령어.

SQL 튜닝을 위해서 자주 사용되는 SQL이다.

merge를 사용하기 전

먼저 추가할 컬럼은 따로 생성해 놓아야 한다

컬럼을 추가하는 방법 :

alter table 테이블명
 add 컬럼명 데이터 유형;

예제 : 사원 테이블에 추가한 부서위치(loc) 컬럼에 데이터를 해당 사원의 부서위치로 값을 갱신하기

alter  table  emp
   add  loc   varchar2(10);

--> emp 테이블에 새로 loc이라는 컬럼을 만들기

merge  into  emp   e 
 using   dept   d --> 데이터를 끌어올 다른 테이블
 on   ( e.deptno = d.deptno) --> 연결 고리
 when  matched  then
 update   set   e.loc = d.loc; --> 아까 만든 loc 컬럼에 dept 테이블의 loc 컬럼을 갱신