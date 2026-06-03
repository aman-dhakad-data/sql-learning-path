/* ===============================================================================
SET OPERATORS PRACTICE
Concepts Covered:
- UNION
- UNION ALL
- INTERSECT
- EXCEPT
- Data Comparison Between Tables
- Duplicate Handling
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================

-- Engineering Students Table
CREATE TABLE engineering_students (
    student_id INT,
    name VARCHAR(50),
    city VARCHAR(50)
);

-- =============================================================================
-- SAMPLE DATA INSERTION
-- =============================================================================
INSERT INTO engineering_students (student_id, name, city) VALUES
(1,'Aman','Delhi'),
(2,'Riya','Mumbai'),
(3,'Kabir','Pune'),
(4,'Sneha','Delhi'),
(5,'Arjun','Jaipur'),
(6,'Neha','Mumbai'),
(7,'Rahul','Pune'),
(8,'Pooja','Delhi'),
(9,'Karan',NULL);

-- MBA Students Table
CREATE TABLE mba_students (
    student_id INT,
    name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO mba_students (student_id, name, city) VALUES
(5,'Arjun','Jaipur'),
(6,'Neha','Mumbai'),
(7,'Rahul','Pune'),
(10,'Meera','Chennai'),
(11,'Rohan','Delhi'),
(12,'Isha','Mumbai'),
(13,'Dev','Pune'),
(14,'Anita',NULL);

-- Scholarship Students Table
CREATE TABLE scholarship_students (
    student_id INT,
    name VARCHAR(50)
);

INSERT INTO scholarship_students (student_id, name) VALUES
(1,'Aman'),
(5,'Arjun'),
(10,'Meera'),
(14,'Anita'),
(15,'Unknown');

-- =============================================================================
-- VIEW TABLE DATA
-- =============================================================================
SELECT * 
FROM engineering_students;

SELECT * 
FROM mba_students;

SELECT * 
FROM scholarship_students; 

-- =============================================================================
-- SET OPERATOR PRACTICE QUERIES
-- =============================================================================

---------------------------------------------------------------------------------
--UNION
---------------------------------------------------------------------------------

-- Q1. Retrieve a combined list of Engineering and MBA students without duplicates
SELECT *
FROM engineering_students
UNION
SELECT * 
FROM mba_students;

---------------------------------------------------------------------------------
--UNION ALL
---------------------------------------------------------------------------------

-- Q2. Retrieve a combined list of students including duplicates
-- Useful for identifying students enrolled in both programs
SELECT *
FROM engineering_students
UNION ALL
SELECT * 
FROM mba_students;

---------------------------------------------------------------------------------
--INTERSECT
---------------------------------------------------------------------------------

-- Q3. Find students enrolled in both Engineering and MBA programs
SELECT student_id,
       name
FROM engineering_students
INTERSECT
SELECT student_id,
       name 
FROM mba_students;

---------------------------------------------------------------------------------
--EXCEPT
---------------------------------------------------------------------------------

-- Q4. Find Engineering students who are not enrolled in the MBA program
SELECT *
FROM engineering_students
EXCEPT
SELECT * 
FROM mba_students;

-- Q5. Find MBA students who are not enrolled in the Engineering program
SELECT student_id,
       name
FROM mba_students
EXCEPT
SELECT student_id,
       name
FROM engineering_students;

---------------------------------------------------------------------------------
-- Advanced Practice Queries
---------------------------------------------------------------------------------

-- Q6. Find scholarship students who are not enrolled in Engineering
SELECT 
     student_id,
	 name
FROM scholarship_students
EXCEPT
SELECT 
     student_id,
	 name
FROM engineering_students;

-- Q7. Find students enrolled in both programs who also received scholarships
SELECT 
     student_id
FROM engineering_students
INTERSECT
SELECT 
     student_id
FROM mba_students
INTERSECT
SELECT 
     student_id
FROM scholarship_students;

---------------------------------------------------------------------------------
-- REPORTING LOGIC
---------------------------------------------------------------------------------

-- Q8. Generate a unified student report showing participation across Engineering, MBA, and Scholarship programs
SELECT 
    s.student_id,
    s.name,

    CASE WHEN e.student_id IS NOT NULL THEN 1 ELSE 0 END AS is_engineering,
    CASE WHEN m.student_id IS NOT NULL THEN 1 ELSE 0 END AS is_mba,
    CASE WHEN sc.student_id IS NOT NULL THEN 1 ELSE 0 END AS is_scholarship

FROM (
    SELECT student_id, name FROM engineering_students
    UNION
    SELECT student_id, name FROM mba_students
    UNION
    SELECT student_id, name FROM scholarship_students
) s

LEFT JOIN engineering_students e
    ON s.student_id = e.student_id

LEFT JOIN mba_students m
    ON s.student_id = m.student_id

LEFT JOIN scholarship_students sc
    ON s.student_id = sc.student_id;