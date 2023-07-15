# Section 22 - SQL Temporary tables

# exercise 296.1 - Store the highest contract salary values of all male employees in a temporary 
# table called male_max_salaries.
CREATE TEMPORARY TABLE male_max_salaries
SELECT s.emp_no, MAX(s.salary) 
FROM salaries s
	JOIN employees e ON e.emp_no = s.emp_no
WHERE e.gender = 'M'
GROUP BY s.emp_no;

#exercise 296.2 - Write a query that, upon execution, allows you to check the result set contained in the 
# male_max_salaries temporary table you created in the previous exercise.
SELECT * FROM male_max_salaries;

DROP TABLE male_max_salaries;

## temporary tables cannot be used with self_joins, UNION nor UNION ALL operators

CREATE TEMPORARY TABLE dates
SELECT
	NOW() AS current_date_and_time,
    DATE_SUB(NOW(), INTERVAL 1 MONTH) AS a_month_earlier,
    DATE_SUB(NOW(), INTERVAL -1 YEAR) AS a_year_later;
    
SELECT * FROM dates;

SELECT 
	* 
FROM 
	dates d1
UNION SELECT
	*
FROM dates d2; -- doesn't work!

WITH cte AS (
SELECT
	NOW() AS current_date_and_time,
    DATE_SUB(NOW(), INTERVAL 1 MONTH) AS a_month_earlier,
    DATE_SUB(NOW(), INTERVAL -1 YEAR) AS a_year_later
)
SELECT * FROM dates d1 JOIN cte c;

WITH cte AS (
SELECT
	NOW() AS current_date_and_time,
    DATE_SUB(NOW(), INTERVAL 1 MONTH) AS a_month_earlier,
    DATE_SUB(NOW(), INTERVAL -1 YEAR) AS a_year_later
)
SELECT * FROM dates UNION ALL SELECT * FROM cte;

DROP TABLE IF EXISTS f_highest_salaries;
DROP TABLE dates;

# exercise 299.1 - Create a temporary table called dates containing the following three columns:
# - one displaying the current date and time,
# - another one displaying two months earlier than the current date and time, and a
# - third column displaying two years later than the current date and time.

CREATE TEMPORARY TABLE dates
SELECT 
	NOW(),
	DATE_SUB(NOW(), INTERVAL 2 MONTH) AS two_months_earlier,
    DATE_SUB(NOW(), INTERVAL -2 YEAR) AS twp_years_later;
    
SELECT * FROM dates;

WITH cte AS (
SELECT 
	NOW(),
	DATE_SUB(NOW(), INTERVAL 2 MONTH) AS two_months_earlier,
    DATE_SUB(NOW(), INTERVAL -2 YEAR) AS twp_years_later
)
SELECT * FROM dates JOIN cte;

WITH cte AS (
SELECT 
	NOW(),
	DATE_SUB(NOW(), INTERVAL 2 MONTH) AS two_months_earlier,
    DATE_SUB(NOW(), INTERVAL -2 YEAR) AS twp_years_later
)
SELECT * FROM dates UNION ALL SELECT * FROM cte;

DROP TABLE IF EXISTS dates;
