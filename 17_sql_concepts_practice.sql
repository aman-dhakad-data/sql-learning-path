/* ===============================================================================
COMPLETE SQL PRACTICE PROJECT
Concepts Covered:
- DDL Operations
- DML Operations
- Filtering Operators
- Aggregate Functions
- GROUP BY and HAVING
- Constraints
- Data Analysis Queries
- Real-world Business Scenarios
=============================================================================== */

-- ============================================
-- TABLE 1: customers
-- ============================================
CREATE TABLE customers (
    customer_id  INT           PRIMARY KEY,
    name         VARCHAR(100)  NOT NULL,
    city         VARCHAR(50),
    email        VARCHAR(100)  UNIQUE,
    join_date    DATE
);

INSERT INTO customers(customer_id, name, city, email, join_date) VALUES
(1, 'Riya Sharma',  'Mumbai',    'riya@gmail.com',  '2022-01-15'),
(2, 'Aman Verma',   'Delhi',     'aman@gmail.com',  '2022-03-20'),
(3, 'Priya Singh',  'Mumbai',    'priya@gmail.com', '2023-06-10'),
(4, 'Raj Patel',    'Ahmedabad', 'raj@gmail.com',   '2023-08-05'),
(5, 'Neha Joshi',   'Pune',      'neha@gmail.com',  '2024-01-22');

-- ============================================
-- TABLE 2: products
-- ============================================
CREATE TABLE products (
    product_id    INT              PRIMARY KEY,
    product_name  VARCHAR(100)   NOT NULL,
    category      VARCHAR(50),
    price         DECIMAL(10,2),
    stock_qty     INT             DEFAULT 0
);

INSERT INTO products (product_id, product_name, category, price, stock_qty) VALUES
(1, 'iPhone 15',        'Electronics', 79999, 50),
(2, 'Nike Shoes',       'Footwear',    4999,  200),
(3, 'Samsung TV',       'Electronics', 45999, 30),
(4, 'Levis Jeans',    'Clothing',    2499,  150),
(5, 'Sony Headphones', 'Electronics', 8999,  80),
(6, 'Adidas T-Shirt',  'Clothing',    1299,  300);

-- ============================================
-- TABLE 3: orders
-- ============================================
CREATE TABLE orders (
    order_id      INT              PRIMARY KEY,
    customer_id   INT,
    order_date    DATE,
    total_amount  DECIMAL(10,2),
    status        VARCHAR(20)     DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (order_id, customer_id, order_date, total_amount, status) VALUES
(101, 1, '2024-01-10', 79999, 'Delivered'),
(102, 2, '2024-01-15', 4999,  'Delivered'),
(103, 1, '2024-02-05', 45999, 'Pending'),
(104, 3, '2024-02-20', 2499,  'Delivered'),
(105, 4, '2024-03-01', 8999,  'Cancelled'),
(106, 2, '2024-03-10', 1299,  'Delivered'),
(107, 5, '2024-03-15', 79999, 'Pending');

-- ============================================
-- TABLE 4: order_items
-- ============================================
CREATE TABLE order_items (
    item_id     INT              PRIMARY KEY,
    order_id    INT,
    product_id  INT,
    quantity    INT              DEFAULT 1,
    unit_price  DECIMAL(10,2),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 101, 1, 1, 79999),
(2, 102, 2, 1, 4999),
(3, 103, 3, 1, 45999),
(4, 104, 4, 1, 2499),
(5, 105, 5, 1, 8999),
(6, 106, 6, 1, 1299),
(7, 107, 1, 1, 79999);

-- ============================================
-- TABLE 5: employees
-- ============================================
CREATE TABLE employees (
    emp_id      INT              PRIMARY KEY,
    emp_name    VARCHAR(100)   NOT NULL,
    department  VARCHAR(50),
    salary      DECIMAL(10,2),
    hire_date   DATE
);

INSERT INTO employees (emp_id, emp_name, department, salary, hire_date) VALUES
(1, 'Arjun Das',     'Sales', 45000, '2021-05-01'),
(2, 'Meera Nair',    'HR',    38000, '2020-11-15'),
(3, 'Vivek Tiwari', 'Sales', 52000, '2019-03-20'),
(4, 'Sunita Rao',   'IT',    65000, '2018-07-10'),
(5, 'Karan Mehta',  'HR',    41000, '2022-01-05');

-- ============================================
-- -- Verify Table Creation and Data Insertion
-- ============================================
SELECT 'customers'   AS table_name, COUNT(*) AS rows FROM customers  UNION ALL
SELECT 'products'    AS table_name, COUNT(*) AS rows FROM products   UNION ALL
SELECT 'orders'      AS table_name, COUNT(*) AS rows FROM orders     UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS rows FROM order_items UNION ALL
SELECT 'employees'   AS table_name, COUNT(*) AS rows FROM employees;

-- =============================================================================
-- SELECT STATEMENT PRACTICE
-- =============================================================================

-- select Q1
-- Retrieve all customer names and cities.
SELECT customer_id, 
       name, 
	   city 
FROM customers;

-- select Q2 · WHERE
-- Show only the orders whose status is 'Delivered'.
SELECT * FROM orders
WHERE status = 'Delivered';

-- select Q3 · ORDER BY
-- Show all products sorted by price, most expensive first.
SELECT * FROM products
ORDER BY price DESC;

-- select Q4 · GROUP BY
-- Calculate the number of employees in each department
SELECT department,
       COUNT(*) AS total_employees
FROM employees
GROUP BY department;

-- select Q5 · HAVING
-- Retrieve departments with more than one employee
SELECT department,
       count(*) AS total_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;

-- select Q6 · DISTINCT
-- How many distinct cities do the customers belong to?
SELECT DISTINCT city 
FROM customers;

-- select Q7 · GROUP BY + SUM
-- Calculate total order amount spent by each customer
SELECT customer_id, SUM(total_amount) FROM orders
GROUP BY customer_id
ORDER BY customer_id ASC;

-- select Q8 · WHERE + ORDER BY
-- Show Electronics category products in ascending order of price.
SELECT * FROM products
WHERE category = 'Electronics'
ORDER BY price ASC;

-- select Q9 · HAVING + AVG
-- Show categories where the average product price is greater than 5000.
SELECT category, ROUND(AVG(price),0) FROM products
GROUP BY category
HAVING AVG(price) > 5000;

-- =============================================================================
-- DDL STATEMENT PRACTICE
-- =============================================================================

-- Q1 · CREATE TABLE
-- Create a reviews table with primary and foreign key constraints 
-- product_id (FK), rating (1–5), and review_text.
CREATE TABLE reviews (
     review_id INT PRIMARY KEY,
	 customer_id INT,
	 product_id INT,
	 rating INT CHECK (rating BETWEEN 1 AND 5),
	 review_text TEXT,
	 FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	 FOREIGN KEY (product_id) REFERENCES products(product_id));

-- ddl Q2 · ALTER — ADD COLUMN
-- Add a new column 'phone_number' VARCHAR(15) to the customers table.
ALTER TABLE customers ADD 
phone_number VARCHAR(15);

-- ddl Q3 · ALTER — MODIFY COLUMN
-- Increase the length of the 'product_name' column in the products table from 100 to 200.
ALTER TABLE products 
ALTER COLUMN product_name TYPE VARCHAR(200);

-- ddl Q4 · ALTER — DROP COLUMN
-- Remove the 'hire_date' column from the employees table.
ALTER TABLE employees
DROP COLUMN hire_date;

-- ddl Q5 · DROP TABLE
-- Delete the 'reviews' table, but first check if it exists.
DROP TABLE IF EXISTS reviews;

-- ddl Q6 · CREATE TABLE + Constraints
-- Create a 'discounts' table with discount_id (PK), product_id (FK), discount_percent (between 0 and 100),
-- and valid_till (DATE).
CREATE TABLE discounts(
       discount_id INT PRIMARY KEY,
	   product_id INT,
	   discount_percent DECIMAL(5,2) CHECK (discount_percent BETWEEN 0 AND 100),
	   valid_till DATE,
	   FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =============================================================================
-- DML STATEMENT PRACTICE
-- =============================================================================
-------------------------------------
-- DML — INSERT / UPDATE / DELETE
-------------------------------------

-- Q1 · INSERT
-- Add a new customer: Karan Kapoor, Jaipur, karan@gmail.com, join date today.
INSERT INTO customers VALUES (6,'Karan Kapoor', 'Jaipur', 'Karan@gmail.com', '2026-04-10');


-- dml Q2 · INSERT Multiple
-- Insert 2 new products at once: (7, 'Boat Earbuds', 'Electronics', 2499, 120) 
-- and (8, 'Woodland Boots', 'Footwear', 3499, 75).

INSERT INTO products VALUES (7, 'Boat Earbuds', 'Electronics', 2499, 120), 
(8, 'Woodland Boots', 'Footwear', 3499, 75);


-- dml Q3 · UPDATE
-- Increase Vivek Tiwari's salary from 52000 to 58000.

UPDATE employees 
SET salary = 58000
WHERE emp_id = 3;


-- dml Q4 · UPDATE — Calculated
-- Increase the price of all Electronics products by 10%
UPDATE products 
SET price = price* 1.10
WHERE category = 'Electronics';

-- dml Q5 · DELETE
-- Delete order 105 which has a 'Cancelled' status from the orders table. 

DELETE FROM orders 
WHERE order_id = 105
AND status = 'Cancelled';

-- dml Q6 · DELETE — Conditional
-- Delete all orders that are older than 2024.

DELETE FROM orders
WHERE order_date < '2024-01-01';

-- =============================================================================
-- FILTERING OPERATORS PRACTICE
-- =============================================================================

-- filter Q1 · Comparison Operators
-- Show employees whose salary is greater than 45000.
SELECT * FROM employees
WHERE salary > 45000;

-- filter Q2 · Comparison — Not Equal
-- Show orders that are not 'Cancelled'.

SELECT * FROM orders
WHERE status != 'Cancelled';

-- filter Q3 · AND Operator
-- Retrieve customers from Mumbai who joined after 2022

SELECT * FROM customers
WHERE city = 'Mumbai'
AND join_date > '2022-12-31' ;

-- filter Q4 · OR Operator
-- Show products that belong to either 'Electronics' or 'Footwear' category.

SELECT * FROM products
WHERE category = 'Electronics' 
OR category = 'Footwear';

-- filter Q5 · NOT Operator
-- Show products that are not in the 'Clothing' category.

SELECT * FROM products
WHERE category <>'Clothing';

-- filter Q6 · BETWEEN
-- Show products whose price is between 3000 and 50000.

SELECT * FROM products
WHERE price BETWEEN 3000 AND 50000;

-- filter Q7 · IN
-- Show customers from Mumbai, Delhi, and Pune.

SELECT * FROM customers
WHERE city IN ('Mumbai', 'Delhi', 'Pune');

-- filter Q8 · NOT IN
-- Show all employees except those in the IT department.

SELECT * FROM employees
WHERE department NOT IN ('IT');

-- filter Q9 · LIKE — Starts With
-- Retrieve customers whose names start with the letter 'R'

SELECT * FROM customers
WHERE name LIKE 'R%';

-- filter Q10 · LIKE — Contains
-- Show products whose name contains the letters 'oo'.

SELECT * FROM products
WHERE product_name LIKE '%oo%';

-- filter Q11 · LIKE — Single Char
-- Show employees whose name is exactly 5 characters long.

SELECT * FROM employees
WHERE emp_name LIKE '_____%';

-- =============================================================================
-- MIXED SQL PRACTICE QUERIES
-- =============================================================================

-- mixed Q1 · SELECT + WHERE + GROUP BY
-- Among 'Delivered' orders only — how many orders did each customer place? 
-- Show only customers with more than 1 delivered order.

SELECT customer_id,
       COUNT(*) AS delivered_orders
FROM orders
WHERE status = 'Delivered'
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- mixed Q2 · UPDATE + WHERE + Operators
-- Increase the salary of all employees in the Sales department who earn less than 50000 by 5%.

UPDATE employees
SET salary = salary * 1.05
WHERE department = 'Sales' AND salary < 50000;

SELECT * FROM employees;

-- mixed Q3 · SELECT + BETWEEN + ORDER BY
-- Show all orders placed between January 2024 and March 2024, sorted by date.

SELECT * FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY order_date ASC;

-- mixed Q4 · DELETE + IN
-- Delete items from the order_items table where product_id is 5, 6, or 7.

DELETE FROM order_items
WHERE product_id IN (5,6,7);

-- mixed Q5 · Full Mix
-- Retrieve the most expensive product price from each category, excluding Electronics.

SELECT category, MAX(price) AS max_price 
FROM products
WHERE category <> 'Electronics'
GROUP BY category
ORDER BY MAX(price) DESC;