** 오라클의 테이블 종류


1. 일반 테이블 ( heap table )
2. 임시 테이블 ( temp table )
3. 외부 테이블 ( external table )
4. 파티션 테이블 ( partition table )


외부 테이블(external table) 만들기


(1) emp.txt를 c 드라이브 밑에 data라는 폴더를 만들고 그 안에 넣기


(2) c 드라이브에 data 폴더를 오라클 디렉토리로 생성하기

create directory emp_dir as 'c:\data';

(3) 외부 테이블 생성하기

organiztion external --> external table을 생성하겠다.

type oracle_loader --> data를 로드하는 엔진을 sql*loader를 사용하겠다.

 (자동으로 insert문을 만들어주는 녀석)

default directory emp_dir --> emp_dir 를 기본 디렉토리로 하겠다.

access parameters --> 이제 text 파일의 내용을 테이블에 입력하기 위한 문법을 시작하겠다.

(records delimited by newline --> 행과 행 사이는 엔터로 구분하겠다

fields terminated by "," --> 데이터와 데이터는 콤마(,)로 구분하겠다.

(empno char, --> 외부 테이블의 컬럼들의 실제 데이터는 문자인데

ename char, --> 인데 오라클에는 숫자로 입력한다.

...

...

deptno char))

location ('emp.txt')); --> 링크를 걸 파일의 위치


(4) 테이블 확인


** 외부 테이블의 장점


1. database의 저장 공간이 필요 없다.

2. 대용량 데이터인 경우 테이블에 입력하는 시간을 줄일 수 있다.

예제 : ext_emp11 테이블을 조회해서 직업이 SALESMAN인 사원들의 이름과 직업과 월급을 출력하기

select ename, job, sal
 from ext_emp11
 where job ='SALESMAN';


평소처럼 테이블 명에 외부 테이블 이름을 넣어주면 된다.

예제 : 이름과 부서위치를 출력하기

select e.ename, d.loc
 from ext_emp11 e, dept d
 where e.deptno=d.deptno;


** 외부 테이블의 단점


1. DML 작업이 안되고 오직 SELECT만 가능하다.

2. 인덱스를 생성할 수가 없다.

예제 : ext_emp11의 scott의 월급을 6000으로 갱신하기 

update ext_emp11
 set sal=6000
 where ename='scott';


그러면 이렇게 오류가 발생한다. don't do that!

* 외부 테이블이 어떤 게 있는지 확인하고 삭제하는 방법

select table_name, external
 from user_tables
 where external = 'YES';



이렇게 확인이 끝나고, 삭제하고 싶은 테이블은

drop table ext_emp11
drop table ext_dept
drop table ext_dept2

해주면 된다.