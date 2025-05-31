
CREATE TABLE mentor (
    id SERIAL PRIMARY KEY,
    user_id BIGINT,
    question_id INT,
    points INT,
    submitted_at TIMESTAMP WITH TIME ZONE,
    username VARCHAR(50)
);

SELECT * FROM mentor;


-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
-- Q.2 Calculate the daily average points for each user.
-- Q.3 Find the top 3 users with the most positive submissions for each day.
-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
-- Q.5 Find the top 10 performers for each week.


-- Please note for each questions return current stats for the users

-- -------------------
-- My Solutions
-- -------------------

--Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
SELECT
	DISTINCT username,
	SUM(points) AS total_points,
	COUNT(*) AS total_submissions
FROM mentor
GROUP BY 1
ORDER BY 2 DESC;

-- Q.2 Calculate the daily average points for each user.
SELECT
	TO_CHAR(submitted_at, 'DD-MM') AS day,
	username,
	ROUND(AVG(points),2) AS daily_points
FROM mentor
GROUP BY 1,2
ORDER BY 2;

-- Q.3 Find the top 3 users with the most positive submissions for each day.
WITH daily
AS
(
	SELECT 
		TO_CHAR(submitted_at, 'DD-MM') AS day,
		username,
		SUM(CASE 
			WHEN points > 0 THEN 1 ELSE 0
		END) AS correct_submissions
	FROM mentor
	GROUP BY 1,2
),
ranking_table
AS
	(SELECT 
		day,
		username,
		correct_submissions,
		DENSE_RANK() OVER
						(PARTITION BY day ORDER BY correct_submissions DESC) AS rank
	FROM daily
)
SELECT 
	day,
	username,
	correct_submissions,
	rank
FROM ranking_table
WHERE rank <= 3

-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
SELECT 
	username,
	SUM(CASE 
		WHEN points < 0 THEN 1 ELSE 0
		END) AS incorrect_submissions
FROM mentor
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5

-- Q.5 Find the top 10 performers for each week.

WITH weekly
AS
(
	SELECT 
		TO_CHAR(submitted_at, 'MM-IW') AS week,
		username,
		SUM(points) AS total_points
	FROM mentor
	GROUP BY 1,2
),
ranking_table_1
AS
	(SELECT 
		week,
		username,
		total_points,
		DENSE_RANK() OVER
						(PARTITION BY week ORDER BY total_points DESC) AS rank
	FROM weekly
)
SELECT 
	week,
	username,
	total_points,
	rank
FROM ranking_table_1
WHERE rank <= 10


