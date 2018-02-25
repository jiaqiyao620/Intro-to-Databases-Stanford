# SQL Movie-Rating Query Exercises (core set)

Find the titles of all movies directed by Steven Spielberg.

```sql
select title
from movie
where director = 'Steven Spielberg';
```

Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

```sql
select distinct year
from movie join rating using(mID)
where stars >= 4 order by year;
```

Find the titles of all movies that have no ratings.

```sql
select title
from movie
where mID not in (select mID from rating);
```

Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

```sql
select name
from reviewer
where rID in (select rID from rating where ratingDate is null);
```

Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

```sql
select name, title, stars, ratingDate
from reviewer, movie, rating
where reviewer.rID = rating.rID and movie.mID = rating.mID order by name, title, stars;
```

For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

```sql
select Reviewer.name, Movie.title
from Reviewer, Movie, (select R1.rID, R1.mID from Rating R1, Rating R2 where R1.rID=R2.rID and R1.mID=R2.mID and R2.ratingDate>R1.ratingDate and R2.stars>R1.stars) as T
where Reviewer.rID=T.rID and Movie.mID=T.mID;

select name, title 
from Reviewer, Movie, Rating, Rating r2
where Rating.mID=Movie.mID and Reviewer.rID=Rating.rID 
  and Rating.rID = r2.rID and r2.mID = Movie.mID
  and Rating.stars < r2.stars and Rating.ratingDate < r2.ratingDate;
  
SELECT name, title
FROM Movie
INNER JOIN Rating R1 USING(mId)
INNER JOIN Rating R2 USING(rId, mId)
INNER JOIN Reviewer USING(rId)
WHERE R1.ratingDate < R2.ratingDate AND R1.stars < R2.stars;
```

For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

```sql
select title, max(stars)
from movie join rating using(mID)
group by title;
```

List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.

```sql
select title, avg(stars)
from movie join rating using(mID)
group by title order by avg(stars) desc, title;
```

Find the names of all reviewers who have contributed three or more ratings.

```sql
select name
from rating join reviewer using(rID)
group by name
having count(mID) >= 3;
```
