# Section 20 - Windows Functions

USE employees;
SELECT
	emp_no,
    salary,
    ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num
FROM
	salaries;
    
-- the OVER clause relates to the window over which the function evaluation will occur
-- PARTITION BY clause is not mandatory

# exercise 259.1 - Write a query that upon execution, assigns a row number to all managers 
# we have information for in the "employees" database (regardless of their department).
# Let the numbering disregard the department the managers have worked in. Also, let it start 
# from the value of 1. Assign that value to the manager with the lowest employee number.

SELECT 
	*,
    ROW_NUMBER() OVER(ORDER BY emp_no) AS row_num
FROM dept_manager; 

# 259.2 - Write a query that upon execution, assigns a sequential number for each employee number 
# registered in the "employees" table. Partition the data by the employee's first name and order 
# it by their last name in ascending order (for each partition).

SELECT
	*,
    ROW_NUMBER() OVER(PARTITION BY first_name ORDER BY last_name) AS row_num
FROM employees;

-- Only use window specifications requiring identical partitions. In the example below only row_num2 and 3 have the same partition
SELECT
	emp_no,
    salary,
    ROW_NUMBER() OVER() AS row_num1,
    ROW_NUMBER() OVER(PARTITION BY emp_no) AS row_num2,
    ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num3,
    ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num4
FROM salaries
ORDER BY emp_no, salary;

# exercise 262.1 - Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, 
# refer to the "employees" database.
# Use window functions to add the following two columns to the final output:
# - a column containing the row number of each row from the obtained dataset, starting from 1.
# - a column containing the sequential row numbers associated to the rows for each manager, where their highest salary has been 
# given a number equal to the number of rows in the given partition, and their lowest - the number 1.
# Finally, while presenting the output, make sure that the data has been ordered by the values in the first of the row number 
# columns, and then by the salary values for each partition in ascending order.

SELECT
	dm.emp_no,
    s.salary,
    ROW_NUMBER() OVER() AS row_num1,
    ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary) AS row_num2
FROM salaries s
	JOIN dept_manager dm ON s.emp_no = dm.emp_no
ORDER BY row_num1, dm.emp_no, salary; -- optional in this case

# exercise 262.2 - Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, 
# refer to the "employees" database.
# Use window functions to add the following two columns to the final output:
# - a column containing the row numbers associated to each manager, where their highest salary has been given a number equal to the 
# number of rows in the given partition, and their lowest - the number 1.
# - a column containing the row numbers associated to each manager, where their highest salary has been given the number of 1, and the 
# lowest - a value equal to the number of rows in the given partition.
# Let your output be ordered by the salary values associated to each manager in descending order.

SELECT
	dm.emp_no,
    s.salary,
    ROW_NUMBER() OVER(PARTITION BY dm.emp_no ORDER BY salary) AS row_num1,
    ROW_NUMBER() OVER(PARTITION BY dm.emp_no ORDER BY salary DESC) AS row_num2
FROM salaries s
	JOIN dept_manager dm ON s.emp_no = dm.emp_no
ORDER BY dm.emp_no, salary DESC;

-- alternatively
SELECT
	emp_no,
    salary,
    ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC); -- this example would not be used by professionals because the window specification only comes once in the code 

# exercise 265 - Write a query that provides row numbers for all workers from the "employees" table, partitioning the data by their first names and ordering 
# each partition by their employee number in ascending order.
# NB! While writing the desired query, do *not* use an ORDER BY clause in the relevant SELECT statement. At the same time, do use a WINDOW clause to provide 
# the required window specification.

-- group by vs partition by
SELECT 
	*,
    ROW_NUMBER() OVER w AS row_num
FROM employees
WINDOW w AS (PARTITION BY first_name ORDER BY emp_no);

SELECT a.emp_no, MAX(salary) AS max_salary
FROM (
	SELECT emp_no, salary, ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num
    FROM salaries) a
GROUP BY a.emp_no;
# OR
SELECT a.emp_no,
	a. salary AS max_salary 
FROM (
	SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
    FROM salaries
    WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC)) a
WHERE a.row_num =1;

# exercise 268.1 - Find out the lowest salary value each employee has ever signed a contract for. To obtain the desired 
# output, use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword.
# Also, to obtain the desired result set, refer only to data from the “salaries” table.

SELECT
	a.emp_no, 
    a.salary  AS min_salary
FROM (
	SELECT
		emp_no, 
		salary,
		ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary ASC) as row_num
	FROM salaries) a
WHERE row_num = 1;

# OR

SELECT 
	emp_no,
	MIN(salary) AS min_salary
FROM salaries
GROUP BY emp_no;

#####
# RANK() and DENSE_RANK()
####

-- checking employees who had at least one new contract with the same value as the previous
SELECT 
	emp_no,
    (COUNT(salary) - COUNT(DISTINCT salary)) AS diff
FROM salaries
GROUP BY emp_no
HAVING diff > 0
ORDER BY emp_no;

SELECT
	emp_no,
    salary,
    RANK() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS rank_num
FROM salaries
WHERE emp_no = 11839;

-- when using RANK() the focus is one the number of values we have in our output
-- using the function DENSE_RANK() we focus on ranking of the values

########## IMPORTANT ##########
# Windows functions:
# - they all require the use of the OVER clause
# - the rank values they prove are always assigned sequenTially
# - the first rank is always equial to the integer 1, and the subsequent rank values grow incrementally by 1, except for the duplicate records potentially
# - RANK() and DENSE_RANK() are only useful when applied on ordered partitions (=partitions defined by the use of the ORDER BY clause)

# exercise 271.1 - Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for.
# Order and display the obtained salary values from highest to lowest.

SELECT 
	emp_no,
    salary,
    RANK() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS rank_salary
FROM salaries
WHERE emp_no = 10560;

# exercise 271.2 - Write a query that upon execution, displays the number of salary contracts that each manager has ever signed while working in the company.

SELECT
	dm.emp_no,
    COUNT(s.salary) AS num_contracts_signed
FROM dept_manager dm
	JOIN salaries s ON dm.emp_no = s.emp_no
GROUP BY dm.emp_no;

# 271.3 - Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. Use a window 
# function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and that gaps in the obtained ranks for subsequent rows are allowed.

SELECT 
	emp_no,
    salary,
    RANK() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS rank_salary
FROM salaries
WHERE emp_no = 10560;

# 271.4 - Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. Use a window function 
# to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and that gaps in the obtained ranks for subsequent rows are not allowed.

SELECT 
	emp_no,
    salary,
    DENSE_RANK() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS rank_salary
FROM salaries
WHERE emp_no = 10560;

# exercise "pessoal" - Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for.
# Display the obtained salary ranking 2 from highest to lowest.

SELECT 
	a.emp_no,
    a.salary
FROM (
	SELECT 
		emp_no,
		salary,
		RANK() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS rank_salary
	FROM salaries
    ) a
WHERE emp_no = 10560 AND rank_salary = 2;

SELECT 
	d.dept_no,
    d.dept_name,
    dm.emp_no,
    RANK() OVER (PARTITION BY dm.dept_no ORDER BY s.salary DESC) AS rank_salary_desc,
    s.salary,
    s.from_date AS salary_from_date,
    s.to_date AS salary_to_date,   
    dm.from_date AS dept_manager_from_date,
    dm.to_date AS dept_manager_to_date
FROM dept_manager dm
    JOIN salaries s ON s.emp_no = dm.emp_no
    JOIN departments d ON d.dept_no = dm.dept_no
WHERE s.from_date BETWEEN dm.from_date AND dm.to_date -- needed to add this WHERE clause otherwise we get values in the result in which the salary doesn't fit to the timing when the employee was manager
	AND s.to_date BETWEEN dm.from_date AND dm.to_date;
    
# exercise 274.1 - Write a query that ranks the salary values in descending order of all contracts signed by employees numbered between 10500 and 10600 inclusive. 
# Let equal salary values for one and the same employee bear the same rank. Also, allow gaps in the ranks obtained for their subsequent rows.
    
SELECT 
	s.emp_no,
    s.salary,
	DENSE_RANK() OVER (PARTITION BY s.emp_no ORDER BY salary DESC)
FROM salaries s
WHERE s.emp_no BETWEEN 10500 AND 10600;

# exercise 274.2 - Write a query that ranks the salary values in descending order of the following contracts from the "employees" database:
# - contracts that have been signed by employees numbered between 10500 and 10600 inclusive.
# - contracts that have been signed at least 4 full-years after the date when the given employee was hired in the company for the first time.
# In addition, let equal salary values of a certain employee bear the same rank. Do not allow gaps in the ranks obtained for their subsequent rows.

SELECT 
	s.emp_no,
    s.salary,
	RANK() OVER (PARTITION BY s.emp_no ORDER BY salary DESC) AS salary_rank,
    s.from_date,
    e.hire_date
FROM salaries s
	JOIN employees e ON s.emp_no = e.emp_no
WHERE s.emp_no BETWEEN 10500 AND 10600
	AND s.from_date - e.hire_date >= 4;

SELECT * FROM employees ORDER BY emp_no;

-- LAG() and LEAD()

SELECT 
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LEAD(salary) OVER w AS next_salary,
    salary - LAG(salary) OVER w AS diff_salary_current_previous,
    LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM salaries
WHERE emp_no = 10001
WINDOW w AS (ORDER BY salary); -- no need to use partition because we are focusing on emp 10001 only

# exercise 277.1 - Write a query that can extract the following information from the "employees" database:
# - the salary values (in ascending order) of the contracts signed by all employees numbered between 10500 and 10600 inclusive
# - a column showing the previous salary from the given ordered list
# - a column showing the subsequent salary from the given ordered list
# - a column displaying the difference between the current salary of a certain employee and their previous salary
# - a column displaying the difference between the next salary of a certain employee and their current salary
# Limit the output to salary values higher than $80,000 only.
# Also, to obtain a meaningful result, partition the data by employee number.

SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LEAD(salary) OVER w AS next_salary,
    salary - LAG(salary) OVER w AS diff_salary_current_previous,
    LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM salaries
WHERE emp_no BETWEEN 10500 AND 10600
	AND salary > 80000
WINDOW w AS (PARTITION BY emp_no ORDER BY salary);

# exercise 277.2 - The MySQL LAG() and LEAD() value window functions can have a second argument, designating how many rows/steps back (for LAG()) or forth (for LEAD()) we'd like to refer to with respect to a given record.
# With that in mind, create a query whose result set contains data arranged by the salary values associated to each employee number (in ascending order). Let the output contain the following six columns:
# - the employee number
# - the salary value of an employee's contract (i.e. which we’ll consider as the employee's current salary)
# - the employee's previous salary
# - the employee's contract salary value preceding their previous salary
# - the employee's next salary
# - the employee's contract salary value subsequent to their next salary
# Restrict the output to the first 1000 records you can obtain.

SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LAG(salary,2) OVER w AS 1_before_previous_salary,
    LEAD(salary) OVER w AS next_salary,
    LEAD(salary,2) OVER w AS 1_after_next_salary
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;

####
# Ranking window functinos = ROW_NUMBER(), RANK(), DENSE_RANK()
# Value window functions = LAG(), LEAD()

-- Aggregate functions in the context of window functions

	## finding the latest salary value of the employees
	SELECT 
		s1.emp_no,
		s.salary,
		s.to_date
	FROM salaries s
		JOIN (SELECT emp_no, MAX(from_date) AS from_date FROM salaries GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
		AND s.from_date = s1.from_date
		AND s.to_date > SYSDATE();
		
	## finding the department of the employees
	SELECT
		de.emp_no,
        de.dept_no,
        de.from_date,
        de.to_date
	FROM 
		dept_emp de
		JOIN (SELECT emp_no, MAX(from_date) AS from_date FROM dept_emp GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
	WHERE de.from_date = de1.from_date
    AND de.to_date > SYSDATE();
    
SELECT
	s2.emp_no,
    d.dept_name,
    s2.salary,
	AVG(s2.salary) OVER (PARTITION BY d.dept_name) AS avg_saalry_per_department
FROM
	salaries s 
	JOIN ( SELECT 
			s1.emp_no,
			s.salary AS salary,
			s.to_date
		FROM salaries s
			JOIN (SELECT emp_no, MAX(from_date) AS from_date FROM salaries GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
			AND s.from_date = s1.from_date
			AND s.to_date > SYSDATE() ) s2 ON s2.emp_no = s.emp_no
	JOIN ( SELECT
			de.emp_no,
			de.dept_no AS dept_no,
			de.from_date,
			de.to_date
		FROM 
			dept_emp de
			JOIN (SELECT emp_no, MAX(from_date) AS from_date FROM dept_emp GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
		WHERE de.from_date = de1.from_date
		AND de.to_date > SYSDATE() ) de2 ON de2.emp_no = s.emp_no
	JOIN departments d ON d.dept_no = de2.dept_no
    GROUP BY s.emp_no, d.dept_name
    ORDER BY s2.emp_no;

# IMPORTANT
-- Should we allow the use of an aggregate function to alter the number of returned rows of a given subset then we'll a group by clause on a relevant field in the query.
-- Should we not allow a change in the number of records returned but only apply a calculation on a given subset of the source data we need to use an aggregate window 
-- function and relate it to a relevant window specification through the over clause.
		
# exercise 280 - Create a query that upon execution returns a result set containing the employee numbers, contract salary values, start, and end dates 
# of the first ever contracts that each employee signed for the company.
SELECT
	s.emp_no,
    s.salary,
    s.from_date,
    s.to_date
FROM salaries s
	JOIN (SELECT
				emp_no,
                MIN(from_date) AS from_date
			FROM salaries
            GROUP BY emp_no) s1 ON s1.emp_no = s.emp_no
WHERE s1.from_date = s.from_date;

# exercise 283 - Consider the employees' contracts that have been signed after the 1st of January 2000 and terminated before the 1st of January 2002 (as registered in the "dept_emp" table).
# Create a MySQL query that will extract the following information about these employees:
# - Their employee number
# - The salary values of the latest contracts they have signed during the suggested time period
# - The department they have been working in (as specified in the latest contract they've signed during the suggested time period)
# - Use a window function to create a fourth field containing the average salary paid in the department the employee was last working in during the suggested time period. Name that field "average_salary_per_department".

SELECT
	e.emp_no,
    d.dept_name,
    s2.salary,
    ROUND(AVG(s2.salary) OVER (PARTITION BY d.dept_name), 2) AS avg_salary_per_department
FROM employees e 
	JOIN (SELECT
			s1.emp_no,
            s.salary
		FROM salaries s
			JOIN
    		(SELECT
				emp_no,
				MAX(from_date) AS from_date
			FROM salaries
			WHERE from_date > '2000-01-01' and to_date < '2002-01-01'
			GROUP BY emp_no ) s1 ON s1.emp_no = s.emp_no AND s1.from_date = s.from_date) s2 ON s2.emp_no = e.emp_no
	JOIN (SELECT
			de1.emp_no,
            de.dept_no
		FROM dept_emp de
			JOIN
            (SELECT 
				emp_no,
				MAX(from_date) AS from_date
			FROM dept_emp de
			WHERE de.from_date > '2000-01-01' and de.to_date < '2002-01-01'
			GROUP BY emp_no) de1 ON de.emp_no = de1.emp_no AND de1.from_date = de.from_date) de2 ON de2.emp_no = e.emp_no
	JOIN departments d ON d.dept_no = de2.dept_no
ORDER BY e.emp_no;