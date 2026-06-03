/* ===============================================================================
SUBQUERIES PRACTICE
Concepts Covered:
- Scalar Subqueries
- Derived Tables
- Correlated Subqueries
- EXISTS / NOT EXISTS
- IN / NOT IN
- ANY / ALL
- Nested Subqueries
- Multi-level Query Logic
- Analytical SQL Queries
=============================================================================== */

-- ============================================================
-- TABLES FOR: Subqueries Practice
-- ============================================================

-- TABLE 1: categories
CREATE TABLE categories (
    category_id   INT          PRIMARY KEY,
    category_name VARCHAR(50)  NOT NULL
);

INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Furniture'),
(4, 'Books'),
(5, 'Sports');

-- TABLE 2: suppliers
CREATE TABLE suppliers (
    supplier_id   INT          PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    country       VARCHAR(50),
    rating        DECIMAL(3,1) -- out of 5.0
);

INSERT INTO suppliers VALUES
(1, 'TechCorp',      'India',   4.5),
(2, 'FashionHub',    'China',   3.8),
(3, 'WoodWorks',     'India',   4.2),
(4, 'PageTurners',   'USA',     4.7),
(5, 'SportZone',     'Germany', 4.0),
(6, 'MegaSupply',    'China',   3.5),
(7, 'EliteGoods',    'India',   4.8); -- high rating but no products yet

-- TABLE 3: products
CREATE TABLE products (
    product_id    INT            PRIMARY KEY,
    product_name  VARCHAR(100)   NOT NULL,
    category_id   INT,
    supplier_id   INT,
    price         DECIMAL(10,2),
    stock         INT            DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

INSERT INTO products VALUES
(1,  'Laptop Pro',        1, 1, 85000,  40),
(2,  'Wireless Mouse',    1, 1, 1500,   200),
(3,  'USB Hub',           1, 6, 899,    150),
(4,  'Cotton Shirt',      2, 2, 999,    300),
(5,  'Denim Jeans',       2, 2, 2499,   180),
(6,  'Formal Blazer',     2, 2, 5999,   60),
(7,  'Office Chair',      3, 3, 12999,  25),
(8,  'Bookshelf',         3, 3, 8500,   40),
(9,  'Study Table',       3, 3, 15000,  15),
(10, 'Python Basics',     4, 4, 499,    500),
(11, 'Data Science Book', 4, 4, 799,    320),
(12, 'SQL Mastery',       4, 4, 599,    410),
(13, 'Cricket Bat',       5, 5, 3500,   80),
(14, 'Football',          5, 5, 1200,   120),
(15, 'Yoga Mat',          5, 5, 850,    200);
-- NOTE: supplier_id 7 (EliteGoods) has no products — for subquery practice

-- TABLE 4: customers
CREATE TABLE customers (
    customer_id   INT          PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city          VARCHAR(50),
    membership    VARCHAR(20)  DEFAULT 'Regular' -- Regular, Silver, Gold
);

INSERT INTO customers VALUES
(1,  'Aarav Shah',     'Mumbai',    'Gold'),
(2,  'Priya Menon',    'Delhi',     'Silver'),
(3,  'Rohan Verma',    'Bangalore', 'Regular'),
(4,  'Sneha Joshi',    'Mumbai',    'Gold'),
(5,  'Karan Patel',    'Hyderabad', 'Regular'),
(6,  'Meera Nair',     'Chennai',   'Silver'),
(7,  'Dev Sharma',     'Delhi',     'Regular'),
(8,  'Ananya Rao',     'Bangalore', 'Gold'),
(9,  'Vikram Das',     'Pune',      'Regular'),
(10, 'Nisha Kulkarni', 'Mumbai',    'Silver');

-- TABLE 5: orders
CREATE TABLE orders (
    order_id    INT            PRIMARY KEY,
    customer_id INT,
    order_date  DATE,
    status      VARCHAR(20)    DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders VALUES
(1001, 1,  '2024-01-10', 'Delivered'),
(1002, 2,  '2024-01-15', 'Delivered'),
(1003, 1,  '2024-02-05', 'Delivered'),
(1004, 3,  '2024-02-10', 'Cancelled'),
(1005, 4,  '2024-02-20', 'Delivered'),
(1006, 5,  '2024-03-01', 'Pending'),
(1007, 2,  '2024-03-05', 'Delivered'),
(1008, 6,  '2024-03-10', 'Delivered'),
(1009, 8,  '2024-03-15', 'Delivered'),
(1010, 1,  '2024-03-20', 'Pending'),
(1011, 4,  '2024-04-01', 'Delivered'),
(1012, 7,  '2024-04-05', 'Cancelled'),
(1013, 9,  '2024-04-10', 'Pending'),
(1014, 10, '2024-04-15', 'Delivered'),
(1015, 8,  '2024-04-20', 'Delivered');
-- NOTE: customer_id 3 (Rohan) only has Cancelled orders
-- NOTE: customer_id 9 (Vikram) only has Pending orders

-- TABLE 6: order_items
CREATE TABLE order_items (
    item_id    INT            PRIMARY KEY,
    order_id   INT,
    product_id INT,
    quantity   INT            DEFAULT 1,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items VALUES
(1,  1001, 1,  1, 85000),
(2,  1001, 2,  2, 1500),
(3,  1002, 4,  3, 999),
(4,  1002, 5,  1, 2499),
(5,  1003, 7,  1, 12999),
(6,  1004, 10, 2, 499),
(7,  1005, 1,  1, 85000),
(8,  1005, 12, 1, 599),
(9,  1006, 13, 1, 3500),
(10, 1007, 6,  1, 5999),
(11, 1007, 11, 1, 799),
(12, 1008, 14, 2, 1200),
(13, 1008, 15, 1, 850),
(14, 1009, 1,  1, 85000),
(15, 1010, 9,  1, 15000),
(16, 1011, 2,  3, 1500),
(17, 1011, 3,  1, 899),
(18, 1012, 10, 1, 499),
(19, 1013, 13, 2, 3500),
(20, 1014, 11, 1, 799),
(21, 1015, 8,  1, 8500),
(22, 1015, 12, 2, 599);

-- =============================================================================
-- VERIFY
-- =============================================================================
SELECT 'categories'  AS tbl, COUNT(*) FROM categories  UNION ALL
SELECT 'suppliers'   AS tbl, COUNT(*) FROM suppliers   UNION ALL
SELECT 'products'    AS tbl, COUNT(*) FROM products    UNION ALL
SELECT 'customers'   AS tbl, COUNT(*) FROM customers   UNION ALL
SELECT 'orders'      AS tbl, COUNT(*) FROM orders      UNION ALL
SELECT 'order_items' AS tbl, COUNT(*) FROM order_items;


-- =============================================================================
-- 35 PRACTICE QUESTIONS — SUBQUERIES
-- =============================================================================

-- =============================================================================
-- SECTION A - SCALAR SUBQUERY (WHERE + SELECT)
-- =============================================================================

-- SC1 — Retrieve products priced higher than the overall average product price
SELECT product_id, 
       product_name
FROM products 
WHERE price > (SELECT AVG(price) FROM products);

-- SC2 — Retrieve the most expensive product along with its price
SELECT product_name, 
       price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

-- SC3 — Display each product's price difference from the overall average product price
--(Scalar subquery in SELECT)
SELECT product_name,
       price,
	   ROUND(price - (SELECT AVG(price) FROM products),2) AS price_difference
FROM products;

-- SC4 — Retrieve customers whose total order count is greater than the company-wide average orders per customer.
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > (
              SELECT AVG(order_count)
			  FROM(
                  SELECT COUNT(order_id) AS order_count
				  FROM orders
				  GROUP BY customer_id
			  ) AS customer_order_counts
);

-- SC5 — Retrieve all products supplied by the highest-rated supplier
SELECT product_name,
       supplier_id
FROM products
WHERE supplier_id = (
        SELECT TOP 1 supplier_id
		FROM suppliers
		ORDER BY rating DESC
);


-- =============================================================================
-- SECTION B - SUBQUERY IN FROM (DERIVED TABLE)
-- =============================================================================

-- FR1 — Calculate the average product price per category and display categories with averages greater than 3000
SELECT category_id, avg_price
FROM (
	    SELECT category_id,
		ROUND(AVG(price),2) AS avg_price
		FROM products
		GROUP BY category_id
) AS category_smry
WHERE avg_price > 3000;

-- FR2 — Calculate total customer spending and retrieve the top 3 highest-spending customers
SELECT *
FROM (
    SELECT TOP 3 customer_id,
           SUM(quantity * unit_price) AS total_spent
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    GROUP BY customer_id
) AS customer_spending
ORDER BY total_spent DESC ;

-- FR3 — Retrieve suppliers who manage more than three products
SELECT supplier_id, 
       total_products
FROM(
     SELECT supplier_id,
	        COUNT(product_id) AS total_products
	 FROM products
	GROUP BY supplier_id
) AS products_count
WHERE total_products > 3;

-- FR4 — Rank products based on total order frequency
SELECT 
    product_id, 
    total_orders,
    DENSE_RANK() OVER(ORDER BY total_orders DESC) AS sales_rank
FROM (
    SELECT product_id, COUNT(order_id) AS total_orders
    FROM order_items
    GROUP BY product_id
) AS product_stats;

-- FR5 — Retrieve the highest-stock product from each category
SELECT p.category_id,
       p.product_name,
       p.stock
FROM products p
JOIN (
    SELECT category_id, MAX(stock) AS max_stock
	FROM products
	GROUP BY category_id
) AS max_stock_table
ON p.category_id = max_stock_table.category_id
AND p.stock = max_stock_table.max_stock;

-- =============================================================================
-- SECTION C - SUBQUERY IN WHERE WITH IN/ NOT IN
-- =============================================================================

-- FR5 — Retrieve the highest-stock product from each category
SELECT product_id, product_name, category_id
FROM products
WHERE product_id IN (
      SELECT DISTINCT product_id 
	  FROM order_items
);

-- IN2 — Retrieve products that have never been ordered
SELECT product_id, product_name, category_id
FROM products
WHERE product_id NOT IN (
      SELECT product_id 
	  FROM order_items
);

-- IN3 — Retrieve customers whose orders contain only 'Delivered' statuses
SELECT customer_id, customer_name
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders
    WHERE status != 'Delivered'
)
AND customer_id IN (
    SELECT customer_id FROM orders  -- koi order hai bhi
);

-- IN4 — Retrieve suppliers whose products have been ordered at least once
SELECT supplier_id, supplier_name
FROM suppliers
WHERE supplier_id IN (
      SELECT DISTINCT supplier_id 
	  FROM products
	  WHERE product_id IN(
            SELECT DISTINCT product_id
			FROM order_items
	  )
);


-- IN5 — Retrieve categories containing at least one product with stock greater than 100
SELECT category_id, category_name
FROM categories
WHERE category_id IN (
      SELECT category_id
	  FROM products
	  WHERE stock > 100
);

--Another way
SELECT category_id, category_name
FROM categories c
WHERE EXISTS (
    SELECT 1 
    FROM products p 
    WHERE p.category_id = c.category_id 
    AND p.stock > 100
);


-- =============================================================================
-- SECTION D - SUBQUERY WITH EXISTS / NOT EXISTS
-- =============================================================================

-- EX1 — Retrieve customers with at least one delivered order
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE c.customer_id = o.customer_id 
    AND o.status = 'Delivered'
);

-- EX2 — Retrieve customers who have no delivered orders
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE c.customer_id = o.customer_id 
    AND o.status = 'Delivered'
);

-- EX3 — Retrieve products that have never appeared in any order
SELECT p.product_id, p.product_name
FROM products p
WHERE NOT EXISTS (
      SELECT 1
	  FROM order_items oi
	  WHERE oi.product_id = p.product_id 
);

-- EX4 — Retrieve suppliers whose products have never been ordered
SELECT s.supplier_id, s.supplier_name
FROM suppliers s
WHERE NOT EXISTS (

	SELECT 1 
	FROM products p
	WHERE p.supplier_id = s.supplier_id
	AND EXISTS (
	
        SELECT 1 
		FROM order_items oi
		WHERE oi.product_id = p.product_id
   )
);

-- EX5 — Retrieve customers who have purchased products from the Electronics category
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE EXISTS (

	  SELECT 1 
	  FROM orders o
	  JOIN order_items oi ON oi.order_id = o.order_id
	  JOIN products p ON p.product_id = oi.product_id
	  JOIN categories cg ON cg.category_id = p.category_id
	  WHERE o.customer_id = c.customer_id
	  AND cg.category_name = 'Electronics'
);

--ANOTHER WAY 

SELECT 
    c.customer_id, 
    c.customer_name, 
    p.product_name,        
    cg.category_name    
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories cg ON p.category_id = cg.category_id
WHERE cg.category_name = 'Electronics';


-- =============================================================================
-- SECTION E - SUBQUERY WITH ANY / ALL
-- =============================================================================

-- ANY1 — Retrieve products priced higher than at least one product in the Books category
SELECT product_id, 
       product_name, 
	   price, 
	   category_id
FROM products 
WHERE price > ANY (
                  SELECT p.price 
				  FROM products p 
				  JOIN categories c ON p.category_id = c.category_id
                  WHERE c.category_name = 'Books');

-- ANY2 — Retrieve products priced higher than all products in the Furniture category
SELECT product_id, 
       product_name, 
	   price, 
	   category_id
FROM products 
WHERE price > ALL (
                  SELECT p.price 
				  FROM products p 
				  JOIN categories c ON p.category_id = c.category_id
                  WHERE c.category_name = 'Furniture');


-- ANY3 — Retrieve customers located in cities that contain at least one Gold member
SELECT customer_name,
	   city,
	   membership
FROM customers 
WHERE city = ANY (
                  SELECT DISTINCT city
				  FROM customers
				  WHERE membership = 'Gold');

-- ALL4 — Retrieve products priced higher than every product in the Clothing category
SELECT product_id,
       product_name,
	   price,
	   category_id
FROM products
WHERE price > ALL (
                   SELECT p.price
				   FROM products p
				   JOIN categories c ON p.category_id = c.category_id
				   WHERE c.category_name = 'Clothing'
);
-- =============================================================================
-- SECTION F - CO-RELATED SUBQUERY
-- =============================================================================
-- CO1 — Display each product along with its category's average product price
--(Correlated scalar subquery in SELECT)
SELECT p1.product_name,
       p1.price,
	   p1.category_id,
	   
	   ( SELECT ROUND(AVG(p2.price),2)
	     FROM products p2
		 WHERE p2.category_id = p1.category_id
	   ) AS category_avg_price
	   
FROM products p1;


-- CO2 — Retrieve the most expensive product from each category
SELECT product_name,
       price,
       category_id
FROM products p1
WHERE price =   (
                 SELECT MAX(p2.price)
				 FROM products p2
				 WHERE p2.category_id = p1.category_id
				); 

-- CO3 — Retrieve customers whose total spending exceeds the average spending within their city
--(Correlated — city ke hisaab se compare)
SELECT 
    c1.customer_id, 
    c1.customer_name, 
    c1.city,
    -- Har customer ki total spending calculate karna
    (SELECT SUM(oi1.quantity * oi1.unit_price)
     FROM orders o1
     JOIN order_items oi1 ON o1.order_id = oi1.order_id
     WHERE o1.customer_id = c1.customer_id) AS total_spent
FROM customers c1
WHERE 
    -- Condition: Spending city average se zyada honi chahiye
    (SELECT SUM(oi1.quantity * oi1.unit_price)
     FROM orders o1
     JOIN order_items oi1 ON o1.order_id = oi1.order_id
     WHERE o1.customer_id = c1.customer_id) 
    > 
    -- Subquery: City ka average spending nikalna
    (SELECT AVG(customer_total)
     FROM (
         SELECT SUM(oi2.quantity * oi2.unit_price) AS customer_total
         FROM customers c2
         JOIN orders o2 ON c2.customer_id = o2.customer_id
         JOIN order_items oi2 ON o2.order_id = oi2.order_id
         WHERE c2.city = c1.city -- Correlation Link
         GROUP BY c2.customer_id
     ) AS city_avg_table
);

				  
-- CO4 — Display each order total along with the customer's average order value
--(Correlated in SELECT)
SELECT o1.order_id,
       o1.customer_id,
	   (
        SELECT SUM(oi1.quantity * oi1.unit_price) 
		FROM order_items oi1
		WHERE oi1.order_id = o1.order_id
	   ) AS order_total,
	   
	   (
        SELECT ROUND(AVG(order_sum),2)
		FROM (
              SELECT SUM(oi2.quantity * oi2.unit_price) AS order_sum
			  FROM orders o2
			  JOIN order_items oi2 ON oi2.order_id = o2.order_id
			  WHERE o2.customer_id = o1.customer_id
			  GROUP BY o2.order_id --Correlational link
		) AS customer_orders
	   ) AS customer_avg_order_value
FROM orders o1;

-- CO5 — Retrieve products priced at least 50% higher than their category's average price
--(Correlated with calculation)
SELECT p1.product_name,
	   p1.price,
	   (SELECT ROUND(AVG(p2.price),2) FROM products p2
	    WHERE p2.category_id = p1.category_id) AS category_avg_price
FROM products p1
WHERE p1.price > (
			  SELECT AVG(p2.price) * 1.5
			  FROM products p2
			  WHERE p2.category_id = p1.category_id
			  );

-- =============================================================================
-- SECTION G - NESTED SUBQUERIES + MIXED
-- =============================================================================

-- MX1 — Retrieve the customer associated with the highest-value order
SELECT customer_name
FROM customers
WHERE customer_id = (
              SELECT customer_id
			  FROM orders
			  WHERE order_id = (
                          SELECT TOP 1 order_id
						  FROM order_items
						  GROUP BY order_id
						  ORDER BY SUM(quantity * unit_price) DESC
						  
			  )
);

--ANOTHER WAY
SELECT customer_name
FROM customers 
WHERE customer_id IN (
	   SELECT customer_id
	   FROM orders
	   WHERE order_id IN (
		   SELECT order_id
		   FROM order_items
		   GROUP BY order_id
		   HAVING SUM(quantity * unit_price) = (
					 SELECT MAX(total_val) FROM (
					 SELECT SUM(quantity * unit_price) AS total_value
					 FROM order_items
					 GROUP BY order_id
					 ) AS sub
	   )
   )	   
);

-- MX2 — Calculate total supplier order values and display suppliers with sales above 50000
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.price > 50000;
        
 
-- MX3 — Calculate total supplier order values and display suppliers with sales above 50000
SELECT supplier_name, total_order_value
FROM (
    SELECT 
        s.supplier_name,
        -- Subquery: Har supplier ke saare products ki total sales nikalna
        (SELECT SUM(oi.quantity * oi.unit_price)
         FROM products p
         JOIN order_items oi ON p.product_id = oi.product_id
         WHERE p.supplier_id = s.supplier_id) AS total_order_value
    FROM suppliers s
) AS supplier_sales
WHERE total_order_value > 50000;

-- MX4 — Retrieve the second-highest priced product
SELECT MAX(price)
FROM products
WHERE price NOT IN (
      SELECT MAX(price)
	  FROM products
); 

--THIS IS ANOTHER CORRECT WAY
SELECT product_name, price
FROM products
WHERE price = (
    SELECT MAX(price) FROM products
    WHERE price != (SELECT MAX(price) FROM products)
);

-- MX5 — Retrieve Gold members whose orders contain only delivered statuses
--(Multiple conditions, multiple subqueries)
SELECT customer_name,
       city
FROM customers c
WHERE membership = 'Gold'
AND NOT EXISTS (
         SELECT 1
		 FROM orders o
		 WHERE o.customer_id = c.customer_id
		 AND o.status != 'Delivered'
)
AND EXISTS (
         SELECT 1
		 FROM orders o
		 WHERE o.customer_id = c.customer_id
);