논리 연산자 : and, or, not

*  True  and  True  면  True 여서 결과가 출력이 된다.
   False  and  True  면  False  여서 결과가 출력이 안 된다
   False   or   True   는  True 이므로 결과가 출력이 된다. 


예제 : 직업이 SALESMAN 이고 월급이 1400 이상인 사원만 출력

select ename, sal,  job
 from emp
 where  job ='SALESMAN' and sal >= 1400;

예제 : 직업이 SALESMAN 이거나 월급이 1400 이상인 사원 출력

select ename, sal,  job
 from emp
 where  job ='SALESMAN' or sal >= 1400;

예제 : 이메일의 도메인이 naver나 gmail이 아닌 학생 출력

select ename, email
    from emp12
    where email not like '%gmail%' and email not like '%naver%';