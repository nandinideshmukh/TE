-- Demonstrate the use of Table, View, Index, Sequence, Synonym, different constraints on the following Schema
-- ● Student( s_id,Drive_id,T_id,s_name,CGPA,s_branch,S_dob)
-- ● PlacementDrive( Drive_id, Pcompany_name, package, location)
-- ● Training ( T_id,Tcompany_name,T_Fee,T_year) 
-- Note: Use referential integrity constraints while creating tables with on delete cascade options. 
-- Use the tables created in assignment no 2B and execute the following queries: 
-- 1. Insert at least 10 records in the Student table and insert other tables accordingly.
-- 2. Display all students details with branch ‘Computer ‘and ‘It’ and student name starting with ‘a' or 'd'. 
-- 3. Display Pcompany_name, S_name, location and Package with Package 30K, 40K and 50k 
-- 4. list the number of different companies. (use of distinct) 
-- 5. Give 15% increase in fee of the Training whose joining year is 2019.
-- 6. Delete Student details having CGPA score less than 7. 
-- 7. Find the names of companies belonging to Pune or Mumbai 
-- 8. Find the student’s name who joined training in 1-1-2019 as well as in 1-1-2021 
-- 9. Find the student’s name having maximum CGPA score and names of students having CGPA score between 7 to 9.
-- 10. Display all Student name with T_id with decreasing order of Fees11.
--  A2: Guidelines Synonyms not supported in MySQL. Required to include example from oracle in write-up or we can 
--  use Alice name for table name in query. Sequence should be implemented with AUTO_INCREMENT. Concept of sequence from oracle must be included in the write-up. 


create table placed(
    -> id int primary key auto_increment,
    -> name varchar(30) not null,
    -> pack decimal(8,0) not null,
    -> loc varchar(50) not null);
-- Query OK, 0 rows affected (0.01 sec)

mysql> create table train(
    -> tid int primary key ,
    -> tname varchar(30) not null,
    -> fee decimal(8,0) not null,
    -> tyear date not null);
-- Query OK, 0 rows affected (0.02 sec)

mysql> create table stud(
    -> sid int primary key,
    -> did int ,
    -> trid int,
    -> cgpa float,
    -> branch varchar(40) not null,
    -> dob date not null,
    name varchar(40) not null
    );
-- Query OK, 0 rows affected (0.02 s)

ALTER TABLE stud 
    -> ADD CONSTRAINT fk_placed 
    -> FOREIGN KEY (did) REFERENCES placed(id) 
    -> ON DELETE CASCADE 
    -> ON UPDATE CASCADE;   
-- Query OK, 0 rows affected (0.04 sec)

alter table stud
    -> add constraint fk_train
    -> foreign key (trid) references train(tid)
    -> on delete cascade
    -> on update cascade;

alter table stud
    -> add column name varchar(40) not null default 'a';
-- Query OK, 0 rows affected (0.02 sec)
-- Records: 0  Duplicates: 0  Warnings: 0

mysql> select * from stud  where branch in ('CSE','IT') and (name like 'a%' or name like 'd%');
-- +-----+------+------+------+--------+------------+------+
-- | sid | did  | trid | cgpa | branch | dob        | name |
-- +-----+------+------+------+--------+------------+------+
-- |   1 |    1 |  101 |  8.7 | CSE    | 2000-05-10 | a    |
-- |   2 |    2 |  102 |  8.5 | IT     | 2000-07-15 | a    |
-- |   3 |    3 |  103 |  8.9 | CSE    | 1999-09-20 | a    |
-- |   7 |    7 |  107 |  8.8 | CSE    | 1999-12-05 | a    |
-- |   8 |    8 |  108 |  8.2 | IT     | 2000-08-18 | a    |
-- |   9 |    9 |  109 |    9 | CSE    | 1999-06-22 | a    |
+-----+------+------+------+--------+------------+------

select count(distinct name) from placed;
-- +----------------------+
-- | count(distinct name) |
-- +----------------------+
-- |                    2 |
-- +----------------------+
-- 1 row in set (0.00 sec)

update train set fee = 1.15*fee where year(tyear) = 2019;
-- Query OK, 1 row affected (0.01 sec)
-- Rows matched: 1  Changed: 1  Warnings: 0

mysql> delete from stud where cgpa<7;


select name from placed where loc in ('Bangalore','Hyderabad');
-- +---------+
-- | name    |
-- +---------+
-- | TCS     |
-- | Infosys |
-- +---------+
-- 2 rows in set (0.00 sec)

mysql> select name from stud where cgpa = 
    -> (select max(cgpa) from stud);
-- +--------+
-- | name   |
-- +--------+
-- | Deepak |
-- +--------+
-- 1 row in set (0.00 sec)
mysql> select name,t.tid from stud s left join train t on s.trid = t.tid order by t.fee desc;
-- +--------+------+
-- | name   | tid  |
-- +--------+------+
-- | Deepak |  109 |
-- | Vijay  |  105 |
-- | Kavita |  110 |
-- | Neha   |  104 |
-- | Sneha  |  106 |
-- | Priya  |  102 |
-- | Rohit  |  107 |
-- | Anjali |  108 |
-- | Rahul  |  101 |
-- | Amit   |  103 |
-- +--------+------+
-- 10 rows in set (0.00 sec)


 select 
    ->     p.name AS Pcompany_name,
    ->     s.name AS S_name,
    ->     p.loc AS location,
    ->     p.pack AS Package
    -> from stud s
    -> join placed p ON s.did = p.id
    -> where p.pack IN (30000, 40000, 50000);   
-- Empty set (0.00 sec)

