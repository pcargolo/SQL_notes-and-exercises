# Section 14 - Joins

ALTER TABLE departments_dup
DROP COLUMN dept_manager;

SELECT * FROM departments_dup;

ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;

ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

INSERT INTO departments_dup (dept_name)
VALUES ('Public Relations');

DELETE FROM departments_dup
WHERE
    dept_no = 'd002'; 
    
DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (
  emp_no int(11) NOT NULL,
  dept_no char(4) NULL,
  from_date date NOT NULL,
  to_date date NULL
);

SHOW WARNINGS;

INSERT INTO dept_manager_dup
select * from dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES (999904, '2017-01-01'),
       (999905, '2017-01-01'),
       (999906, '2017-01-01'),
       (999907, '2017-01-01');

DELETE FROM dept_manager_dup
WHERE
    dept_no = 'd001';

INSERT INTO departments_dup (dept_name)
VALUES ('Public Relations');

DELETE FROM departments_dup
WHERE
    dept_no = 'd002'; 

SELECT * FROM dept_manager_dup ORDER BY dept_no;

-- INNER JOIN
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
INNER JOIN departments_dup d
ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

/* we can only see information that appear in both tables that we are joining */

# exercise 172
SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
FROM employees e
INNER JOIN dept_manager_dup d
ON e.emp_no = d.emp_no
ORDER BY d.dept_no;

/* For inner join we don't need to write "INNER JOIN". We can just write "JOIN" */

INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');

SELECT * FROM dept_manager_dup ORDER BY dept_no ASC;
SELECT * FROM departments_dup ORDER BY dept_no ASC;

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
INNER JOIN departments_dup d
ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

/* Now there are 25 rows instead of 20 
To eliminate the duplicates from the output use group by*/ 

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
INNER JOIN departments_dup d
ON m.dept_no = d.dept_no
GROUP BY m.dept_no, m.emp_no, d.dept_name
ORDER BY m.dept_no;

-- LEFT JOIN
# first, remove the duplicates we inserted
DELETE FROM dept_manager_dup
WHERE emp_no = '110228';

DELETE FROM departments_dup
WHERE dept_no = 'd009';

INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN departments_dup d
ON m.dept_no = d.dept_no
GROUP BY m.dept_no, m.emp_no, d.dept_name
ORDER BY m.dept_no;
# now the result has 26 rows instead of only 20

# now selecting only the information present in the left data set
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN departments_dup d
ON m.dept_no = d.dept_no
WHERE dept_name IS NULL
ORDER BY m.dept_no;

#exercise
SELECT d.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
FROM dept_manager d
LEFT JOIN employees e on e.emp_no = d.emp_no
WHERE last_name = 'Markovitch'; 

# linking columng = matchin column

-- old join syntax vs new syntax
#old join syntax
SELECT d.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
FROM dept_manager d, employees e
WHERE e.emp_no = d.emp_no;

#new join syntax
SELECT d.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
FROM dept_manager d
JOIN employees e ;

# selecting employees with salaries above 145.000
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON s.emp_no = e.emp_no
WHERE salary > 145000;

# changing sql mode to allow grouping by just one value of the select clause / could also be used with @@global.sql_mode
select @@session.sql_mode;
set @@session.sql_mode := replace(@@session.sql_mode, 'ONLY_FULL_GROUP_BY', '');

# exercise
SELECT e.first_name, e.last_name, e.hire_date, t.title
FROM employees e
JOIN titles t
ON e.emp_no = t.emp_no
WHERE first_name = 'Margareta' AND last_name = 'Markovitch';

-- CROSS JOIN
SELECT dm.*, d.*
FROM dept_manager dm
CROSS JOIN departments d
ORDER BY dm.emp_no, d.dept_no;

/* Writing JOIN without ON will deliver a CROSS JOIN and is not best practice
When writeing CROSS JOIN then we don't use ON */

/* Using the join old syntax whithout a WHERE clause is the 
same as writing a cross join.
Also, if writing a JOIN without the ON  keyword it will also process as a CROSS JOIN */


# Combining 2 or more tables
SELECT e.*, d.*
FROM departments d
CROSS JOIN dept_manager dm
JOIN employees e ON dm.emp_no = e.emp_no
WHERE d.dept_no <> dm.dept_no
ORDER BY dm.emp_no, d.dept_no;

# exercise
SELECT dm.*, d.*
FROM dept_manager dm
CROSS JOIN departments d
WHERE d.dept_no = 'd009'
ORDER BY dm.emp_no;

# exercise
SELECT * from employees;

SELECT e.*, d.*
FROM employees e
CROSS JOIN departments d
WHERE emp_no <= 10010
ORDER BY e.emp_no, d.dept_name; 

-- aggregate functions and joins
SELECT e.gender, AVG(s.salary)
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no
GROUP BY gender;

SELECT 
	e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM employees e
JOIN dept_manager m ON e.emp_no = m.emp_no
JOIN departments d ON m.dept_no = d.dept_no
;

# exercise
SELECT e.first_name, e.last_name, e.hire_date, t.title, dm.from_date, d.dept_name
FROM dept_manager dm
JOIN employees e
ON e.emp_no = dm.emp_no
JOIN titles t
ON t.emp_no = dm.emp_no
JOIN departments d
ON d.dept_no = dm.dept_no
WHERE t.title = 'Manager';
/* we nee to add the WHERE clause because several managers have had other positions
and it's matching more than one title in the titles table */

select * from titles where emp_no = 110022;
select * from dept_emp where emp_no = 110022;
select * from dept_manager where emp_no = 110022;
select * from dept_manager;

# exercise - avg salary from managers
SELECT d.dept_name, AVG(s.salary) AS average_salary
FROM departments d
JOIN dept_manager dm ON dm.dept_no = d.dept_no
JOIN salaries s ON s.emp_no = dm.emp_no
GROUP BY d.dept_name
-- HAVING average_salary > 60000
ORDER BY average_salary DESC;

# exercise - How many male and how many female managers do we have in the ‘employees’ database?
SELECT e.gender, COUNT(dm.emp_no)
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY e.gender;

# UNION VS UNION ALL
DROP TABLES IF EXISTS employees_dup;
CREATE TABLE employees_dup (
	emp_no INT(11),
    birth_date DATE,
    firts_name VARCHAR(14),
    last_name VARCHAR(16),
    gender ENUM('M','F'),
    hire_date DATE
);

INSERT INTO employees_dup
SELECT e.*
FROM employees e
LIMIT 20;

SELECT * FROM employees_dup;

INSERT INTO employees_dup
VALUES
('10001', '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');

/* Important to know:
- When uniting two identically organized tables UNION displays only distinct values in the output
while UNION ALLretrieves the duplicates as well 
- UNION uses more computational power the perform the additional operation 
- If looking for better results (no-duplicates) then use UNION, when seeking
to optimize performance then use UNION ALL */

# exercise - Go forward to the solution and execute the query. What do you think is the meaning of the minus sign before subset A in the last row (ORDER BY -a.emp_no DESC)? 
SELECT
    *
FROM
    (SELECT
        e.emp_no,
        e.first_name,
        e.last_name,
        NULL AS dept_no,
        NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT
        NULL AS emp_no,
        NULL AS first_name,
        NULL AS last_name,
        dm.dept_no,
		dm.from_date
    FROM
        dept_manager dm) as a
ORDER BY -a.emp_no DESC;