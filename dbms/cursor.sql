-- Cursors: (All types: Implicit, Explicit, Cursor FOR Loop,
-- Parameterized Cursor)
-- Write a PL/SQL block of code using parameterized Cursor, that
-- will merge the data available in the newly created table
-- N_EmpId with the data available in the table O_EmpId.
-- If the data in the first table already exist in the second table then
-- that data should be skipped.


create table oldemp(
    id int primary key,
    name varchar(50) not null,
    salary int default 0,
    joind date not null,
    age int not null,
    experience int not null,
);

create table newemp(
    id int primary key,
    name varchar(50) not null,
    salary int default 0,
    joind date not null,
    age int not null,
    experience int not null,
);

insert into oldemp values(1,'s',50000,'2020-01-01',30,5);
insert into oldemp values(2,'n',60000,'2019-01-01',28,3);
insert into oldemp values(3,'p',55000,'2021-01-01',35,10);

-- this should be skipped
insert into newemp values(1,'s',50000,'2020-01-01',30,5);


DELIMITER /

CREATE PROCEDURE merge_emp()
BEGIN
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(255);
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_joind DATE;
    DECLARE v_age INT;
    DECLARE v_experience INT;
    DECLARE done INT DEFAULT 0;

    DECLARE emp CURSOR FOR 
        SELECT id, name, salary, joind, age, experience FROM oldemp;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN emp;

    read_loop: LOOP
        FETCH emp INTO v_id, v_name, v_salary, v_joind, v_age, v_experience;
        IF done THEN
            LEAVE read_loop;
        END IF;

        if not exists (select 1 from newemp where id = v_id) then
            INSERT INTO newemp VALUES (v_id, v_name, v_salary, v_joind, v_age, v_experience);
        END IF;
    END LOOP;

    CLOSE emp;
END/


delimiter ;
