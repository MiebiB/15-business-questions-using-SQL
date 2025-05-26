-- Solving 15 business problems with Netflix data. Source: Kaggle

  select * from netflix_titles$

  -- 1. Count the number of Movies vs TV Shows

 select [type], count(*) as  total_content
 from netflix_titles$
 group by type

 -- 2. Find the most common rating for movies and TV shows

select 
	[type], 
	rating, 
	count(*) as  total_rating
from netflix_titles$
group by type, rating
order by type, total_rating desc

-- 3. List all movies released in a specific year (e.g 2020)

select type, title, release_year
from netflix_titles$
where type='Movie' and release_year = 2020;

-- 4. Find the top 5 countries with the most content on netflix

WITH CountrySplit AS (
    SELECT 
        show_id,
        TRIM(value) AS country
    FROM netflix_titles$
    CROSS APPLY STRING_SPLIT(country, ',')
)

-- Then count the number of shows per country
SELECT 
    top(5)country,
    COUNT(show_id) AS total_content
FROM CountrySplit
GROUP BY country
ORDER BY total_content DESC;


-- 5. Identify the longest movie

select *
from netflix_titles$
where duration = (select max(duration) as longest from netflix_titles$) and type = 'Movie'

-- 6. Find content added in the last 5 years

select * 
from netflix_titles$
order by date_added desc
--not really accurate

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'

select *
from netflix_titles$
where director like '%Rajiv Chilaka%' --any where the name shows up 

-- 8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix_titles$
WHERE type = 'TV Show'
  AND TRY_CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;

-- 9. Count the number of content items in each genre

with genre as(
SELECT TRIM(value) AS listed_in, title 
    FROM netflix_titles$
    CROSS APPLY string_split(listed_in, ',')
) --new table called 'genre'
select listed_in, count(title) as count
from genre
group by listed_in
order by count desc

-- 10. Find the years and the average number of content released by India on netflix. Return the top 5 years with the highest average content release

WITH IndiaContent AS (SELECT * FROM netflix_titles$ WHERE country LIKE '%India%'),
YearlyContent AS (SELECT release_year, COUNT(*) AS yearly_content FROM IndiaContent GROUP BY release_year),
TotalIndiaContent AS (SELECT COUNT(*) AS total_content FROM IndiaContent)

SELECT y.release_year, y.yearly_content, ROUND(CAST(y.yearly_content AS FLOAT) / t.total_content * 100, 2) AS avg_content_per_year
FROM YearlyContent y
CROSS JOIN TotalIndiaContent t
ORDER BY avg_content_per_year DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


-- 11. List all movies that are documentaries

select *
from netflix_titles$
where listed_in like '%Documentaries%' and type = 'Movie'

-- 12. Find all content without a director

select *
from netflix_titles$
where director is null

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years

select *
from netflix_titles$
where cast like '%Salman Khan%' and type = 'Movie' and release_year > 2008
order by release_year desc

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India

with actorSplit as (select title, trim(value) as actors from netflix_titles$ cross apply string_split(cast, ',') where country like '%India%')
select top(10) actors, count(title) as movie_count
from actorSplit
group by actors
order by movie_count desc 


/* 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content 
containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.*/

with new_table as
(select *,
	case when description like '%kill%' or description like '%violence%' then 'Bad Content' else 'Good Content'end as category
from netflix_titles$)
select category, count(*) as total_content
from new_table
group by category
