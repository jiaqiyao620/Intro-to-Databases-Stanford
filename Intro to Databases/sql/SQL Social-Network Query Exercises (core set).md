# SQL Social-Network Query Exercises (core set)

Q1.Find the names of all students who are friends with someone named Gabriel.

```sql
select name
from highschooler
where ID in (
	select ID1
	from friend
	where ID2 in (
		select ID
		from highschooler
		where name = 'Gabriel'));
```

Q2.For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.

```sql
select hs1.name as name1, hs1.grade as grade1, hs2.name as name2, hs2.grade as grade2
from highschooler as hs1, highschooler as hs2, likes
where hs1.ID = likes.ID1 and hs2.ID = likes.ID2
	and hs1.grade - hs2.grade >= 2;
```

Q3.For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

```sql
select *
from likes as l1 join likes as l2 
where l1.ID2 = l2.ID1 and l1.ID1 = l2.ID2 and l1.ID1 <> l1.ID2;

# my version
select h2.name, h2.grade, h1.name, h1.grade
from (select l1.ID1, l1.ID2
	from likes as l1 join likes as l2 
	where l1.ID2 = l2.ID1 and l1.ID1 = l2.ID2 and l1.ID1 < l1.ID2) as M join highschooler as h1 join highschooler as h2
on h1.ID = M.ID1 and h2.ID = M.ID2 order by h2.name;

# answer
select h1.name, h1.grade, h2.name, h2.grade  
from Likes l1, Likes l2, Highschooler h1, Highschooler h2
where l1.ID1=l2.ID2 and l2.ID1=l1.ID2 and l1.ID1=h1.ID and l1.ID2=h2.ID and h1.name<h2.name;
```

Q4.Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.

```sql
select h1.ID ID1, h1.name name1, h1.grade grade1, h2.ID ID2, h2.name name2, h2.grade grade2
from friend f, highschooler h1, highschooler h2
where f.ID1 = h1.ID and f.ID2 = h2.ID;

select name1, grade1
from (select h1.ID ID1, h1.name name1, h1.grade grade1, h2.ID ID2, h2.name name2, h2.grade grade2
	from friend f, highschooler h1, highschooler h2
	where f.ID1 = h1.ID and f.ID2 = h2.ID) as M
group by name1, grade1
having count(distinct grade2) = 1 order by grade1, name1;
```

Q5.Find the name and grade of all students who are liked by more than one other student.

```sql
select name, grade
from highschooler
where ID in (
	select ID2
	from likes 
	group by ID2
	having count(*) > 1);
```
***
# Extra Practice
Q1. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
```sql
select ID1, ID2
from likes 
where ID2 in (
	select ID2 
	from likes
	where ID2 not in (select ID1 from likes));

select distinct name1, grade1, name2, grade2
from (select h1.ID ID1, h1.name name1, h1.grade grade1, h2.ID ID2, h2.name name2, h2.grade grade2
	from likes l, highschooler h1, highschooler h2
	where l.ID1 = h1.ID and l.ID2 = h2.ID) as M
where ID2 not in (select ID1 from likes);
```

Q2. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
```sql
select ID2 C
from likes
where ID1 in (select ID2 from likes)  ;
```
Q3. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
