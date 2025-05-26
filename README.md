# Netflix Movies and TV Shows Data Analysis using SQL

Practice work on SQL, solving Netflix business questions with SQL

![Netflix logo]([images/.png](https://github.com/MiebiB/15-business-questions-using-SQL/blob/main/perchE-netflix-disney-aumentato-prezzi-italiani-pagheranno-33-piU-v3-666390.jpg))

<h2>🔍 Overview</h2>
<p>
This project explores Netflix’s content dataset to derive actionable business insights using SQL. By addressing key business questions, I aimed to optimize decision-making for content acquisition, user targeting, and platform engagement.
</p>

<h2>🎯 Objectives</h2>
<ul>
  <li>Evaluate Netflix's content distribution and trends over time.</li>
  <li>Identify valuable genres, countries, and talent (directors/actors).</li>
  <li>Assess content gaps and engagement opportunities.</li>
  <li>Drive strategic decisions through data-driven insights.</li>
</ul>

<h2>🗂️ Schema</h2>
<p><em>Note: This section will be updated with the full schema diagram or explanation.</em></p>

<h2>📌 Business Problems & Solutions (SQL)</h2>

<ol>
  <li>
    <strong>Count the number of Movies vs TV Shows</strong><br />
    <pre><code>SELECT [type], COUNT(*) AS total_content
FROM netflix_titles$
GROUP BY type;</code></pre>
  </li>
  
  <li>
    <strong>Find the most common rating for Movies and TV Shows</strong><br />
    <pre><code>SELECT [type], rating, COUNT(*) AS total_rating
FROM netflix_titles$
GROUP BY type, rating
ORDER BY type, total_rating DESC;</code></pre>
  </li>

  <li>
    <strong>List all Movies released in 2020</strong><br />
    <pre><code>SELECT type, title, release_year
FROM netflix_titles$
WHERE type = 'Movie' AND release_year = 2020;</code></pre>
  </li>

  <li>
    <strong>Top 5 Countries with Most Content</strong><br />
    <pre><code>WITH CountrySplit AS (
  SELECT show_id, TRIM(value) AS country
  FROM netflix_titles$
  CROSS APPLY STRING_SPLIT(country, ',')
)
SELECT TOP(5) country, COUNT(show_id) AS total_content
FROM CountrySplit
GROUP BY country
ORDER BY total_content DESC;</code></pre>
  </li>

  <li>
    <strong>Identify the Longest Movie</strong><br />
    <pre><code>SELECT *
FROM netflix_titles$
WHERE duration = (SELECT MAX(duration) FROM netflix_titles$)
  AND type = 'Movie';</code></pre>
  </li>

  <li>
    <strong>Find Content Added in the Last 5 Years</strong><br />
    <pre><code>SELECT *
FROM netflix_titles$
ORDER BY date_added DESC;</code></pre>
  </li>

  <li>
    <strong>Find all Movies/TV Shows by Director 'Rajiv Chilaka'</strong><br />
    <pre><code>SELECT *
FROM netflix_titles$
WHERE director LIKE '%Rajiv Chilaka%';</code></pre>
  </li>

  <li>
    <strong>List TV Shows with More Than 5 Seasons</strong><br />
    <pre><code>SELECT *
FROM netflix_titles$
WHERE type = 'TV Show'
  AND TRY_CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;</code></pre>
  </li>

  <li>
    <strong>Count of Content per Genre</strong><br />
    <pre><code>WITH genre AS (
  SELECT TRIM(value) AS listed_in, title
  FROM netflix_titles$
  CROSS APPLY STRING_SPLIT(listed_in, ',')
)
SELECT listed_in, COUNT(title) AS count
FROM genre
GROUP BY listed_in
ORDER BY count DESC;</code></pre>
  </li>

  <li>
    <strong>Top 5 Years with Most Content from India (Avg %)</strong><br />
    <pre><code>WITH IndiaContent AS (
  SELECT * FROM netflix_titles$ WHERE country LIKE '%India%'
),
YearlyContent AS (
  SELECT release_year, COUNT(*) AS yearly_content
  FROM IndiaContent GROUP BY release_year
),
TotalIndiaContent AS (
  SELECT COUNT(*) AS total_content FROM IndiaContent
)
SELECT y.release_year, y.yearly_content,
ROUND(CAST(y.yearly_content AS FLOAT) / t.total_content * 100, 2) AS avg_content_per_year
FROM YearlyContent y
CROSS JOIN TotalIndiaContent t
ORDER BY avg_content_per_year DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;</code></pre>
  </li>

  <li>
    <strong>List all Movies that are Documentaries</strong><br />
    <pre><code>SELECT *
FROM netflix_titles$
WHERE listed_in LIKE '%Documentaries%' AND type = 'Movie';</code></pre>
  </li>

  <li>
    <strong>Find all Content without a Director</strong><br />
    <pre><code>SELECT *
FROM netflix_titles$
WHERE director IS NULL;</code></pre>
  </li>

  <li>
    <strong>Find How Many Movies Salman Khan Appeared In (last 10 years)</strong><br />
    <pre><code>SELECT *
FROM netflix_titles$
WHERE cast LIKE '%Salman Khan%' AND type = 'Movie' AND release_year > 2008
ORDER BY release_year DESC;</code></pre>
  </li>

  <li>
    <strong>Top 10 Most Featured Actors in Indian Movies</strong><br />
    <pre><code>WITH actorSplit AS (
  SELECT title, TRIM(value) AS actors
  FROM netflix_titles$
  CROSS APPLY STRING_SPLIT(cast, ',')
  WHERE country LIKE '%India%'
)
SELECT TOP(10) actors, COUNT(title) AS movie_count
FROM actorSplit
GROUP BY actors
ORDER BY movie_count DESC;</code></pre>
  </li>

  <li>
    <strong>Classify Content as 'Good' or 'Bad' Based on Description</strong><br />
    <pre><code>WITH new_table AS (
  SELECT *,
    CASE
      WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad Content'
      ELSE 'Good Content'
    END AS category
  FROM netflix_titles$
)
SELECT category, COUNT(*) AS total_content
FROM new_table
GROUP BY category;</code></pre>
  </li>
</ol>

<h2>📈 Key Findings</h2>
<ul>
  <li>Movies slightly outnumber TV shows, reflecting a strong content preference for films on Netflix.</li>
  <li>India is one of the top countries for content production, with a growing yearly contribution.</li>
  <li>Some directors and actors dominate certain niches or genres—these can guide future acquisition decisions.</li>
  <li>There’s a significant portion of content without credited directors, potentially impacting discoverability or trust.</li>
  <li>Genres like Documentaries and Dramas dominate the catalog—offering potential for niche growth or diversification.</li>
</ul>

<h2>🧠 Conclusion</h2>
<p>
By analyzing Netflix’s global content distribution and consumption characteristics, we gain insights into user preferences, production gaps, and strategic investments. This information can help businesses:
</p>
<ul>
  <li>Optimize content acquisition by country, genre, and talent.</li>
  <li>Fill underrepresented niches or formats.</li>
  <li>Enhance data quality (e.g., director metadata) for improved user experience.</li>
</ul>
