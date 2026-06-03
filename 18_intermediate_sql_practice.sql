/* ===============================================================================
INTERMEDIATE SQL PRACTICE
Concepts Covered:
- JOIN Operations
- Anti Joins
- SET Operators
- String Functions
- Number Functions
- Date & Time Functions
- NULL Handling
- CASE Statements
- Multi-table Analysis
=============================================================================== */

-- =============================================================================
-- TABLES FOR: JOINs, SET OPERATORS, ROW-LEVEL FUNCTIONS
-- =============================================================================
-- =============================================================================
-- TABLE 1: cities 
-- =============================================================================
CREATE TABLE cities (
    city_id   INT          PRIMARY KEY,
    city_name VARCHAR(50)  NOT NULL,
    state     VARCHAR(50)
);

INSERT INTO cities (city_id, city_name, state) VALUES
(1, 'Mumbai',    'Maharashtra'),
(2, 'Delhi',     'Delhi'),
(3, 'Bangalore', 'Karnataka'),
(4, 'Hyderabad', 'Telangana'),
(5, 'Chennai',   'Tamil Nadu'),
(6, 'Kolkata',   'West Bengal');
-- NOTE: city_id 6 (Kolkata) has no students — intentional for LEFT JOIN practice

-- =============================================================================
-- TABLE 2: departments
-- =============================================================================
CREATE TABLE departments (
    dept_id   INT          PRIMARY KEY,
    dept_name VARCHAR(50)  NOT NULL,
    hod       VARCHAR(100)  -- Head of Department (intentionally NULL for some)
);

INSERT INTO departments (dept_id, dept_name, hod) VALUES
(1, 'Computer Science', 'Dr. Meera Iyer'),
(2, 'Mathematics',      'Dr. Rakesh Gupta'),
(3, 'Physics',          NULL),             -- no HOD assigned
(4, 'History',          'Dr. Anita Bose'); -- no instructors assigned — for LEFT ANTI JOIN

-- =============================================================================
-- TABLE 3: instructors
-- =============================================================================
CREATE TABLE instructors (
    instructor_id   INT           PRIMARY KEY,
    instructor_name VARCHAR(100)  NOT NULL,
    dept_id         INT,
    email           VARCHAR(100),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO instructors (instructor_id, instructor_name, dept_id, email) VALUES
(1, 'Prof. Arjun Das',     1, 'arjun@uni.edu'),
(2, 'Prof. Sunita Rao',    1, 'sunita@uni.edu'),
(3, 'Prof. Vivek Tiwari',  2, 'vivek@uni.edu'),
(4, 'Prof. Kiran Mehta',   3, 'kiran@uni.edu'),
(5, 'Prof. Riya Sharma',   NULL, 'riya@uni.edu'); -- no department assigned — for NULL join practice

-- =============================================================================
-- TABLE 4: courses
-- =============================================================================
CREATE TABLE courses (
    course_id     INT           PRIMARY KEY,
    course_name   VARCHAR(100)  NOT NULL,
    instructor_id INT,
    credits       INT           DEFAULT 3,
    dept_id       INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id),
    FOREIGN KEY (dept_id)       REFERENCES departments(dept_id)
);

INSERT INTO courses (course_id, course_name, instructor_id, credits, dept_id) VALUES
(101, 'Database Systems',      1, 4, 1),
(102, 'Data Structures',       2, 3, 1),
(103, 'Linear Algebra',        3, 4, 2),
(104, 'Quantum Mechanics',     4, 4, 3),
(105, 'Machine Learning',      1, 4, 1),
(106, 'Ancient Civilizations', NULL, 3, 4), -- no instructor assigned
(107, 'Topology',              NULL, 3, 2); -- no instructor — for RIGHT JOIN practice

-- =============================================================================
-- TABLE 5: students
-- =============================================================================
CREATE TABLE students (
    student_id   INT           PRIMARY KEY,
    student_name VARCHAR(100)  NOT NULL,
    city_id      INT,
    email        VARCHAR(100),
    enroll_year  INT,
    gpa          DECIMAL(3,2),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

INSERT INTO students (student_id, student_name, city_id, email, enroll_year, gpa) VALUES
(1,  'Aarav Mehta',   1, 'aarav@mail.com',   2022, 8.50),
(2,  'Priya Singh',   2, 'priya@mail.com',   2021, 9.10),
(3,  'Rohan Verma',   3, 'rohan@mail.com',   2022, 7.80),
(4,  'Sneha Joshi',   1, 'sneha@mail.com',   2023, 8.20),
(5,  'Karan Patel',   4, 'karan@mail.com',   2021, 6.90),
(6,  'Meera Nair',    5, 'meera@mail.com',   2023, 9.50),
(7,  'Dev Sharma',    2, 'dev@mail.com',     2022, 7.40),
(8,  'Ananya Rao',    3, 'ananya@mail.com',  2021, 8.80),
(9,  'Vikram Das',    NULL, 'vikram@mail.com', 2023, 7.20), -- no city — for NULL/LEFT JOIN
(10, 'Nisha Kulkarni',1, 'nisha@mail.com',   2022, 9.00);

-- =============================================================================
-- TABLE 6: enrollments (junction table)
-- =============================================================================
CREATE TABLE enrollments (
    enrollment_id INT  PRIMARY KEY,
    student_id    INT,
    course_id     INT,
    grade         VARCHAR(2),
    enrolled_on   DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id)  REFERENCES courses(course_id)
);

INSERT INTO enrollments (enrollment_id, student_id, course_id, grade, enrolled_on) VALUES
(1,  1,  101, 'A',  '2022-07-15'),
(2,  1,  102, 'B+', '2022-07-15'),
(3,  2,  101, 'A+', '2021-07-10'),
(4,  2,  103, 'A',  '2021-07-10'),
(5,  3,  102, 'B',  '2022-07-20'),
(6,  4,  101, 'A',  '2023-07-12'),
(7,  4,  105, 'B+', '2023-07-12'),
(8,  5,  103, 'C+', '2021-07-08'),
(9,  6,  105, 'A+', '2023-07-18'),
(10, 7,  102, 'B',  '2022-07-22'),
(11, 8,  104, 'A',  '2021-07-05'),
(12, 8,  101, 'A+', '2021-07-05'),
(13, 10, 101, 'A',  '2022-07-14'),
(14, 10, 105, 'A+', '2022-07-14');
-- NOTE: student_id 9 (Vikram) has NO enrollments — for anti-join practice

-- =============================================================================
-- TABLE 7: archived_students (same structure as students — for SET OPERATORS)
-- =============================================================================
CREATE TABLE archived_students (
    student_id   INT,
    student_name VARCHAR(100),
    city_id      INT,
    email        VARCHAR(100),
    enroll_year  INT,
    gpa          DECIMAL(3,2)
);

INSERT INTO archived_students (student_id, student_name, city_id, email, enroll_year, gpa) VALUES
(1,  'Aarav Mehta',    1, 'aarav@mail.com',    2022, 8.50), -- duplicate of students
(11, 'Tanvi Kapoor',   2, 'tanvi@mail.com',    2019, 7.60),
(12, 'Harsh Gupta',    3, 'harsh@mail.com',    2020, 8.10),
(13, 'Pooja Tiwari',   4, 'pooja@mail.com',    2018, 6.50),
(14, 'Siddharth Rao',  5, 'sid@mail.com',      2020, 9.20),
(2,  'Priya Singh',    2, 'priya@mail.com',    2021, 9.10); -- another duplicate

-- =============================================================================
-- VERIFY
-- =============================================================================
SELECT 'cities'            AS tbl, COUNT(*) FROM cities            UNION ALL
SELECT 'departments'       AS tbl, COUNT(*) FROM departments       UNION ALL
SELECT 'instructors'       AS tbl, COUNT(*) FROM instructors       UNION ALL
SELECT 'courses'           AS tbl, COUNT(*) FROM courses           UNION ALL
SELECT 'students'          AS tbl, COUNT(*) FROM students          UNION ALL
SELECT 'enrollments'       AS tbl, COUNT(*) FROM enrollments       UNION ALL
SELECT 'archived_students' AS tbl, COUNT(*) FROM archived_students;


--The 40 Practice Questions
-- =============================================================================
-- SECTION A - BASIC JOINs (INNER, LEFT, RIGHT, FULL)
-- =============================================================================

-- J1 — Show each student's name and the city they belong to. (INNER JOIN)
SELECT s.student_name, c.city_name
FROM students s
INNER JOIN cities c
ON c.city_id = s.city_id;

  
-- J2 — Show all students along with their city name. Students with no 
-- city should also appear. (LEFT JOIN)
SELECT s.student_name, c.city_name
FROM students s
LEFT JOIN cities c
ON c.city_id = s.city_id;


-- J3 — Show all cities along with students who belong to them. Cities with
-- no students should also appear. (RIGHT JOIN or LEFT JOIN reversed)
SELECT c.city_name, s.student_name
FROM cities c
LEFT JOIN students s
ON c.city_id = s.city_id;


-- J4 — Show all courses along with their instructor's name. Courses without
-- instructors should still show. (LEFT JOIN)
SELECT c.course_name, i.instructor_name
FROM  courses c
LEFT JOIN instructors i
ON c.instructor_id= i.instructor_id;


-- J5 — Show each enrollment with: student name, course name, and grade. (3-table INNER JOIN)
SELECT s.student_name,
       c.course_name,
	   e.grade
FROM  enrollments e
INNER JOIN students s
ON s.student_id = e.student_id
INNER JOIN courses c 
ON e.course_id = c.course_id;


-- J6 — Show each instructor's name and their department name. Include
--      instructors who don't have a department. (LEFT JOIN)
SELECT i.instructor_name, 
       d.dept_name
FROM instructors i
LEFT JOIN departments d
ON i.dept_id = d.dept_id;

-- J7 — Show all departments and all instructors. Even departments with
--      no instructors and instructors with no department should appear. (FULL OUTER JOIN)
SELECT i.instructor_name, 
       d.dept_name
FROM instructors i
FULL OUTER JOIN departments d
ON i.dept_id = d.dept_id;


-- J8 — Retrieve each course along with its instructor and department name (3-table JOIN)
SELECT c.course_name,
       i.instructor_name,
	   d.dept_name
FROM courses c
LEFT JOIN instructors i ON c.instructor_id = i.instructor_id
LEFT JOIN departments d ON c.dept_id = d.dept_id;

-- J9 — For each student who is enrolled in at least one course, show their name,
--      the course name, and the instructor who teaches it. (3-table JOIN via enrollments)
SELECT s.student_name,
       c.course_name,
	   i.instructor_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id;


-- J10 — Show all students and all courses, pairing every student with every course.
--       Use CROSS JOIN to generate every possible student-course combination
SELECT * FROM students s
CROSS JOIN courses c;


-- =============================================================================
-- SECTION B — ANTI JOINS
-- =============================================================================

-- AJ1 — Find students who are NOT enrolled in any course. (LEFT ANTI JOIN)
SELECT s.student_name
FROM Students s
LEFT JOIN Enrollments e 
ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

--ANOTHER WAY
SELECT *
FROM Students s
WHERE NOT EXISTS (
    SELECT 1 
    FROM Enrollments e 
    WHERE s.student_id = e.student_id
);


-- AJ2 — Find courses that have NO students enrolled. (LEFT ANTI JOIN on courses side)
SELECT c.course_name
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

--ANOTHER WAY
SELECT * FROM courses c
WHERE NOT EXISTS (
      SELECT 1
	  FROM enrollments e
	  WHERE c.course_id = e.course_id
);


-- AJ3 — Find departments that have no instructors assigned. (LEFT ANTI JOIN)
SELECT d.dept_name
FROM departments d
LEFT JOIN instructors i
ON d.dept_id = i.dept_id
WHERE i.dept_id IS NULL;

--ANOTHER WAY
SELECT * FROM departments d
WHERE NOT EXISTS (
       SELECT 1 
	   FROM instructors i
	   WHERE d.dept_id = i.dept_id
);


-- AJ4 — Find instructors who are not teaching any course. (RIGHT ANTI JOIN or LEFT ANTI JOIN)
SELECT i.instructor_name
FROM instructors i
LEFT JOIN courses c
ON i.instructor_id = c.instructor_id
WHERE c.instructor_id IS NULL;

--ANOTHER WAY
SELECT * FROM instructors i
WHERE NOT EXISTS(
      SELECT 1 
	  FROM courses c
	 where i.instructor_id = c.instructor_id
);


-- AJ5 — Find cities that have no students. (LEFT ANTI JOIN on cities)
SELECT c.city_name
FROM cities c
LEFT JOIN students s
ON c.city_id = s.city_id
WHERE s.city_id IS NULL;

--ANOTHER WAY
SELECT * FROM cities c
WHERE NOT EXISTS (
      SELECT 1
	  FROM students s
	  WHERE c.city_id = s.city_id
);


-- =============================================================================
-- SECTION C — SET OPERATORS
-- =============================================================================

-- S1 — Combine all students from students and archived_students into one list.
--      Include duplicates. (UNION ALL)
SELECT * 
FROM students
UNION ALL
SELECT *
FROM archived_students;


-- S2 — Same as above but remove duplicates. (UNION)
SELECT * 
FROM students
UNION
SELECT * 
FROM archived_students;


-- S3 — Find students who exist in BOTH students and archived_students — i.e.,
--      students who were archived but are also currently active. (INTERSECT)
SELECT *
FROM students
INTERSECT
SELECT * 
FROM archived_students;


-- S4 — Find students who are in students but NOT in archived_students. (EXCEPT)
SELECT * 
FROM students
EXCEPT
SELECT * 
FROM archived_students;


-- S5 — Find students who are in archived_students but NOT in students. (EXCEPT — reversed)
SELECT * 
FROM archived_students
EXCEPT
SELECT * 
FROM students;


-- S6 — From students, get names of students enrolled in 2022. From archived_students,
--      get names of students enrolled in 2020. Combine both lists without duplicates and 
--      sort the final result alphabetically by student name.
SELECT student_name
FROM students
WHERE enroll_year = 2022

UNION

SELECT student_name
FROM archived_students
WHERE enroll_year = 2020
ORDER BY student_name;


-- =============================================================================
-- SECTION D — STRING FUNCTIONS
-- =============================================================================

-- STR1 — Show all student names in UPPERCASE.
SELECT UPPER(student_name) 
FROM students;


-- STR2 — Extract instructor names excluding the title prefix
--       (everything before the space after "Prof."). Use SPLIT_PART or SUBSTRING.
SELECT SPLIT_PART(instructor_name, ' ', 2) AS first_name 
FROM instructors;


-- STR3 — Show each student's email domain (the part after '@').
SELECT SUBSTRING(email FROM POSITION('@' IN email) + 1) AS domain
FROM students;
--OR
SELECT email, SPLIT_PART(email, '@', 2) AS domain
FROM students;


-- STR4 — Concatenate student name and email into one column like: "Aarav Mehta <aarav@mail.com>".
SELECT CONCAT(student_name, '<',email, '>' ) AS full_email
FROM students;


-- STR5 — Find students whose name contains exactly 10 characters. (Use LENGTH)
SELECT student_name FROM students
WHERE length(student_name) = 10;

-- STR6 — Show course names with all spaces replaced by underscores.
SELECT REPLACE(course_name, ' ', '_') AS course_with_underscore
FROM courses;


-- =============================================================================
-- SECTION E — NUMBER FUNCTIONS
-- =============================================================================

-- NUM1 — Show each student's GPA rounded to 1 decimal place.
SELECT *, ROUND(gpa, 1) as round_gpa FROM students;


-- NUM2 — Show the floor and ceiling of each student's GPA.
SELECT *,
       FLOOR(gpa) AS floor_gpa,
       CEILING(gpa) AS ceil_gpa
FROM students;


-- NUM3 — Calculate the absolute difference between each student's GPA and
--        the class average GPA. (Use ABS + subquery or window — try it both ways)
SELECT *, 
      ABS( gpa- (SELECT AVG(gpa) FROM students)) AS gpa_difference
FROM students;

-- Alternative Solution Using Window Functions
SELECT *, 
       ABS(gpa - AVG(gpa) OVER()) AS gpa_difference
FROM students;


-- NUM4 — Show each course's credits and the square root of credits. (Use SQRT)
SELECT credits, 
       SQRT(credits) AS credits_sqrt
FROM courses;  


-- =============================================================================
-- SECTION F — DATE & TIME FUNCTIONS
-- =============================================================================

-- DT1 — Show today's date.
SELECT CURRENT_DATE; 


-- DT2 — Show each enrollment's date and extract the month from it.
SELECT enrolled_on, 
       EXTRACT(MONTH FROM enrolled_on) AS enrollment_month
FROM enrollments;
-- OR
SELECT enrolled_on, 
       to_char(enrolled_on, 'Month') AS enrollment_month
FROM enrollments;

-- DT3 — Calculate how many days have passed since each student enrolled 
--       (using enroll_year — Use date construction or year extraction techniques
--       year and subtract from current year).
SELECT student_name, 
       CURRENT_DATE - CAST(enroll_year || '-01-01' AS DATE) AS days_passed
FROM students;
--OR
SELECT student_name,
       EXTRACT(YEAR FROM CURRENT_DATE) - enroll_year AS since_enrolled  
FROM students;
--OR
SELECT student_name, 
       AGE(CURRENT_DATE, CAST(enroll_year || '-01-01' AS DATE)) AS time_passed
FROM students;


-- DT4 — Show enrollments where the enrolled_on date was in the second 
-- half of July 2022 (after July 15).
SELECT *
FROM enrollments
WHERE enrolled_on >= '2022-07-16'
AND enrolled_on < '2022-08-01'


-- =============================================================================
-- SECTION G — NULL FUNCTIONS & CASE
-- =============================================================================

-- N1 — Show all instructors. For those with no department, 
-- display 'Unassigned' instead of NULL. (Use COALESCE)
SELECT instructor_id,
       instructor_name,
       COALESCE(CAST(dept_id AS VARCHAR), 'Unassigned') AS department
FROM instructors;


-- N2 — Show all students. For those with no city, 
-- display 'City Unknown'. (Use COALESCE with a JOIN) 
SELECT s.student_name,
       COALESCE(c.city_name::TEXT, 'City Unknown') AS city_name
FROM students s
    LEFT JOIN cities c
    ON c.city_id = s.city_id;

-- N3 — Classify students based on GPA ranges using CASE: GPA >= 9.0 = 'Distinction', 
--      8.0–8.9 = 'First Class', 7.0–7.9 = 'Second Class', below 7.0 = 'Pass'.
SELECT student_id,
       student_name,
	   CASE
	       WHEN GPA >= 9.0 THEN 'Distinction'
		   WHEN GPA >= 8.0 THEN 'First Class'
		   WHEN GPA >= 7.0 THEN 'Second Class'
		   ELSE 'Pass' 
		   END AS students_gpa_rank
FROM students; 


-- N4 — Use CASE to show whether each course has an instructor 
-- assigned or not: 'Assigned' / 'Unassigned'.
SELECT course_id,
       course_name, 
	   CASE
            WHEN instructor_id IS NULL THEN 'Unassigned'
			ELSE 'Assigned'
			END AS instructor
FROM courses;


-- N5 — Show each student's name and grade from enrollments. 
--      For any NULL grade, show 'Not Graded'. (Use COALESCE or CASE)
SELECT s.student_name,
       COALESCE (e.grade, 'Not Graded') AS grade
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id;

--OR

SELECT s.student_name,
       CASE 
	       WHEN grade IS NULL THEN 'Not Graded'
		   ELSE grade
		   END AS grade
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id;