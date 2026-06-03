/* ===============================================================================
NULL HANDLING FUNCTIONS PRACTICE
Concepts Covered:
- IS NULL
- IS NOT NULL
- COALESCE()
- NULLIF()
- NULL Handling in Calculations
- Data Cleaning Techniques
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================
CREATE TABLE sales_data (
        order_id INT,
		customer_name VARCHAR (50),
		email VARCHAR (100),
		phone VARCHAR (20),
		quantity INT,
		price NUMERIC (10,2),
		discount NUMERIC(10,2)
);

-- =============================================================================
-- DATA INSERTION
-- =============================================================================
INSERT INTO sales_data (order_id, customer_name, email, phone, quantity, price, discount) VALUES
(1,'Aman','aman@email.com','9876543210',2,500,NULL),
(2,'Riya','riya@email.com',NULL,1,1200,100),
(3,'Kabir',NULL,'9123456789',NULL,800,50),
(4,'Sneha','sneha@email.com','',3,400,NULL),
(5,'Arjun',NULL,NULL,2,NULL,20),
(6,'Neha','neha@email.com','9988776655',NULL,700,NULL);

-- =============================================================================
-- VIEW TABLE DATA
-- =============================================================================
SELECT * 
FROM sales_data;

-- =============================================================================
-- NULL HANDLING PRACTICE TASKS
-- =============================================================================

-- Task 1 — IS NULL
-- Find customers with missing email addresses
-- Expected Output Columns: order_id, customer_name

SELECT 
      order_id,
	  customer_name
FROM sales_data
WHERE email IS NULL;	  

-- Task 2 — IS NOT NULL
-- Retrieve orders where discounts were applied

SELECT 
      order_id,
	  discount
FROM sales_data 
WHERE discount IS NOT NULL;

-- Task 3 — COALESCE
-- Display 'No Phone' when phone numbers are NULL or empty
-- Example Output:
-- Riya | No Phone

SELECT
	   order_id,
	   customer_name,
	   COALESCE(NULLIF(phone,''),'No Phone') AS cleaned_phone
FROM sales_data;

-- Task 4 — Revenue Calculation with NULL Handling
-- Formula: revenue = quantity * price
-- Problem: Quantity or price values may contain NULLs
-- Ensure revenue calculations return valid results
-- Hint: Use COALESCE() to handle NULL values

SELECT
	   order_id,
	   quantity,
	   price,
	   COALESCE(quantity,0) * COALESCE(price,0) AS revenue
FROM sales_data;

-- Task 5 — NULLIF
-- Treat empty phone values as NULL using NULLIF()

SELECT
	   order_id,
	   phone,
	   NULLIF(phone,'') AS cleaned_phone
FROM sales_data;