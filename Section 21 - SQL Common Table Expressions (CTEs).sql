# Section 21 - SQL Common Table Expressions (CTEs)

# also knows as 'named subqueries'

WITH cte AS (
SELECT ROUND(AVG(salary), 2) AS avg_salary FROM salaries)
SELECT 
	*
FROM salaries s
	JOIN
    cte;
-- when joining without an ON keyword it becomes a CROSS JOIN
-- CTEs can be reused (refereced multiple times) within a MySQL statement

# exercise 287.1 - Use a CTE (a Common Table Expression) and a SUM() function in the SELECT statement in a 
# query to find out how many male employees have never signed a contract with a salary value higher than 
# or equal to the all-time company salary average.

WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries)
SELECT 
	SUM(CASE WHEN s.salary >= c.avg_salary THEN 1 ELSE 0 END) AS salaries_above_average
FROM employees e
	JOIN salaries s ON e.emp_no = s.emp_no
	JOIN cte c
WHERE e.gender = 'M';

WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries
)
SELECT
SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_salaries_below_avg,
COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no 
JOIN cte c
WHERE e.gender = 'M';

# exercise 287.2 - Use a CTE (a Common Table Expression) and (at least one) COUNT() function in the SELECT 
# statement of a query to find out how many male employees have never signed a contract with a salary value 
# higher than or equal to the all-time company salary average.

WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries
)
SELECT
SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_salaries_below_avg,
COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no 
JOIN cte c
WHERE e.gender = 'M';

# exercise 287.3 - Use MySQL joins (and don’t use a Common Table Expression) in a query to find out how many male 
# employees have never signed a contract with a salary value higher than or equal to the all-time company salary 
# average (i.e. to obtain the same result as in the previous exercise).

SELECT
	COUNT(CASE WHEN s.salary < (SELECT AVG(salary) FROM salaries) THEN s.salary ELSE NULL END) AS count_salaries,
    COUNT(s.salary)
FROM employees e
	JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.gender = 'M';

-- alternatively: 
SELECT
    SUM(CASE
        WHEN s.salary < a.avg_salary THEN 1
        ELSE 0
    END) AS no_salaries_below_avg,
    COUNT(s.salary) AS no_of_salary_contracts
FROM
    (SELECT
        AVG(salary) AS avg_salary
    FROM
        salaries s) a
        JOIN
    salaries s
        JOIN
    employees e ON e.emp_no = s.emp_no AND e.gender = 'M';
    

# How many female employees' highest contract salary values were higher than the all-time company salary average (across all genders)?
WITH cte1 AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte2 AS (
SELECT s.emp_no, MAX(s.salary) AS f_highest_salary
FROM salaries s
JOIN employees e ON e.emp_no = s.emp_no
WHERE e.gender = 'F'
GROUP BY s.emp_no
)
SELECT 
	SUM(CASE WHEN c2.f_highest_salary > c1.avg_salary THEN 1 ELSE 0 END) AS f_highest_salary_above_avg,
    COUNT(e.emp_no) AS total_no_female_contracts
FROM employees e
JOIN cte2 c2 ON c2.emp_no = e.emp_no
CROSS JOIN cte1 c1;

WITH cte1 AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte2 AS (
SELECT s.emp_no, MAX(s.salary) AS f_highest_salary
FROM salaries s
JOIN employees e ON e.emp_no = s.emp_no
WHERE e.gender = 'F'
GROUP BY s.emp_no
)
SELECT 
	COUNT(CASE WHEN c2.f_highest_salary > c1.avg_salary THEN c2.f_highest_salary ELSE NULL END) AS f_highest_salary_above_avg,
    COUNT(e.emp_no) AS total_no_female_contracts
FROM employees e
JOIN cte2 c2 ON c2.emp_no = e.emp_no
CROSS JOIN cte1 c1;

# with the percetage
WITH cte_avg_salary AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte_f_highest_salary AS (
SELECT s.emp_no, MAX(s.salary) AS f_highest_salary
FROM salaries s
JOIN employees e ON e.emp_no = s.emp_no
WHERE e.gender = 'F'
GROUP BY s.emp_no
)
SELECT 
	SUM(CASE WHEN c2.f_highest_salary > c1.avg_salary THEN 1 ELSE 0 END) AS f_highest_salary_above_avg,
    COUNT(e.emp_no) AS total_no_female_contracts,
    CONCAT(ROUND((SUM(CASE WHEN c2.f_highest_salary > c1.avg_salary THEN 1 ELSE 0 END) / COUNT(e.emp_no))*100, 2),'%') AS percentage
FROM employees e
JOIN cte_f_highest_salary c2 ON c2.emp_no = e.emp_no
CROSS JOIN cte_avg_salary c1;

# exercise 291.1 - Use two common table expressions and a SUM() function in the SELECT statement of a query 
# to obtain the number of male employees whose highest salaries have been below the all-time average.
WITH cte1 AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte2 AS (
SELECT e.emp_no, MAX(s.salary) AS m_highest_salary
FROM employees e
	JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.gender = 'M'
GROUP BY e.emp_no
)
SELECT
	SUM(CASE WHEN c2.m_highest_salary < c1.avg_salary THEN 1 ELSE 0 END) AS m_highest_salary_below_avg
FROM employees e
	JOIN cte2 c2 ON e.emp_no = c2.emp_no
    JOIN cte1 c1;
    
# exercise 291.2 - Use two common table expressions and a COUNT() function in the SELECT statement of a query
# to obtain the number of male employees whose highest salaries have been below the all-time average.
WITH cte1 AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte2 AS (
SELECT e.emp_no, MAX(s.salary) AS m_highest_salary
FROM employees e
	JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.gender = 'M'
GROUP BY e.emp_no
)
SELECT
	COUNT(CASE WHEN c2.m_highest_salary < c1.avg_salary THEN c2.m_highest_salary ELSE NULL END) AS m_highest_salary_below_avg
FROM employees e
	JOIN cte2 c2 ON e.emp_no = c2.emp_no
    JOIN cte1 c1;
    
# exercise 291.3 - Does the result from the previous exercise change if you used the Common Table Expression 
# (CTE) for the male employees' highest salaries in a FROM clause, as opposed to in a join?
WITH cte1 AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte2 AS (
SELECT e.emp_no, MAX(s.salary) AS m_highest_salary
FROM employees e
	JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.gender = 'M'
GROUP BY e.emp_no
)
SELECT
	COUNT(CASE WHEN c2.m_highest_salary < c1.avg_salary THEN c2.m_highest_salary ELSE NULL END) AS m_highest_salary_below_avg
FROM cte2 c2
		JOIN cte1 c1;


## solution
WITH cte_avg_salary AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte_m_highest_salary AS (
SELECT s.emp_no, MAX(s.salary) AS max_salary
FROM salaries s JOIN employees e ON e.emp_no = s.emp_no AND e.gender = 'M'
GROUP BY s.emp_no
)
SELECT
COUNT(CASE WHEN c2.max_salary < c1.avg_salary THEN c2.max_salary ELSE NULL END) AS max_salary
FROM cte_m_highest_salary c2
JOIN cte_avg_salary c1;

WITH cte_avg_salary AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte_m_highest_salary AS (
SELECT s.emp_no, MAX(s.salary) AS max_salary
FROM salaries s JOIN employees e ON e.emp_no = s.emp_no AND e.gender = 'M'
GROUP BY s.emp_no
)
SELECT
COUNT(CASE WHEN c2.max_salary < c1.avg_salary THEN c2.max_salary ELSE NULL END) AS max_salary
FROM employees e
JOIN cte_m_highest_salary c2 ON c2.emp_no = e.emp_no
JOIN cte_avg_salary c1;

WITH cte1 AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte2 AS (
SELECT s.emp_no, MAX(s.salary) AS max_salary
FROM salaries s
JOIN employees e ON e.emp_no = s.emp_no AND e.gender = 'M'
GROUP BY s.emp_no
)
SELECT
SUM(CASE WHEN c2.max_salary < c1.avg_salary THEN 1 ELSE 0 END) AS highest_salaries_below_avg
FROM employees e
JOIN cte2 c2 ON c2.emp_no = e.emp_no
JOIN cte1 c1;

-- Referring to CTEs in a WITH clause

# CTEs
## they are a tool providing temporary result sets that exist within the execution of a given query
## they are written in the WITH clause of a query
## a CTE can contain multicle subclauses (subqueries of the CTE)
## a CTE can be referenced multiple times within a query
## we can refer to a common table expressino defined earlier within a given WITH clause. We cannot refer to one that has been defined after.ALTER
 
WITH emp_hired_from_jan_2000 AS(
SELECT * FROM employees WHERE hire_date > '2000-01-01'
),
highest_contract_salary_values AS (
SELECT e.emp_no, MAX(s.salary) FROM salaries s JOIN emp_hired_from_jan_2000 e ON e.emp_no = s.emp_no GROUP BY e.emp_no
)
SELECT * FROM highest_contract_salary_values;

SELECT * FROM employees WHERE hire_date > '2000-01-01';
SELECT * FROM salaries WHERE emp_no = 205048;