# insert two students with null GPA
insert into Student values (432, 'Kevin', null, 1500);
insert into Student values (321, 'Lori', null, 2500);


select sID, sName, GPA
from Student
where GPA > 3.5;

select sID, sName, GPA
from Student
where GPA <= 3.5;

select sID, sName, GPA
from Student
where GPA > 3.5 or GPA <= 3.5 or GPA is null;


select sID, sName, GPA, sizeHS
from Student
where GPA > 3.5 or sizeHS < 1600 or sizeHS >= 1600; # return all of the student


select count(distinct GPA)
from Student; # not counting the null values

select distinct GPA
from Student;	# include the null value



