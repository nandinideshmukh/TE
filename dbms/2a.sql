-- Assignment No 2A (Employee Schema)
-- Demonstrate the use Table, View, Index, Sequence, Synonym,
--  different constraints on the following Schema
--  ● Employee( Emp_id, Dept_id, Emp_fname, Emp_lname, Emp_Position, Emp_salary,Emp_JoinDate)
--  ● Dept ( Dept_id, Dept_name,Dept_location ,)
--  ● Project( Proj_id,Dept_id ,Proj_Name,Proj_Location,Proj_cost,Proj_year)
--  Note: Use referential integrity constraints while creating tables with on delete cascade options. 
--  Use the tables created in assignment no 2A and execute the following queries: 
--  1. Insert at least 10 records in the Employee table and insert other tables accordingly.
--  2. Display all Employee details with Department ‘Computer’ and ‘IT’ and Employee first name starting with 'p' or 'h'.
--  3. lists the number of different Employee Positions. 
--  4. Give 10% increase in Salary of the Employee whose joining year is before 1985. 
--  5. Delete Department details which location is ‘Mumbai’. 
--  6. Find the names of Projects with location ‘pune’ . 
--  7. Find the project having cost in between 100000 to 500000. 
--  8. Find the project having maximum price and find average of Project cost
--  9. Display all employees with Emp _id and Emp name in decreasing order of Emp_lname
--  10. Display Proj_name,Proj_location ,Proj_cost of all project started in 2004,2005,2007 
--  A2: Guidelines Synonyms not supported in MySQL. Sequence should be implemented with AUTO_INCREMENT. 
--  Concept of sequence from oracle must be included in the write-up. Simple view, Index (simple, unique, composite and text
--   – show index after creation)

CREATE TABLE dept (
    id INT PRIMARY KEY,
    dname VARCHAR(20) NOT NULL,
    loc VARCHAR(50) NOT NULL
);

CREATE TABLE employee (
    id INT PRIMARY KEY,
    dept_id INT NOT NULL,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50),
    pos VARCHAR(20) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    joind DATE NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES dept(id)
);   

create table project(
    pid int primary key,
    dept_id int,
    pname varchar(50) not null,
    ploc varchar(50) not null,
    pcost decimal(10,2) not null,
    pyear date not null,
    foreign key(dept_id) references dept(id)

);




-- insert into dept values(1,'dev','loc1');
-- Query OK, 1 row affected (0.01 sec)

-- mysql> insert into employee values(1,1,'a','b','dev',1000000,'2026-01-01');
-- Query OK, 1 row affected (0.00 sec)

-- mysql> select * from dept;
-- +----+-------+------+
-- | id | dname | loc  |
-- +----+-------+------+
-- |  1 | dev   | loc1 |
-- +----+-------+------+
-- 1 row in set (0.00 sec)

-- mysql> select * from employee;
-- +----+---------+-------+-------+-----+------------+------------+
-- | id | dept_id | fname | lname | pos | salary     | joind      |
-- +----+---------+-------+-------+-----+------------+------------+
-- |  1 |       1 | a     | b     | dev | 1000000.00 | 2026-01-01 |
-- +----+---------+-------+-------+-----+------------+------------+
-- 1 row in set (0.00 sec)

-- mysql> ^C
-- mysql> insert into dept values(2, 'HR', 'Los Angeles');;
-- Query OK, 1 row affected (0.00 sec)

-- ERROR: 
-- No query specified

-- mysql> 
-- mysql> INSERT INTO employee (id, dept_id, fname, lname, pos, salary, joind) VALUES 
--     -> (2, 1, 'Jane', 'Smith', 'Developer', 72000.00, '2023-02-20'),
--     -> (3, 1, 'Sam', 'Brown', 'Lead', 85000.00, '2022-11-10'),
--     -> (4, 2, 'Lisa', 'Taylor', 'Analyst', 60000.00, '2023-03-05'),
--     -> (5, 2, 'Mark', 'Wilson', 'Manager', 80000.00, '2022-12-01'),
--     -> (6, 1, 'Paul', 'Adams', 'Developer', 71000.00, '2023-04-12'),
--     -> (7, 1, 'Anna', 'Lee', 'QA', 67000.00, '2023-05-18'),
--     -> (8, 2, 'Tom', 'Hall', 'HR Specialist', 58000.00, '2023-06-01'),
--     -> (9, 1, 'Kim', 'Wong', 'DevOps', 78000.00, '2023-07-22'),
--     -> (10, 2, 'Alex', 'Martin', 'Recruiter', 62000.00, '2023-08-30');
-- Query OK, 9 rows affected (0.01 sec)
-- Records: 9  Duplicates: 0  Warnings: 0



-- select * from employee e left join dept d on d.id = e.dept_id where d.dname in ('dev','HR') and (e.fname like 'p%' or e.fname like 'h%');
-- NSERT INTO dept (id, dname, loc) VALUES 
--     -> (3, 'Computer', 'Boston'),
--     -> (4, 'IT', 'San Francisco');   
-- Query OK, 2 rows affected (0.01 sec)
-- Records: 2  Duplicates: 0  Warnings: 0

-- mysql> INSERT INTO employee (id, dept_id, fname, lname, pos, salary, joind) VALUES 
--     -> (12, 4, 'Helen', 'Smith', 'Admin', 60000.00, '2023-04-15'),
--     -> (13, 3, 'Peter', 'Chang', 'Manager', 85000.00, '2022-12-01'),
--     -> (14, 4, 'Henry', 'Lee', 'Support', 55000.00, '2023-06-01');
-- Query OK, 3 rows affected (0.00 sec)
-- Records: 3  Duplicates: 0  Warnings: 0

-- mysql> select * from employee e left join dept d on d.id = e.dept_id where d.dname in ('dev','HR') and (e.fname like 'p%' or e.fname like 'h%');
-- +----+---------+-------+-------+-----------+----------+------------+------+-------+------+
-- | id | dept_id | fname | lname | pos       | salary   | joind      | id   | dname | loc  |
-- +----+---------+-------+-------+-----------+----------+------------+------+-------+------+
-- |  6 |       1 | Paul  | Adams | Developer | 71000.00 | 2023-04-12 |    1 | dev   | loc1 |
-- +----+---------+-------+-------+-----------+----------+------------+------+-------+------+
-- 1 row in set (0.00 sec)

-- mysql> select * from employee e left join dept d on d.id = e.dept_id where d.dname in ('Computer','IT') and (e.fname like 'p%' or e.fname like 'h%');
-- +----+---------+-------+-------+---------+----------+------------+------+----------+---------------+
-- | id | dept_id | fname | lname | pos     | salary   | joind      | id   | dname    | loc           |
-- +----+---------+-------+-------+---------+----------+------------+------+----------+---------------+
-- | 13 |       3 | Peter | Chang | Manager | 85000.00 | 2022-12-01 |    3 | Computer | Boston        |
-- | 12 |       4 | Helen | Smith | Admin   | 60000.00 | 2023-04-15 |    4 | IT       | San Francisco |
-- | 14 |       4 | Henry | Lee   | Support | 55000.00 | 2023-06-01 |    4 | IT       | San Francisco |
-- +----+---------+-------+-------+---------+----------+------------+------+----------+---------------+

--  SELECT COUNT(DISTINCT pos) AS distinct_positions
--     -> FROM employee;   
-- +--------------------+
-- | distinct_positions |
-- +--------------------+
-- |                 11 |
-- +--------------------+
-- 1 row in set (0.01 sec)


-- insert into employee values(15,4,'b','c','DevOps',1000000,'1975-01-01');
-- Query OK, 1 row affected (0.00 sec)

-- mysql> update employee
--     -> set salary = 1.1 * salary
--     -> where year(joind)<1985;
-- Query OK, 1 row affected (0.01 sec)
-- Rows matched: 1  Changed: 1  Warnings: 0
-- | 15 |       4 | b     | c      | DevOps        | 1100000.00 | 1975-01-01 |

-- delete from dept where loc ='loc1';
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`db`.`employee`, CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `dept` (`id`))
-- mysql> DELETE FROM employee WHERE dept_id IN (SELECT id FROM dept WHERE loc = 'loc1');
-- Query OK, 6 rows affected (0.00 sec)

-- mysql> delete from dept where loc ='loc1';
-- Query OK, 1 row affected (0.01 sec)
-- 

-- select * from project where ploc = 'ploc1';
-- +-----+---------+-------+-------+----------+------------+
-- | pid | dept_id | pname | ploc  | pcost    | pyear      |
-- +-----+---------+-------+-------+----------+------------+
-- |   1 |       3 | p1    | ploc1 | 10000.00 | 2026-03-04 |

-- select pname from project  where pcost between 100000 and 500000;
-- +-------+
-- | pname |
-- +-------+
-- | p2    |
-- | p3    |
-- +-------+

-- select * from project where pcost =  (select max(pcost) from project);
-- +-----+---------+-------+-------+-----------+------------+
-- | pid | dept_id | pname | ploc  | pcost     | pyear      |
-- +-----+---------+-------+-------+-----------+------------+
-- |   3 |       4 | p3    | ploc3 | 410000.00 | 2026-03-04 |
-- +-----+---------+-------+-------+-----------+------------+
-- 1 row in set (0.00 sec)

-- select avg(pcost) from project;
-- +---------------+
-- | avg(pcost)    |
-- +---------------+
-- | 210000.000000 |
-- +---------------+
-- 1 row in set (0.00 sec)

-- mysql> select id,concat(fname,' ',lname) as full_name from employee order by lname desc;
-- +----+-------------+
-- | id | full_name   |
-- +----+-------------+
-- |  5 | Mark Wilson |
-- |  4 | Lisa Taylor |
-- | 12 | Helen Smith |
-- | 10 | Alex Martin |
-- | 14 | Henry Lee   |
-- |  8 | Tom Hall    |
-- | 13 | Peter Chang |
-- | 15 | b c         |
-- +----+-------------+
-- 8 rows in set (0.00 sec)

select pname,ploc,pcost from project where year(pyear) in ('2005','2006','2004');
-- +-------+-------+-----------+
-- | pname | ploc  | pcost     |
-- +-------+-------+-----------+
-- | p4    | p4    |  10000.00 |
-- | p5    | p5loc | 100000.00 |
-- +-------+-------+-----------+
-- 2 rows in set (0.00 sec)




-- CREATE SEQUENCE emp_seq START WITH 16 INCREMENT BY 1;
-- INSERT INTO employee (id, fname) VALUES (emp_seq.NEXTVAL, 'John');   


--  create index idx1 on employee(fname);
-- Query OK, 0 rows affected (0.04 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

-- mysql> create unique index idx2 on employee(id);
-- Query OK, 0 rows affected (0.02 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

-- mysql> CREATE INDEX idx_name_dept ON employee(fname, dept_id);   
-- Query OK, 0 rows affected (0.03 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

-- mysql> CREATE FULLTEXT INDEX idx_pname ON project(pname);   
-- Query OK, 0 rows affected, 1 warning (0.12 sec)
-- Records: 0  Duplicates: 0  Warnings: 1

-- mysql> show index from employee;
-- +----------+------------+---------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
-- | Table    | Non_unique | Key_name      | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
-- +----------+------------+---------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
-- | employee |          0 | PRIMARY       |            1 | id          | A         |           8 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
-- | employee |          0 | idx2          |            1 | id          | A         |           8 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
-- | employee |          1 | dept_id       |            1 | dept_id     | A         |           3 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
-- | employee |          1 | idx1          |            1 | fname       | A         |           8 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
-- | employee |          1 | idx_name_dept |            1 | fname       | A         |           8 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
-- | employee |          1 | idx_name_dept |            2 | dept_id     | A         |           8 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
-- +----------+------------+---------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
-- 6 rows in set (0.01 sec)