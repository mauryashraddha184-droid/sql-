create DATABASE college_db;

create table students(id int,name varchar(50),age int,city varchar(30),marks int);
 

INSERT INTO students VALUES
(1,'Aman',20,'Delhi',82),
(2,'Priya',21,'Mumbai',91),
(3,'Karan',19,'Pune',74),
(4,'Neha',22,'Delhi',68),
(5,'Arjun',21,'Jaipur',95),
(6,'simran',23,'Delhi',88),
(7,'Rohit',20,'Mumbai',59),
(8,'Riya',22,'Pune',76),
(9,'Vikas',19,'Jaipur',64),
(1,'Anjali',20,'Delhi',90);

select * from students;

SELECT name,city,marks
FROM students;

SELECT * FROM students
WHERE marks>75;


SELECT * FROM students
WHERE city='Delhi';

SELECT * FROM students
WHERE marks BETWEEN 60 AND 85;

UPDATE students 
SET city='Delhi'
WHERE id=7;

ALTER TABLE students
ADD  email varchar(100);

ALTER TABLE students
ALTER COLUMN marks DECIMAL(5,2);

EXEC sp_rename 'students.city', 'location',
'column';

SELECT COUNT(*) FROM students;

SELECT SUM(marks) FROM students;

SELECT MAX(marks) FROM students;

SELECT MIN( marks) FROM students;

SELECT AVG(marks) FROM students;

SELECT TOP 5 * FROM students;

SELECT * FROM students ORDER BY ID OFFSET 5 ROWS 
FETCH NEXT 5 ROWS ONLY;

SELECT TOP 5 * FROM
students Order By marks;

SELECT * FROM(SELECT TOP 5 *
FROM
students ORDER BY
id desc )
as last5
order by id asc;

DELETE FROM students
WHERE id=9;

SELECT * FROM students;

TRUNCATE TABLE students;

DROP TABLE STUDENTS;

USE MASTER ;
GO

ALTER DATABASE college_db
set single_user
with rollback immediate ;
go

drop database college_db;