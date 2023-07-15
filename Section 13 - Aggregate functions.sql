# Section 13 - Aggregate functions

-- COUNT
SELECT * 
FROM salaries 
ORDER by salary DESC
LIMIT 10;

SELECT 
	COUNT(salary)
FROM salaries;

SELECT 
	COUNT(from_date)
FROM salaries;

SELECT 
	COUNT(DISTINCT from_date)
FROM salaries;

/* Using COUNT(*) counts all rows including NULL values, while using 
COUNT(salary) will only count the rows where value is differnt from NULL */ 

/* Don't use space between the name of the function and the parenthesis */

/* How many departments exist in the database? */
SELECT COUNT(DISTINCT dept_no)
FROM dept_emp;

SELECT * FROM dept_emp;

-- SUM
SELECT 
	SUM(salary)
FROM salaries;

# Using SUM(*) doesn't work
# COUNT is the only function that works with numeric and non-numeric data

# SUM
SELECT 
	SUM(salary)
FROM salaries
WHERE from_date > '1997-01-01';

-- MAX and MIN
# Which is the highest salary we offer?

SELECT MAX(salary) FROM salaries;
SELECT MIN(salary) FROM salaries;

# Lowest and highest employee number in the database
SELECT MIN(emp_no) FROM employees;
SELECT MAX(emp_no) FROM employees;

-- AVG
# Extracts the average value of all non-NULL values in a field
SELECT 
	AVG(salary)
FROM salaries;

SELECT
	AVG(salary)
FROM salaries
WHERE from_date > '1997-01-01';

-- ROUND
SELECT
	ROUND(AVG(salary), 2)
FROM salaries
WHERE from_date > '1997-01-01';

-- IFNULL and COALESCE
ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

INSERT INTO departments_dup
(
	dept_no
) VALUES
	('d010'), ('d011');
    
SELECT * FROM departments_dup order by dept_no asc;

ALTER TABLE employees.departments_dup
ADD COLUMN dept_manager VARCHAR(255) NULL AFTER dept_name;

SELECT * FROM departments_dup ORDER BY dept_no ASC;
COMMIT;

SELECT 
	dept_no,
	IFNULL(dept_name, 'Deparment name not provided') AS dept_name
FROM departments_dup;

SELECT
	dept_no,
    dept_name,
    COALESCE(dept_manager, dept_name, 'N/A') as dept_manager
FROM
	departments_dup
ORDER BY dept_no ASC;

/* When using COALESCE the fuction checks the first value to see if it's NULL,
if it is it will check the next value. If it's also NULL it will check the next 
and do this until it finds a value differnt from NULL */ 

/* Using IFNULL and COALESCE doesn't change the data in the database */

SELECT
	dept_no,
    dept_name,
    COALESCE('department manager name') as fake_col
FROM
	departments_dup;
    
/* COALESCE can help visualize a prototype of the table's final version.
This trick doesn't work with IFNULL */

SELECT 
	dept_no, 
	dept_name,
    COALESCE(dept_name, dept_no) AS dept_info
FROM departments_dup;
