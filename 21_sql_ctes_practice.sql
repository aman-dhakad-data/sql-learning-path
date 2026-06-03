/* ===============================================================================
CTEs PRACTICE
Concepts Covered:
- Common Table Expressions (CTEs)
- Standalone CTEs
- Multiple / Nested CTEs
- Recursive CTEs
- CTE + Window Function Combinations
- Aggregations with CTEs
- Ranking & Analytical Queries
- Hierarchical Data Processing
=============================================================================== */

-- ============================================================
-- CTEs PRACTICE
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

-- Yeh table existing database mein add karo
--TABLE 7: emp_org
CREATE TABLE emp_org (
    emp_id    INT PRIMARY KEY,
    emp_name  VARCHAR(100),
    manager_id INT  -- NULL = top level (CEO)
);

INSERT INTO emp_org VALUES
(1, 'Sunita Rao',    NULL),   -- CEO
(2, 'Arjun Das',     1),      -- Reports to CEO
(3, 'Meera Nair',    1),      -- Reports to CEO
(4, 'Vivek Tiwari',  2),      -- Reports to Arjun
(5, 'Karan Mehta',   2),      -- Reports to Arjun
(6, 'Priya Kapoor',  3),      -- Reports to Meera
(7, 'Rohit Sharma',  4),      -- Reports to Vivek
(8, 'Anjali Singh',  4),      -- Reports to Vivek
(9, 'Dev Gupta',     6),      -- Reports to Priya
(10,'Nisha Patel',   3);      -- Reports to Meera

-- =============================================================================
-- VERIFY
-- =============================================================================
SELECT 'categories'  AS tbl, COUNT(*) FROM categories  UNION ALL
SELECT 'suppliers'   AS tbl, COUNT(*) FROM suppliers   UNION ALL
SELECT 'products'    AS tbl, COUNT(*) FROM products    UNION ALL
SELECT 'customers'   AS tbl, COUNT(*) FROM customers   UNION ALL
SELECT 'orders'      AS tbl, COUNT(*) FROM orders      UNION ALL
SELECT 'order_items' AS tbl, COUNT(*) FROM order_items UNION ALL
SELECT 'emp_org'     AS tbl, COUNT(*) FROM emp_org;


-- =============================================================================
-- 25 PRACTICE QUESTIONS — CTEs
-- =============================================================================

-- =============================================================================
-- SECTION A - STANDALONE CTE 
-- =============================================================================

-- CT1 — Use a CTE to find products whose price is higher than their category's average price. 
--       (First calculate category avg in the CTE, then filter.)
WITH Category_avg AS (
     SELECT category_id,
	 ROUND(AVG(price),2) AS avg_price
	 FROM products 
	 GROUP BY category_id
)
SELECT p.product_name,
       p.price,
	   p.category_id,
	   c.avg_price
FROM products p
JOIN Category_avg c 
ON c.category_id = p.category_id
WHERE p.price > c.avg_price;

-- CT2 — Use a CTE to get total product count per supplier, then show only those with 2 or more products.
WITH SupplierCount AS (
      SELECT supplier_id,
	         COUNT(product_id) AS total_products
	  FROM products
	  GROUP BY supplier_id
)
SELECT s.supplier_name,
       sc.total_products
FROM suppliers s
JOIN SupplierCount sc 
ON sc.supplier_id = s.supplier_id
WHERE sc.total_products >= 2;

-- CT3 — In a CTE, calculate each customer's total spending (quantity × unit_price, Delivered orders only). 
--       Then show only Gold members along with their spending.
WITH CustomerSpending AS (
     SELECT o.customer_id,
	        SUM(oi.quantity *oi. unit_price) AS total_spent
	 FROM orders o
	 JOIN order_items oi
	 ON o.order_id = oi.order_id
	 WHERE o.status = 'Delivered'
	 GROUP BY o.customer_id
)
SELECT c.customer_name,
       c.city,
	   c.membership,
       cs.total_spent
FROM customers c
JOIN CustomerSpending cs 
ON cs.customer_id = c.customer_id
WHERE membership = 'Gold';

-- CT4 — Use a CTE to find the product with the highest stock. Then show which supplier supplies that product.
WITH MaxStockProduct AS (
     SELECT product_id, 
	        product_name, 
			supplier_id, 
			stock
	 FROM products
	 WHERE stock = (SELECT MAX(stock) FROM products)
)
SELECT 
		msp.product_name, 
		msp.stock, 
		s.supplier_name
FROM MaxStockProduct msp
JOIN suppliers s ON msp.supplier_id = s.supplier_id;

-- CT5 — Use a CTE to find orders whose total value exceeds 10000. Show order ID, customer name, and total value.
WITH OrderTotals AS (
     SELECT order_id,
	        SUM(quantity * unit_price) AS total_value
	 FROM order_items
	 GROUP BY order_id
)
SELECT o.order_id,
       c.customer_name,
	   ot.total_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN OrderTotals ot ON o.order_id = ot.order_id
WHERE total_value > 10000;

-- CT6 — In a CTE, count how many products are in each category. 
--       Then show only categories that have 3 or more products — include the category name.
WITH CategoryCount AS (
     SELECT category_id,
	        COUNT(product_id) AS product_count
	 FROM products
	 GROUP BY category_id
)
SELECT c.category_id,
       c.category_name,
	   cc.product_count
FROM categories c
JOIN CategoryCount cc ON c.category_id = cc.category_id
WHERE cc.product_count >= 3;

-- CT7 — Use a CTE to find the customer with the most orders.
--       Only one row should appear — customer name and order count.
WITH CustomerOrders AS (
     SELECT customer_id,
	        COUNT(order_id) AS order_count
	FROM orders
	GROUP BY customer_id
)
SELECT  c.customer_name,
        co.order_count
FROM customers c
JOIN CustomerOrders co ON co.customer_id = c.customer_id
ORDER BY co.order_count DESC
LIMIT 1;

-- CT8 — In a CTE, calculate the average price of products. 
--       Then for each product, show how much percent above or below the average it is. ((price - avg) / avg * 100)
WITH ProductsAvgPrice AS (
     SELECT AVG(price) AS table_avg
	 FROM products
)
SELECT p.product_name,
       p.price,
	   ROUND(pap.table_avg, 2),
	   ROUND(((p.price - pap.table_avg) / pap.table_avg) * 100, 2) AS precentage_diff
FROM products p
CROSS JOIN ProductsAvgPrice pap;


-- =============================================================================
-- SECTION B - MULTIPLE CTEs / NESTED CTE 
-- =============================================================================

-- MC1 — First CTE: total spending per customer. Second CTE: overall average spending. 
--       Final query: show only those whose spending is above average — customer name and spending.
WITH CustomerSpending AS (
     SELECT customer_id,
	        SUM(quantity * unit_price) AS total_spent
	 FROM orders o
	 JOIN order_items oi ON o.order_id = oi.order_id
	 GROUP BY customer_id
),
AverageSpending AS (
     SELECT AVG(total_spent) AS avg_spent
	 FROM CustomerSpending
)
SELECT c.customer_name,
       cs.total_spent
FROM customers c
JOIN CustomerSpending cs ON cs.customer_id = c.customer_id
CROSS JOIN AverageSpending asp
WHERE cs.total_spent > asp.avg_spent;

-- MC2 — First CTE: total value of each order. Second CTE: average order value per customer. 
--       Final: show customer name and avg order value — only for Silver or Gold members.
WITH OrderTotals AS (
     SELECT o.order_id,
	        o.customer_id,
	        SUM(oi.quantity * oi.unit_price) AS total_value
	 FROM orders o
	 JOIN order_items oi ON oi.order_id = o.order_id
	 GROUP BY o.order_id, o.customer_id
),
CustomerAverages AS (
     SELECT customer_id,
	        ROUND(AVG(total_value),2) AS persona_avg_val
	 FROM OrderTotals
	 GROUP BY customer_id
)
SELECT c.customer_name,
       ca.persona_avg_val,
	   c.membership
FROM customers c
JOIN CustomerAverages ca ON ca.customer_id = c.customer_id
WHERE c.membership IN ('Silver', 'Gold');

-- MC3 — First CTE: Delivered orders only. Second CTE: 
--       how many times each product was ordered in those delivered orders. Final: show top 5 most ordered products.
WITH DeliveredOrders AS (
     SELECT order_id
	 FROM orders
	 WHERE status = 'Delivered'
),
ProductOrderCount AS (
     SELECT oi.product_id,
	        COUNT(oi.order_id) AS times_ordered
	 FROM order_items oi
	 JOIN DeliveredOrders dos ON dos.order_id = oi.order_id
	 GROUP BY oi.product_id
)
SELECT p.product_name,
       poc.times_ordered
FROM products p
JOIN ProductOrderCount poc ON p.product_id = poc.product_id
ORDER BY poc.times_ordered DESC
LIMIT 5;

--MC4 — First CTE: total order value per supplier's products. Second CTE: average supplier order value.
--      Final: show only suppliers whose total value is above average — include supplier name.
WITH SupplierRevenue AS (
     SELECT p.supplier_id,
	        SUM(oi.quantity * oi.unit_price) AS total_value
	 FROM products p
	 JOIN order_items oi ON oi.product_id = p.product_id
	 GROUP BY p.supplier_id
),
AverageRevenue AS (
     SELECT AVG(total_value) AS ave_value
	 FROM SupplierRevenue
)
SELECT s.supplier_name,
       sr.total_value,
	   ar.ave_value
FROM suppliers s
JOIN SupplierRevenue sr ON sr.supplier_id = s.supplier_id
CROSS JOIN AverageRevenue ar
WHERE sr.total_value > ar.ave_value;

-- MC5 — First CTE: average price per category. Second CTE: each product's difference from its category avg. 
--       Final: show the most overpriced product — the one furthest above its category average.
WITH CategoryAverages AS (
     SELECT category_id,
	        AVG(price) AS avg_price
	 FROM products
	 GROUP BY category_id
),
ProductDifferences AS (
     SELECT p.product_id,
	        p.product_name,
			p.price,
			ca.avg_price,
	        (p.price - ca.avg_price) AS price_diff
	 FROM products p
	 JOIN CategoryAverages ca ON ca.category_id = p.category_id
)

SELECT product_name,
       price,
       ROUND(avg_price, 2) AS category_avg,
	   ROUND(price_diff, 2) AS overpriced_by
FROM ProductDifferences
ORDER BY price_diff DESC
LIMIT 1;


-- MC6 — First CTE: total orders per customer. Second CTE: total spending per customer. 
--       Final: show customer name, total orders, total spending, and spending per order (total_spent / total_orders).
WITH CustomerOrders AS (
     SELECT customer_id,
	        COUNT(order_id) AS total_orders
	 FROM orders 
	 GROUP BY customer_id
),
CustomerSpendings AS (
     SELECT o.customer_id,
	        SUM(oi.quantity * oi.unit_price) AS total_spent
	 FROM orders o
	 JOIN order_items oi ON oi.order_id = o.order_id
	 GROUP BY customer_id
)

SELECT c.customer_name,
       co.total_orders,
	   ROUND(cs.total_spent, 2) AS total_spending,
	   ROUND(cs.total_spent / co.total_orders , 2) AS spending_per_order
FROM customers c
JOIN CustomerOrders co ON co.customer_id = c.customer_id
JOIN CustomerSpendings cs ON cs.customer_id = c.customer_id
ORDER BY total_spending DESC;


-- MC7 — First CTE: only products that have been ordered at least once. Second CTE: 
--       category-wise average price of those products. 
--       Final: show category name and avg price — join with categories table.
WITH OrderedProductIDs AS (
     SELECT DISTINCT product_id
	 FROM order_items
),
CategoryAvgPrice AS (
	SELECT p.category_id,
	       AVG(p.price) AS avg_price
	FROM products p
	JOIN OrderedProductIDs op ON p.product_id = op.product_id
	GROUP BY p.category_id 
)
SELECT c.category_name,
       ROUND(ca.avg_price, 2) AS average_product_price
FROM categories c
JOIN CategoryAvgPrice ca ON ca.category_id = c.category_id;


-- MC8 — First CTE: total value of each order. Second CTE: count of distinct products in each order. 
--       Third CTE: combine both. Final: show order id, customer name, total value, and product count.
WITH OrderValue AS (
     SELECT order_id,
	        SUM(quantity * unit_price) AS total_order_value
	 FROM order_items
	 GROUP BY order_id
),
OrderProductCount AS (
     SELECT order_id,
	 COUNT(DISTINCT product_id) AS distinct_products
	 FROM order_items
	 GROUP BY order_id
),
CombineData AS (
     SELECT ov.order_id,
	        ov.total_order_value,
	        opc.distinct_products
	 FROM OrderValue ov
	 JOIN OrderProductCount opc ON opc.order_id = ov.order_id
)
SELECT o.order_id,
       c.customer_name,
	   ROUND(cm.total_order_value, 2) AS order_total,
	   cm.distinct_products
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN CombineData cm ON cm.order_id = o.order_id
ORDER BY order_total DESC;


-- MC9 — First CTE: customers who have Cancelled orders. Second CTE: customers who have only Delivered orders. 
--       Final: show both lists together — add a label column with 'Only Cancelled' or 'Only Delivered'.
WITH OnlyCancelledCustomer AS(
     SELECT DISTINCT customer_id
	 FROM orders
	 WHERE status = 'Cancelled'
	 AND customer_id NOT IN (SELECT customer_id FROM orders WHERE status = 'Delivered')
),
OnlyDeliveredCustomer AS (
     SELECT DISTINCT customer_id
	 FROM orders
	 WHERE status = 'Delivered'
	 AND customer_id NOT IN (SELECT customer_id FROM orders WHERE status = 'Cancelled')
)
SELECT c.customer_id,
       'Only Cancelled' AS customer_status
FROM customers c
JOIN OnlyCancelledCustomer occ ON c.customer_id = occ.customer_id

UNION ALL

SELECT c.customer_id,
       'Only Delivered' AS customer_status
FROM customers c
JOIN OnlyDeliveredCustomer odc ON c.customer_id = odc.customer_id;


-- =============================================================================
-- SECTION C - RECURSIVE CTE
-- =============================================================================

-- RC1 — Build a full org chart — show each employee's name and their level. 
--       CEO = Level 1, direct reports = Level 2, and so on.
WITH RECURSIVE OrgChart AS (
 
     SELECT emp_id,
	        emp_name,
			manager_id,
			1 AS level
	 FROM emp_org
	 WHERE manager_id IS NULL

	 UNION ALL

	 SELECT e.emp_id,
	        e.emp_name,
			e.manager_id,
			oc.level + 1 AS level
	 FROM emp_org e
	 JOIN OrgChart oc ON e.manager_id = oc.emp_id
)
SELECT * FROM OrgChart
ORDER BY level, manager_id;

-- RC2 — Extend RC1 — show the manager's name alongside each employee in every row.
WITH RECURSIVE OrgChart AS (

	 SELECT emp_id,
	        emp_name,
			manager_id,
			CAST('Top Level' AS VARCHAR(100)) AS manager_name,
			1 AS level
	 FROM emp_org
	 WHERE manager_id IS NULL

	 UNION ALL

	 SELECT e.emp_id,
	        e.emp_name,
			e.manager_id,
			oc.emp_name AS manager_name,
			oc.level + 1 AS level
	 FROM emp_org e
	 JOIN OrgChart oc ON e.manager_id = oc.emp_id
)
SELECT emp_name,
       manager_name,
	   level
FROM OrgChart
ORDER BY level, manager_name ;

--RC3 — Show only employees at Level 3 and below — those who are 3 or more steps away from the CEO.
WITH RECURSIVE OrgChart AS (

	 SELECT emp_id,
	        emp_name,
			manager_id,
			1 AS level
	FROM emp_org
	WHERE manager_id IS NULL

    UNION ALL

	SELECT e.emp_id,
	       e.emp_name,
		   e.manager_id,
		   oc.level + 1 AS level
	FROM emp_org e
	JOIN OrgChart oc ON e.manager_id = oc.emp_id		
)
SELECT * FROM OrgChart
WHERE level >= 3
ORDER BY level, manager_id;


-- RC4 — For each employee, count how many people are below them (direct + indirect). 
--       CEO should have everyone, leaf nodes should have 0.
WITH RECURSIVE EmployeeHierarchy AS (
     SELECT emp_id,
	        manager_id,
			emp_id AS subordinate_id
	 FROM emp_org

	 UNION ALL

	 SELECT e.emp_id,
	        e.manager_id,
			eh.subordinate_id
	 FROM emp_org e
	 JOIN EmployeeHierarchy eh ON e.emp_id = eh.manager_id
)
SELECT e.emp_name,
       COUNT(eh.subordinate_id) - 1 AS total_reports 
FROM emp_org e
LEFT JOIN EmployeeHierarchy eh ON e.emp_id = eh.emp_id
GROUP BY e.emp_id, e.emp_name
ORDER BY total_reports DESC;


-- =============================================================================
-- SECTION D - CTE + WINDOW FUNCTION COMBO
-- =============================================================================

-- CW1 — In a CTE, calculate total spending per customer. Then use a window function to rank them — 
--       use DENSE_RANK. Show top 3.
WITH CustomerSpending AS (
     SELECT c.customer_name,
	        SUM(oi.quantity * oi.unit_price) AS total_spent
	 FROM customers c
	 JOIN orders o ON o.customer_id = c.customer_id
	 JOIN order_items oi ON o.order_id = oi.order_id
	 GROUP BY c.customer_name
),
RankedCustomers AS (
     SELECT customer_name,
	        total_spent,
			DENSE_RANK() OVER(ORDER BY total_spent DESC) AS spending_rank
	 FROM CustomerSpending
)
SELECT * FROM RankedCustomers
WHERE spending_rank <= 3;

--CW2 — In a CTE, get monthly order counts per product. 
--      Then use a window function to rank each product by total orders. Show only rank 1 — the most ordered product.
WITH MonthlyProductSales AS (
    SELECT 
        TO_CHAR(o.order_date, 'YYYY-MM') AS order_month, 
        p.product_name,
        COUNT(oi.order_id) AS total_orders
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY order_month, p.product_name
),
RankedMonthlyProducts AS (
    SELECT 
        order_month,
        product_name,
        total_orders,
		
        RANK() OVER (PARTITION BY order_month ORDER BY total_orders DESC) AS monthly_rank
    FROM MonthlyProductSales
)
SELECT 
    order_month, 
    product_name, 
    total_orders
FROM RankedMonthlyProducts
WHERE monthly_rank = 1
ORDER BY order_month DESC;

-- CW3 — In a CTE, calculate average product price per supplier. 
--       Then use NTILE(3) to divide suppliers into 3 buckets — premium, mid, budget. Bucket 1 = highest avg price.
WITH SupplierAvgPrices AS (
    SELECT 
        s.supplier_name,
        AVG(p.price) AS avg_product_price
    FROM suppliers s
    JOIN products p ON s.supplier_id = p.supplier_id
    GROUP BY s.supplier_name
),
BucketList AS (
    SELECT 
        supplier_name,
        ROUND(avg_product_price, 2) AS avg_price,
        NTILE(3) OVER (ORDER BY avg_product_price DESC) AS bucket_num
    FROM SupplierAvgPrices
)
SELECT 
    supplier_name,
    avg_price,
    CASE 
        WHEN bucket_num = 1 THEN 'Premium'
        WHEN bucket_num = 2 THEN 'Mid'
        WHEN bucket_num = 3 THEN 'Budget'
    END AS supplier_category
FROM BucketList
ORDER BY avg_price DESC;

-- CW4 — In a CTE, calculate total value of each order. 
--       Then use LAG() to sort each customer's orders chronologically — 
--       show how much more or less they spent compared to their previous order.
WITH OrderTotals AS (
    SELECT 
        o.customer_id,
        o.order_id,
        o.order_date,
        SUM(oi.quantity * oi.unit_price) AS current_order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id, o.order_id, o.order_date
),

OrderComparison AS (
    SELECT 
        customer_id,
        order_id,
        order_date,
        current_order_value,
        
        LAG(current_order_value) OVER (
            PARTITION BY customer_id 
            ORDER BY order_date
          ) AS previous_order_value
    FROM OrderTotals
)

SELECT 
    c.customer_name, 
    oc.order_date,
    oc.current_order_value,
    COALESCE(oc.previous_order_value, 0) AS last_spend,
    (oc.current_order_value - COALESCE(oc.previous_order_value, 0)) AS diff_from_last
FROM OrderComparison oc
JOIN customers c ON oc.customer_id = c.customer_id
ORDER BY c.customer_name, oc.order_date;