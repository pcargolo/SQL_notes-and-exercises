# Section 17 - SQL Views

SELECT 
    emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
FROM
    dept_emp
GROUP BY emp_no;
-- this statement shows the lastest status of an employee's contract. Let's create a view with this information

CREATE OR REPLACE VIEW v_dept_emp_latest_date AS
    SELECT 
        emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;
    
# views update themselves automatically when the database is updated

# exercise - Create a view that will extract the average salary of all managers registered in the database. Round this value to the nearest cent.
SELECT ROUND(AVG(s.salary),2)
FROM salaries s
JOIN dept_manager dm ON s.emp_no = dm.emp_no;

CREATE OR REPLACE VIEW avg_mng_salary AS
    SELECT 
        ROUND(AVG(s.salary), 2)
    FROM
        salaries s
            JOIN
        dept_manager dm ON s.emp_no = dm.emp_no;
