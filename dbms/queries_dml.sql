-- SQL Queries
-- a. Design and Develop SQLDDL statements which
-- demonstrate the use of SQL objects such as Table,
-- View, Index, Sequence, Synonym, different
-- constraints etc.
-- b. Write at least 10 SQL queries on the suitable
-- database application using SQL DML statements


-- table
create table if not exists chat_messages(
    id int primary key,
    name varchar(50) not null,
    receiver_id int not null,
    message varchar(255) not null,
    constraint name_len check (length(name) <= 50)
);

-- view
create view chat_view as
select name,receiver_id, message from chat;

-- index
create index sender_index on chat(id);

insert into chat_messages values(1, 'a', 4, 'heyy');
insert into chat_messages values(2, 'b', 8, 'how is dbms going');
insert into chat_messages values(3, 'c', 2, 'how are you?');
insert into chat_messages values(5, 'a', 2, 'is it working?');
insert into chat_messages values(6, 'a', 7, 'yes it works');
insert into chat_messages values(7, 'e', 8, 'letsgoo');
insert into chat_messages values(8, 'a', 2, 'heyy');
insert into chat_messages values(9, 'b', 10, 'do you attend lectures ?');
insert into chat_messages values(10, 'c', 2, 'attendance kiti aheeee');

-- sequence
-- create sequence chat_id_seq start with 2 increment by 1;
-- synonym mysql does support 
-- create synonym chat for chat_messages;

-- 10 queries

-- basic
select * from chat_messages where name = 'a';
update  chat_messages set message = 'hello' where id = 1;
delete from chat_messages where id = 2;
alter table chat_messages add column timestamp datetime default current_timestamp;


select receiver_id,count(*) as msgs
from chat_messages
group by receiver_id
order by msgs desc 
limit 1;

select name as "Name", count(*) as "Messages Sent"
from chat_messages
group by name
order by "Messages Sent" desc;

delete from chat_messages where datediff(now(),timestamp) > 15;

-- min max avg 
select min(timestamp) as "Oldest Message", max(timestamp) as "Newest Message" from chat_messages;
select avg(length(message)) as "Average Message Length" from chat_messages;

-- <> null

alter table chat_messages
modify message varchar(500);

select * from chat_messages where length(message)=0;
