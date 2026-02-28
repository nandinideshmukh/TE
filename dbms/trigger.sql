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


connect_do_mysqlile_url = "sqlilte:///library.db"

create table if not exists library(
    id int primary key auto_increment start with 1,
    NAME VARCHAR(50) not NULL,
    AUTHOR VARCHAR(50) not NULL,
    PUBLISHER VARCHAR(50) not NULL,
    DOP DATE not NULL
);

create table if not exists library_audit(
    id int primary key auto_increment start with 1,
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
create or REPLACE TRIGGER  after_update
after update
on library
for each row
begin
    insert into library_audit(NAME, AUTHOR, PUBLISHER, DOP)
    VALUES (old.name, old.author,old.publisher, old.dop);
end;
!!

create or REPLACE TRIGGER after_delete
after delete
on library
for each row
begin
    insert into library_audit(NAME, AUTHOR, PUBLISHER, DOP)
    values(old.NAME, old.AUTHOR, old.PUBLISHER, old.DOP) 
end;
!!


CREATE or REPLACE TRIGGER after_insert
after insert
on library
for each row
begin
    insert into library_audit(NAME, AUTHOR, PUBLISHER, DOP)
    values(new.NAME, new.AUTHOR, new.PUBLISHER, new.DOP);
end;
!!


create or replace trigger before_insert
before insert
on library
for each row

begin
    if new.author = '' or new.dop is NULL
    then
        signal sqlstate '45000' set message_text = 'Author and Date of Publication cannot be empty';
    end if;
end;


create or replace TRIGGER BEFORE_UPDATE
before UPDATE
on library
for each row
BEGIN
    -- prevent duplicate book entries on the basis of name
    if new.name = old.name or new.author = old.author
    then
        signal sqlstate '45000' set message_text = 'Book with the same name already exists';
    end if;
end;
!!

DELIMITER ;


-- example of all 4 implemented above

-- before insert
insert into library values('Book2', '', 'Publisher2', '2024-02-01');

-- after insert
insert into library(NAME, AUTHOR, PUBLISHER, DOP) values('Book1', 'Author1', 'Publisher1', '2024-01-01');

-- after update
update library set name = 'Book1 Updated' where id = 1;

-- after delete
delete from library where id = 1;

-- before update
update library set name = 'Book1 Updated' where id = 2;
-- duplicate entry error because of same name and author as Book1 Updated
update library set name = 'Book1 Updated' where id = 2;


