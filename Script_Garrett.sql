--#### Provide the SQL queries and answers for the following questions/tasks using the data_analyst_jobs table you have created in PostgreSQL:

--1.	How many rows are in the data_analyst_jobs table?
--Answer: 1793
SELECT COUNT(*) AS row_count
FROM data_analyst_jobs;

SELECT *
FROM data_analyst_jobs;

--2.	Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?
--Answer: ExxonMobil
SELECT company
FROM data_analyst_jobs
LIMIT 10;

SELECT *
FROM data_analyst_jobs
LIMIT 10;

--3.	How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?
--Answer: 21 in TN, 27 in TN or KY.
SELECT COUNT(location) AS tennessee_postings
FROM data_analyst_jobs
WHERE location = 'TN';

SELECT COUNT(location) AS tennessee_postings
FROM data_analyst_jobs
WHERE location IN ('TN', 'KY');

--4.	How many postings in Tennessee have a star rating above 4?
--Answer: 3
SELECT COUNT(*) AS high_star_tn_count
FROM data_analyst_jobs
WHERE location = 'TN' AND star_rating > 4.0;

SELECT *
FROM data_analyst_jobs
WHERE location = 'TN' AND star_rating > 4.0;

SELECT *
FROM data_analyst_jobs
WHERE location = 'TN';

--5.	How many postings in the dataset have a review count between 500 and 1000?
--Answer: 151
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;

SELECT *
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;

--6.	Show the average star rating for companies in each state. The output should show the state as `state` and the average rating for the state as `avg_rating`. 
SELECT location AS state, ROUND(AVG(star_rating),2) AS avg_rating
FROM data_analyst_jobs
WHERE location IS NOT NULL AND star_rating IS NOT NULL
GROUP BY state
ORDER BY avg_rating DESC;
--Which state shows the highest average rating?
--Answer: NE

--7.	Select unique job titles from the data_analyst_jobs table. How many are there?
--Answer: 881
SELECT COUNT(DISTINCT title) AS unique_job_titles
FROM data_analyst_jobs;

SELECT DISTINCT title
FROM data_analyst_jobs;

SELECT *
FROM data_analyst_jobs;

--8.	How many unique job titles are there for California companies?
--Answer: 230
SELECT COUNT(DISTINCT title) AS unique_job_titles_california
FROM data_analyst_jobs
WHERE location = 'CA';

--9.	Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations.
--How many companies are there with more than 5000 reviews across all locations?
--Answer: 40 (based on the rows returned from the query)
SELECT DISTINCT company, MIN(review_count) AS min_review_count, ROUND(AVG(star_rating),2) AS avg_star_rating
FROM data_analyst_jobs
WHERE company IS NOT NULL
GROUP BY company
HAVING MIN(review_count) > 5000
ORDER BY company;

--checking what the review and star differences are within the companies...
--looking at this, the star rating seems to be consistent but the review count differs across the company by up to 19.
--So the average of the star_rating will be the star_rating... there is no difference.  I'll still AVG to use the function.  :)
SELECT DISTINCT company
	, MAX(review_count) - MIN(review_count) AS review_difference
	, MAX(star_rating) - MIN(star_rating) AS star_difference
	, MIN(review_count) AS min_company_review_count
	, MAX(review_count) AS max_company_review_count
	, MIN(star_rating) AS min_star_rating
	, MAX(star_rating) AS min_star_rating
FROM data_analyst_jobs
GROUP BY company
HAVING MIN(review_count) > 5000
ORDER BY review_difference DESC
--ORDER BY star_difference DESC
;

SELECT DISTINCT company
	, MIN(review_count) AS min_company_review_count
	, MAX(review_count) AS max_company_review_count
	, MIN(star_rating) AS min_star_rating
	, MAX(star_rating) AS min_star_rating
FROM data_analyst_jobs
GROUP BY company
HAVING MIN(review_count) > 5000
ORDER BY company;

SELECT company, review_count, star_rating, location
FROM data_analyst_jobs
ORDER BY company;

SELECT company, review_count, star_rating, location
FROM data_analyst_jobs;

SELECT *
FROM data_analyst_jobs;

--10.	Add the code to order the query in #9 from highest to lowest average star rating.
--Which company with more than 5000 reviews across all locations in the dataset has the highest star rating?
--What is that rating?
--Answer: 6 companies have the highest at 4.2.
--They are American Express, General Motors, Kaiser Permanente, Microsoft, Nike, and Unilever.
SELECT DISTINCT company, MIN(review_count) AS min_review_count, ROUND(AVG(star_rating),2) AS avg_star_rating
FROM data_analyst_jobs
WHERE company IS NOT NULL
GROUP BY company
HAVING MIN(review_count) > 5000
ORDER BY avg_star_rating DESC, company;

SELECT DISTINCT company, MIN(review_count) AS min_review_count, AVG(star_rating) AS avg_star_rating
FROM data_analyst_jobs
WHERE company IS NOT NULL
GROUP BY company
HAVING MIN(review_count) > 5000
ORDER BY avg_star_rating DESC;

--11.	Find all the job titles that contain the word ‘Analyst’. How many different job titles are there?
--Answer: 774
SELECT COUNT(DISTINCT title) AS analyst_jobs
FROM data_analyst_jobs
WHERE title ILIKE '%analyst%';

SELECT DISTINCT title
FROM data_analyst_jobs
WHERE title ILIKE '%analyst%'
ORDER BY title;

--12.	How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?
--Answer: They are looking for proficiency with Data Visualization / Tableau
SELECT DISTINCT title
FROM data_analyst_jobs
WHERE title NOT ILIKE '%analyst%' AND title NOT ILIKE '%analytics%'
ORDER BY title;


--**BONUS:**
--You want to understand which jobs requiring SQL are hard to fill.
--Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks. 
-- - Disregard any postings where the domain is NULL. 
-- - Order your results so that the domain with the greatest number of `hard to fill` jobs is at the top. 
SELECT
	domain AS industry
	, count(domain) AS count_of_hard_to_fill_jobs
	, ROUND(AVG(days_since_posting)) AS avg_days_since_posting
	, MIN(days_since_posting) AS min_days_since_posting
	, MAX(days_since_posting) AS max_days_since_posting
FROM data_analyst_jobs
WHERE skill ILIKE '%sql%' AND days_since_posting > 21 AND domain IS NOT NULL
GROUP BY industry
ORDER BY count_of_hard_to_fill_jobs DESC;

SELECT
	domain AS industry
	, skill
	, days_since_posting
FROM data_analyst_jobs
WHERE skill ILIKE '%sql%' AND days_since_posting > 21 AND domain IS NOT NULL;
--  - Which three industries are in the top 4 on this list? IGNORE PER SLACK
--How many jobs have been listed for more than 3 weeks for each of the top 4?
--Answer: 62, 61, 57, and 52
--Note: The top 4 are:
--	Internet and Software, Banks and Financial Services, Consulting and Business Services, and Health Care




