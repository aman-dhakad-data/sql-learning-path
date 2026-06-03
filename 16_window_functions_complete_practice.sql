/* ===============================================================================
WINDOW FUNCTIONS PRACTICE
Concepts Covered:
- SUM() OVER()
- AVG() OVER()
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- NTILE()
- LEAD()
- LAG()
- FIRST_VALUE()
- LAST_VALUE()
- CUME_DIST()
- PERCENT_RANK()
- Running Totals
- Department-wise Analytics
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================
CREATE TABLE employees (
    emp_id INT,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    hire_date DATE
);

-- =============================================================================
-- SAMPLE DATA INSERTION
-- =============================================================================
INSERT INTO employees VALUES
(1, 'Amit',    'IT',      70000, '2020-01-15'),
(2, 'Priya',   'IT',      85000, '2019-03-10'),
(3, 'Rahul',   'IT',      90000, '2018-07-22'),
(4, 'Sneha',   'HR',      60000, '2021-06-01'),
(5, 'Vikram',  'HR',      72000, '2020-09-14'),
(6, 'Kavya',   'HR',      68000, '2022-02-28'),
(7, 'Arjun',   'Finance', 95000, '2017-11-05'),
(8, 'Meera',   'Finance', 88000, '2019-08-19'),
(9, 'Rohan',   'Finance', 76000, '2021-04-30'),
(10,'Divya',   'IT',      70000, '2020-01-15');

-- =============================================================================
-- VIEW TABLE DATA
-- =============================================================================
SELECT * 
FROM employees;

-- =============================================================================
-- WINDOW FUNCTION PRACTICE QUERIES
-- =============================================================================

-- =============================================================================
-- WINDOW AGGREGATIONS
-- =============================================================================
-- Calculate total department salary using window aggregation
SELECT
    name,
	department,
	salary,
	SUM(salary) OVER(PARTITION BY department) AS dept_total_salary
FROM employees;	

-- Calculate running total salary based on hire date
SELECT
    name,
	salary,
	hire_date,
	SUM(salary) OVER(ORDER BY hire_date) AS running_total
FROM employees;	

-- Calculate department-wise employee count
SELECT 
		name,
		department,
		COUNT(*) OVER(PARTITION BY department) AS department_headcount
FROM employees;

-- Calculate department-wise salary statistics
SELECT 
		name,
		department,
		salary,
		ROUND(AVG(salary) OVER(PARTITION BY department),0) AS avg_salary,
		MIN(salary) OVER(PARTITION BY department) AS min_salary,
		MAX(salary) OVER(PARTITION BY department) AS max_salary
FROM employees;

-- =============================================================================
-- RANKING FUNCTIONS
-- =============================================================================
-- Assign row numbers to employees based on salary within each department
SELECT 
		name,
		department,
		salary,
		ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS row_num
FROM employees;

-- Rank employees by salary within each department
SELECT 
		name,
		department,
		salary,
		RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM employees;

-- Generate dense salary rankings across all employees
SELECT 
		name,
		salary,
		DENSE_RANK() OVER(ORDER BY salary DESC) AS dense_salary_rank
FROM employees;

-- Calculate cumulative salary distribution
SELECT 
		name,
		salary,
		CUME_DIST() OVER(ORDER BY salary) AS cumulative_distribution
FROM employees;

-- Calculate percentage-based salary ranking
SELECT 
		name,
		salary,
		ROUND(PERCENT_RANK() OVER(ORDER BY salary), 2) AS percent_salary_rank
FROM employees;


-- Divide employees into four salary quartiles
SELECT 
    name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS quartile
FROM employees;

-- =============================================================================
-- LEAD AND LAG ANALYSIS
-- =============================================================================
-- Compare employee salaries with upcoming records using LEAD()
SELECT 
		name,
		hire_date,
		salary,
		LEAD(salary, 2, 0) OVER(PARTITION BY department ORDER BY hire_date) AS next_employee_salary
FROM employees;

-- Compare employee salaries with previous records using LAG()
SELECT 
		name,
		hire_date,
		salary,
		LAG(salary, 1, 0) OVER(PARTITION BY department ORDER BY hire_date) AS previous_employee_salary,
		salary - LAG(salary, 1, salary) OVER(PARTITION BY department ORDER BY hire_date) AS salary_diff
FROM employees;

-- =============================================================================
-- FIRST_VALUE AND LAST_VALUE
-- =============================================================================
-- Retrieve the highest-paid employee in each department
SELECT
		name,
		department,
		salary,
		FIRST_VALUE(name) OVER(PARTITION BY department ORDER BY salary DESC) AS highest_paid_in_dept
FROM employees;

-- Retrieve the lowest-paid employee in each department
SELECT 
    name,
    department,
    salary,
    LAST_VALUE(name) OVER (
        PARTITION BY department 
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_paid_in_dept
FROM employees;

-- =============================================================================
-- ADVANCED WINDOW FUNCTION ANALYSIS
-- =============================================================================
-- =============================================================================
-- TOP-N ANALYSIS
-- =============================================================================
-- Retrieve the top 2 highest-paid employees from each department
SELECT * FROM(
		SELECT 
				name,
				department,
				salary,
				DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rnk
		FROM employees
) ranked
        WHERE rnk <= 2;