데이터베이스를 배울 때 인덱스(INDEX)를 알아야 하는 이유 :

인덱스를 알아야 빠르게 데이터를 검색할 수 있고, 속도는 현업에서 매우 매우 중요하다.


20분 ---> 0.01초        : 쉬운 SQL 튜닝

0.1   ---> 0.01초        : 어려운 SQL 튜닝    --> 인덱스의 구조를 이해하고, 활용을 잘할 수 있어야한다.



인덱스의 구조 : 컬럼명 + rowid ( row의 물리적 주소 )

    + 컬럼명이 오름차순으로 정렬이 되어있다.



** 만약에 대용량 데이터가 있는 환경에 가서 SQL을 수행했는데

너무 느리다면 반드시 실행 계획을 확인해서 full table scan을 했는지, index scan을 했는지 확인을 해야한다.


SQL 문 앞에 explain plan for 를 붙이고

실행계획을 확인하는 table을 조회하자.

explain plan for
 select ename, sal
  from emp
   where ename='SCOTT'


select * from table(dbms_xplan.display);


자세히 보면 INDEX RANGE SCAN을 확인할 수 있다.

만약 FULL TABLE SCAN으로 나오면 SCOTT을 검색하기 위해 EMP 테이블을 처음부터 끝까지 스캔했다는 뜻이다.


실행 계획을 만드는 옵티마이져라는 프로세서가 있는데

이 프로세서가 점점 인공지능화 되어가고 있다.

explain plan for
 select /*+ index(emp emp_ename) */ ename, sal
  from emp
  where ename='SCOTT';



/*+ 실행 계획을 제어하는 명령어 */  -->> 힌트

emp 테이블에 있는 emp_ename라는 인덱스를 통해서 데이터 검색을 해라

라고 힌트를 줘서 옵티마이저에게 명렁을 내린다.



**[[[+를 띄어쓰지 않도록 주의!!]]]



예 : 사원 테이블의 월급에 인덱스를 생성하고, 사원 테이블을 검색하는데 월급이 3000인 사원들의 이름과 월급을 검색



create index emp_sal
 on emp(sal);


select ename, sal
 from emp
 where sal = 3000;


select * from table(dbms_xplan.display);  ( 실행 계획 확인 )


* 실행문을 클릭해두고 F10을 눌러서 실행 계획을 확인할 수도 있다.




** 인덱스의 과정을 생각하기


select ename, sal
 from emp
 where ename='BLAKE';


일반적인 인덱스가 없는 SQL문은 full table scan이다.

그리고 

왜냐하면 SCOTT이 있는지 없는지 알려면 일단 데이터 끝까지 쫙 봐야하기 때문.

SCOTT이 맨 끝에 또 있을 수도 있으니까.



반면

INDEX scan은 ABCD 순으로 정렬이 되어있기 때문에 BLAKE를 A부터 찾아서 찾은 다음, ROWID를 본다.

그리고 전체 테이블에서 그 ROWID에 있는 행을 보고 그와 관련한 컬럼들을 반환한다.

그래서 index scan은 끝까지 테이블을 안 봐도 되기 때문에 반환이 훨씬 빠르다.



인덱스의 구조를 전부 읽어오는 방법


1. 문자 > ' '

2. 숫자 >= 0

3. 날짜 <= to_date('9999/12/31','RRRR/MM/DD')


위의 조건이 WHERE 절에 있어줘야 인덱스 전체를 다 읽어 올 수 있다.


인덱스의 구조를 알면 SQL 튜닝을 할 수가 있는데 그 중 하나가

order by 절을 사용하지 않고 정렬된 결과를 볼 수 있다는 것이다.



order by 절을 남발하면 검색 성능이 느려진다.

전체 데이터를 정렬한다는 것은 시간이 오래 걸리는 일



예제 : 월급 순으로 사원의 이름과 월급을 출력하기



1. order by 절을 사용했을 때


select ename, sal
 from emp
 order by sal asc;



2. 인덱스 사용

select ename, sal
 from emp
 where sal>0;


3. 힌트 사용 (만약 인덱스가 먹히지 않았다면 무조건)

select /*+ index_asc(emp emp_sal) */ ename, sal
 from emp
 where sal>=0;


** 인덱스를 통해서 정렬된 데이터를 보려면

where 절에 반드시 해당 컬럼을 검색하는 조건이 있어야하고,

힌트도 준다면 확실하게 정렬된 결과를 볼 수 있다.


/*+ index_asc(테이블명 인덱스이름) */

/*+ index_desc(테이블명 인덱스이름) */


예제 : 이름과 월급을 출력하는 월급이 높은 사원부터 출력하기 (인덱스 사용)


select /*+ index_desc(emp emp_sal) */ ename, sal
 from emp
 where sal>=0;


예제 : 입사일이 가장 최근인 사원부터 이름과 입사일 출력하기


select /*+ index_desc(emp emp_hiredate) */ ename, hiredate
 from emp
 where hiredate<= to_date('9999/12/31','RRRR/MM/DD')