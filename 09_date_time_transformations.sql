/* ===============================================================================
DATE AND TIME TRANSFORMATION PRACTICE
Concepts Covered:
- EXTRACT()
- DATE_TRUNC()
- TO_CHAR()
- CAST()
- INTERVAL
- Date Arithmetic
- Date Formatting
- Timestamp Transformations
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================
CREATE TABLE orders (
    order_id INT,
    order_date TIMESTAMP
);

-- =============================================================================
-- SAMPLE DATA INSERTION
-- =============================================================================
INSERT INTO orders VALUES
(1,'2024-01-15 10:30:00'),
(2,'2024-02-20 14:15:00'),
(3,'2024-02-25 18:45:00'),
(4,'2024-03-05 09:10:00'),
(5,'2024-03-31 23:59:00'),
(6,'2024-04-01 00:05:00');

-- =============================================================================
-- VIEW TABLE DATA
-- =============================================================================
SELECT * 
FROM orders

-- =============================================================================
-- DATE AND TIME FUNCTION PRACTICE TASKS
-- =============================================================================

-- Task 1 — Extract the year, month, and day from the order date
SELECT order_id,
	   EXTRACT( YEAR FROM order_date)  AS order_year
	   EXTRACT( MONTH FROM order_date) AS order_month
	   EXTRACT( DAY FROM order_date)   AS order_day
FROM orders;

-- Task 2 — Extract the hour from the order timestamp
SELECT order_id,
       EXTRACT(HOUR FROM order_date) AS order_hour
FROM orders;

-- Task 3 — Retrieve the month name from the order date
SELECT order_id,
       TO_CHAR(order_date, 'FMMonth') AS month_name
FROM orders;

-- Task 4 — Retrieve the start date of the month
SELECT order_id,
       DATE_TRUNC ('month', order_date) AS month_start
FROM orders;

-- Task 5 — Retrieve the end date of the month
SELECT order_id,
       DATE_TRUNC('month', order_date)
       + INTERVAL '1 month'
       - INTERVAL '1 day' AS month_end
FROM orders;

-- Count total orders grouped by month
SELECT
       DATE_TRUNC('month', order_date) AS month,
       COUNT(*)
FROM orders
GROUP BY month;

-- Generate year-month formatted values for reporting
--Extract:| order_id | year_month |
--Example:
--2024-02
--2024-03
--Hint:TO_CHAR() use karo.

SELECT order_id,
       TO_CHAR(order_date, 'YYYY-MM') AS year_month
FROM orders;

SELECT
       TO_CHAR(order_date,'YYYY-MM') AS year_month,
       COUNT(*) AS total_orders
FROM orders
GROUP BY year_month
ORDER BY year_month;

-- Task 1 — Convert timestamp values to date-only format
SELECT order_id,
       CAST(order_date AS DATE) AS order_date
FROM orders;

-- Task 2 — Format dates using a custom display pattern
SELECT order_id,
       TO_CHAR(order_date, 'DD-Mon-YYYY') AS formatted_Date
FROM orders;

-- Task 3 — Convert a string '123.45' value into a numeric data type
SELECT CAST('123.45' AS NUMERIC);

-- Task 4 — Extract the year as a text value
SELECT order_id,
       TO_CHAR( order_date, 'YYYY') AS year
FROM orders;

SELECT order_id,
       CAST(EXTRACT(YEAR FROM order_date) AS TEXT)
FROM orders;

SELECT order_id,
       DATE_TRUNC('month', order_date)::DATE AS order_month
FROM orders;

-- =============================================================================
-- DATE ARITHMETIC PRACTICE TASK
-- =============================================================================

-- Task 1 — Add 7 days to the order date
SELECT order_id,
       order_date,
       order_date + INTERVAL '7 days' AS order_date_7day_added
FROM orders;

-- Task 2 — Add 1 month to the order date
SELECT order_id,
       order_date,
       order_date + INTERVAL '1 month' AS next_month
FROM orders;

-- Task 3 — Calculate the number of days since the order date
SELECT order_id,
       order_date,
       CURRENT_DATE - order_date::DATE AS days_since_order
FROM orders;

-- Task 4 — Calculate the difference between two dates
SELECT
DATE '2024-03-01' - DATE '2024-02-20' AS diff_days;

-- Task 5 — Validate date conversion using TO_DATE()
--Create test data:
--SELECT
--TO_DATE('2024-03-15','YYYY-MM-DD');
--SELECT
--TO_DATE('2024-15-03','YYYY-MM-DD');
--Observe difference.

SELECT TO_DATE('2024-03-15','YYYY-MM-DD');

SELECT TO_DATE('2024-15-03','YYYY-MM-DD');