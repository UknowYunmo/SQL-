데이터 분석을 하다보면 가장 많은 시간을 할애하는 작업은 데이터 전처리.

품질이 높은 데이터를 처음부터 입력받도록 강제화하면 나중에 데이터 전처리에 많은 시간을 들이지 않아도 된다.

그래서 데이터 품질을 높이기 위한 한 방법으로 제약을 사용한다.

그래서 처음부터 테이블에 데이터를 입력받을 때부터 엄격한 기준으로 데이터를 입력하도록 제약을 건다.


* 제약의 종류


1. PRIMARY KEY : 중복된 데이터와 null 값을 허용하지 않게 하는 제약

2. UNIQUE        : 중복된 데이터를 허용하지 않게 하는 제약

3. NOT NULL     : null 값을 허용하지 않게 하는 제약

4. CHECK          : 특정 데이터 외 다른 데이터는 입력되지 못하게 하는 제약

5. FOREIGN KEY : 참조하는 컬럼에 거는 제약



* PRIMARY KEY - 제약을 건 테이블 생성하기

create table emp307
( empno  number(10) primary key,
  ename   varchar2(20) ) ;


위와 같이 테이블을 생성하면 앞으로 empno에는 앞으로 중복된 데이터나 null 값이 입력되지 않는다.


그럼 empno에 값들을 넣어보자.


insert into emp307 values(1111,'scott');

insert into emp307 values(2222,'smith');

insert into emp307 values(1111,'allen');

insert into emp307 values(null,'jones');



그럼 다음과 같이 empno의 중복된 값이나 null 값이 들어있는 데이터는 들어가지 않는다.


데이터 품질 높이는 비싼 소프트웨어 ( 1억 이상 )를 사용해도, 처음부터 좋은 데이터를 받는 게 낫다.





* UNIQUE - 중복된 데이터를 허용하지 않게 하기


create table emp506
 ( empno     number(10),
   ename     varchar2(10) unique );


insert into emp507 values (1111,'scott');

insert into emp507 values (2222,'scott');


SCOTT을 넣으려고 할 때, 무결성 제약 오류 뜨면서 안된다.


* 제약 삭제


1. 삭제할 제약 이름을 확인한다.


select table_name, constraint_name
 from user_constraints
 where table_name='EMP507';


2. EMP507 테이블의 UNIQUE 제약을 삭제한다.

alter table emp507
 drop constraint SYS_C007315;


3. 중복된 데이터가 입력이 잘 되는지 확인하기


insert into emp507 values(2222,'scott');


** 위와 같이 제약이름이 SYS_C007315 라고 나와서 이름만 봐서는

이 제약이 어떤 제약인지 확인하기가 어려우니

제약을 처음 만들 때부터 이름을 의미있게 부여해서 만들어주면 관리가 쉽다


4. 제약 이름을 주고 테이블을 생성하는 방법


create table emp508
 ( empno number(10),
   ename varchar2(10) constraint emp508_ename_un unique);
  테이블명_컬럼명_제약이름축약


5. EMP508 테이블의 ename에 걸린 UNIQUE 제약 확인하기

select table_name, constraint_name
 from user_constraints
 where table_name='EMP508';


6. emp508 테이블의 ename에 걸린 UNIQUE 제약 삭제하기

 alter   table  emp508
  drop   constraint  emp508_ename_un;


* 제약을 생성하는 방법 2가지 

   1.  테이블 생성할 때 

   2.  이미 만들어 놓은 테이블에 제약을 추가



 * 이미 만들어 놓은 테이블에 제약을 추가하는 방법

  emp 테이블에 ename 에 unique 제약 걸기


  alter table emp
    add  constraint emp_ename_un unique(ename); 


기존에 테이블에 중복된 데이터가 있다면 위의 명령어는 실행되지 않는다.

예를 들어 KING 이라는 이름이 한 명 더 있으면 실행되지 않는다.



* NOT NULL - null 값을 입력하지 못하게 막는 제약

* CHECK - 지정된 데이터만 입력되고 다른 데이터는 입력되지 못하게 막는 제약


예제 1 : 테이블을 생성할 때 제약을 거는 방법


create table emp745
           (  ename  varchar2(10),
              loc varchar2(20) constraint  emp745_loc_ck  
              check( loc in  ('DALLAS', 'CHICAGO', 'BOSTON') ) );   


--> 이제 loc 컬럼에는 DALLAS, CHICAGO, BOSTON 외의 데이터가 입력되거나 수정될 수 없다.


예제 2 : 만들어진 테이블에 제약을 거는 방법


alter table dept
 add constraint dept_loc_ck   
   check( loc in ('NEW YORK', 'DALLAS', 'CHICAGO','BOSTON') );


예제 : between을 사용한 check 제약


alter table emp
  add constraint emp_sal_ck check( sal between 0 and 9500) ;


* FOREIGN KEY - 참조하는 컬럼에 거는 제약

dept 테이블에 primary key 제약을 걸고 emp 테이블에 foreign key 제약을 걸면서

emp 테이블의 deptno 가 dept 테이블에 deptno를 참조하겠다 라고 하게되면

앞으로 emp 테이블의 deptno에 부서번호를 입력할때 dept 테이블에 있는 deptno인 10,20,30,40번 데이터만

입력될 수 있다. 그리고 dept 테이블에 deptno의 데이터를 지우려고하면

emp 테이블의 deptno가 참조하고 있으므로 지워지지 않는다.  


* foreign key를 사용하는 이유


1. 데이터 품질을 높이기 위해서

2. 조인할 때 outer join을 남발하지 않기 위해서  