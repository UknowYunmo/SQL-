테이블은 아니고 데이터를 바라보는 쿼리문을 테이블처럼 하나의 object(객체)로 생성하자

예 : emp 테이블의 내용을 가진 emp708 생성하기

create table emp708
 as
   select empno, ename, sal, deptno
     from emp;

select * from emp708;

** as 다음에 나오는 쿼리문의 결과대로 emp708 테이블이 생성된다.

하지만 emp708은 emp와는 다른, 별개의 또 다른 테이블이다.

** emp로 시작하는 내가 만든 테이블이 뭐가 있는지 확인하는 방법

select table_name
 from user_tables
 where table_name like 'EMP%';  -->> 반드시 대문자로 작성해줘야한다.

create view emp801
 as
  select empno, ename, sal, deptno
   from emp;

** view는 table 과는 다르게 별도로 데이터를 저장하고 있지 않다.

그러면, 어떨 때 사용하나?

데이터에 접근하는 사람에게 모든 정보를 공개하지 않고, 필요한 데이터만 공개하고 싶을 때 사용한다.

예제 : 직업, 직업별 월급의 합을 출력하기

select job,sum(sal)
 from emp
 group by job;

예제 : 위의 결과를 출력하는 뷰 생성하기

create view emp403
 as
  select job,sum(sal) as 토탈
  from emp
  group by job;

이렇게 만약 as 토탈을 안 써주면 오류가 난다.

** view를 생성할 때 그룹함수를 사용하게 되면 꼭 컬럼 별칭을 달아줘야 한다.

select e.ename, e.sal, v.토탈
 from emp e, emp403 v
 where e.job=v.job;

방금 만든 view를 데려와서 조인해서 함께 출력할 수 있다.

뷰의 장점

1. 민감한 컬럼을 감춰서 데이터를 제공할 수 있다.

2. 복잡한 쿼리문을 단순하게 만들 수 있다. (조인 할 때)

뷰의 종류 2가지

1. 단순 view

2. 복합 view

		단순 view                                          복합 view



테이블의 갯수                    1개                                      2개 이상

그룹 함수                        포함안됨                                 포함됨

DML 여부                        가능                                  불가능할 수도 있음


예제 : 이름과 부서위치를 출력하는 VIEW를 ename_loc라는 이름으로 생성하기

create view ename_loc
 as
    select e.ename, d.loc
         from emp e, dept d
          where e.deptno=d.deptno;

그 다음, ename_loc의 SCOTT의 부서 위치를 washington으로 변경하기

update ename_loc
 set loc='washington'
 where ename='SCOTT';

그럼 오류가 뜬다.

왜 오류가 뜰까?

ename_loc의 SCOTT의 위치를 washington으로 바꾸면,

dept 테이블과 연결되어있기 때문에, 원래 SCOTT과 연결된

dept의 'DALLAS'가 'washington '으로 바뀌어버리고,

DALLAS와 연결된 다른 emp 사원들도 washington으로 바뀌어버리기 때문이다.



마찬가지로 이 뷰로도 수정을 진행해보자.

select * from emp403;

SALESMAN의 월급을 2000으로 바꿔보면,

update emp403
 set 토탈 = 2000
 where job='SALESMAN';

마찬가지로 토탈 월급이라는 집계 함수가 포함되어있는 경우도 수정하려면 오류가 발생한다.

월급을 바꾸면 합계라는 컬럼의 값에도 영향이 가기 때문이다.


지금까지 만든 뷰 전체 조회하기

select view_name, text
 from user_views;

** 위와 같이 조회하면 view를 만들었을 때 사용한 테이블 명도 볼 수 있다.

그래서 외부에서 온 데이터 분석가들은 위의 쿼리를 조회할 수 있는 권한을 제한하는 경우가 많다. (권한 제한 - DCL문)



뷰 삭제하기

drop view emp809;

( 테이블 삭제할 때랑 똑같다 )