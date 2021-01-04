예제 : 1부터 6까지 값을 갖는 시퀀스 생성하기

create sequence seq1
 start with 1                    
 maxvalue 6;


이 때 start with은 시퀀스의 시작 번호,

maxvalue는 시퀀스의 최대 번호를 뜻한다.


이렇게 만들었으면,


select seq1.nextval
 from dual;


로 실행시켜보자.


1이 출력되었다.


그리고 아까 실행시킨


select seq1.nextval
 from dual;


위 구절을 계~속 반복 실행해보면 계속 1씩 증가하는 것이 보인다.


그러다가 6까지 실행되고,

한 번 더 하면

오류가 발생하면서 안 된다.

아까 maxvalue 를 6으로 설정해두었기 때문.




** 시퀀스를 이용하면 좋은 점


번호를 중복되지 않게 일관되게 테이블에 입력할 수 있다.



번호가 중복되면 안되는 컬럼은?


주식 테이블 매매번호, 사원 테이블의 사원 번호 등..


테이블  emp534 생성

create table emp534
( empno number(10),
  ename varchar2(20),
  sal   number(10) );


seq2를 이용해서 emp534이 empno에 일관된 번호가 입력되게 하기


insert into emp534
values(seq2.nextval,'scott',3000);


select * from emp534;


확인해보면, 시퀀스 번호가 empno로 들어갔다.



* 시퀀스의 현재값 확인하는 방법

select seq2.currval
 from dual;


* 내가 가지고 있는 시퀀스 확인하는 방법


select sequence_name
 from user_sequences;


* 시퀀스 삭제하는 방법

drop sequence 시퀀스 이름