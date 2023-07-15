# Section 12 - DELETE

USE employees;
COMMIT;

SELECT *
FROM employees
WHERE emp_no = 999903;

DELETE FROM employees
WHERE emp_no = 999903;

SELECT * 
FROM titles 
WHERE emp_no = 999903;

ROLLBACK;

SELECT * FROM departments_dup;
DELETE FROM departments_dup;
ROLLBACK;

DELETE FROM departments
WHERE dept_no = 'd010';
SELECT * FROM departments;

/* Using DELETE FROM without a WHERE clause has almost the same 
effect as using TRUNCATE. Mentioned difference is that 
TRUNCATE resets the AUTO_INCREMENT count while DELETE FROM without
WHERE clause doesn't */

/* DROP TABLE removes the complete table with its structure and records */