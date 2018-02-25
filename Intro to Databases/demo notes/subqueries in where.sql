################### subqueries in Where ######################
# ID's and names of all students who have applied to major in CS to some college.
select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS');

select distinct Student.sID,  sName # 因为有的学生申请了两个学校的CS，所以结果中会有重复，加入distinct可以去除dups
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

select sName
from Student
where sID in (select sID from Apply where major = 'CS');

# use join instead of subquery in where clause
select sName # 结果中会有重复，但如果用distinct，结果中同名但不同id的学生会被过滤掉
from Student, Apply
where Student.sID = Apply.sID and Apply.major = 'CS';

# 关于duplicate的重要性， 因为计算平均分时需要考虑所有的GPA
# the only to get CORRECT DUPLICATES is to use SUBQUERIES in where clause
select GPA
from Student
where sID in (select sID from Apply where major = 'CS');

select distinct GPA 
from Student, Apply
where Student.sID = Apply.sID and Apply.major = 'CS';

# Students who have applied to major in CS but have not applied to major in EE
select sName, sID
from Student
where sID in (select sID from Apply where major = 'CS')
and sID not in (select sID from Apply where major = 'EE'); # not 也可以放在sID前

# use EXIST to check whether a subquery is empty
# correlated reference
select cName, state
from College C1
where exists (select * from College C2 where C2.state = C1.state and C1.cName <> C2.cName);

# college with highest enrollment
select cName
from College C1
where not exists (select * from College C2
				  where C2.enrollment > C1.enrollment);

# Student with highest GPA
select sName, GPA
from Student s1
where not exists (select * from Student s2
				  where s2.GPA > s1.GPA);

# without subquery does not work by using join
select s1.sName, s1.GPA
from Student s1, Student s2
where s1.GPA > s2.GPA;

# another construct 'ALL'
# ALL ---- for checking whether a value has relationship with all of the result of a subquery
select sName, GPA 
from Student
where GPA >= all (select GPA from Student);

# 下面这个只有在所有学生的GPA都是unique的情况下才有用
select sName
from Student s1
where GPA > all (select GPA from Student s2
				 where s2.sID <> s1.sID);
                 
# get the college with highest enrollment
# 因为从数据中可以看出， 每个学校的enrollment都不相同
select cName, enrollment
from College c1
where enrollment > all (select enrollment from College c2
						where c2.cName <> c1.cName);

# any
# satisfy with at least one element of the set
# not exp any 相当于 反(exp) all
# 如果把 <= 换成 > 那么就换选择enrollment最小的学校
select cName, enrollment
from College c1
where not enrollment <= any (select enrollment from College c2
						where c2.cName <> c1.cName);
                        
                        
# students not from the smallest high school
select sName, sID, sizeHS
from Student
where  sizeHS > any (select sizeHS from Student);

# written without ANY
select sID, sName, sizeHS
from Student s1
where exists (select * from Student s2
			  where s2.sizeHS < s1.sizeHS);
              
select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
and sID <> any (select sID from Apply where major = 'EE'); 
# second condition is satisfied as long as there's anybody who applied to EE that's not equal to the student we're looking for        
# 所以第二个condition并没有多余的限制能力    

select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
and not sID = any (select sID from Apply where major = 'EE'); 


select sID
from Student
where not sID = any (select sID from Apply where major = 'EE') ;