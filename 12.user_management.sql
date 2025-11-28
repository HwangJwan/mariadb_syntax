-- 사용자 목록조회
select * from mysql.user;

-- 사용자 생성
create user 'juwan'@'%' identified by 'test4321';

-- 사용자에게 권한 부여
grant select on board.author to 'juwan'@'%';
grant select, insert on board.* to 'juwan'@'%'
grant all privilages on board.* to 'juwan'@'%'

-- 사용자 권한 회수
revoke select on board.author from 'juwan'@'%';

-- 사용자 권한 조회
show grants for 'juwan'@'%';

-- 사용자 계정삭제
drop user 'juwan'@'%';