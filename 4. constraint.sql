-- not null 제약조건 추가
alter table author modify column name varchar(255) not null;
-- not null 제약조건 추가
alter table author modify column name varchar(255);
-- not null, unique 동시 추가
alter table author modify column email varchar(255) not null unique;

-- pk/fk 추가/제거
-- pk 제약조건 삭제
alter table post drop primary key; => pk는 하나밖에 없음
-- fk 제약조건 삭제
alter table post drop foreign key fk명;
-- pk 제약조건 추가
alter table post add constraint post_pk primary key(id);
-- fk 제약조건 추가
alter table post add constraint post_fk foreign key(author_id) references author(id);

-- on delete/on update 제약조건 변경 테스트
alter table post add constraint post_fk foreign key(author_id) references author(id) on delete set null on update cascade;

-- 기존 fk 삭제
-- 새로운 fk 추가 (onupdate/ondelete 변경)
-- 새로운 fk에 맞는 테스트
-- 삭제 테스트
-- 수정 테스트 67ol

-- default 옵션
-- 어떤 컬럼이든  default 지정이 가능하지만, 일반적으로 enum타입 및 현재시간에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';
-- auto_increment : 숫자값을 입력안했을때, 마지막 입력된 가장 큰 값에 +1만큼 증가된 숫자값 자동으로 적용
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

-- UUID 타입
alter table post add column user_id char(36) default (UUID());