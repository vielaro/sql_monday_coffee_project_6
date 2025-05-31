# SQL Mentor User Performance Analysis 

![SQL Data Analytics](https://github.com/najirh/sql-project-10---sql-mentor-datasets/blob/main/Unknown-5.jpg)

## Objectives

- Learn how to use SQL for data analysis tasks such as aggregation, filtering, and ranking.
- Understand how to calculate and manipulate data in a real-world dataset.
- Gain hands-on experience with SQL functions like `COUNT`, `SUM`, `AVG`, `EXTRACT()`, and `DENSE_RANK()`.
- Develop skills for performance analysis using SQL by solving different types of data problems related to user performance.


## SQL Mentor User Performance Dataset

The dataset consists of information about user submissions for an online learning platform. Each submission includes:
- **User ID**
- **Question ID**
- **Points Earned**
- **Submission Timestamp**
- **Username**

This data allows you to analyze user performance in terms of correct and incorrect submissions, total points earned, and daily/weekly activity.

## SQL Problems and Questions


### Q1. List All Distinct Users and Their Stats
- **Description**: Return the user name, total submissions, and total points earned by each user.
- **Expected Output**: A list of users with their submission count and total points.

### Q2. Calculate the Daily Average Points for Each User
- **Description**: For each day, calculate the average points earned by each user.
- **Expected Output**: A report showing the average points per user for each day.

### Q3. Find the Top 3 Users with the Most Correct Submissions for Each Day
- **Description**: Identify the top 3 users with the most correct submissions for each day.
- **Expected Output**: A list of users and their correct submissions, ranked daily.

### Q4. Find the Top 5 Users with the Highest Number of Incorrect Submissions
- **Description**: Identify the top 5 users with the highest number of incorrect submissions.
- **Expected Output**: A list of users with the count of incorrect submissions.

### Q5. Find the Top 10 Performers for Each Week
- **Description**: Identify the top 10 users with the highest total points earned each week.
- **Expected Output**: A report showing the top 10 users ranked by total points per week.

## SQL Queries Solutions

Below are the solutions for each question in this project:

### Q1: List All Distinct Users and Their Stats
```sql
SELECT
	DISTINCT username,
	SUM(points) AS total_points,
	COUNT(*) AS total_submissions
FROM mentor
GROUP BY 1
ORDER BY 2 DESC;
```

### Q2: Calculate the Daily Average Points for Each User
```sql
SELECT
	TO_CHAR(submitted_at, 'DD-MM') AS day,
	username,
	ROUND(AVG(points),2) AS daily_points
FROM mentor
GROUP BY 1,2
ORDER BY 2;
```

### Q3: Find the Top 3 Users with the Most Correct Submissions for Each Day
```sql
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
WHERE rank <= 3;
```

### Q4: Find the Top 5 Users with the Highest Number of Incorrect Submissions
```sql
SELECT 
	username,
	SUM(CASE 
		WHEN points < 0 THEN 1 ELSE 0
		END) AS incorrect_submissions
FROM mentor
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;
```

### Q5: Find the Top 10 Performers for Each Week
```sql
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
```

## Conclusion

This project provides an excellent opportunity for beginners to apply their SQL knowledge to solve practical data problems. By working through these SQL queries, you'll gain hands-on experience with data aggregation, ranking, date manipulation, and conditional logic.
