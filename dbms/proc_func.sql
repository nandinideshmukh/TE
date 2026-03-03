-- Named PL/SQL Block: PL/SQL Stored Procedure and 
-- Stored Function. 
-- Write a Stored Procedure namely proc_Grade for the 
-- categorization of student. If marks scored by students in 
-- examination is <=1500 and marks>=990 then student will 
-- be placed in distinction category if marks scored are 
-- between 989 and900 category is first class, if 
-- marks899and 825 category is Higher Second Class. 
-- Write a PL/SQLblock to use procedure created with 
-- above requirement.  
-- Stud_Marks(name, total_marks)      
-- Result(Roll,Name, Class) 


create table if not exists stud_marks(
    id int PRIMARY key,
    name VARCHAR(60) NOT NULL,
    marks int not NULL,
);

CREATE TABLE Result(
    id INT PRIMARY key,
    name VARCHAR(100),
    class VARCHAR(45),
    FOREIGN KEY(id) REFERENCES stud_Marks(id) ON DELETE CASCADE ON UPDATE CASCADE
    );


CREATE PROCEDURE proc_grade_(IN p_rollno INT, IN p_marks INT)
BEGIN     
    DECLARE student VARCHAR(100);    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        SELECT 'ENTRY NOT FOUND' AS EXCEPTION;

    IF NOT EXISTS (
        SELECT 1 FROM stud_marks WHERE id = p_rollno AND marks = p_marks
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching record found';
    END IF;

    SELECT name INTO student FROM stud_marks 
    WHERE id = p_rollno AND marks = p_marks;

    IF (p_marks >= 990 AND p_marks <= 1500) THEN
        INSERT INTO Result VALUES(p_rollno, student, 'Distinction');     
    ELSEIF (p_marks >= 900 AND p_marks <= 989) THEN         
        INSERT INTO Result VALUES(p_rollno, student, 'First Class');     
    ELSEIF (p_marks >= 825 AND p_marks <= 899) THEN             
        INSERT INTO Result VALUES(p_rollno, student, 'Higher Second Class');     
    ELSE         
        INSERT INTO Result VALUES(p_rollno, student, NULL);     
    END IF;      

    SELECT * FROM Result; 
END/


DELIMITER ;


-- select * from stud_marks;
-- +----+------+-------+
-- | id | name | marks |
-- +----+------+-------+
-- |  1 | abc  |    80 |
-- |  2 | bcd  |    90 |
-- |  4 | d    |   990 |
-- +----+------+-------+
-- 3 rows in set (0.00 sec)

-- mysql> CALL proc_grade_(4, 990);
-- +----+------+-------------+
-- | id | name | class       |
-- +----+------+-------------+
-- |  1 | abc  | NULL        |
-- |  2 | bcd  | NULL        |
-- |  4 | d    | Distinction |
-- +----+------+-------------+
-- 3 rows in set (0.01 sec)


-- Function


CREATE fucntion get_grade_class(marks INT) 
    -> returns VARCHAR(50) 
    -> deterministic
    -> begin
    ->     IF (marks >= 990 AND marks <= 1500) THEN
    ->         RETURN 'Distinction';
    ->     ELSEIF (marks >= 900 AND marks <= 989) THEN
    ->         RETURN 'First Class';
    ->     ELSEIF (marks >= 825 AND marks <= 899) THEN
    ->         RETURN 'Higher Second Class';
    ->     ELSE
    ->         RETURN NULL;
    ->     END IF;
    -> END/


DELIMITER ;   
mysql> SELECT id, name, get_grade_class(marks) AS class FROM stud_marks;   
-- +----+------+-------------+
-- | id | name | class       |
-- +----+------+-------------+
-- |  1 | abc  | NULL        |
-- |  2 | bcd  | NULL        |
-- |  4 | d    | Distinction |
-- +----+------+-------------+
-- 3 rows in set (0.00 sec)

-- mysql> select * from stud_marks;
-- +----+------+-------+
-- | id | name | marks |
-- +----+------+-------+
-- |  1 | abc  |    80 |
-- |  2 | bcd  |    90 |
-- |  4 | d    |   990 |
-- +----+------+-------+
-- 3 rows in set (0.00 sec)
