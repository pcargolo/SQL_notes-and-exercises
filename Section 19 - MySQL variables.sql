# Section 19 - Advanced SQL topics

/* there are three types of MySQL variables: local, session and global */
-- Local
# for local variables we use DECLARE
# local variables exist only within the BEGIN-END block

-- Session
# for session variables we use "SET @...." and we can select this variable at any moment
# if the session is ended and another one is started, the varible is lost

-- Global
# must use "SET GLOBAL var_name = value;" or "SET @@global.var_name = value;"

-- User-defined vs system variables

-- Indexes
# exercise 248 - Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum. 
# Then, create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement.

SELECT * FROM salaries WHERE salary > 89000;

CREATE INDEX i_salary 
ON salaries(salary);

# to drop an index:
ALTER TABLE salaries
DROP INDEX i_salary;

-- SHOW INDEX FROM <schema> FROM <table>

