# Section 11 - UPDATE

SELECT *
FROM employees
WHERE emp_no = 999901;

UPDATE employees
SET 
	first_name = 'Stella',
    last_name = 'Parkinson',
    birth_date = '1990-12-31',
    gender = 'F'
WHERE emp_no = 999901;

SELECT * FROM departments_dup;
COMMIT;

UPDATE departments_dup
SET
	dept_no = 'd011',
    dept_name = 'Quality Control';
    
ROLLBACK;
COMMIT;

SELECT * FROM departments;

UPDATE departments
SET
	dept_name = 'Data Analysis'
WHERE dept_name = 'Business Analysis';