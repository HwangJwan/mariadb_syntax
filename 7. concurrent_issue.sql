-- read uncommitted : 커밋되지 않은 데이터 read 가능 -> dirty read 문제 발생
-- 실습 절차
-- 1) workbench에서 오토커밋 해제. update실행, commut하지 않음 (transaction1)
-- 2) 터미널을 열어 select 했을때, 위 update변경사항이 읽히는지 확인 (transaction2)
-- 결론 : mariadb는 기본이 repeatable read 이므로 dirty read 발생 X
                                                 insert 경우      update 경우
-- read cmmitted : commit한 데이터만 read가능 -> phantom read , non-repeatable read
-- 실습절차
-- 1) workbench에서 아래 코드 실행
start transaction;
select count(*) from author;
do sleep(15);
select count(*) from author;
commit;
-- 2) 터미널을 열어 아래 코드 실행
insert into author(email) values('ggg@naver.com');

-- repeatable read : 읽기의 일관성 보장 -> Lost update문제 발생 - 배타lock(배타적 잠금)
-- lost update 문제가 발생하는 상황
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 2);
    select post_count into count from author where id=2;
    do sleep(15);
    update author set post_count=count+1 where id=2;
    commit;
end //
DELIMITER ;
call concurrent_test1();
-- 터미널에서는 아래 코드 실행
select post_count from author where id=1;

-- 배타락을 통해 lost update문제를 해결한 상황
-- select for update하게 되면 트랜잭션이 실행되는 동안 lock이 걸리고, 트랜잭션이 종료되면 lock이 풀림
DELIMITER //
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 2);
    select post_count into count from author where id=2 for update;
    do sleep(15);
    update author set post_count=count+1 where id=2;
    commit;
end //
DELIMITER ;
call concurrent_test2();
-- 터미널에서는 아래 코드 실행
select post_count from author where id=2 for update;

-- serializable - 모든 트랜잭션 순차적 실행 -> 동시성 문제없음(성능저하)