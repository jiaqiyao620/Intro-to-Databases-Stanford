# SQL Movie-Rating Modification Exercises

Q1.Add the reviewer Roger Ebert to your database, with an rID of 209.

```sql
insert into reviewer values (209, 'Roger Ebert');
insert into reviewer(rID, name) values (209, 'Roger Ebert');

```

Q2.Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.

```sql
select * 
from movie left outer join reviewer
on reviewer.name = 'James Cameron'; 

insert into rating(rID, mID, stars, ratingDate)
select reviewer.rID, movie.mID, 5, null from movie
left outer join reviewer
on reviewer.name = 'James Cameron';
```

Q3.For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)

```sql
select mID 
from rating
group by mID
having avg(stars) >= 4;
```
> *First, select movies with average rating of 4*
```sql
update movie
set year = year + 25
where mID in (select mID 
			from rating
			group by mID
			having avg(stars) >= 4);
```

Q4.Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.

```sql
delete from rating
where mID in (select mID from movie where year <1970 or year > 2000)
and stars < 4;
```

