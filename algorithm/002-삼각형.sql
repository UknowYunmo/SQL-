예제 :주사위를 10만번 던져서 주사위의 눈이 6이 나올 확률 구하기

select count(*) /100000 as "주사위가 6이 나올 확률"
  from ( select round ( dbms_random.value(0.5,6.5) ) as 주사위
             from dual
              connect by level <= 100000)
  where 주사위 = 6;


* dbms_random.value(a,b)는 a,b 사이에서 랜덤으로 난수를 생성하는 함수이다.

여기서 round로 감쌌기 때문에 결국 1,2,3,4,5,6만 나온다.

결국 10만번 중 6이 나온 횟수를 count한 뒤 전체인 10만으로 나누면 그 확률이 된다.

그런데 이 때 round(dbms_random.value(0,6))을 하게 되면

1은 0.5~1.5 사이인 반면

0은 0~0.5 사이밖에 존재하지 않으므로

같은 이유로 0과 6은 1,2,3,4보다 나올 확률이 절반이 되어버리니 유의하자.




예제 : 주사위 2개를 던져서 합이 10인 확률 구하기

select count(*) / 100000 as "합이 10인 확률"
   from ( select round( dbms_random.value(0.5,6.5) ) as 주사위1,
                round( dbms_random.value(0.5,6.5) ) as 주사위2
               from dual
               connect by level <= 100000)
   where 주사위1 + 주사위2 = 10;


보기와 같이 주사위 두 개를 동시에 던질 수도 있다.




예제 : 주사위 한 개와 동전을 던져서, 주사위는 5, 동전은 앞면이 나올 확률 구하기

select count(*)/100000
                 from ( select round( dbms_random.value(0.5, 6.5) ) as 주사위,
                          round( dbms_random.value(0,1)) as 동전
                             from dual
                             connect by level <=100000)
                 where 주사위 = 5 and 동전 =1;