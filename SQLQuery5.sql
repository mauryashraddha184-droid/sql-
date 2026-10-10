
create table student(student_id int primary key,name varchar(40),age int,gender varchar(10),city varchar(40));

create table courses(course_id int primary key,course_name varchar(40),duration_months int,fee decimal);

create table enrollment(enroll_id int primary key,student_id int,course_id int,enroll_date int,
foreign key(student_id)references student(student_id),
foreign key (course_id)references courses(course_id));
drop table enrollment;

insert into student values
(101,'shraddha',19,'female','ayodhya'),
(102,'shagufta',19,'female','bihar'),
(103,'sarika',19,'female','gopalganj'),
(104,'ansh',21,'male','ayodhya'),
(105,'soniya',23,'female','sultanpur');
select * from student;

insert into courses values
(213,'operating system',2,30000),
(216,'java',1,20000),
(210,'software devlopment',3,35000),
(225,'fullstack',2,30000);

insert into enrollment values
(1,101,216,12-02-2025),
(2,104,225,10-01-2025),
(3,102,210,1-03-2025),
(4,103,213,2-03-2025),
(5,101,225,7-04-2025);

--display all students
select student_id,name from student;
--display student from specific city
select student_id ,name from student where city='ayodhya';
--show all courses fee greater than 20000
select course_id couse_name fee from courses where fee>20000;
--display students older than 20 years
select name age from student where age>20;
--course name with total enrollment id
select course_name ,