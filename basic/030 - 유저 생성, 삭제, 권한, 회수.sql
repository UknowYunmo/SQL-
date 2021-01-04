* 유저 생성하기

create user king                   ----> 유저 이름
 identified by tiger;               ----> 비밀번호


* 접속할 수 있는 권한 주기

grant connect to king;


--> king에게 connect 권한을 주겠다!


* king으로 접속해보기


cmd 창을 열고,


sqlplus king/tiger 입력



* 접속한 이름 확인하기


show user;


* 로그 아웃하기


exit

당연하지만 이렇게

로그 아웃을 해줘야 다른 유저로 다시 들어갈 수 있다



* 유저 상태에서 테이블 만들기

create table emp407 ( empno number(10), ename varchar2(10) );


-- 테이블을 만드는 권한이 없어서 테이블을 만들 수 없다고 나온다.


그럼, 일단 로그아웃하고, 관리자로 들어가자.

exit

sqlplus/ "/ as sysdba" --> 관리자로 접속


show user  --> 접속 확인


grant create table to king  --> 테이블을 만드는 권한을 king에게 주겠다


exit --> 로그아웃


sqlplus king/tiger --> king으로 접속


create table emp407 ( empno number(10), ename varchar2(10) ); --> 테이블 만들어보기



* 내가 갖고 있는 모든 권한을 알아보기


select * from session_privs;


* 줬던 권한 취소하기 ( revoke )


sys 유저에서 king에게 주었던 create table 권한을 취소하고 싶다면?


revoke create table from king;


* 유저 삭제하기


drop user king cascade;