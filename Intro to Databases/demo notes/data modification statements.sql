insert into College values ('Carnegie Mellon', 'PA', 11500); # add a new college to database
####################################################################
####### 把所有没有申请学校的学生的申请专业和学校改为 CS 和 CMU #############
####################################################################

# 首先找到这些学生
select * 
from Student
where sID not in (select sID from Apply); 

# 根据以上query， 改写成可以插入到Apply relation中的tuple
# Apply relation 由 sID， cName， major 和decision 构成
select sID, 'Carnegie Mellon', 'CS', null
from Student
where sID not in (select sID from Apply);

# 再把以上query 插入到Apply中
insert into Apply
select sID, 'Carnegie Mellon', 'CS', null
from Student
where sID not in (select sID from Apply);

####################################################################
# Admit to CMU EE all students who were turned down in EE elsewhere#
####################################################################

# 首先检查一下那些申请EE但是被拒绝的学生--（一共有两位）
select * 
from Student
where sID in (select sID from Apply where major = 'EE' and decision = 'N');

# 再构建可以插入到Apply中的tupel
# 需要： sID， 申请CMU， 专业是EE， decision是Y
insert into Apply
select sID, 'Carnegie Mellon', 'EE', 'Y'
from Student
where sID in (select sID from Apply where major = 'EE' and decision = 'N');


#####################################################################
# delete all students who applied to more than two different majors #
#####################################################################

# 首先根据学生sID分类，统计每个学生申请专业的数量
select sID, count(distinct major)
from Apply
group by sID
having count(distinct major) > 2;

# 再从student中把这些删除, 但有些db system并不支持
# delete from a table where...
delete from Student
where sID in 	# 把后半部分变成subquery
(select sID
from Apply
group by sID
having count(distinct major) > 2);
# 但以上只是把他们从student relation中删除，并未把他们从Apply relation中删除
delete from Apply
where sID in 
(select sID
from Apply
group by sID
having count(distinct major) > 2);
# to create a temporary table, put in the results of this sub-query and then delete
# from apply, where the student ID is present, in that temporary table.

#########################################
# delete colleges with no CS applicants #
#########################################

select *
from College
where cName not in (select cName from Apply where major = 'CS');

delete from College 
where cName not in (select cName from Apply where major = 'EE');

# UPDATE

############################################################################################
# Accept applicants to Carnegie Mellon with GPA < 3.6 but turn them into economics majors ##
############################################################################################

select * from Apply
where cName = 'Carnegie Mellon'
	and sID in (select sID from Student where GPA < 3.6);
    
# change select to update
# update every tuple that satisfies the conditon
update Apply
set decision = 'Y', major = 'economics'
where cName = 'Carnegie Mellon'
	and sID in (select sID from Student where GPA < 3.6);

##########################################################
# Turn the highest-GPA EE applicant into a CSE applicant #
##########################################################

select * from Apply
where major = 'EE'
	and sID in 
		(select sID from Student	# 选出这个学生sID
        where GPA >= all	# 从这些学生的GPA中选出GPA最大的
			(select GPA from Student	# 再选出这些申请EE学生的GPA
            where sID in (select sID from Apply where major = 'EE')));	# 先找所有申请EE的sID


update Apply 
set major = 'CSE'
where major = 'EE'
	and sID in 
		(select sID from Student	
        where GPA >= all	
			(select GPA from Student	
            where sID in (select sID from Apply where major = 'EE')));

update Student
set GPA = (select max(GPA) from Student),
	sizeHS = (select min(sizeHS) from Student);
    
update Apply
set decision = 'Y';









