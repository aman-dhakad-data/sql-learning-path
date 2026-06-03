/* ===============================================================================
CASE STATEMENT AND DATA TRANSFORMATION PRACTICE
Concepts Covered:
- CASE Statements
- Data Cleaning
- NULL Handling
- COALESCE()
- NULLIF()
- DATE_TRUNC()
- EXTRACT()
- Revenue Calculations
- Data Classification
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================
CREATE TABLE orders (
			 order_id INT,
			 customer_name VARCHAR(50),
			 email VARCHAR(100),
			 phone VARCHAR(20),
			 city VARCHAR(50),
			 order_date TIMESTAMP,
			 quantity INT,
			 price NUMERIC(10,2)
);

-- =============================================================================
-- SAMPLE ORDER DATA
-- =============================================================================
INSERT INTO orders (order_id, customer_name, email, phone, city, order_date, quantity, price) VALUES
(1,'Aman','aman@email.com','9876543210','Delhi','2024-01-15 10:30',2,500),
(2,'Riya','',NULL,'Mumbai','2024-02-20 14:15',1,1200),
(3,'Kabir',NULL,'9123456789','Bangalore','2024-02-25 18:45',NULL,800),
(4,'Sneha','sneha@email.com',' ','Delhi','2024-03-05 09:10',3,400),
(5,'Arjun',NULL,NULL,' ','2024-03-31 23:59',2,NULL),
(6,'Neha','neha@email.com','9988776655','Pune','2024-04-01 00:05',NULL,700),
(7,'Rahul',' ','8887776666','Chennai','2024-04-10 12:00',5,150),
(8,'Meera','meera@email.com','','Delhi','2024-04-12 08:45',1,900),
(9,'Dev','',NULL,'Mumbai','2024-04-20 11:20',4,300),
(10,'Priya',NULL,'   ','Bangalore','2024-05-01 16:10',2,450),
(11,'Ankit','ankit@email.com','9998887777','Delhi','2024-05-10 13:30',3,600),
(12,'Sara',' ',' ','Pune','2024-05-15 09:50',NULL,500);

-- =============================================================================
-- VIEW RAW ORDER DATA
-- =============================================================================
SELECT * 
FROM orders;

-- =============================================================================
-- DATA TRANSFORMATION TASKS
-- =============================================================================

-- Task 1 — Clean and Standardize Email Addresses
-- Rules:
-- Remove unnecessary spaces
-- Convert empty strings ('') to NULL
-- Replace NULL values with 'Unknown'
-- Output Column: clean_email

SELECT
     order_id,
	 COALESCE(NULLIF(TRIM(email), ''),'Unknown') AS clean_email
FROM orders;

-- Task 2 — Clean and Standardize Phone Numbers
-- Rules:
-- Remove unnecessary spaces using TRIM()
-- Convert empty strings ('') to NULL
-- Replace NULL values with 'Unknown'
-- Output Column: clean_phone

SELECT
     order_id,
	 COALESCE(NULLIF(TRIM(phone), ''),'Unknown') AS clean_phone
FROM orders;

-- Task 3 — Extract Order Month
-- Retrieve the starting date of each order month
-- Example: 2024-02-25 → 2024-02-01
-- Hint: Use DATE_TRUNC()
-- Output Column: order_month

SELECT
      order_id,
	  order_date,
	  DATE_TRUNC('month', order_date) AS order_month
FROM orders;

-- Task 4 — Extract Order Year
-- Extract the year from the order date
-- Hint: Use EXTRACT()
-- Output Column: order_year

SELECT
      order_id,
	  order_date,
	  EXTRACT(YEAR FROM order_date) AS order_year
FROM orders;


-- Task 5 — Revenue Calculation with NULL Handling
-- Formula: quantity * price
-- Problem: Quantity or price values may contain NULLs
-- Ensure revenue calculations return valid results
-- Hint: Use COALESCE() to handle NULL values

SELECT
      order_id,
	  quantity,
	  price,
	  COALESCE(quantity,0) * COALESCE(price,0) AS revenue
FROM orders;

-- Task 6 — Classify Orders by Revenue
-- Use CASE statements for classification
-- Rules:
-- Revenue >= 1000 → 'High Value'
-- Revenue >= 500  → 'Medium Value'
-- Otherwise        → 'Low Value'
-- Output Column: order_category

SELECT
      order_id,
	  CASE
         WHEN COALESCE(quantity,0) * COALESCE(price,0) >= 1000 THEN 'High Value'
         WHEN COALESCE(quantity,0) * COALESCE(price,0) >= 500 THEN 'Medium Value'
         ELSE 'Low Value'
      END AS order_category
FROM orders;

-- =============================================================================
-- FINAL REPORTING QUERY
-- =============================================================================

-- Final Reporting Query
-- Required Output Columns:
--order_id
--customer_name
--clean_email
--clean_phone
--city
--order_month
--order_year
--revenue
--order_category
SELECT 
     order_id,
	 customer_name,
	 COALESCE(NULLIF(TRIM(email),''),'Unknown') AS clean_email,
	 COALESCE(NULLIF(TRIM(phone),''),'Unknown') AS clean_phone,
	 COALESCE(NULLIF(TRIM(city),''),'Unknown') AS cleaned_city,
	 DATE_TRUNC('month', order_date) AS order_month,
	 EXTRACT(YEAR FROM order_date) AS order_year,
	 COALESCE(quantity,0) * COALESCE(price,0) AS revenue,
	 CASE
     	 WHEN COALESCE(quantity,0) * COALESCE(price,0) >= 1000 THEN 'High Value'
     	 WHEN COALESCE(quantity,0) * COALESCE(price,0) >= 500 THEN 'Medium Value'
     	 ELSE 'Low Value'
         END AS order_category
FROM orders;