/* ===============================================================================
DML PRACTICE
Concepts Covered:
- INSERT
- UPDATE
- DELETE
- TRUNCATE
=============================================================================== */

CREATE TABLE student_courses (
		enrollment_id INT PRIMARY KEY,
		student_name VARCHAR (100) NOT NULL,
		course_name VARCHAR (100) NOT NULL,
		fees INT NOT NULL ,
		status VARCHAR (20),  -- active / completed / dropped
		join_date DATE NOT NULL
);


INSERT INTO student_courses ( enrollment_id, student_name, course_name, fees, status, join_date)
VALUES  (1,'Aman','SQL',3000,'active','2024-01-10'),
		(2,'Riya','Python',5000,'completed','2024-02-01'),
		(3,'Kabir','Power BI',4500,'active','2024-02-15'),
		(4,'Sneha','Excel',2000,'dropped','2024-03-01'),
		(5,'Arjun','SQL',3000,'active','2024-03-12'),
		(6,'Neha','Python',5000,'active','2024-04-05');


-- View current records
SELECT * 
FROM student_courses;

-- =============================================================================
-- INSERT PRACTICE
-- =============================================================================

-- Insert a new student with a fixed join date
-- Q1. Insert a new student named "Vikas" enrolled in the Power BI course

INSERT INTO student_courses ( enrollment_id, student_name, course_name, fees, status, join_date)
VALUES  (7, 'Vikas', 'Power BI', 4500 ,'active', '2026-02-12');

-- Q2. Insert a student named "Meera" with unknown fees temporarily set to 0.

INSERT INTO student_courses ( enrollment_id, student_name, course_name, fees, status, join_date)
VALUES  (8, 'Meera', 'Excel', 0 ,'active', '2026-02-12');


-- Q3. Insert two students in a single query
--	  Rahul – SQL    – 3000 – active
--	  Pooja – Python – 5000 – active

INSERT INTO student_courses ( enrollment_id, student_name, course_name, fees, status, join_date)
VALUES  (9, 'Rahul', 'SQL', 3000 ,'active', '2026-02-12'),
        (10, 'Pooja', 'Python', 5000 ,'active', '2026-02-12');

-- =============================================================================
-- UPDATE PRACTICE
-- =============================================================================

-- Q4. Update Kabir's course status to completed

UPDATE student_courses
SET status = 'completed'
WHERE enrollment_id = 3;

-- Q5. Update SQL course fees to 3500 for all students

UPDATE student_courses
SET fees = 3500
WHERE course_name = 'SQL';

-- Q6. Reactivate students with dropped status

UPDATE student_courses
SET status = 'active'
WHERE status = 'dropped';

-- Q7. Change Neha's course to Data Analytics and update the fees

UPDATE student_courses
SET course_name = 'Data Analytics',
    fees = 7000
WHERE enrollment_id = 6;

-- =============================================================================
-- DELETE PRACTICE
-- =============================================================================

-- Q8. Delete Sneha's record from the table

DELETE FROM student_courses
WHERE  enrollment_id = 4 ;

-- Q9. Remove students with fees below 2000 or NULL

DELETE FROM student_courses
WHERE fees < 2000 OR fees IS NULL;

-- Q10. Archive students with completed status

UPDATE student_courses
SET status = 'archived'
WHERE status = 'completed';

SELECT *
FROM student_courses
ORDER BY enrollment_id;

TRUNCATE TABLE student_courses;