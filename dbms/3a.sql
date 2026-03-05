-- Use table model of 2a 

-- -- 
-- 1. Find Employee details and Department details using NATURAL JOIN. 
-- 2. Find the emp_fname,Emp_position,location,Emp_JoinDate who have same Dept id. 
-- 3. Find the Employee details ,Proj_id,Project cost who does not have Project location as ‘Hyderabad’.
-- 4. Find Department Name ,employee name, Emp_position for which project year is 2020
-- 5. Display emp_position,D_name who have Project cost >30000
-- 6. Find the names of all the Projects that started in the year 2015.
-- 7. List the Dept_name having no_of_emp=10 
-- 8. Display the total number of employee who have joined any project before 2009
-- 9. Create a view showing the employee and Department details. 
-- 10. Perform Manipulation on simple view-Insert, update, delete, drop view. 

select * from employee e  join dept d;
+----+---------+-------+--------+---------------+------------+------------+----+----------+---------------+
| id | dept_id | fname | lname  | pos           | salary     | joind      | id | dname    | loc           |
+----+---------+-------+--------+---------------+------------+------------+----+----------+---------------+
|  4 |       2 | Lisa  | Taylor | Analyst       |   60000.00 | 2023-03-05 |  4 | IT       | San Francisco |
|  4 |       2 | Lisa  | Taylor | Analyst       |   60000.00 | 2023-03-05 |  3 | Computer | Boston        |
|  4 |       2 | Lisa  | Taylor | Analyst       |   60000.00 | 2023-03-05 |  2 | HR       | Los Angeles   |
|  5 |       2 | Mark  | Wilson | Manager       |   80000.00 | 2022-12-01 |  4 | IT       | San Francisco |
|  5 |       2 | Mark  | Wilson | Manager       |   80000.00 | 2022-12-01 |  3 | Computer | Boston        |
|  5 |       2 | Mark  | Wilson | Manager       |   80000.00 | 2022-12-01 |  2 | HR       | Los Angeles   |
|  8 |       2 | Tom   | Hall   | HR Specialist |   58000.00 | 2023-06-01 |  4 | IT       | San Francisco |
|  8 |       2 | Tom   | Hall   | HR Specialist |   58000.00 | 2023-06-01 |  3 | Computer | Boston        |
|  8 |       2 | Tom   | Hall   | HR Specialist |   58000.00 | 2023-06-01 |  2 | HR       | Los Angeles   |
| 10 |       2 | Alex  | Martin | Recruiter     |   62000.00 | 2023-08-30 |  4 | IT       | San Francisco |
| 10 |       2 | Alex  | Martin | Recruiter     |   62000.00 | 2023-08-30 |  3 | Computer | Boston        |
| 10 |       2 | Alex  | Martin | Recruiter     |   62000.00 | 2023-08-30 |  2 | HR       | Los Angeles   |
| 12 |       4 | Helen | Smith  | Admin         |   60000.00 | 2023-04-15 |  4 | IT       | San Francisco |
| 12 |       4 | Helen | Smith  | Admin         |   60000.00 | 2023-04-15 |  3 | Computer | Boston        |
| 12 |       4 | Helen | Smith  | Admin         |   60000.00 | 2023-04-15 |  2 | HR       | Los Angeles   |
| 13 |       3 | Peter | Chang  | Manager       |   85000.00 | 2022-12-01 |  4 | IT       | San Francisco |
| 13 |       3 | Peter | Chang  | Manager       |   85000.00 | 2022-12-01 |  3 | Computer | Boston        |
| 13 |       3 | Peter | Chang  | Manager       |   85000.00 | 2022-12-01 |  2 | HR       | Los Angeles   |
| 14 |       4 | Henry | Lee    | Support       |   55000.00 | 2023-06-01 |  4 | IT       | San Francisco |
| 14 |       4 | Henry | Lee    | Support       |   55000.00 | 2023-06-01 |  3 | Computer | Boston        |
| 14 |       4 | Henry | Lee    | Support       |   55000.00 | 2023-06-01 |  2 | HR       | Los Angeles   |
| 15 |       4 | b     | c      | DevOps        | 1100000.00 | 1975-01-01 |  4 | IT       | San Francisco |
| 15 |       4 | b     | c      | DevOps        | 1100000.00 | 1975-01-01 |  3 | Computer | Boston        |
| 15 |       4 | b     | c      | DevOps        | 1100000.00 | 1975-01-01 |  2 | HR       | Los Angeles   |
+----+---------+-------+--------+---------------+------------+------------+----+----------+---------------+
-- 24 rows in set (0.00 sec)

mysql> select fname,pos,joind, d.loc,dept_id from employee e left join dept d on d.id = e.dept_id ;


select lname , p.dept_id,ploc,pcost,pname from project p left join  employee e on e.dept_id =
p.dept_id where ploc not in ('Hyderabad');

mysql> select dname,e.fname,e.pos from employee e left join dept d on d.id = e.dept_id join project p on p.dept_id = e.dept_id where year(p.pyear)=2020;


select pos,e.fname from employee e left join project p  on p.dept_id = e.dept_id where p.pcost
 > 30000;

mysql> select pname from project p
    -> where year(pyear) = 2015;

select dname from dept d
join employee e
on d.id = e.dept_id
group by d.id,d.dname
having count(e.id)=10;


SELECT COUNT(*) AS total_employees
FROM employee
WHERE joind < '2009-01-01';   

create view unionview AS
select e.fname, e.lname, e.pos, e.joind, d.dname, d.loc
from employee e
join dept d ON e.dept_id = d.id;   

mysql> DROP VIEW unionview;
