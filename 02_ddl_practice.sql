/* ===============================================================================
DDL PRACTICE
Concepts Covered:
- CREATE TABLE
- ALTER TABLE
- DROP TABLE
- Constraints
=============================================================================== */


-- =============================================================================
-- PERSONS TABLE
-- =============================================================================

-- Create a table to store person details
CREATE TABLE persons(
       id INT NOT NULL,
	   person_name VARCHAR (50) NOT NULL,
	   birth_date DATE,
	   phone VARCHAR (15) NOT NULL
);

-- Retrieve all records from the persons table
SELECT * 
FROM persons;

-- Add an email column to the persons table
ALTER TABLE persons
ADD email VARCHAR (50) NOT NULL;

-- Remove the phone column from the persons table
ALTER TABLE persons
DROP COLUMN phone;

-- Delete the persons table
DROP TABLE persons;


-- =============================================================================
-- ORDERS TABLE
-- =============================================================================

-- Create an orders table with a unique email constraint
CREATE TABLE orders(
	   order_id INT NOT NULL,
	   product VARCHAR (50),
	   email VARCHAR (50) NOT NULL,
	   customer_name VARCHAR (50) NOT NULL,
	   CONSTRAINT uq_orders_email UNIQUE (email)
	   );

-- Retrieve all records from the orders table
SELECT * 
FROM orders;

-- Add a phone column to the orders table
ALTER TABLE orders
ADD phone VARCHAR (15) NOT NULL;

-- Remove the phone column from the orders table
ALTER TABLE orders
DROP COLUMN phone;

-- Remove the unique constraint from the orders table
ALTER TABLE orders
DROP CONSTRAINT uq_orders_email;

-- Delete the orders table
DROP TABLE orders;