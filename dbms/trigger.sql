-- Problem Statement:
-- Database Trigger (All Types: Row level and Statement 
-- level triggers, Before and After Triggers). Write a 
-- database trigger on Library table. The System should keep 
-- track of the records that are being updated or deleted. The 
-- old value of updated or deleted records should be added in 
-- Library_Audit table. 
-- Frame problem statement for writing Database 
-- Triggers of all types, inline with above statement. The 
-- problem statement should clearly state the 
-- requirements. 

-- connect to mysql server and create database
-- 1. sudo mysql -u root -p
-- 2. create database library_db;
-- 3. use library_db;

create table if not exists library(
    id int primary key auto_increment ,
    NAME VARCHAR(50) not NULL,
    AUTHOR VARCHAR(50) not NULL,
    PUBLISHER VARCHAR(50) not NULL,
    DOP DATE not NULL
);

create table if not exists library_audit(
    id int primary key auto_increment ,
    NAME VARCHAR(50) not NULL,
    AUTHOR VARCHAR(50) not NULL,
    PUBLISHER VARCHAR(50) not NULL,
    DOP DATE not NULL
);

-- Six types of triggers
-- 1. BEFORE insert
-- 2. after insert
-- 3. before update
-- 4. after update
-- 5. before delete
-- 6. after delete


DELIMITER !!
create  TRIGGER  after_update
after update
on library
for each row
begin
    insert into library_audit(NAME, AUTHOR, PUBLISHER, DOP)
    VALUES (old.name, old.author,old.publisher, old.dop);
end
!!


create TRIGGER after_delete
after delete
on library
for each row
begin
    insert into library_audit(NAME, AUTHOR, PUBLISHER, DOP)
    values(old.NAME, old.AUTHOR, old.PUBLISHER, old.DOP) 
end
!!


CREATE TRIGGER after_insert
after insert
on library
for each row
begin
    insert into library_audit(NAME, AUTHOR, PUBLISHER, DOP)
    values(new.NAME, new.AUTHOR, new.PUBLISHER, new.DOP);
end
!!


create trigger before_insert
before insert
on library
for each row

begin
    if new.author = '' or new.dop is NULL
    then
        signal sqlstate '45000' set message_text = 'Author and Date of Publication cannot be empty';
    end if;
end
!!


create TRIGGER BEFORE_UPDATE
before UPDATE
on library
for each row
BEGIN
    -- prevent duplicate book entries on the basis of name
    if new.name = old.name or new.author = old.author
    then
        signal sqlstate '45000' set message_text = 'Book with the same name already exists';
    end if;
end
!!

DELIMITER ;


-- example of all 4 implemented above

-- before insert
insert into library values(1,'Book2', '', 'Publisher2', '2024-02-01');

-- after insert
insert into library values(2,'Book1', 'Author1', 'Publisher1', '2024-01-01');
select * from library_audit;

-- after update
update library set name = 'Book1 Updated' where id = 1;

-- after delete
delete from library where id = 1;


-- select * from library_audit;
-- +----+-------+---------+------------+------------+
-- | id | NAME  | AUTHOR  | PUBLISHER  | DOP        |
-- +----+-------+---------+------------+------------+
-- |  1 | Book1 | Author1 | Publisher1 | 2024-01-01 |
-- +----+-------+---------+------------+------------+
-- 1 row in set (0.00 sec)

-- mysql> select* from library ;
-- +----+-------+---------+------------+------------+
-- | id | NAME  | AUTHOR  | PUBLISHER  | DOP        |
-- +----+-------+---------+------------+------------+
-- |  2 | Book1 | Author1 | Publisher1 | 2024-01-01 |
-- +----+-------+---------+------------+------------+
-- 1 row in set (0.00 sec)


-- before update
update library set name = 'Book1 Updated' where id = 2;

-- Output:
-- mysql> update library set name = 'Book1 Updated' where id = 2;
-- ERROR 1644 (45000): Book with the same name already exists

-- duplicate entry error because of same name and author as Book1 Updated
update library set name = 'Book1 Updated' where id = 2;

-- check library_audit table for the old values of updated and deleted records
select * from library_audit;


-- Output:
-- mysql> insert into library values(2,'Book1', 'Author1', 'Publisher1', '2024-01-01');
-- ERROR 1062 (23000): Duplicate entry '2' for key 'library.PRIMARY'
-- mysql> insert into library values(3,'Book1', 'Author1', 'Publisher1', '2024-01-01');
-- Query OK, 1 row affected (0.00 sec)

-- mysql> select * from library_audit;
-- +----+-------+---------+------------+------------+
-- | id | NAME  | AUTHOR  | PUBLISHER  | DOP        |
-- +----+-------+---------+------------+------------+
-- |  1 | Book1 | Author1 | Publisher1 | 2024-01-01 |
-- |  2 | Book1 | Author1 | Publisher1 | 2024-01-01 |
-- +----+-------+---------+------------+------------+
-- 2 rows in set (0.00 sec)

-- mysql> select* from library ;
-- +----+-------+---------+------------+------------+
-- | id | NAME  | AUTHOR  | PUBLISHER  | DOP        |
-- +----+-------+---------+------------+------------+
-- |  2 | Book1 | Author1 | Publisher1 | 2024-01-01 |
-- |  3 | Book1 | Author1 | Publisher1 | 2024-01-01 |
-- +----+-------+---------+------------+------------+
-- 2 rows in set (0.00 sec)

