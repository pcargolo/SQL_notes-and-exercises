# Section 19 - CASE statement

SELECT
	emp_no,
    first_name,
    last_name,
    CASE
		WHEN gender = 'M' THEN 'Male'
        ELSE 'Female'
	END AS gender
FROM
	employees;
    
SELECT
	emp_no,
    first_name,
    last_name,
    CASE gender
		WHEN 'M' THEN 'Male'
        ELSE 'Female'
	END AS gender
FROM
	employees;
    
SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
	END AS is_manager
    FROM employees e
		LEFT JOIN dept_manager dm ON dm.emp_no = e.emp_no -- we must use left join because all the values not existing in the managers table will then be nulls in this joins and then the return 'employee'
	WHERE e.emp_no > 109990;

# using IF instead of CASE
SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    IF(gender = 'M', 'Male', 'Female') AS gender
FROM employees e;

# IF has limitations because it can only deliver one true and one false result. See example below for CASE using two times WHEN

SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Test 1'
        WHEN 20000 < MAX(s.salary) - MIN(s.salary) < 30000 THEN 'Test 2'
        ELSE 'Test 3'
	END AS salary_increase
FROM employees e
	JOIN dept_manager dm ON e.emp_no = dm.emp_no
    JOIN salaries s ON s.emp_no = e.emp_no
GROUP BY e.emp_no;

# exercise 252 - Similar to the exercises done in the lecture, obtain a result set containing the employee number, 
# first name, and last name of all employees with a number higher than 109990. Create a fourth column in the query, 
# indicating whether this employee is also a manager, according to the data provided in the dept_manager table, or a regular employee.

SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE 
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
	END AS is_manager
FROM employees e
	LEFT JOIN dept_manager dm ON e.emp_no = dm.emp_no
WHERE e.emp_no > 109990;

# exercise 253 - Extract a dataset containing the following information about the managers: employee number, first name, 
# and last name. Add two columns at the end – one showing the difference between the maximum and minimum salary of that 
# employee, and another one saying whether this salary raise was higher than $30,000 or NOT.

SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Rise greater than 30.000'
	ELSE 'Rise below 30.000'
    END AS greater_than_30000
FROM employees e
	JOIN dept_manager dm ON e.emp_no = dm.emp_no
    JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY emp_no;

SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    IF(MAX(s.salary) - MIN(s.salary) > 30000, 'Rise greater than 30.000', 'Rise below 30.000') AS greater_than_30000
FROM employees e
	JOIN dept_manager dm ON e.emp_no = dm.emp_no
    JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY emp_no;

# exercise 255 - Extract the employee number, first name, and last name of the first 100 employees, and add a fourth column, 
# called “current_employee” saying “Is still employed” if the employee is still working in the company, or “Not an employee 
# anymore” if they aren’t.

SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE 
		WHEN MAX(de.to_date) > DATE(NOW()) THEN 'Is still employed'
        ELSE 'Not an employee anymore'
	END AS current_employee
FROM employees e
JOIN dept_emp de ON de.emp_no = e.emp_no
GROUP BY e.emp_no
LIMIT 100;
