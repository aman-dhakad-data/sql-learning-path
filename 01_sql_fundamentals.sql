/* ===============================================================================
BASIC SQL PRACTICE
Concepts Covered:
- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- DISTINCT
- Aggregations
=============================================================================== */

CREATE TABLE person_scores (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    score INT NOT NULL
);

SELECT * 
FROM person_scores;

INSERT INTO person_scores (id, name, country, score)
VALUES
(1, 'Aman Verma', 'India', 0),
(2, 'Rohan Mehta', 'USA', 120),
(3, 'Daniel Scott', 'UK', 260),
(4, 'Arjun Malhotra', 'India', 410),
(5, 'Lucas Brown', 'Canada', 590),
(6, 'Ethan Miller', 'USA', 780),
(7, 'Hiro Tanaka', 'Japan', 1020),
(8, 'Oliver Smith', 'Australia', 1350),
(9, 'Noah Fischer', 'Germany', 1700),
(10, 'Min-Jae Park', 'South Korea', 2200);

--1. SELECT (Basic Data Fetch)

SELECT * 
FROM person_scores;

SELECT name, score
FROM person_scores;


--2. WHERE (Filtering)

-- Find records with scores greater than 500
SELECT *
FROM person_scores
WHERE score > 500 ;

-- Retrieve people from India
SELECT name, score
FROM person_scores
WHERE country = 'India';

-- Retrieve scores less than 1000 but greater than 0
SELECT *
FROM person_scores
WHERE score < 1000 AND score > 0;


--3. ORDER BY (Sorting)

-- Sort scores from highest to lowest
SELECT * FROM person_scores
WHERE score > 0
ORDER BY score DESC;

SELECT name, country, score
FROM person_scores
ORDER BY country ASC, score DESC;

SELECT country, AVG(score) AS avg_score
FROM person_scores
GROUP BY country;

SELECT country, SUM(score) AS total_score
FROM person_scores
GROUP BY country;


--4. HAVING (Filter on Aggregated Data)

SELECT country, AVG(score) AS avg_score
FROM person_scores
GROUP BY country
HAVING AVG(score) > 500;

SELECT country, COUNT(*) AS total_people
FROM person_scores
GROUP BY country
HAVING COUNT(*) = 2;


--5. TOP (SQL Server Style)
SELECT TOP 3 * 
FROM person_scores
ORDER BY score DESC;


--6. DISTINCT (Unique Values)

--Unique countries:
SELECT DISTINCT country
FROM person_scores;

--Unique scores above 500:
SELECT DISTINCT score
FROM person_scores
WHERE score > 500;


--7. Aggregations (Real Interview Type)

-- Find the highest score achieved in each country
SELECT country, MAX(score) AS highest_score
FROM person_scores
GROUP BY country;

-- Find the total number of records
SELECT COUNT(*) AS total_record
FROM person_scores;

-- Find the average score including zero values
SELECT AVG(score) AS avg_score
FROM person_scores;

-- Find the maximum and minimum scores
SELECT MAX(score) AS max_score, MIN(score) AS min_score
FROM person_scores;

-- Retrieve people with scores greater than 1000
SELECT name, score 
FROM person_scores
WHERE score > 1000;

-- Count how many people have scores above 500
SELECT COUNT(score) AS score
FROM person_scores
WHERE score > 500;