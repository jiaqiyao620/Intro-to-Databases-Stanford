############# Table Variable and Set Operators ####################################
select S.sID, sName, GPA, A.cName, enrollment
from Student S, College C, Apply A	# more readable
where A.sID = S.sID and A.cName = C.cName;

# find students that have same GPA
select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID < S2.sID;

# Set Operators
select cName as name from College # union in sql eliminate duplicate by sorting the result when execute union
union all # keep the dups
select sName as name from Student
order by name;


select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major = 'EE';

select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major <> 'EE';