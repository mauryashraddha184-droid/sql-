create database studentdb;
use studentdb;

create table students(std_id int primary key,name varchar(50),email varchar(50),age int);
create table cousres(Course_id int primary key,course_name varchar(50),duration_months int);
create table enrollment(enroll_id int primary key,std_id int,course_id int,enroll_date date,foreign key (std_id) references students(std_id),foreign key (course_id) references cousres(course_id) );
insert into students values
(1,'amit','amit@gmail.com',21),
(2,'neha','neha@gmail.com',22),
(3,'rahul','rahul@gmail.com',20);

insert into cousres values
(101,'python',3),
(102,'sql',2),
(103,'web devlopment',4);

insert into enrollment values
(1,1,101,'2024-01-10'),
(2,1,102,'2024-01-15'),
(3,2,103,'2024-02-01'),
(4,3,101,'2024-02-05');

select * from students;
--student enrolled in courses
select s.name,c.course_name from students s 
join enrollment e on s.std_id=e.std_id
join cousres c on e.course_id=c.course_id;
--count student per cousre
select c.course_name ,count(e.std_id) as total_students from cousres c
left join enrollment e on c.course_id=e.course_id group by c.course_name;
--student enrolled in python
select s.name from students s join enrollment e on s.std_id=e.std_id
join cousres c on e.course_id=c.course_id 
where c.course_name='python';
--find student older than 21
select * from students where age>21;
--add unique constraint to email
alter table students add  constraint uq_students_email unique (email);
--inner join
select s.std_id,s.name,c.course_name from students s 
inner join enrollment e on s.std_id=e.std_id
inner join cousres c on e.course_id=c.course_id;
--right join 
select s.name,c.course_name from students s 
right join enrollment e on s.std_id=e.std_id 
right join  cousres c on e.course_id=c.course_id;
--group by +having clause
select c.course_name,count(e.std_id) as total_students from cousres c
join enrollment e on c.course_id=e.course_id
group by c.course_name;
--course with more than one students
select c.course_name ,count(*) as total_students from cousres c
join enrollment e on c.course_id=e.course_id
group by c.course_name
having count(*)>1;
--subqueries
--student enrolled in python course
select name from students
where std_id in(select std_id from enrollment where 
course_id =(select course_id from cousres where course_name='python'));
--student older than average age
select name,age from students where age>(select avg(age) from students);

