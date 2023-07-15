# Section  9
select COUNT(*) from employees;
select * from employees;

select dept_no from departments;
select * from departments;

select * from employees where first_name = 'Elvis';
select * from employees where first_name = 'Kellie' and gender = 'F';
select * from employees where first_name = 'Kellie' or first_name = 'Aruna';
select * from employees where gender = 'F' and (first_name = 'Kellie' or first_name = 'Aruna');
select * from employees where first_name IN ('Denis', 'Elvis');
select * from employees where first_name NOT IN ('John', 'Mark', 'Jacob');
select * from employees where first_name like ('Mark%');
select * from employees where hire_date LIKE ('2000%');
select * from employees where first_name NOT IN ('John', 'Mark', 'Jacob');
select * from employees where first_name like ('%Jack%');
select * from employees where first_name not like ('%Jack%');
select * from salaries where salary between 66000 and 70000;
select * from salaries where emp_no not between '10004' and '10012';
select * from departments;
select dept_name from departments where dept_no between 'd003' and 'd006';
select dept_name from departments where dept_no is not null;
select * from employees where gender = 'F' and hire_date >= '2000-01-01';
select * from salaries where salary > 150000;
select distinct hire_date from employees;
select count(*) from salaries where salary >= 100000;
select count(*) from dept_manager;
select * from employees order by hire_date desc;

SELECT 
    salary, COUNT(salary) AS emps_with_same_salary
FROM
    salaries
WHERE
    salary > 80000
GROUP BY salary
ORDER BY salary;

select * from salaries;
select emp_no, avg(salary) from salaries group by emp_no having avg(salary) > 120000 order by emp_no;
select * from dept_emp;

SELECT 
    emp_no, COUNT(emp_no)
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(emp_no) > 1
ORDER BY emp_no;

select * from dept_emp limit 100;