-- pk, fk ,unique 제약조건 추가시에 해당컬럼에 대해 index 페이지 자동생성
-- 별도의 컬럼에 대해 index 추가 생성 가능
-- cardinality는 데이터의 종류

-- index 조회
show index from author;

-- 기존 index 삭제
alter table author drop index 인덱스명;

-- 신규 index 생성
create index 인덱스명 on 테이블명(컬럼명);
create index name_index on author(name);

-- index는 한 개의 컬럼 뿐만 아니라, 2컬럼을 대상으로 1개의 index를 설정하는 것도 가능
-- 이경우 두컬럼을 and조건으로 조회해야만 index를 사용
create index 인덱스명 on 테이블명(컬럼1, 컬럼2);   <= 사용하려면 where 컬럼1=? and 컬럼2=?
                                                컬럼1에만 인덱스가 만들어져 있다면 컬럼1 인덱스만 탐
                                                컬럼2에만 인덱스가 만들어져 있다면 컬럼2 인덱스만 탐
                                                컬럼1, 컬럼2에 각각 인덱스가 있다면 mariadb엔진에서 최적화
-- index 생성 or not?
-- 1. 조회가 빈번한가?
-- 2. cardinality가 높은가? (데이터의 종류가 다양한가?)
-- => 극단적으로 높은 것 -> 인덱스 의미 있음
-- => 극단적으로 낮은 것 -> 1개 (인덱스 효과 없음)

-- index 성능테스트
-- 기존 테이블 삭제 후 간단한 테이블로 index설정 또는 index미설정 테스트
create table author(id bigint auto_increment, email varchar(255), name varchar(255), primary key(id));
create table author(id bigint auto_increment, email varchar(255) unique, name varchar(255), primary key(id));

-- 아래 프로시저를 통해 수십만건의 데이터 insert후에 index생성 전후에 따라 조회성능확인
DELIMITER //
CREATE PROCEDURE insert_authors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE email VARCHAR(100);
    DECLARE batch_size INT DEFAULT 10000; -- 한 번에 삽입할 행 수
    DECLARE max_iterations INT DEFAULT 100; -- 총 반복 횟수 (1000000 / batch_size)
    DECLARE iteration INT DEFAULT 1;
    WHILE iteration <= max_iterations DO
        START TRANSACTION;
        WHILE i <= iteration * batch_size DO
            SET email = CONCAT('bradkim', i, '@naver.com');
            INSERT INTO author (email) VALUES (email);
            SET i = i + 1;
        END WHILE;
        COMMIT;
        SET iteration = iteration + 1;
        DO SLEEP(0.1); -- 각 트랜잭션 후 0.1초 지연
    END WHILE;


END //
DELIMITER ;

-- 기획 -> ERD(Entity Relationship Diagram) -erd cloud, drawio 설계
-- 1. 1:1 (점----점) =>author_id(unique) or 1:n (--------삼지창)  author_id(unique X)
-- 2. mandatory - 필수적인 (짝대기) , optimal - 선택적인 (동그라미)

-- 0.관계가 있는가 없는가
-- 1.회원 입장에서 게시글이 1:1인가 1:N인가     1:1인경우 unique로 보장
-- 2.회원 입장에서 게시글이 필수, 선택인가      (회원 입장에서 게시글이 어떠한가를 게시글 쪽에 표시)
-- 3.게시글 입장에서 회원이 1:1인가 N:1인가
-- 4.게시글 입장에서 회원이 필수, 선택인가      (게시글 입장에서 회원이 어떠한가를 게시글 쪽에 표시)

-- 1.자식에 FK설정
-- 2.누가 부모고, 누가 자식 테이블인가 (삭제할 때 부모가 삭제될 때 자식이 같이 삭제 되도록 관계 설정)

-- n : m 관계   1. fk 설정 불가 2. 수정 삭제 어려움
-- 1 : n , 1 : n 의 관계를 갖는 junction table로 풀어냄