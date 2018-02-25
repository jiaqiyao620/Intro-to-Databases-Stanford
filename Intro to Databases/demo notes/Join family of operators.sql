# nature join
select distinct sName, major
from student, apply
where student.sID = apply.sID;

# inner join 
select distinct sName, major
from student inner join apply # inner 可有可没有
on student.sID = apply.sID;

select sName, GPA
from student, apply
where student.sID = apply.sID
	and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

# ============>
select sName, GPA
from student join apply
on student.sID = apply.sID
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford'; # 后半部分变成了where的条件， 也可以放到on后面



# Multiple join
select apply.sID, sName, GPA, apply.cName, enrollment
from apply, student, college
where apply.sID = student.sID and apply.cName = college.cName;

# 把 ，换成 join， where 换成 on
select apply.sID, sName, GPA, apply.cName, enrollment
from apply join student join college
on apply.sID = student.sID and apply.cName = college.cName;




# Different types of join
select distinct sName, major
from student inner join apply
on student.sID = apply.sID;

# 等价于
select distinct sName, major
from student natural join apply;

select * from student natural join apply; # 可以发现结果中只有一列sID， 因为natural join自动删掉了重复的sID col

select distinct sID from student natural join apply; # natural join 自动地 equating those columns
select distinct sID from student, apply; # 这个就不行，因为有两个sID， 导致ambiguity

select sName, GPA
from student natural join apply
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford'; 

# using
select sName, GPA
from student join apply using(sID)
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford'; 

# using join operator when there are more than one instance of same relation
select s1.sID, s1.sName, s1.GPA, s2.sID, s2.sName, s2.GPA
from student s1, student s2
where s1.GPA = s2.GPA and s1.sID < s2.sID;

select s1.sID, s1.sName, s1.GPA, s2.sID, s2.sName, s2.GPA
from student s1 join student s2 using(GPA) 
where s1.sID < s2.sID;

select * 
from student s1 natural join student s2;



# Outer join
select sName, sID, cName, major
from student inner join apply using(sID);

# student 中包含一些没有申请学校的学生， 把他们加入到结果中可以用 left join
select sName, sID, cName, major
from student left outer join apply using(sID);

# natural left outer join
select sName, sID, cName, major
from student natural left outer join apply; # same result

# 不用join的等价方法
select sName, student.sID, cName, major
from student, apply
where student.sID = Apply.sID
union
select sName, sID, null,null
from student
where sID not in (select sID from apply);

# keep all tuples in apply relation
# 加入两个student中没有的id
insert into apply values (321, 'MIT', 'history', 'N');
insert into apply values(321, 'MIT', 'psychology', 'Y');

select sName, sID, cName, major
from apply natural left outer join student;

# 实际上sql中有right outer join，所以并不需要把apply和student换位置就可以达到目的
select sName, sID, cName, major
from student natural right outer join apply;

# full outer join
select sName, sID, cName, major
from student full outer join apply using(sID);













