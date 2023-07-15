# Section 18 - Stored routines

-- call, request or invoke a query
-- stored procedures or functions

USE employees;

-- delimiters $$ or //

#Syntax:
DELIMITER $$
CREATE PROCEDURE procedure_name()
BEGIN
	SELECT * FROM employees
    LIMIT 1000;
END$$
DELIMITER ;


USE employees;
DROP PROCEDURE IF EXISTS select_employees;

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
	SELECT * FROM employees
    LIMIT 1000;
END$$
DELIMITER ;

CALL employees.select_employees();

CALL select_employees();

# exercise 222 - Create a procedure that will provide the average salary of all employees. Then, call the procedure.
SELECT AVG(salary) AS avg_salary FROM salaries;

DELIMITER $$
CREATE PROCEDURE select_avg_salary()
BEGIN
SELECT AVG(salary) AS avg_salary FROM salaries;
END$$
DELIMITER ;

CALL select_avg_salary();

# Stored procedures with an input parameter
DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
BEGIN
SELECT 
	e.first_name, 
    e.last_name, 
    s.salary, 
    s.from_date, 
    s.to_date
FROM 
	employees e
JOIN 
	salaries s ON s.emp_no = e.emp_no
WHERE 
	e.emp_no = p_emp_no;
END $$
DELIMITER ;

-- now with aggragate functions
DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_avg_salary(IN p_emp_no INTEGER)
BEGIN
SELECT 
	e.first_name, 
    e.last_name, 
    AVG(salary)
FROM 
	employees e
JOIN 
	salaries s ON s.emp_no = e.emp_no
WHERE 
	e.emp_no = p_emp_no;
END $$
DELIMITER ;

CALL emp_avg_salary(11300);

# Stored procedures with an input and output parameters
USE employees;
DROP PROCEDURE IF EXISTS emp_avg_salary_out;

DELIMITER $$

CREATE PROCEDURE emp_avg_salary_OUT(in p_emp_no INTEGER, out p_avg_salary DECIMAL(10,2))
BEGIN
SELECT 
	AVG(salary)
INTO p_avg_salary FROM 
	employees e
JOIN 
	salaries s ON s.emp_no = e.emp_no
WHERE 
	e.emp_no = p_emp_no;
END $$

DELIMITER ;

# exercise - Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual, and returns their employee number.
USE employees;
DROP PROCEDURE IF EXISTS emp_info;

DELIMITER $$
CREATE PROCEDURE emp_info (in p_first_name VARCHAR(40), in p_last_name VARCHAR(50), out p_emp_no INT)
BEGIN
SELECT e.emp_no
INTO p_emp_no FROM employees e
WHERE p_first_name = e.first_name AND p_last_name = e.last_name;
END$$

DELIMITER ;

-- When using output parameter remember to use "SELECT ... INTO... FROM ..."

# Using variables
SET @v_avg_salary = 0;
CALL employees.emp_avg_salary_OUT(11300, @v_avg_salary);
SELECT @v_avg_salary;

# exercise 230 - Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.
SET @v_emp_no = 0;
CALL employees.emp_info('Aruna','Journel',@v_emp_no);
SELECT @v_emp_no;

SELECT e.emp_no
FROM employees e
WHERE 'Aruna' = e.first_name AND 'Journel' = e.last_name;

# Functions

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN

DECLARE v_avg_salary DECIMAL(10, 2);

SELECT AVG(s.salary)
INTO v_avg_salary FROM
	employees e
    JOIN salaries s ON s.emp_no = e.emp_no
    WHERE e.emp_no = p_emp_no;

RETURN v_avg_salary;
END$$

DELIMITER ;

SELECT f_emp_avg_salary(11300);
-- for functions we don't use call. we use select

/* with the function above we can use it in a query such as the one below */

SET @v_emp_no = 11300;
SELECT
	emp_no,
    first_name,
    last_name,
    f_emp_avg_salary(@v_emp_no) AS avg_salary
FROM
	employees
WHERE
	emp_no = @v_emp_no;

# exercise 234 - Create a function called ‘emp_info’ that takes for parameters the first and last name of an employee, and returns the salary from the newest contract of that employee.
DELIMITER $$
CREATE FUNCTION emp_info(p_first_name VARCHAR(40), p_last_name VARCHAR(50)) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN

DECLARE v_max_from_date DATE;
DECLARE v_salary decimal(10, 2);

SELECT MAX(from_date)
INTO v_max_from_date FROM employees e
		JOIN salaries s ON s.emp_no = e.emp_no
        WHERE p_first_name = e.first_name AND p_last_name = e.last_name;
        
SELECT s.salary
INTO v_salary FROM employees e
	JOIN salaries s ON e.emp_no = s.emp_no
    WHERE p_first_name = e.first_name AND p_last_name = e.last_name AND s.from_date = v_max_from_date;
           
RETURN v_salary;
END$$

DELIMITER ;

SELECT emp_info('Aruna', 'Journel');