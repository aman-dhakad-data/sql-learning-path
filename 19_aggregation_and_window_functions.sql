/* ===============================================================================
AGGREGATION AND WINDOW FUNCTIONS PRACTICE
Concepts Covered:
- Window Aggregate Functions
- PARTITION BY
- Running Totals
- Moving Averages
- Ranking Functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- NTILE()
- CUME_DIST()
- PERCENT_RANK()
- LEAD()
- LAG()
- FIRST_VALUE()
- LAST_VALUE()
- Analytical SQL Queries
=============================================================================== */

-- ============================================================
-- TABLES FOR: Aggregation & Window Functions Practice
-- ============================================================

-- TABLE 1: regions
CREATE TABLE regions (
    region_id   INT         PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL
);

INSERT INTO regions VALUES
(1, 'North'),
(2, 'South'),
(3, 'East'),
(4, 'West');

-- TABLE 2: employees
CREATE TABLE employees (
    emp_id      INT           PRIMARY KEY,
    emp_name    VARCHAR(100)  NOT NULL,
    department  VARCHAR(50),
    region_id   INT,
    salary      DECIMAL(10,2),
    hire_date   DATE,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

INSERT INTO employees VALUES
(1,  'Arjun Das',      'Sales',   1, 72000, '2020-03-15'),
(2,  'Meera Nair',     'HR',      2, 55000, '2019-07-01'),
(3,  'Vivek Tiwari',   'Sales',   1, 68000, '2021-01-10'),
(4,  'Sunita Rao',     'IT',      3, 95000, '2018-05-20'),
(5,  'Karan Mehta',    'HR',      2, 58000, '2022-02-14'),
(6,  'Priya Kapoor',   'IT',      3, 91000, '2019-11-30'),
(7,  'Rohit Sharma',   'Sales',   4, 72000, '2020-08-05'),  -- same salary as Arjun
(8,  'Anjali Singh',   'IT',      3, 87000, '2021-06-18'),
(9,  'Dev Gupta',      'HR',      1, 52000, '2023-01-25'),
(10, 'Nisha Patel',    'Sales',   4, 81000, '2020-12-01'),
(11, 'Sameer Khan',    'IT',      2, 95000, '2018-09-10'),  -- same salary as Sunita
(12, 'Pooja Tiwari',   'Sales',   2, 65000, '2022-05-17'),
(13, 'Amit Verma',     'HR',      4, 61000, '2021-03-08'),
(14, 'Kavya Reddy',    'IT',      1, 78000, '2020-07-22'),
(15, 'Rajesh Menon',   'Sales',   3, 74000, '2019-04-11');

-- TABLE 3: monthly_sales
CREATE TABLE monthly_sales (
    sale_id     INT           PRIMARY KEY,
    emp_id      INT,
    sale_month  DATE,          -- first day of month
    amount      DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO monthly_sales VALUES
(1,  1,  '2024-01-01', 120000),
(2,  1,  '2024-02-01', 135000),
(3,  1,  '2024-03-01', 118000),
(4,  3,  '2024-01-01', 98000),
(5,  3,  '2024-02-01', 105000),
(6,  3,  '2024-03-01', 112000),
(7,  7,  '2024-01-01', 143000),
(8,  7,  '2024-02-01', 139000),
(9,  7,  '2024-03-01', 143000),  -- same as Jan
(10, 10, '2024-01-01', 87000),
(11, 10, '2024-02-01', 92000),
(12, 10, '2024-03-01', 88000),
(13, 12, '2024-01-01', 76000),
(14, 12, '2024-02-01', 71000),
(15, 12, '2024-03-01', 79000),
(16, 15, '2024-01-01', 110000),
(17, 15, '2024-02-01', 125000),
(18, 15, '2024-03-01', 108000);

-- TABLE 4: targets
CREATE TABLE targets (
    emp_id      INT,
    sale_month  DATE,
    target_amt  DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO targets VALUES
(1,  '2024-01-01', 115000),
(1,  '2024-02-01', 130000),
(1,  '2024-03-01', 120000),
(3,  '2024-01-01', 100000),
(3,  '2024-02-01', 100000),
(3,  '2024-03-01', 100000),
(7,  '2024-01-01', 140000),
(7,  '2024-02-01', 140000),
(7,  '2024-03-01', 140000),
(10, '2024-01-01', 90000),
(10, '2024-02-01', 90000),
(10, '2024-03-01', 90000),
(12, '2024-01-01', 80000),
(12, '2024-02-01', 80000),
(12, '2024-03-01', 80000),
(15, '2024-01-01', 110000),
(15, '2024-02-01', 120000),
(15, '2024-03-01', 115000);

-- =============================================================================
-- VERIFY
-- =============================================================================
SELECT 'regions'       AS tbl, COUNT(*) FROM regions       UNION ALL
SELECT 'employees'     AS tbl, COUNT(*) FROM employees     UNION ALL
SELECT 'monthly_sales' AS tbl, COUNT(*) FROM monthly_sales UNION ALL
SELECT 'targets'       AS tbl, COUNT(*) FROM targets;

-- =============================================================================
-- SECTION A — WINDOW AGGREGATE FUNCTIONS
-- =============================================================================

-- WA1 — Display each employee's salary along with the company-wide average salary
SELECT emp_id,
       emp_name,
	   salary,
	   ROUND(AVG(salary) OVER(),2) AS avg_slry
FROM employees;	   

-- WA2 — Display each employee's salary along with their department's average salary
SELECT emp_id,
       emp_name,
	   department,
	   salary,
	   ROUND(AVG(salary) OVER(PARTITION BY department),2) AS dept_avg_slry
FROM employees;

-- WA3 — Display each employee's salary along with the minimum and maximum salary within their department
SELECT emp_id,
	   salary,
	   department,
	   MIN(salary) OVER(PARTITION BY department) AS min_slry,
	   MAX(salary) OVER(PARTITION BY department) AS max_slry
FROM employees;

-- WA4 — Calculate each employee's salary contribution percentage within their department
SELECT emp_id,
	   salary,
	   department,
	  ROUND(salary/SUM(salary) OVER(PARTITION BY department) * 100.0 , 2) AS percent_slry
FROM employees;

-- WA5 — Calculate cumulative monthly sales for each employee using a running total window
SELECT sale_id,
       emp_id,
	   sale_month,
	   SUM(amount) OVER( PARTITION BY emp_id ORDER BY sale_month
	   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM monthly_sales;

-- WA6 — Display each employee's salary difference from the company's total salary
SELECT emp_id,
       emp_name,
	   salary,
	   SUM(salary) OVER() AS total_salary,
	   salary - AVG(salary) OVER() AS salary_difference
FROM employees;

-- WA7 — Display department-wise employee counts using window functions instead of GROUP BY
SELECT 
	  CONCAT(emp_name, ' (', COUNT(*) OVER(PARTITION BY department), ')') AS name_with_count,
      department
FROM employees;

-- WA8 — Calculate a rolling three-month average sales value for each employee
SELECT emp_id,
       ROUND(AVG(amount) OVER(PARTITION BY emp_id ORDER BY sale_month
	   ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS three_months_avg_sales
FROM monthly_sales;

-- WA9 — Display each employee's salary along with the highest salary within their region
SELECT emp_id,
       emp_name,
	   salary,
	   MAX(salary) OVER(PARTITION BY region_id) AS slry_by_region
FROM employees;

-- WA10 — Calculate a three-row moving average using sliding window frames
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING.
SELECT sale_id,
       emp_id,
       AVG(amount) OVER(PARTITION BY emp_id ORDER BY sale_month
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg
FROM monthly_sales;


-- =============================================================================
-- SECTION B — RANKING FUNCTIONS 
-- =============================================================================

-- RK1 — Rank all employees by salary (highest = rank 1). Use RANK().
SELECT emp_id,
       emp_name,
	   RANK() OVER(ORDER BY salary DESC) AS ranking_slry
FROM employees;

-- RK2 — Same as above but use DENSE_RANK() 
-- Compare the results with RANK() and observe how ties are handled differently
SELECT emp_id,
       emp_name,
	   DENSE_RANK() OVER(ORDER BY salary DESC) AS dense_rnking_slry
FROM employees;

-- RK3 — Rank employees within each department by salary. (PARTITION BY department)
SELECT emp_id,
       emp_name,
	   salary,
	   RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS ranking_dept
FROM employees;

-- RK4 — Assign unique row numbers to employees within each department based on salary
SELECT emp_id,
       emp_name,
	   salary,
	   ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS ranking_dept
FROM employees;

-- RK5 — Retrieve the highest-paid employee from each department.
-- (Subquery + RANK or ROW_NUMBER trick — WHERE rank = 1)
SELECT emp_id, 
       emp_name, 
	   department
FROM	   
     (SELECT emp_id,
		     emp_name,
		     department,
			 ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS rnk
             FROM employees) AS top_earner
             WHERE rnk = 1;

--RK6 — Divide employees into 4 quartiles based on salary. Use NTILE(4).
--use karo. Quartile 1 = top earners.
SELECT emp_id,
       emp_name,
	   salary,
	   NTILE(4) OVER(ORDER BY salary DESC) AS salary_quartile
FROM employees;

-- RK7 — Calculate cumulative salary distribution percentages using CUME_DIST()
SELECT emp_id,
       emp_name,
	   salary,
	   CUME_DIST() OVER(ORDER BY salary) * 100 AS slry_percentile
FROM employees;

-- RK8 — Calculate relative salary rankings using PERCENT_RANK()
SELECT emp_name,
       salary,
	   PERCENT_RANK() OVER(ORDER BY salary) AS relative_rank
FROM employees;

--RK9 — In monthly_sales — rank employees by their sales within each month. 
--      Who was rank 1 in January, who in February?
SELECT emp_id,
       sale_month,
	   amount,
       RANK() OVER(PARTITION BY sale_month ORDER BY amount DESC) AS ranking_by_month
	   FROM monthly_sales;

--RK10 — Find the bottom 2 earners in each department. (RANK ascending, WHERE rank <= 2)
SELECT emp_name,
       salary,
	   department
FROM 
    (SELECT emp_name,
	        salary,
			department,
			RANK() OVER(PARTITION BY department ORDER BY salary ASC) AS rank 
			FROM employees) AS top_low_earner
            WHERE rank <=2;


-- =============================================================================
-- SECTION C — VALUE FUNCTIONS: LEAD, LAG, FIRST/LAST VALUE
-- =============================================================================

-- VF1 — Display current and next month's sales for each employee using LEAD()
SELECT emp_id,
       sale_month,
	   amount AS current_month_sale,
       LEAD(amount, 1, 0) OVER(PARTITION BY emp_id ORDER BY sale_month) AS next_month_sale
FROM monthly_sales;

--VF2 — Display current and next month's sales for each employee using LEAD().
SELECT emp_id,
       sale_month,
	   amount AS current_month_sale,
       LAG(amount, 1, 0) OVER(PARTITION BY emp_id ORDER BY sale_month) AS previous_month_sale
FROM monthly_sales;

-- VF3 — Calculate month-over-month sales changes using LAG()
WITH SalesDiff AS (
    SELECT 
        emp_id,
        sale_month,
        amount AS current_sale,
        LAG(amount) OVER(PARTITION BY emp_id ORDER BY sale_month) AS previous_sale
    FROM monthly_sales
)
SELECT 
    *,
    (current_sale - previous_sale) AS diff,
    CASE 
        WHEN (current_sale - previous_sale) > 0 THEN 'Increase'
        WHEN (current_sale - previous_sale) < 0 THEN 'Decrease'
        WHEN (current_sale - previous_sale) = 0 THEN 'No Change'
        ELSE 'First Month' -- Jab previous_sale NULL ho
    END AS status
FROM SalesDiff;

--VF4 — Use both LEAD() and LAG() in a single query — show current, previous, and next month sales in one row.
SELECT emp_id,
       sale_month,
	   amount AS current_month_sale,
	   LAG(amount, 1, 0) OVER(PARTITION BY emp_id ORDER BY sale_month) AS previous_month_sale,
       LEAD(amount, 1, 0) OVER(PARTITION BY emp_id ORDER BY sale_month) AS next_month_sale
FROM monthly_sales;

-- VF5 — Display each employee's highest monthly sale alongside the current month's sale
SELECT emp_id,
       sale_month,
	   FIRST_VALUE(amount) OVER(PARTITION BY emp_id ORDER BY amount DESC
	   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS best_month_sale,
	   amount AS current_month_sale
FROM monthly_sales;

-- VF6 — Display each employee's lowest monthly sale using LAST_VALUE()
SELECT emp_id,
       sale_month,
	   amount AS current_month_sale,
	   LAST_VALUE(amount) OVER(PARTITION BY emp_id ORDER BY amount DESC
	   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS worst_month_sale
FROM monthly_sales;

--VF7 — Join monthly_sales with targets, then use LAG() to show: 
--      did the employee achieve their target last month? (amount >= target_amt)
WITH MonthlyPerformance AS (
       SELECT 
	         m.emp_id,
			 m.sale_month,
			 m.amount,
			 t.target_amt,
			 CASE WHEN m.amount >= t.target_amt THEN 'YES' ELSE 'NO' END AS achieved
			 FROM monthly_sales m
			 JOIN targets t ON m.emp_id = t.emp_id AND m.sale_month = t.sale_month
) 
       SELECT
	         emp_id,
			 sale_month,
			 amount,
			 target_amt,
			 achieved AS current_month_status,
			 LAG(achieved, 1, 'N/A') OVER(PARTITION BY emp_id ORDER BY sale_month) AS prev_month_achieved
			 FROM MonthlyPerformance;
			
-- VF8 — Sort by salary and show each employee alongside the salary of the person ranked just above them,
--       and the difference. Use LEAD().
SELECT emp_name,
       salary,
	   LEAD(salary) OVER(ORDER BY salary ASC) AS next_higher_salary,
	   (LEAD(salary) OVER(ORDER BY salary ASC) - salary)  AS slry_diff
FROM employees;

--VF9 — Use FIRST_VALUE() to show the name of the earliest hired employee in each department,
--      display it alongside every row. (PARTITION BY dept, ORDER BY hire_date)
SELECT emp_name,
       department,
	   FIRST_VALUE(emp_name) OVER(PARTITION BY department ORDER BY hire_date
	   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_hired_emp
FROM employees;

-- VF10 — Combine ranking and value window functions into a comprehensive employee performance analysis query
SELECT emp_name,
       department,
	   salary,
	   DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC ) AS dept_rank,
	   DENSE_RANK() OVER(ORDER BY salary DESC) AS company_rank,
	   FIRST_VALUE(emp_name) OVER(PARTITION BY department ORDER BY salary DESC
	   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS dept_top_earner
FROM employees;