# students whoes scaled GPA changed by more than 1.0
# 注意到GPA*(sizeHS/1000.0) 重复了三遍
select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student
where GPA*(sizeHS/1000.0) - GPA > 1.0
or GPA - GPA*(sizeHS/1000.0) > 1.0;

# 可以使用abs()
select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student
where abs(GPA*(sizeHS/1000.0) - GPA) > 1.0;

# compute the select from where expression and call the result G
select *
from (select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student) G
where abs(G.scaledGPA - GPA) > 1.0;


# use subquery in select clause
# 目标 colleges paired with the highest GPA of their applicants
# 每个学校对应其申请者里最高的GPA
select distinct College.cName, state, GPA
from College, Apply, Student
where College.cName = Apply.cName
	and Apply.sID = Student.sID
	and GPA >= all
		(select GPA from Student, Apply
        where Student.sID = Apply.sID
        and Apply.cName = College.cName);

select cName, state,
(select distinct GPA	# 括号中只计算每个学校最大的GPA
from Apply, Student
where College.cName = Apply.cName
	and Apply.sID = Student.sID
	and GPA >= all
		(select GPA from Student, Apply
        where Student.sID = Apply.sID
        and Apply.cName = College.cName)) as GPA
from College;


# pair the college name with the name of the applicant with the highest GPA
select cName, state,
(select distinct sName
from Apply, Student
where College.cName = Apply.cName
	and Apply.sID = Student.sID) as sName	
from College;

# 结果中报错的原因是之前选择最高的gpa只有一个数值，但是gpa最高的申请人却有可能有很多， 所以系统并不知道要把哪个放到tuple中













