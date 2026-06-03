/* ===============================================================================
MULTI-TABLE JOINS AND BUSINESS ANALYSIS
Concepts Covered:
- Multi-Table Joins
- LEFT JOIN
- Anti Joins
- Revenue Calculations
- Aggregations
- Ranking Functions
- Business Reporting Queries
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Country VARCHAR(50)
);

-- =============================================================================
-- SAMPLE DATA INSERTION
-- =============================================================================
INSERT INTO Customers (customerid, firstname, lastname, country) VALUES
(1,'Aman','Sharma','India'),
(2,'Riya','Verma','India'),
(3,'Kabir','Mehta','India'),
(4,'Sneha','Kapoor','India'),
(5,'Arjun','Rana','India');

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price INT
);

INSERT INTO Products (ProductID, ProductName, Price) VALUES
(101,'Mouse',500),
(102,'Keyboard',1200),
(103,'Monitor',8000),
(104,'Headphones',1500),
(105,'Webcam',2200);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);

INSERT INTO Employees (employeeid, firstname, lastname) VALUES
(1,'Raj','Malhotra'),
(2,'Neha','Singh'),
(3,'Vikram','Joshi');

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    SalesPersonID INT,
    Quantity INT,
    OrderDate DATE
);

INSERT INTO Orders (orderid, customerid, productid, salespersonid , quantity, orderdate) VALUES
(1,1,101,1,2,'2025-01-10'),
(2,2,103,2,1,'2025-01-11'),
(3,3,105,3,3,'2025-01-12'),
(4,4,102,2,1,'2025-01-15'),
(5,5,104,1,2,'2025-01-18'),
(6,2,999,3,1,'2025-01-20'),   -- invalid product
(7,9,101,1,1,'2025-01-22'),   -- invalid customer
(8,3,103,5,2,'2025-01-25');   -- invalid employee

-- =============================================================================
-- VIEW TABLE DATA
-- =============================================================================
SELECT * FROM customers;
SELECT * FROM Products;
SELECT * FROM employees;
SELECT * FROM orders;

-- =============================================================================
-- BUSINESS ANALYSIS TASKS
-- =============================================================================

-- =============================================================================
-- TASK 1 — GENERATE A COMPLETE ORDER SUMMARY
-- =============================================================================

-- Display the following details for each order:
-- OrderID
-- Customer full name
-- Product name
-- Employee full name
-- Quantity
-- TotalAmount (Quantity * Price)
SELECT 
    o.OrderId,
	CONCAT(c.firstname,' ',c.lastname) AS CustomerFullName,
	p.productname,
	CONCAT(e.firstname,' ',e.lastname) AS EmployeeFullName,
	o.quantity,
	(o.quantity * p.price) AS total_amount
FROM orders AS o
LEFT JOIN customers AS c
ON o.customerid = c.customerid
LEFT JOIN products AS p
ON o.productid = p.productid
LEFT JOIN employees AS e
ON o.salespersonid = e.employeeid;

-- =============================================================================
-- TASK 2 — IDENTIFY INVALID REFERENCES USING ANTI JOINS
-- =============================================================================

-- Anti join validation queries
-- Find orders with invalid product references
SELECT * FROM orders AS o
LEFT JOIN products AS p
ON o.productid = p.productid
WHERE p.productID IS NULL;

-- Find orders with invalid customer references
SELECT * FROM orders AS o
LEFT JOIN customers AS c
ON o.customerid = c.customerid
WHERE c.customerID IS NULL;

-- Find orders with invalid employee references
SELECT * FROM orders AS o
LEFT JOIN employees AS e
ON o.salespersonid  = e.employeeid 
WHERE e.employeeid IS NULL;

-- =============================================================================
-- TASK 3 — BUSINESS ANALYSIS QUERIES
-- =============================================================================

-- Find the top-selling product based on total quantity sold
SELECT TOP 1
   p.productname,
   sum(o.quantity) AS total_quantity
FROM orders AS o
 JOIN products AS p
ON o.productid = p.productid
GROUP BY p.productname;

-- Find the employee who generated the highest revenue
SELECT TOP 1 
   e.employeeid,
   CONCAT(e.firstname,' ',e.lastname) AS EmployeeFullName,
   sum(o.quantity * p.price) AS TotalRevenue
FROM orders AS o 
JOIN employees AS e
ON o.salespersonid = e.employeeid
JOIN products AS p
ON o.productid = p.productid 
GROUP BY e.employeeid, e.firstname, e.lastname
ORDER BY TotalRevenue DESC;

SELECT *
FROM (
    SELECT 
        e.EmployeeID,
        CONCAT(e.FirstName,' ',e.LastName) AS EmployeeName,
        SUM(o.Quantity * p.Price) AS TotalRevenue,
        RANK() OVER (ORDER BY SUM(o.Quantity * p.Price) DESC) rnk
    FROM Orders o
    JOIN Employees e
    ON o.SalesPersonID = e.EmployeeID
    JOIN Products p
    ON o.ProductID = p.ProductID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
) t
WHERE rnk = 1;