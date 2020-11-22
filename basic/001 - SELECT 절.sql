데이터를 정렬해서 출력하기 (ORDER  BY)

* order by 절은 데이터를 정렬하는 절이고 select 문장에 맨 마지막에 기술한다.
* 정렬할 컬럼명 정렬방법 :
asc : 낮은값부터 높은값 순으로
desc : 높은값부터 낮은값 순으로

예제 : 월급이 높은 순으로 이름과 월급을 출력하기
select ename, sal
  from  emp
  order by sal desc;

select ename, sal
  from  emp
  order by sal asc;

select ename, sal
  from  emp
  order by sal;

보이는 것처럼 오름차순(asc) 또는 내림차순(desc)을 명시하지 않으면 디폴트 값은 asc다.


또한
 select ename, job, hiredate
  from  emp
  order  by 2 asc, 3 asc; 

위와 같이 order by를 2개 이상 해주는 것도 가능하며, select 절의 컬럼명을 간단하게 순서대로 1,2,3으로 대체해서 작성할 수 있다.


where 절 (숫자 데이터 검색)

* where 절을 사용하면 특정 조건에 대한 데이터만 선별해서 출력할 수 있다

* 기본 비교 연산자

 >, <, >=, <=, =,  !=, <>, ^=
이 중에 [!=,<>,^=]-->이것들 전부 다 같지 않다는 뜻.


예제 : 월급이 3000 이상인 사원들의 이름과 월급을 출력하기

select ename, sal
   from emp
   where sal>=3000;

예제 : 직업이 SALESMAN이 아닌 사원들의 이름과 직업을 출력하기

select ename, job
   from emp
   where job!='SALESMAN';

select  ename, hiredate, deptno
   from  emp
   where deptno = 20
   order by 2 desc;

부서 번호가 20인 사원들의 이름, 고용일, 부서 번호를 출력하고 최근에 고용된 순서부터 정렬


8. where 절 - 2 (문자와 날짜 검색)

* 숫자가 아닌 문자를 검색할 때는 문자 양쪽에 싱글 쿼테이션 마크('')를 둘러줘야 한다.

select  ename, sal
 from emp
 where ename='SCOTT'; 

또한 문자열은 대문자를 구분하기 때문에 소문자인 scott으로 검색하면 다른 것으로 인식되어 검색 결과가 출력되지 않는다.