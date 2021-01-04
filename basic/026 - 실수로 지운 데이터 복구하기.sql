1. 실수로 지운 데이터 복구하기 ( FLASHBACK QUERY )


오라클은 10g 버전부터 타임 머신 기능이 생겼다.


그래서 타임 머신 기능을 이용해서 과거의 데이터를 확인할 수 있고

테이블을 과거로 되돌릴 수가 있다.


flashback query는 과거의 데이터를 확인하는 기능이다.


예 :

delete from emp;


commit;


사라져버린 emp 테이블

commit 까지 해버렸다.



* 10분 전에 있었던 emp 테이블 상태를 확인하기


select *
 from emp as of timestamp( systimestamp - interval '10' minute );



그럼 일단 이걸 그대로 emp 백업 테이블에 저장하고,


create table emp_backup_20201111
 as
  select *
    from emp as of timestamp( systimestamp - interval '10' minute );




emp 백업 테이블을 emp 테이블 값에 다시 옮기자


insert into emp
 select *
  from emp_backup_20201111;



select * from emp;



2. 실수로 지운 데이터 복구하기 ( FLASHBACK TABLE )


* 특정 테이블을 과거로 완전히 되돌려 버리는 기능

delete from dept;

commit;


(1) dept 테이블이 flashback 될 수 있도록 설정한다.


alter table dept enable row movement;


(2) dept 테이블을 과거로 되돌린다.

flashback table dept to timestamp
(systimestamp - interval '5' minute);


(3) dept 테이블을 조회한다.

select * from dept;


** 과거로 되돌리지 못하는 경우

1. sys 유저에서 작업했을 경우

2. delete 하고 commit 한 이후에 DDL 명령어를 수행했으면 안된다.



* 과거로 되돌릴 수 있는 골든 타임 확인하는 방법

SHOW PARAMETER UNDO_RETENTION;


출력된 VALUE는 900초를 의미한다. (15분)



*** flashback table 명령어를 수행해서 과거로 되돌렸으면 반드시 commit을 해야한다.
     자동 commit이 안되기 때문에 방심하면 안된다.


3. 실수로 지운 데이터 복구하기 3 ( FLASHBACK DROP )

테이블을 drop 했을 경우에도 복구할 수 있는데

10g 버전 이후부터는 drop한 테이블이 휴지통에 입력된다.

그래서 휴지통에서 끄집어 내기만 하면 복구할 수가 있다.


drop table dept;



[1] show recyclebin;



[2] select *

     from

      recyclebin;

둘 중 하나를 골라서 하면 된다.


그럼 이렇게 휴지통이 출력이 된다.

이 휴지통을 비우지만 않으면 계속해서 휴지통에 테이블이 있기 때문에 복구할 수가 있다.


flashback table dept to before drop;


* 휴지통을 비우는 명령어

purge recyclebin;

* 휴지통에 넣지 않고 테이블을 삭제하는 방법

drop table 테이블명 purge;


4. 실수로 지운 데이터 복구하기 4 ( FLASHBACK VERSION QUERY )


특정 테이블이 과거로부터 현재까지 어떻게 변경이 되어왔는지

그 이력 정보를 확인할 때 사용하는 쿼리문

(1) 현재 시간 확인하기 (안해도 됨)

select systimestamp from dual;

20/11/11 15:50:14.581000000 +09:00   --->> 현재 시간 확인


(2) KING의 이름과 월급과 부서번호를 조회하기

select ename, sal, deptno
 from emp
 where ename='KING';

(3) KING의 월급을 8000으로 변경한 뒤 COMMIT 하기

update emp
 set sal=8000
 where ename='KING';

COMMIT;

(4) KING의 부서번호를 20번으로 변경한 뒤 COMMIT


update emp
 set deptno=20
 where ename='KING';

 COMMIT;

(5) 그동안 KING의 데이터가 어떻게 변경되어 왔는지 그 이력 정보를 화인하기


select  ename, sal, deptno, versions_starttime, versions_endtime,
         versions_operation
 from   emp 
 versions  between  timestamp 
              to_timestamp('20/11/11 15:50:10','RR/MM/DD HH24/MI/SS')  --> (1)에서 확인했던 시간
             and  maxvalue
 where  ename='KING'
 order  by  versions_endtime;


(6) 위의 시간 중에 하나를 확인해서 그 시간대의 emp 테이블의 상태를 확인하기

select *
 from emp as of timestamp
 to_timestamp('20/11/11 15:53:19', 'RR/MM/DD HH24/MI/SS'); --> (5)에서 봤던 시간대 중 하나 선택


(7) 그 시간으로 emp 테이블을 복구하기

alter table emp enable row movement;

flashback table emp to timestamp
 to_timestamp('20/11/11 15:53:19', 'RR/MM/DD HH24/MI/SS');

select * from emp;

commit;


* 일단 과거로 가면 현재로 돌아올 수 없다.

  그래서 시간을 정확하게 확인해서 신중하게 되돌려야 한다.


5. 실수로 지운 데이터 복구하기 5 ( FLASHBACK TRANSACTION QUERY )

실습이 잘 안되고 DBA 영역에 가까워서 따로 실습 X

- 그동안 작업했던 DML 문장을 확인해 볼 수 있다.