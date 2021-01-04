1. 일반 테이블 생성하기 ( CREATE TABLE )

DDL 문 ( Date Definition Language ) : create, alter, drop, truncate, rename

겨울 왕국 대본을 오라클에 입력하고 엘사가 더 많이 나오는지 안나가 더 많이 나오는지,

긍정 단어가 더 많은지, 부정 단어가 더 많은지 등을 SQL 문으로 검색하려면

DDL 문을 이용해서 테이블을 생성할 수 있어야 한다.

예제 : 테이블 생성 스크립트

Create table emp500     --> 테이블 명
 ( empno number(10),    --> 컬럼명   데이터 유형 ( 길이 )
   ename varchar2(20),                    1. 문자형 2. 숫자형 3. 날짜형
   sal      number(10) );

예제 : emp500 테이블에 데이터 입력하기

insert into emp500
 values (1111,'scott',3000),
 values (2222,'smith',2900);

언제든 데이터를 수정하고 나면 commit; 을 빼먹지말자.

* 데이터 타입의 유형

데이터 유형    설명

char              고정길이 문자 데이터 유형이고, 최대 길이는 2000이다.
varchar2        가변길이 문자 데이터 유형이고, 최대 길이는 4000이다.
long             가변길이 문자 데이터 유형이고, 최대 2GB까지 데이터를 허용한다.
clob             문자 데이터 유형이고, 최대 4GB까지 데이터를 허용한다.
blob             바이너리 데이터 유형이고, 최대 4GB (사진, 동영상)
number        숫자 데이터 유형이고, 최대 38까지 허용
date             날짜 데이터 유형이고, 기원전 4712년 1월 1일부터
 	      기원후 9999년 12월 31일까지 날짜를 허용한다.
number(10,2)  숫자 데이터 10자리를 허용하는데, 그 중에 소숫점 2자리를 허용하겠다.
						ex ) 3500.23

** Long 데이터 타입을 사용하는 방법

long 데이터 타입은 아주 긴 텍스트 데이터를 입력할 때 사용하는 데이터 유형이다.

create table profile2 ( ename varchar2(20), self_intro long );
insert into profile2(ename, self_intro)
 values ('김인호', '어렸을 때부터 우리 집은 가난했었습니다. 그리고 어머니는 짜장면이 싫다고 하셨습니다. 야히 야히야' );

create table winter_kingdom
 ( win_text varchar2(4000));

winter_kingdom 이라는 테이블을 만들고

겨울 왕국 대사를 전부 넣어보자.

테이블을 우클릭해서 데이터 임포트를 클릭한 뒤, 구분자를 맨 밑 박스, 왼쪽 둘러싸기를 없음으로 바꾸고 진행한다.

예제 : elsa가 들어있는 줄마다 카운트하기

select regexp_count(lower(win_text),'elsa')as cnt
 from winter_kingdom;

예제 : 카운트된 숫자를 다 더하기 ( 대사 중 elsa가 총 몇번 나왔는가? )

select sum(regexp_count(lower(win_text),'elsa')) as cnt
 from winter_kingdom;

위의 SQL이 유용한 경우?

1. 뉴스기사를 분석해서 회사 주식에 영향을 주는지 파악하고 싶을 때

2. 은행 고객 대출 한도를 정할 때 대출 신청자의 SNS 글을 분석해서, 긍정적인 단어가 많은지 부정적인 단어가 많은지 분석