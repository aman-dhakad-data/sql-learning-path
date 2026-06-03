/* ===============================================================================
JOINS PRACTICE
Concepts Covered:
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL JOIN
- Cartesian Product
- Aggregations with JOINs
- Data Validation Scenarios

-------------------------------------------------------------------------------
-- NOTE:
-- Some queries in this file use PostgreSQL-specific syntax.
=============================================================================== */

CREATE TABLE students (
     student_id INT PRIMARY KEY,
	 student_name VARCHAR (50),
	 city VARCHAR (50)
);

INSERT INTO students (student_id, student_name, city)
VALUES
(1,'Aman','Delhi'),
(2,'Riya','Mumbai'),
(3,'Kabir','Pune'),
(4,'Sneha','Delhi'),
(5,'Arjun','Jaipur'),
(6,'Neha','Mumbai'),
(7,'Rahul','Pune'),
(8,'Pooja','Delhi'),
(9,'Karan','Bangalore'),
(10,'Meera','Chennai');

SELECT * 
FROM students;

CREATE TABLE courses (
     course_id INT PRIMARY KEY,
	 student_id INT,
	 course_name VARCHAR (50),
	 fees INT
);

INSERT INTO courses ( course_id, student_id, course_name, fees) VALUES
(101,1,'SQL',3000),
(102,2,'Python',5000),
(103,3,'Power BI',4500),
(104,4,'Excel',2000),
(105,6,'Python',5000),
(106,7,'SQL',3000),
(107,8,'Tableau',4000),
(108,11,'SQL',3000),      -- student not exist
(109,12,'AI',8000),       -- student not exist
(110,3,'Statistics',3500);

SELECT * 
FROM courses;

-- =============================================================================
-- JOIN PRACTICE QUERIES
-- =============================================================================

--------------------------------------------------------------------------------
-- INNER JOIN
--------------------------------------------------------------------------------

-- Retrieve all possible combinations of students and courses
SELECT * FROM students AS s
INNER JOIN courses AS c
ON s.student_id = c.student_id; 

-- Retrieve only students who are enrolled in courses
SELECT * FROM students AS s
INNER JOIN courses AS c 
ON s.student_id = c.student_id;

-- Retrieve student names along with their enrolled courses
SELECT 
	s.student_name,
	c.course_name
FROM students AS s
INNER JOIN courses AS c 
ON s.student_id = c.student_id;

--------------------------------------------------------------------------------
-- LEFT JOIN
---------------------------------------------------------------------------------

-- Retrieve all students regardless of course enrollment
SELECT * FROM students AS s
LEFT JOIN courses AS c 
ON s.student_id = c.student_id;

-- Find students who have not enrolled in any course
SELECT 
    s.student_name,
	c.course_name
FROM students AS s
LEFT JOIN courses AS c
ON s.student_id = c.student_id
WHERE c.student_id IS NULL;

--------------------------------------------------------------------------------
-- RIGHT JOIN
--------------------------------------------------------------------------------

-- Retrieve all courses regardless of student availability
SELECT 
    s.student_name,
	c.course_name
FROM students AS s 
RIGHT JOIN courses AS c
ON s.student_id = c.student_id;

-- Find courses with invalid or missing student IDs
SELECT 
    c.course_id,
	c.student_id,
	c.course_name
FROM students AS s 
RIGHT JOIN courses AS c
ON s.student_id = c.student_id
WHERE s.student_id IS NULL;

--------------------------------------------------------------------------------
-- FULL JOIN
--------------------------------------------------------------------------------

-- Retrieve complete data from both students and courses tables
SELECT * FROM students AS s 
FULL JOIN courses AS c
ON s.student_id = c.student_id;

-- Identify unmatched records between students and courses

SELECT *
FROM students AS s
FULL JOIN courses AS c
ON s.student_id = c.student_id
WHERE s.student_id IS NULL
   OR c.student_id IS NULL;

--------------------------------------------------------------------------------
-- AGGREGATION
--------------------------------------------------------------------------------
   
-- Find students enrolled in two or more courses
SELECT 
    s.student_id,
	s.student_name,
	COUNT(c.course_id) AS total_courses
FROM students AS s
INNER JOIN courses AS c
ON s.student_id = c.student_id 
GROUP BY s.student_id , s.student_name
HAVING COUNT(c.course_id) >= 2;

SELECT COUNT(*) AS students_with_multiple_courses
FROM (
    SELECT s.student_id
    FROM students AS s
    INNER JOIN courses AS c
    ON s.student_id = c.student_id
    GROUP BY s.student_id
    HAVING COUNT(c.course_id) >= 2
) AS t;

-- Find the most popular course based on student enrollments
SELECT 
    c.course_name,
    COUNT(*) AS total_students
FROM students AS s
INNER JOIN courses AS c
ON s.student_id = c.student_id
GROUP BY c.course_name
ORDER BY total_students DESC
LIMIT 1;