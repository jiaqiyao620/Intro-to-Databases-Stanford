
select distinct sName, major, GPA
from Student, Apply
where Student.sID = Apply.sID;

select distinct sName, GPA, decision 
from Student, Apply
where Student.sID = Apply.sID and 
major = 'CS' and cName = 'Stanford' and sizeHS < 1000;

select distinct College.cName 
from College, Apply
where College.cName = Apply.cName
 and enrollment > 20000 and major = 'CS';
    
select distinct Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Student.sID = Apply.sID and Apply.cName = College.cName
order by GPA desc, enrollment;
    
# like predicate
select sID, major 
from Apply
where major like '%bio%';
    
    
select * 
from Apply
where major like '%bio%';
        
 # arithmetic and 'as' feature
 select sID, sName, GPA, sizeHS, GPA*(sizeHS/1000.0) as 'boost' # adds an attribute
 from Student;
    

