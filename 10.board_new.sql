-- 회원 테이블 생성  
-- id(pk), email(unique), name(not null), password(not null)
create table author(id bigint auto_increment primary key, email varchar(255) not null, name varchar(255) not null, password varchar(255) not null);

-- 주소 테이블
-- id, country, city, street, author_id(fk)
create table post(id bigint auto_increment primary key, title varchar(255) not null, contents varchar(3000));

-- post 테이블
-- id,  title(not null), contents
create table post(id bigint auto_increment primary key, title varchar(255) not null, contents varchar(3000));

-- 연결(junction) 테이블
create table author_post_list(id bigint auto_increment primary key, author_id bigint not null, post_id bigint not null, foreign key(author_id) references author(id), foreign key(post_id) references post(id));

-- 복합키를 이용한 연결(junction) 테이블
create table author_post_list(author_id bigint not null, post_id bigint not null, priamry key(author_id, post_id) foreign key(author_id) references author(id), foreign key(post_id) references post(id));

-- 회원가입 및 주소생성
insert into author(email, name, password) values('min123@naver.com', 'minsu', '1234567');
insert into address(country, city, street, author_id) values('US', 'new york', '9avenue',2);

-- 글쓰기
insert into post(title, contents) values( 'hello2', 'hello world2..');
insert into author_post_list(author_id, post_id) value(1,2);
insert into author_post_list(author_id, post_id) value(2,2);

-- 글 전체목록 조회하기 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select 쿼리 생성 
select distinct p.title,distinct p.contents,distinct a.name from post p inner join author_post_list a_p_l inner join author a;