USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM director_mapping;
-- Total number of rows in director_mapping = 3867

SELECT COUNT(*) FROM genre;
-- Total number of rows in genre = 14662

SELECT COUNT(*) FROM  movie;
-- Total number of rows in movie = 7997

SELECT COUNT(*) FROM names;
-- Total number of rows in names = 25735

SELECT COUNT(*) FROM  ratings;
-- Total number of rows in ratings = 7997

SELECT COUNT(*) FROM  role_mapping;
-- Total number of rows in role_mapping = 15615




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_COUNT,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_COUNT
FROM   movie; 

-- country column have 20 null values
-- worlwide_gross_income colum has 3724 null values
-- languages column has 194 null values
-- production_company column has 528 null values

-- Total sum count of null values from all the columns in movie table are 4466.






-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year; 

-- 2017 has highest number of movies released i.e., 3052

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY number_of_movies DESC;

-- March has the highest number of movies released i.e., 824








/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT year,
       Count(DISTINCT id) AS number_of_movies
FROM   movie
WHERE  ( country LIKE '%USA%'
          OR country LIKE '%INDIA%'
          OR country LIKE 'India%' )
       AND year = 2019; 
    
-- There are 1059 movies released in India or USA in the year 2019





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 
	DISTINCT genre
FROM genre;

SELECT 
	count(DISTINCT genre)
FROM genre;



-- There are 13 different types of genre present in the dataset.





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
	genre.genre,
	COUNT(distinct movie_id) as number_of_movies
FROM genre
INNER JOIN movie
ON genre.movie_id = movie.id
GROUP BY genre.genre
ORDER BY number_of_movies DESC
LIMIT 1;

--  Drama genre movies are highest released i.e., 4285








/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_with_one_genre AS
	(SELECT 
		movie_id
        -- COUNT(genre)
	FROM genre
    GROUP BY movie_id
    HAVING COUNT(DISTINCT genre)= 1)
SELECT 	
		COUNT(movie_id)
FROM movies_with_one_genre;


-- 3289 movies have only one genre in the dataset.





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
		genre,
        ROUND(avg(duration)) as avg_duration
FROM genre as g
LEFT JOIN movie as m
ON g.movie_id= m.id
GROUP BY genre
ORDER BY avg_duration DESC;

-- Average Duration of movies in each Genre are as follows:-
-- Action	113
-- Romance	110
-- Drama	107
-- Crime	107
-- Fantasy	105
-- Comedy	103
-- Thriller	102
-- Adventure 102
-- Mystery	102
-- Family	101
-- Others	100
-- Sci-Fi	98
-- Horror	93







/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH genre_count AS
(
 SELECT genre,
Count(movie_id) AS movie_count ,
Rank() OVER(ORDER BY count(movie_id) DESC) AS genre_rank
FROM genre                                 
GROUP BY genre 
)
SELECT *
FROM genre_count
WHERE genre = 'THRILLER';

-- Thriller has rank = 3 and the movie count = 1484





/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT
		MIN(avg_rating) as min_avg_rating,
        MAX(avg_rating) as max_avg_rating,
        MIN(total_votes) as min_total_votes,
        MAX(total_votes) as max_total_votes,
        MIN(median_rating) as min_median_rating,
        MAX(median_rating) as max_median_rating
FROM ratings;

-- The minimum and maximum values in each column of the ratings table excepts the movie_id column are as follows:-

-- +---------------+-------------------+---------------------+----------------------+-----------------+------------------+
-- | min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
-- +---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
-- |		1.0		|		10.0		|	       100		  |	   725138	    	 |		  1	       |	   10		 |
-- +---------------+-------------------+---------------------+----------------------+-----------------+------------------+


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH MOVIE_RANK AS
(
SELECT title, avg_rating,
dense_rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM ratings AS r
INNER JOIN movie AS m
ON m.id = r.movie_id
)
SELECT * FROM MOVIE_RANK
WHERE movie_rank<=10;

-- The top 3 movies has an average rating greater than 9.5




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
	median_rating,
    COUNT(movie_id) as movie_count
FROM ratings
GROUP BY median_rating
ORDER BY  COUNT(movie_id) DESC;

-- The highest number of movies have an median rating of 7 and lowest movies count have an median rating of 1.






/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


WITH production_summary AS
(SELECT 
	production_company,
    COUNT(id) as movie_count,
    RANK() OVER( ORDER BY COUNT(id) DESC) AS prod_company_rank
    -- avg_rating
FROM movie
LEFT JOIN ratings
ON ratings.movie_id = movie.id
WHERE avg_rating > 8 and production_company IS NOT NULL
GROUP BY production_company)
SELECT * FROM production_Summary
WHERE prod_company_rank = 1;

-- Solution output

--    production_company              |          MOVIE_COUNT      |       PROD_COMPANY_RANK
--   Dream Warrior Pictures           |             3             |            1
--   National Theatre Live            |             3             |            1
 



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	genre,
	count(id) as movie_count
    -- year
    -- total_votes
FROM genre
INNER JOIN movie
ON movie.id= genre.movie_id
LEFT JOIN ratings
ON movie.id= ratings.movie_id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP BY genre
ORDER BY count(id) DESC ;

-- Total number of Drama movies realeased in 2017 are 24 followed by Comedy (9), Action (8). These are the top three genres of movies that were having total votes greater than 1000.



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  title,
       avg_rating,
       genre
FROM   movie AS M
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
GROUP BY title
ORDER BY avg_rating DESC;

-- There are 8 movies which begin with "The" in their title with average rating > 8.
-- The Brighton Miracle has highest average rating of 9.5.




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	-- date_published,
    median_rating,
    count(id) as movie_count
FROM movie
INNER JOIN ratings
ON movie.id= ratings.movie_id
WHERE 
	date_published BETWEEN '2018-04-01' and  '2019-04-01' and 
    median_rating = 8
GROUP BY median_rating;


-- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8.




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
	SUM(CASE WHEN languages LIKE '%German%' THEN total_votes ELSE NULL END) AS German_votes,
    SUM(CASE WHEN languages LIKE '%Italian%' THEN total_votes ELSE NULL END) AS Italian_votes
FROM movie
INNER JOIN ratings
ON ratings.movie_id= movie.id;

-- Yes German get more voter than Italians






-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

-- height, date_of_birth, known_for_movies have null values.




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS
(
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre G
using     (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres
using     (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

-- James Mangold , Joe Russo and Anthony Russo are top three directors in the top three genres whose movies have an average rating > 8









/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	name as actor_name,
    COUNT(role_mapping.movie_id) as movie_count
FROM role_mapping
INNER JOIN names
ON names.id= role_mapping.name_id
INNER JOIN ratings
ON ratings.movie_id= role_mapping.movie_id
WHERE median_rating >=8 and category= 'ACTOR'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2 ;


-- Mammootty has highest number of movies with median rating >= 8





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company,
    SUM(total_votes),
    RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie
INNER JOIN ratings
ON ratings.movie_id = movie.id
GROUP BY production_company
LIMIT 3;

-- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	name as actor_name,
    SUM(total_votes) as total_votes,
    COUNT(role_mapping.movie_id) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) as actor_avg_rating,
    RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actor_rank
FROM role_mapping
INNER JOIN names
ON names.id= role_mapping.name_id
INNER JOIN movie
ON movie.id= role_mapping.movie_id
INNER JOIN ratings
ON ratings.movie_id= role_mapping.movie_id
WHERE category= 'actor' and 
	  country LIKE '%India%' 
GROUP BY actor_name
HAVING movie_count >=5
LIMIT 1;

-- Vijay Sethupathi is top on the list.




-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
	name as actress_name,
	SUM(total_votes) as total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) as actress_avg_rating,
    RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actress_rank
FROM names as n
INNER JOIN role_mapping as r
on r.name_id= n.id
INNER JOIN movie as m
on m.id= r.movie_id
INNER JOIN ratings as ra
on ra.movie_id= r.movie_id
WHERE category = 'actress' and 
country= 'India' and 
languages like '%Hindi%'
GROUP BY actress_name
HAVING movie_count >=3
LIMIT 5;


-- Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda are the top five hindi actress.






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT distinct 
	title, 
    avg_rating,
    -- genre
    CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM movie
INNER JOIN genre
ON movie.id= genre.movie_id
INNER JOIN ratings
ON movie.id= ratings.movie_id
WHERE genre LIKE 'Thriller';








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
		ROUND(AVG(duration)) AS avg_duration,
        ROUND(SUM(AVG(duration)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING),1)AS running_total_duration,
        ROUND(AVG(AVG(duration)) OVER(ORDER BY genre ROWS 10 PRECEDING),2)AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genres AS
(
           SELECT     genre
           FROM       genre g
           INNER JOIN ratings r
           ON         g.movie_id = r.movie_id
           WHERE      avg_rating > 8
           GROUP BY   genre
           ORDER BY   Count(r.movie_id) DESC limit 3),
-- getting summary of movies based on top genres
movie_summary AS
(
           SELECT     g.genre,
					  g.movie_id ,
                      year,
                      title     AS movie_name,
                      -- removing currency signs and replacing null values with zero
                      CASE
                                 WHEN worlwide_gross_income IS NULL THEN 0
                                            -- converting variable type to decimal
                                 WHEN worlwide_gross_income LIKE '$%' THEN Cast(Replace (worlwide_gross_income,'$', '') AS     DECIMAL(10))
                      END  AS worlwide_gross_income
           FROM       movie AS m
           INNER JOIN genre AS g
           ON         g.movie_id = m.id
           WHERE      g.genre IN
                      (
                             SELECT genre
                             FROM   top_3_genres)
           GROUP BY   movie_name
           ORDER BY   worlwide_gross_income DESC), top_movies AS
(
         SELECT   *,
                  Dense_rank() OVER(partition BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
         FROM     movie_summary )
SELECT *
FROM   top_movies
WHERE  movie_rank<= 5;

-- Top movies in each year based on worlwide gross income: 2017: Star Wars, 2018: Avengers:Infinity war, 2019:Avengers:Endgame.








-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_comp_rank AS
(SELECT 
	production_company,
    COUNT(id) AS movie_count, 
    DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) as prod_comp_rank
FROM movie as m
INNER JOIN ratings as r
ON m.id= r.movie_id
WHERE   median_rating >=8 and 
		production_company is not null and
        position(',' IN languages)>0 
GROUP BY production_company)

SELECT *
FROM prod_comp_rank
WHERE prod_comp_rank <= 2;


-- the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies are Star Cinema & Twentieth Century Fox.



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	  n.name as actress_name,
      SUM(r.total_votes) as total_votes,
      COUNT(r.movie_id) as movie_count,
      ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) as actress_avg_rating,
      DENSE_RANK()OVER(ORDER BY COUNT(r.movie_id) DESC) as actress_rank
FROM ratings as r
INNER JOIN role_mapping as rm
ON rm.movie_id= r.movie_id
INNER JOIN names as n
ON n.id= rm.name_id
INNER JOIN movie as m
ON r.movie_id= m.id
INNER JOIN genre as g 
ON g.movie_id= r.movie_id
WHERE category = 'actress' and
	  genre= 'Drama' and 
	  avg_rating > 8
GROUP BY n.name;

/*  
  -- Parvathy Thiruvothu, Susan Brown, Amanda Lawrence, Denise Gough all four have 2 Super hit movies, among them
  Parvathy Thiruvothu has acted in movies with highest votes. *\



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_summary AS 
( 	SELECT 
		name_id as director_id,
        name,
        dm.movie_id,
        date_published,
        lag(date_published) OVER(PARTITION BY dm.name_id ORDER BY date_published DESC) as lag_movie_date,
        r.avg_rating,
        r.total_votes,
        m.duration
FROM names as n
INNER JOIN director_mapping as dm
ON dm.name_id= n.id
INNER JOIN movie as m
ON m.id= dm.movie_id
INNER JOIN ratings as r
ON r.movie_id= dm.movie_id),
director_rank AS
( SELECT 
	director_id,
    name as director_name,
    COUNT(movie_id) as number_of_movies,
    round(avg(DATEDIFF(lag_movie_date,date_published))) as avg_inter_movie_days,
    round(avg(avg_rating)) as avg_rating,
    Sum(total_votes) as total_votes,
    min(avg_rating) as min_rating,
    max(avg_rating) as max_rating,
    sum(duration) as total_duration,
    ROW_NUMBER()OVER(ORDER BY COUNT(movie_id) DESC) as dir_rank
FROM director_summary
GROUP BY director_id
ORDER BY number_of_movies DESC)

SELECT 
	director_id,
    director_name,
    number_of_movies,
    avg_inter_movie_days,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
FROM director_rank 
WHERE dir_rank <= 9;


/*
 The top 9 directors are A.L. Vijay
Andrew Jones
Steven Soderbergh
Jesse V. Johnson
Sam Liu
Sion Sono
Chris Stokes
Justin Price
Özgür Bakar
\*




