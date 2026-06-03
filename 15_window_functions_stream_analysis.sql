/* ===============================================================================
WINDOW FUNCTIONS AND STREAM DATA ANALYSIS
Concepts Covered:
- ROW_NUMBER()
- Window Functions
- PARTITION BY
- Running Totals
- Deduplication
- Data Cleaning
- Revenue Calculations
- Stream Processing Logic
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================
CREATE TABLE orders_stream (
             order_id    INT,
             customer_id INT,
             order_date  DATETIME2,
             update_time DATETIME2,
             city        VARCHAR(50),
             quantity    INT,
             price       NUMERIC(10,2)
);

-- =============================================================================
-- SAMPLE DATA INSERTION
-- =============================================================================
INSERT INTO orders_stream (order_id, customer_id, order_date, update_time, city, quantity, price) VALUES
(1,101,'2024-01-01','2024-01-01 10:00','Delhi',2,500),
(1,101,'2024-01-01','2024-01-01 12:00','Delhi',2,500), -- duplicate (latest)
(2,102,'2024-01-02','2024-01-02 09:00','Mumbai',1,1200),
(3,103,'2024-01-03','2024-01-03 08:00','Pune',NULL,800),
(3,103,'2024-01-03','2024-01-03 10:00','Pune',3,800), -- updated
(4,104,'2024-01-04','2024-01-04 11:00','Delhi',3,400),
(5,105,'2024-01-05','2024-01-05 12:00','',2,NULL),
(6,106,'2024-01-06','2024-01-06 09:00','Chennai',NULL,700),
(7,107,'2024-01-07','2024-01-07 14:00','Delhi',5,150),
(8,108,'2024-01-08','2024-01-08 15:00','Mumbai',1,900),
(9,109,'2024-01-09','2024-01-09 16:00','Pune',4,300),
(10,110,'2024-01-10','2024-01-10 17:00','Bangalore',2,450);

-- =============================================================================
-- VIEW TABLE DATA
-- =============================================================================
SELECT * 
FROM Orders_stream;

-- =============================================================================
-- WINDOW FUNCTION PRACTICE TASKS
-- =============================================================================
-- =============================================================================
-- STREAM DATA DEDUPLICATION
-- =============================================================================

-- Task 1 — Remove Duplicate Order Records
-- Multiple records may exist for the same order_id
-- Retrieve only the latest record using update_time DESC
-- Expected Output: One row per order_id

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY order_id
               ORDER BY update_time DESC
           ) AS row_num
    FROM orders_stream
) ranked_orders
WHERE row_num = 1;

-- =============================================================================
-- DATA CLEANING
-- =============================================================================

-- Task 2 — Clean and Standardize Data
-- Rules:
-- Remove unnecessary spaces from city values
-- Convert empty city values ('') to 'Unknown'
-- Replace NULL quantity values with 0
-- Replace NULL price values with 0

SELECT 
      order_id,
	  COALESCE(NULLIF(TRIM(city), ''), 'Unknown') AS city,
	  COALESCE (quantity, 0) AS quantity,
	  COALESCE (price, 0) AS price
FROM orders_stream;

-- =============================================================================
-- REVENUE ANALYSIS
-- =============================================================================

-- Task 3 — Calculate Revenue
-- Formula: revenue = quantity * price

SELECT 
    order_id,
    quantity,
    price,
    COALESCE(quantity, 0) * COALESCE(price, 0) AS daily_revenue
FROM orders_stream;

-- =============================================================================
-- REVENUE ANALYSIS
-- =============================================================================

-- Task 4 — Rank Customer Orders
-- Rank each customer's orders by latest order date
-- Latest order should receive rank 1
-- Hint: Use ROW_NUMBER() with PARTITION BY

SELECT 
    order_id,
    customer_id,
    order_date,
    ROW_NUMBER() OVER(
        PARTITION BY customer_id 
        ORDER BY order_date DESC
    ) AS rank_per_customer
FROM orders_stream;

-- Task 5 — Calculate Daily Revenue
-- Compute total revenue generated for each date

SELECT 
    order_date::DATE,
    SUM(COALESCE(quantity,0) * COALESCE(price,0)) AS daily_revenue
FROM orders_stream
GROUP BY order_date::DATE
ORDER BY order_date::DATE;

-- =============================================================================
-- WINDOW AGGREGATIONS
-- =============================================================================

-- Task 6 — Calculate Running Revenue Using Window Functions
-- Compute cumulative revenue ordered by date

SELECT 
    order_date,
    revenue,
    SUM(revenue) OVER(
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue
FROM (
    SELECT order_date::DATE AS order_date, SUM(COALESCE(quantity,0) * COALESCE(price,0)) AS revenue
    FROM orders_stream
    GROUP BY order_date::DATE
) daily;