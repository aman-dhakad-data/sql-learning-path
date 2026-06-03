/* ===============================================================================
RAW CUSTOMER DATA CLEANING PRACTICE
Concepts Covered:
- String Cleaning
- Standardization
- Email Normalization
- Phone Number Masking
- NULL Handling
- Text Formatting
- Data Cleaning Techniques
=============================================================================== */

-- =============================================================================
-- TABLE CREATION
-- =============================================================================
CREATE TABLE raw_customers (
    customer_id INT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(50),
    city VARCHAR(50)
);

-- =============================================================================
-- SAMPLE DATA INSERTION
-- =============================================================================
INSERT INTO raw_customers (customer_id, full_name, email, phone, city) VALUES
(1,'  aman SHARMA  ','AMAN@email.COM ',' 9876543210 ',' delhi '),
(2,'riya  verma','riya@email.com',NULL,'MUMBAI'),
(3,'KABIR mehta ','  KABIR@EMAIL.COM','  9123456789', ' pune'),
(4,'Sneha   Kapoor','Sneha@email.com ','','Delhi'),
(5,' arjun RANA','arjun@email.com',NULL,NULL);

-- =============================================================================
-- VIEW TABLE DATA
-- =============================================================================
SELECT * 
FROM raw_customers;

-- =============================================================================
-- DATA CLEANING TASKS
-- =============================================================================

-- Task 1 — Standardize customer names
-- Expected Output:
-- Remove leading and trailing spaces
-- Convert names to proper case formatting
-- Hint: Use TRIM(), LOWER(), UPPER(), and SUBSTRING()

SELECT
    full_name,
    CONCAT(
        UPPER(LEFT(TRIM(full_name),1)),
        LOWER(SUBSTRING(TRIM(full_name),2,LENGTH(TRIM(full_name))))
    ) AS formatted_name
FROM raw_customers;

-- Task 2 — Clean and standardize email addresses
-- Remove unnecessary spaces
-- Convert all email addresses to lowercase

SELECT 
      email,
	  TRIM(LOWER(email)) AS cleaned_email
FROM raw_customers;

--Task 3 — Extract Email Domain
--From: aman@email.com
-- Example Output: email.com

SELECT
    email,
    LOWER(SPLIT_PART(TRIM(email), '@', 2)) AS email_domain
FROM raw_customers;

--Task 4 — Mask Phone Number
--From: 9876543210
-- Example Output: XXXXXX3210
-- Hint: Use RIGHT(), LENGTH(), REPLACE(), or CONCAT()

SELECT
    phone,
    CASE 
        WHEN phone IS NOT NULL AND LENGTH(TRIM(phone)) >= 4
        THEN CONCAT('XXXXXX', RIGHT(TRIM(phone),4))
        ELSE NULL
    END AS masked_phone
FROM raw_customers;

-- Task 5 — Clean and standardize city names
--Remove spaces
--Make all uppercase

SELECT 
      city,
	  UPPER(TRIM(city)) AS cleaned_city
FROM raw_customers; 