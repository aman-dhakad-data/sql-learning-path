/* ===============================================================================
ADVANCED JOINS PRACTICE
Concepts Covered:
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL JOIN
- CROSS JOIN
- Anti Joins
- Data Validation Queries
- Multi-Table Relationship Analysis
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO students VALUES
(1,'Aman','aman@mail.com'),
(2,'Riya','riya@mail.com'),
(3,'Kabir','kabir@mail.com'),
(4,'Sneha','sneha@mail.com'),
(5,'Arjun','arjun@mail.com'),
(6,'Neha','neha@mail.com'),
(7,'Rahul','rahul@mail.com'),
(8,'Pooja','pooja@mail.com');

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

INSERT INTO courses VALUES
(101,'SQL'),
(102,'Python'),
(103,'Power BI'),
(104,'Excel'),
(105,'Tableau');

CREATE TABLE enrollments (
    enroll_id INT PRIMARY KEY,
    student_id INT,
    course_id INT
);

INSERT INTO enrollments VALUES
(1,1,101),
(2,2,102),
(3,3,103),
(4,4,101),
(5,5,104),
(6,9,102),  -- invalid student
(7,2,110),  -- invalid course
(8,3,101),
(9,6,105);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    amount INT
);

INSERT INTO payments VALUES
(1,1,101,3000),
(2,2,102,5000),
(3,3,103,4500),
(4,4,101,3000),
(5,3,101,3000),
(6,10,101,3000),  -- non registered student
(7,5,999,2000);   -- non existing course

CREATE TABLE certificates (
    certificate_id INT PRIMARY KEY,
    student_id INT,
    course_id INT
);

INSERT INTO certificates VALUES
(1,1,101),
(2,2,102),
(3,3,103),
(4,7,101),  -- never enrolled
(5,3,105);  -- never enrolled

-- =============================================================================
-- VIEW TABLE DATA
-- =============================================================================

SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;
SELECT * FROM payments;
SELECT * FROM certificates;

--- =============================================================================
-- ADVANCED JOIN PRACTICE QUERIES
-- ==============================================================================

---------------------------------------------------------------------------------
-- INNER ANTI JOIN
---------------------------------------------------------------------------------

-- Find students who enrolled in courses but never made payments
SELECT e.* 
FROM enrollments AS e
LEFT JOIN payments AS p
ON e.student_id = p.student_id
AND e.course_id = p.course_id
WHERE p.payment_id IS NULL;

---------------------------------------------------------------------------------
-- LEFT ANTI JOIN
---------------------------------------------------------------------------------

-- Find registered students who never enrolled in any course
SELECT s.* 
FROM students AS s
LEFT JOIN enrollments AS e
ON s.student_id = e.student_id
WHERE e.enroll_id IS NULL;

---------------------------------------------------------------------------------
-- RIGHT ANTI JOIN
---------------------------------------------------------------------------------

-- Find enrollments with invalid or missing student records
SELECT e.* 
FROM students s
RIGHT JOIN enrollments e
ON s.student_id = e.student_id
WHERE s.student_id IS NULL;

---------------------------------------------------------------------------------
-- FULL ANTI JOIN
---------------------------------------------------------------------------------

-- Find mismatched enrollment and payment records
SELECT * FROM enrollments e
FULL JOIN payments p
ON e.student_id = p.student_id
AND e.course_id = p.course_id
WHERE e.enroll_id IS NULL
   OR p.payment_id IS NULL;

---------------------------------------------------------------------------------
-- CROSS JOIN
---------------------------------------------------------------------------------

-- Generate all possible student and course combinations
SELECT  
    s.name,
	c.course_name
FROM students AS s
CROSS JOIN courses AS c;

---------------------------------------------------------------------------------
-- LEFT JOIN
---------------------------------------------------------------------------------

-- Find students who made payments but never received certificates
SELECT p.* 
FROM payments AS p
LEFT JOIN certificates AS c
ON p.student_id = c.student_id
AND p.course_id = c.course_id
WHERE c.certificate_id IS NULL;

-- Find students who received certificates without making payments
SELECT c.* 
FROM certificates AS c 
LEFT JOIN  payments AS p
ON p.student_id = c.student_id
AND p.course_id = c.course_id
WHERE p.payment_id IS NULL;