# SQL Movie-Rating Query Exercises (core set)

Q1.Find the titles of all movies directed by Steven Spielberg.

```sql
select title
from movie
where director = 'Steven Spielberg';
```

Q2.Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

```sql
select distinct year
from movie join rating using(mID)
where stars >= 4 order by year;
```

Q3.Find the titles of all movies that have no ratings.

```sql
select title
from movie
where mID not in (select mID from rating);
```

Q4.Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

```sql
select name
from reviewer
where rID in (select rID from rating where ratingDate is null);
```

Q5.Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

```sql
select name, title, stars, ratingDate
from reviewer, movie, rating
where reviewer.rID = rating.rID and movie.mID = rating.mID order by name, title, stars;
```

Q6.For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

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

Q7.For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

```sql
select title, max(stars)
from movie join rating using(mID)
group by title;
```

Q8.List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.

```sql
select title, avg(stars)
from movie join rating using(mID)
group by title order by avg(stars) desc, title;
```

Q9.Find the names of all reviewers who have contributed three or more ratings.

```sql
select name
from rating join reviewer using(rID)
group by name
having count(mID) >= 3;
```
***
Extra Practice

Q1. Find the names of all reviewers who rated Gone with the Wind. 

```sql
select distinct name
from reviewer join rating using(rID)
where rID in (select rID from rating join movie using(mID) where title = 'Gone with the Wind');
```
Q2 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.  

```sql
select name, title, stars
from reviewer join rating join movie
on reviewer.rID = rating.rID and movie.mID = rating.mID
where name = director;
```
Q3.Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine.) 
```sql
select name from reviewer
union
select title from movie order by name;
```

Q4 Find the titles of all movies not reviewed by Chris Jackson. 
```sql
select title 
from movie
where mID not in (select mID from reviewer natural join rating where name = 'Chris Jackson');
```

Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
```sql
SELECT DISTINCT Re1.name, Re2.name
FROM Rating R1, Rating R2, Reviewer Re1, Reviewer Re2
WHERE R1.mID = R2.mID
AND R1.rID = Re1.rID
AND R2.rID = Re2.rID
AND Re1.name < Re2.name
ORDER BY Re1.name, Re2.name;
```

Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
```sql
select name, title, stars
from (reviewer join rating using(rID)) join movie using(mID)
where stars in (select min(stars) from rating);
```
