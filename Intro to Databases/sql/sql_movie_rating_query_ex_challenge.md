# SQL Movie-Rating Query Exercises (challenge-level)

Q1.For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
```sql
select name, title, stars
from (reviewer join rating using(rID)) join movie using(mID)
where stars in (select min(stars) from rating);
```

Q2.Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)


```sql
select title, year, avg(stars) as average
from movie join rating using(mID)
group by title, year, mID;
```
first try to compute average ratings of the movies
```sql
select avg(average1) - avg(average2)
from (select title, year, avg(stars) as average1
from movie join rating using(mID)
group by title, year, mID) Y1, (select title, year, avg(stars) as average2
from movie join rating using(mID)
group by title, year, mID) Y2
where Y1.year > 1980 and Y2.year < 1988;
```

Q3.Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
```sql
select director, title
from movie
where director in 
(select director
from movie
group by director
having count(title) > 1) order by director, title;
```

Q4.Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)
```sql
select title, avg(stars) as average
from movie join rating using(mID)
group by title, mID
having average >= all (select avg(stars) from movie join rating using(mID) group by title, mID);

select title, av
from (select title, avg(stars) as av 
      from rating join movie using(mid) 
      group by mid) a
where av in (select max(av) 
             from (select title, avg(stars) as av 
                   from rating join movie using(mid) 
                   group by mid));

```

Q5.Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)
```sql
select title, avg(stars) as average
from movie join rating using(mID)
group by title, mID
having average <= all (select avg(stars) from movie join rating using(mID) group by title, mID);

```

Q6.For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
```sql
select director, title, avg(stars) as average
from movie m, rating r
where m.mid = r.mid and director is not null
group by director, title 
order by average desc;
```

