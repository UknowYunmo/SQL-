3개 이상의 테이블 조인하기


* 2개의 테이블 조인

              연결 고리 1개

emp ----------------------------- dept


* 3개의 테이블 조인

                연결 고리             (and)              연결 고리

dept ----------------------------- emp ----------------------------- salgrade



         e.deptno=d.deptno        and     e.sal between s.losal and s.hisal


예제 : 이름과 부서위치와 월급과 부서번호를 출력하기


select d.loc, e.sal, e.deptno
 from emp e, dept d
 where d.deptno=e.deptno



예제 : 이름과 부서위치와 급여등급을 출력하기

select e.ename, d.loc, s.grade
 from emp e, dept d, salgrade s
 where d.deptno=e.deptno and e.sal between s.losal and s.hisal;



다음과 같이 테이블이 3개이면 2개의 연결고리를 where 절에 기술해줘야한다.



예제 : bonus 테이블 만들기

create table bonus
 as
  select empno, sal*1.5 as comm2
   from emp;



예제 : 여기서 사원 이름, 월급, 부서 위치, comm2를 출력하기

select e.ename, e.sal, d.loc, b.comm2
 from emp e, dept d, bonus b
 where e.deptno=d.deptno and e.empno=b.empno;