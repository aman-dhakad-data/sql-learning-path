/* ===============================================================================
CUSTOMER DATA CLEANING PRACTICE
Concepts Covered:
- NULL Handling
- Empty String Detection
- Blank Space Cleaning
- TRIM()
- NULLIF()
- COALESCE()
- Data Standardization
- Data Cleaning Queries
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================
CREATE TABLE customer_data (
			 customer_id   INT,
			 customer_name VARCHAR(50),
			 email         VARCHAR(100),
			 phone         VARCHAR(20),
			 city          VARCHAR(50)
);

INSERT INTO customer_data (customer_id, customer_name, email, phone, city) VALUES
(1,'Riya','riya@email.com','9876543210','Delhi'),
(2,'Arjun',NULL,'','Mumbai'),
(3,'Kabir','kabir@email.com',' ','Bangalore'),
(4,'Meera','','9998887777','Delhi'),
(5,'Aisha','aisha@email.com',NULL,' '),
(6,'Rahul',' ','8887776666','Pune'),
(7,'Sneha',NULL,'   ','Chennai'),
(8,'Dev','dev@email.com','','Delhi'),
(9,'Ankit','',' ','Mumbai'),
(10,'Priya',NULL,NULL,'Bangalore');

-- =============================================================================
-- VIEW RAW CUSTOMER DATA
-- =============================================================================
SELECT * 
FROM customer_data;

-- =============================================================================
-- DATA CLEANING TASKS
-- =============================================================================
-- =============================================================================
-- NULL AND EMPTY VALUE DETECTION
-- =============================================================================

-- Task 1 — Find Customers with NULL Emails
-- Retrieve customers whose email values are NULL
-- Expected Concept: WHERE email IS NULL
SELECT 
      customer_id,
	  customer_name,
	  email
	  FROM customer_data
	  WHERE email IS NULL;

-- Task 2 — Find Customers with Empty Emails
-- Retrieve customers whose email values are empty strings ('')
-- Expected Concept: email = ''

SELECT 
      customer_id,
	  customer_name,
	  email
	  FROM customer_data
	  WHERE TRIM(email) = '';

-- Task 3 — Find Customers with Blank Space Emails
-- Retrieve customers whose email values contain blank spaces
-- Expected Concept: email = ' '

SELECT 
      customer_id,
	  customer_name,
	  email
	  FROM customer_data
	  WHERE TRIM(email) = '';

-- =============================================================================
-- PHONE CLEANING
-- =============================================================================

-- Task 4 — Check Phone Numbers for Extra Spaces
-- Hint: Use TRIM(phone)
-- Goal: Display both original and trimmed phone values

SELECT 
     customer_id,
	 phone,
	 LEN(phone) AS phone_length,
	 TRIM(phone) AS trimmed_phone
FROM customer_data;

-- =============================================================================
-- VALUE STANDARDIZATION
-- =============================================================================

-- Task 5 — Convert Empty and Blank Phone Values to NULL
-- Hint: Use NULLIF(TRIM(phone), '')
-- Output Column: clean_phone
SELECT 
     customer_id,
	 phone,
	 NULLIF(TRIM(phone),'') AS clean_phone
FROM customer_data;

-- Task 6 — Clean Phone Numbers with Default Values
-- Replace missing phone values with 'Unknown'
-- Hint: Use COALESCE(NULLIF(TRIM(phone), ''), 'Unknown')

SELECT 
     customer_id,
	 phone,
	 COALESCE(NULLIF(TRIM(phone),''), 'Unknown') AS clean_phone
FROM customer_data;

-- Task 7 — Clean City Values
-- Remove unnecessary spaces from city values
-- Convert empty strings ('') to NULL
-- Hint: Use NULLIF(TRIM(city), '')

SELECT 
     customer_id,
	 city,
	 NULLIF(TRIM(city),'') AS clean_city
FROM customer_data;

-- =============================================================================
-- FINAL CLEANING QUERY
-- =============================================================================

-- Task 8 — Final Customer Data Cleaning Query
-- Required Output Columns:
-- customer_id
-- customer_name
-- clean_email
-- clean_phone
-- clean_city
-- Rules:
-- Remove unnecessary spaces
-- Convert empty strings ('') to NULL
-- Replace NULL values with 'Unknown'

SELECT
     customer_id,
	 customer_name,
	 COALESCE(NULLIF(TRIM(email), ''), 'Unknown') AS clean_email,
	 COALESCE(NULLIF(TRIM(phone), ''), 'Unknown') AS clean_phone,
	 COALESCE(NULLIF(TRIM(city), ''), 'Unknown') AS clean_city
FROM customer_data;