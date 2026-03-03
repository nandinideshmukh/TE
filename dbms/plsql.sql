-- Unnamed PL/SQL code block: Use of Control structure
-- and Exception handling is mandatory. Write a PL/SQL
-- block of code for the following requirements:-
-- Schema:
-- 1. Borrower(Roll,Name,DateofIssue, NameofBook, Status)
-- 2. Fine (Roll, Date, Amt)
-- Accept Roll & N ame of book from user.
-- Check the number of days (from date of issue), if days
-- are between 15 to 30 then fine amount will be Rs 5per day.
-- If no. of days>30, per day fine will be Rs 50 per day &
-- for days less than 30, Rs. 5 per day.
-- After submitting the book, status will change from I to R.
-- If condition of fine is true, then details will be stored into
-- fine table.
-- Frame the problem statement for writing PL/SQL block
-- inline with above statement

create table if not exists borrow(
    roll int primary key,
    name varchar(50) not null,
    doi date not null,
    book_name varchar(50) not null,
    status boolean not null
);

create table fine(
    roll int primary key,
    dof date not null,
    amt float not null,
);

-- procedure as exception handling is permitted .

delimiter /
create procedure change_status(in roll_ int,in name_ varchar(50),out stat boolean)
begin
    declare late date;
    declare fined float;
    declare dayof int;
    
    select doi into late from borrow where roll = roll_ and name = name_;
    set dayof = datediff(curdate(),late);

    if dayof < 30 and dayof > 15 then
        set fined= dayof * 5;
    elseif dayof >=30 then
        set fined= dayof*50;
    end if;
    
    update borrow set status = 'R' where roll = roll_ and name = name_;

    if fined is not null then
        insert into fine values(roll_,curdate(),fined);
    end if;
    set stat = true;

end;
/

delimiter ;

--  OK, 0 rows affected (0.01 sec)

-- mysql> insert into borrow values(1,'a','2024-01-01','book1','I');
--     -> /
-- ERROR 1366 (HY000): Incorrect integer value: 'I' for column 'status' at row 1
-- mysql> alter table borrow modify status char(1) not null;
--     -> /
-- Query OK, 0 rows affected (0.06 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

-- mysql> insert into borrow values(1,'a','2024-01-01','book1','I');
--     -> /
-- Query OK, 1 row affected (0.01 sec)

-- mysql> insert into borrow values(2,'b','2026-01-01','book2','I');
--     -> /
-- Query OK, 1 row affected (0.01 sec)

-- mysql> delimiter ;
-- mysql> insert into borrow values(3,'c','2026-02-01','book3','I');
-- Query OK, 1 row affected (0.01 sec)

--  select * from borrow;
-- +------+------+------------+-----------+--------+
-- | roll | name | doi        | book_name | status |
-- +------+------+------------+-----------+--------+
-- |    1 | a    | 2024-01-01 | book1     | I      |
-- |    2 | b    | 2026-01-01 | book2     | I      |
-- |    3 | c    | 2026-02-01 | book3     | I      |
-- +------+------+------------+-----------+--------+
-- 3 rows in set (0.00 sec)

-- mysql> call change_status(1,'a',@res);
-- Query OK, 1 row affected (0.01 sec)

-- mysql> select * from borrow;
-- +------+------+------------+-----------+--------+
-- | roll | name | doi        | book_name | status |
-- +------+------+------------+-----------+--------+
-- |    1 | a    | 2024-01-01 | book1     | R      |
-- |    2 | b    | 2026-01-01 | book2     | I      |
-- |    3 | c    | 2026-02-01 | book3     | I      |
-- +------+------+------------+-----------+--------+
-- 3 rows in set (0.00 sec)

-- mysql> call change_status(2,'b',@res);
-- Query OK, 1 row affected (0.01 sec)

-- mysql> select * from fine;
-- +------+------------+-------+
-- | roll | dof        | amt   |
-- +------+------------+-------+
-- |    1 | 2026-03-03 | 39600 |
-- |    2 | 2026-03-03 |  3050 |
-- +------+------------+-------+
-- 2 rows in set (0.00 sec)

-- mysql> select * from borrow;
-- +------+------+------------+-----------+--------+
-- | roll | name | doi        | book_name | status |
-- +------+------+------------+-----------+--------+
-- |    1 | a    | 2024-01-01 | book1     | R      |
-- |    2 | b    | 2026-01-01 | book2     | R      |
-- |    3 | c    | 2026-02-01 | book3     | I      |
-- +------+------+------------+-----------+--------+
-- 3 rows in set (0.00 sec)

