-- create table netflix
DROP TABLE IF EXISTS netflix1;
CREATE TABLE netflix1 (
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    movie_cast VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

SELECT * FROM netflix1;

-- 1. count the number of movies vs tv shows
SELECT
    type,
    COUNT(*) as total_content
FROM netflix1
GROUP BY type

-- 2. find the most common rating for movies and tv shows
SELECT
     type,
	 rating,
     COUNT(*)
FROM netflix1
GROUP BY 1,2
ORDER BY 1,3 DESC

-- 3. list all the movies released in a specific year(eg 2020)
SELECT*FROM netflix1
WHERE
    type = 'Movie'
	AND
	release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix
SELECT 
    UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix1
GROUP By 1
ORDER BY 2 DESC -- 2 means 2nd col
LIMIT 5

-- 5. IDENTIFY the longest movie?
SELECT*FROM netflix1
WHERE
    type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix1)

-- 6. find the content added in the last five years
SELECT*FROM netflix1
WHERE
    TO_DATE(date_added,'Month DD,YYYY') >=CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5years'

-- 7. find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT* FROM netflix1
WHERE
director LIKE '%Rajiv Chilaka%'; -- if there are 2 directors 

-- 8. list all tv shows with more than 5 seasons
SELECT * FROM netflix1
WHERE 
type='TV Show'
AND
duration > '5 seasons'

-- 9. count the number of content items in each genre
SELECT
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	Count(show_id) as total_content
FROM netflix1
GROUP BY 1

-- 10. find each year and the avg nos of content release by india on netflix,
-- top 5 year with highest avg content release
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD,YYYY')) as year,
	COUNT(*),
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix1 WHERE country='India')::numeric*100 as avg_content_per_year
FROM netflix1
WHERE country = 'India'
GROUP BY 1

-- 11. list all movies that are documenteries
SELECT*FROM netflix1
WHERE
listed_in LIKE '%Documentaries%'

-- 12. find all the content without a director
SELECT*FROM netflix1
WHERE
director IS NULL

-- 13. find how many movies actor 'salman khan ' appeared in last 10 years
SELECT*FROM netflix1
WHERE
movie_cast ILIKE '%salman khan%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10

-- 14. FIND THE TOP 10 ACTORS WHO APPEARED IN  THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA
SELECT
UNNEST(STRING_TO_ARRAY(movie_cast, ','))as actors,
COUNT(*) as total_content
FROM netflix1
WHERE country ILIKE '%INDIA%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 15. categorize the content based on the presence of the keywords 'kill' and 'violence' in
-- the description field. label content containing these keywords as 'bad' and all other
-- content as 'good'. count how many items fall into each category.
WITH new_table AS (
    SELECT
        *,
        CASE
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' 
                THEN 'Bad_Content'
            ELSE 'Good_Content'
        END AS category
    FROM netflix1
)
SELECT
    category,
    COUNT(*) AS total_content
FROM new_table
GROUP BY category;
