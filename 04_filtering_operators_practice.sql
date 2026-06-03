/* ===============================================================================
ADVANCED FILTERING PRACTICE
Concepts Covered:
- WHERE Clause
- Logical Operators
- BETWEEN
- IN / NOT IN
- LIKE
- NULL Handling
- Subqueries
- Interview-Based Filtering Scenarios
=============================================================================== */

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(30) NOT NULL,
    city VARCHAR(30),
    salary INT CHECK (salary >= 0),
    experience INT CHECK (experience >= 0),
    joining_year INT CHECK (joining_year BETWEEN 2000 AND 2030)
);

INSERT INTO employees (emp_id, name, department, city, salary, experience, joining_year)
VALUES  (1,'Aman','IT','Delhi',45000,2,2022),
		(2,'Riya','HR','Mumbai',38000,1,2023),
		(3,'Kabir','IT','Pune',72000,5,2019),
		(4,'Sneha','Finance','Delhi',68000,4,2020),
		(5,'Arjun','Sales','Jaipur',30000,1,2024),
		(6,'Neha','IT','Mumbai',95000,7,2017),
		(7,'Rahul','HR','Pune',41000,3,2021),
		(8,'Pooja','Finance','Delhi',120000,10,2015),
		(9,'Vivek','IT','Bangalore',87000,6,2018),
		(10,'Meera','Sales','Mumbai',29000,1,2024),
		(11,'Karan','IT','Delhi',150000,12,2012),
		(12,'Isha','HR','Jaipur',36000,2,2022),
		(13,'Mohit','Sales','Pune',52000,4,2020),
		(14,'Nisha','Finance','Bangalore',99000,8,2016),
		(15,'Taran','IT',NULL,61000,3,2021),
		(16,'Zoya','HR','Delhi',43000,2,2022),
		(17,'Aditya','Sales','Mumbai',75000,5,2019),
		(18,'Kavya','IT','Pune',110000,9,2016),
		(19,'Rohan','Finance','Jaipur',47000,3,2021),
		(20,'Simran','HR','Bangalore',39000,2,2023);

SELECT COUNT(*) FROM employees;

SELECT *
FROM employees;

-- =============================================================================
-- LEVEL 1 — BASIC FILTERING
-- =============================================================================

-- Retrieve employees with salaries below 50,000
SELECT * FROM employees
WHERE salary < 50000;

-- Retrieve employees working in the Finance department
SELECT * FROM employees
WHERE department = 'Finance';

-- Retrieve employees with more than 5 years of experience
SELECT * FROM employees
WHERE experience > 5;

-- Retrieve employees who joined in 2022
SELECT * FROM employees
WHERE joining_year = 2022;

-- Retrieve employees who are not working in the IT department
SELECT * FROM employees
WHERE department <> 'IT';

-- =============================================================================
-- Level 2 — Logical operators (AND / OR / NOT)
-- =============================================================================

-- Retrieve employees working in the IT department and located in Pune
SELECT * FROM employees
WHERE department = 'IT' AND city = 'Pune';

-- Retrieve employees working in the HR or Sales departments
SELECT * FROM employees
WHERE department = 'HR' OR department = 'Sales';

-- Retrieve employees with salaries between 40,000 and 90,000 and experience greater than 3 years
SELECT * FROM employees
WHERE salary BETWEEN 40000 AND 90000 AND experience > 3;

-- Retrieve employees located in Mumbai but not working in the Sales department
SELECT * FROM employees
WHERE city = ('Mumbai') AND department NOT IN ('Sales');

-- Retrieve employees who joined after 2020 and earn more than 60,000
SELECT * FROM employees
WHERE joining_year > 2020 AND salary > 60000;

SELECT * 
FROM employees;

-- =============================================================================
-- Level 3 — Range & Membership
-- =============================================================================

-- Retrieve employees with experience between 2 and 5 years
SELECT * FROM employees
WHERE experience BETWEEN 2 AND 5;

--- Retrieve employees working in Delhi, Mumbai, or Bangalore
SELECT * FROM employees
WHERE city IN ('Delhi', 'Mumbai', 'Bangalore');

-- Retrieve employees excluding the HR and Finance departments
SELECT * FROM employees
WHERE department NOT IN ('HR', 'Finance');

-- Retrieve employees with salaries between 70,000 and 120,000
SELECT * FROM employees
WHERE salary BETWEEN 70000 AND 120000;

-- Retrieve employees who joined in 2016, 2017, or 2018
SELECT * FROM employees
WHERE joining_year IN (2016, 2017, 2018);

-- =============================================================================
-- Level 4 — Text Search (LIKE)
-- =============================================================================

-- Retrieve employees whose names start with the letter 'A'
SELECT * FROM employees
WHERE name LIKE 'A%';

-- Retrieve employees whose names end with the letter 'a'
SELECT * FROM employees
WHERE LOWER(name) LIKE '%a';

-- Retrieve employees whose names contain 'ee'
SELECT * FROM employees
WHERE name LIKE '%ee%';

-- Retrieve employees with 5-letter names
SELECT * FROM employees
WHERE name LIKE '_____';

-- Retrieve employees whose names start with 'R' and end with 'a'
SELECT * FROM employees
WHERE name LIKE 'R%a';

-- =============================================================================
-- Level 5 — NULL & Tricky
-- =============================================================================

-- Retrieve employees with unknown city values
SELECT * FROM employees
WHERE city IS NULL;

-- Retrieve employees with known city values
SELECT * FROM employees
WHERE city IS NOT NULL;

-- Retrieve employees whose city is not Jaipur
SELECT * FROM employees
WHERE city <> 'Jaipur' OR city IS NULL;

-- Retrieve employees with non-NULL salary values
SELECT * FROM employees
WHERE salary IS NOT NULL;

-- Retrieve IT employees who are not located in Bangalore
SELECT * FROM employees
WHERE department = 'IT'
AND (city <> 'Bangalore' OR city IS NULL);

-- =============================================================================
-- Level 6 — Interview Traps 🧠
-- =============================================================================

-- Retrieve employees with 3, 5, or 7 years of experience
SELECT * FROM employees
WHERE experience IN (3,5,7);

-- Retrieve employees with salaries above 80,000 or experience greater than 8 years, excluding HR employees
SELECT * FROM employees
WHERE (salary > 80000 OR experience > 8)
AND department <> 'HR';

-- Retrieve IT employees with salaries above 90,000 or experience greater than 10 years
SELECT * FROM employees
WHERE (salary > 90000 OR experience > 10)
AND department = 'IT';

-- Retrieve Sales employees not located in Mumbai or Pune
SELECT * FROM employees
WHERE department = 'Sales'
AND (city NOT IN ('Mumbai','Pune') OR city IS NULL);

-- Retrieve employees whose names contain 'a' but do not start with 'a'
SELECT * FROM employees
WHERE LOWER(name) LIKE '%a%'
AND LOWER(name) NOT LIKE 'a%';

-- =============================================================================
-- Bonus Hard (real analyst thinking)
-- =============================================================================

--Most experienced employees except IT
SELECT * FROM employees
WHERE experience = (
    SELECT MAX(experience)
    FROM employees
)
AND department <> 'IT';

-- Retrieve employees hired within the last 3 years
SELECT * FROM employees
WHERE joining_year >= 2024;

-- Retrieve high-paid employees with low experience
SELECT * FROM employees
WHERE salary > 90000 AND experience < 3;

-- Retrieve employees from cities with multiple departments
SELECT * FROM employees
WHERE city IN (
    SELECT city
    FROM employees
    GROUP BY city
    HAVING COUNT(DISTINCT department) > 1
);

SELECT city, count(department) as department_names
FROM employees
GROUP BY city
HAVING COUNT(DISTINCT department) > 1;

-- Retrieve potential interns based on salary or experience
SELECT * FROM employees
WHERE salary < 30000 OR experience <=1;
