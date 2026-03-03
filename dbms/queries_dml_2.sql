-- SQL Queries all types of Join, Sub-Query and View:
-- Write at least10 SQL queries for suitable database
-- application using SQL DML statements


create table if not exists customer(
    id int primary key auto_increment ,
    name varchar(50) not null,
    email varchar(50) not null,
    phone varchar(20) not null
);

create table if not exists orders(
    id int primary key auto_increment ,
    customer_id int,
    order_date date not null,
    amount decimal(10,2) not null,
    FOREIGN KEY (customer_id) REFERENCES customer(id) on delete cascade 
);

insert into customer values(1,'a','a@example.com','1234567890');
insert into customer values(3,'b','b@example.com','0987654321');
insert into customer values(2,'c','c@example.com','1122334455');
insert into customer values(4,'d','d@example.com','5566778899');

insert into orders values(1,1,'2023-01-01',100.00);
insert into orders values(2,1,'2023-01-02',150.00);
insert into orders values(3,2,'2023-01-03',200.00);
insert into orders values(4,3,'2023-01-04',250.00);
insert into orders values(5,3,'2023-01-05',300.00);
insert into orders values(6,4,'2023-01-06',350.00);

-- failing due to foreign key constraint
insert  into orders values(7,6,'2023-01-07',400.00);

-- joins

-- inner join
select name,email,c.id,phone,order_date,amount from customer c inner join orders o on o.customer_id = c.id;
-- +------+---------------+----+------------+------------+--------+
-- | name | email         | id | phone      | order_date | amount |
-- +------+---------------+----+------------+------------+--------+
-- | a    | a@example.com |  1 | 1234567890 | 2023-01-01 | 100.00 |
-- | a    | a@example.com |  1 | 1234567890 | 2023-01-02 | 150.00 |
-- | c    | c@example.com |  2 | 1122334455 | 2023-01-03 | 200.00 |
-- | b    | b@example.com |  3 | 0987654321 | 2023-01-04 | 250.00 |
-- | b    | b@example.com |  3 | 0987654321 | 2023-01-05 | 300.00 |
-- +------+---------------+----+------------+------------+--------+


-- left join
select * from customer c left join orders o on o.customer_id = c.id;
-- +----+------+---------------+------------+------+-------------+------------+--------+
-- | id | name | email         | phone      | id   | customer_id | order_date | amount |
-- +----+------+---------------+------------+------+-------------+------------+--------+
-- |  1 | a    | a@example.com | 1234567890 |    1 |           1 | 2023-01-01 | 100.00 |
-- |  1 | a    | a@example.com | 1234567890 |    2 |           1 | 2023-01-02 | 150.00 |
-- |  2 | c    | c@example.com | 1122334455 |    3 |           2 | 2023-01-03 | 200.00 |
-- |  3 | b    | b@example.com | 0987654321 |    4 |           3 | 2023-01-04 | 250.00 |
-- |  3 | b    | b@example.com | 0987654321 |    5 |           3 | 2023-01-05 | 300.00 |
-- |  4 | d    | d@example.com | 5566778899 | NULL |        NULL | NULL       |   NULL |
-- +----+------+---------------+------------+------+-------------+------------+--------+
-- 6 rows in set (0.00 sec)


-- union , union all , intersect and except

select name from customer where id > 3
union
select name from customer where id < 2;

-- union all
insert into customer values(5,'a','a@example.com','1122334455');
select name from customer where id > 3
union all
select name from customer where id < 2;


-- select name from customer where id > 3 union all select name from customer where id < 2;
-- +------+
-- | name |
-- +------+
-- | d    |
-- | a    |
-- | a    |
-- +------+
-- 3 rows in set (0.00 sec)

-- mysql> select name from customer where id > 3
--     -> union
--     -> select name from customer where id < 2;
-- +------+
-- | name |
-- +------+
-- | d    |
-- | a    |
-- +------+
-- 2 rows in set (0.00 sec)


select name from customer where id > 3
intersect
select name from customer where id < 2;


-- +----+------+---------------+------------+
-- | id | name | email         | phone      |
-- +----+------+---------------+------------+
-- |  1 | a    | a@example.com | 1234567890 |
-- |  2 | c    | c@example.com | 1122334455 |
-- |  3 | b    | b@example.com | 0987654321 |
-- |  4 | d    | d@example.com | 5566778899 |
-- |  5 | a    | a@example.com | 1122334455 |
-- +----+------+---------------+------------+

-- select name with highest number of orders
SELECT c.name
FROM customer c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
ORDER BY COUNT(o.id) DESC
LIMIT 1;   

-- count number of orders per name
select c.name,count(*)
from customer c
join orders o on c.id = o.customer_id
group by c.id , c.name;


update customer set name = 'abc' where name = 'a';
