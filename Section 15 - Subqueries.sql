# 15 - Subqueries
# subquery = inner query = nested query - inner select
# outerquery = outer select

SELECT * FROM dept_manager;

-- using JOIN
SELECT e.first_name, e.last_name
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no;

-- now using subquery
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.emp_no IN (SELECT dm.emp_no FROM dept_manager dm);

/* a subquery can return a single value, a single row, a single columnn or an entire table */

#exercise - Extract the information about all department managers who were hired between the 1st of January 1990 and the 1st of January 1995.
SELECT e.*
FROM employees e
WHERE e.hire_date BETWEEN '1990-01-01' AND '1995-01-01'
AND e.emp_no IN (SELECT dm.emp_no FROM dept_manager dm);

SELECT
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');
            
# EXISTS or NOT EXISTS
/* In subqueries EXISTS and IN delivery the same output
EXISTS tests row values for existance while IN searches among values
EXISTS is quicker in retrieving large amounts of data and IN is faster with smaller datasets */

# Use ORDER BY in the outer query instead of the inner query

# in general, subqueries offer enhanced code readability

# exercise - Select the entire information for all employees whose job title is “Assistant Engineer”. 
SELECT e.*
FROM employees e
WHERE EXISTS( SELECT * FROM titles t WHERE t.emp_no = e.emp_no AND title = 'Assistant Engineer');

SELECT e.*
FROM employees e
WHERE e.emp_no IN (SELECT t.emp_no FROM titles t WHERE title= 'Assistant Engineer');

/* When using EXISTS we need to add the part "t.emp_no = e.emp_no AND" so that it's
also checking the emp_no from both tables. Otherwise it will deliver everything as a
result because for sure there is one line with 'Assistent Engineer' and then
then whole things becomes true. This was very confusing! */ 

SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    dm.emp_no
                FROM
                    dept_manager dm
                WHERE
                    dm.emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no BETWEEN 10001 AND 10020
    GROUP BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    dm.emp_no
                FROM
                    dept_manager dm
                WHERE
                    dm.emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no BETWEEN 10021 AND 10040
    GROUP BY e.emp_no) AS B;

# exercise
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
	emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL, 
    manager_no INT(11) NOT NULL
);

INSERT INTO emp_manager
	SELECT U.*
    FROM 
		(SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    dm.emp_no
                FROM
                    dept_manager dm
                WHERE
                    dm.emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no BETWEEN 10001 AND 10020
    GROUP BY e.emp_no) AS A 
        UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    dm.emp_no
                FROM
                    dept_manager dm
                WHERE
                    dm.emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no BETWEEN 10021 AND 10040
    GROUP BY e.emp_no) AS B
        UNION  SELECT
        C.*
FROM 
	(SELECT 
        e.emp_no,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    dm.emp_no
                FROM
                    dept_manager dm
                WHERE
                    dm.emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039) AS C
        UNION SELECT
        D.*
FROM 
	(SELECT 
        e.emp_no,
            MIN(de.dept_no) AS dept_code,
            (SELECT 
                    dm.emp_no
                FROM
                    dept_manager dm
                WHERE
                    dm.emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022) AS D) AS U