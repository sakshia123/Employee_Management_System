CREATE DATABASE employee_analysis;

USE employee_analysis;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    department VARCHAR(30),
    city VARCHAR(30),
    salary DECIMAL(10,2),
    hire_date DATE
);

INSERT INTO employees VALUES
(101,'Rahul Sharma','Male',28,'IT','Pune',65000,'2022-01-15'),
(102,'Sneha Patil','Female',30,'HR','Mumbai',50000,'2021-06-10'),
(103,'Amit Verma','Male',35,'Finance','Delhi',70000,'2020-03-20'),
(104,'Priya Joshi','Female',27,'IT','Pune',72000,'2023-02-11'),
(105,'Karan Singh','Male',31,'Sales','Bangalore',80000,'2019-08-18'),
(106,'Pooja Desai','Female',29,'Marketing','Hyderabad',55000,'2022-09-01'),
(107,'Rohit Mehta','Male',33,'IT','Pune',90000,'2018-04-15'),
(108,'Neha Kulkarni','Female',26,'HR','Mumbai',48000,'2024-01-12'),
(109,'Vikas Gupta','Male',37,'Finance','Delhi',95000,'2017-07-25'),
(110,'Anjali More','Female',32,'Sales','Bangalore',60000,'2021-05-19'),
(111,'Suresh Kumar','Male',29,'IT','Chennai',68000,'2022-08-01'),
(112,'Kavita Shah','Female',34,'Marketing','Ahmedabad',62000,'2020-11-15'),
(113,'Arjun Nair','Male',27,'HR','Kochi',47000,'2023-03-10'),
(114,'Meena Iyer','Female',36,'Finance','Chennai',85000,'2018-09-20'),
(115,'Deepak Yadav','Male',30,'Sales','Lucknow',58000,'2021-12-01');

-- 1. Display All Employees

select * from employees;

-- 2. Total Employees

select count(*) as total_employees
from employees;


-- 3. Average Salary

select avg(salary) as average_salary
from employees;

-- 4. Highest Salary

select max(salary) as highest_salary
from employees;

-- 5. Lowest Salary

select min(salary) as highest_salary
from employees;

-- 6. Total Salary Paid

select sum(salary) as total_salary_paid
from employees;

-- 7. Department-wise Employee Count

select department, count(emp_name) as Department_wise_employee_count
from  employees
group by department;


-- 8. Department-wise Average Salary
select department , round(avg(salary),2) as Department_wise_Average_Salary
from employees
group by department;

-- 9. Employees with Salary Above ₹70,000

select * from employees
where salary>70000;

-- 10. Employees from Pune

select * from employees
where city = "Pune";

-- 11. IT Employees

select * from employees
where department = "IT";

-- 12. Employees Hired After 2022

select emp_name , hire_date from employees
where hire_date> '2022-01-01';

-- 13. Sort Employees by Salary

select emp_name , salary 
from employees
order by salary DESC;

-- 14. Top 5 Highest Paid Employees

select emp_name , salary 
from employees
order by salary DESC
LIMIT 5;

-- 15. Employee Count by Gender

select gender, count(emp_name)
from employees
group by gender;

-- 16. Employees Earning Above Average Salary (Subquery)

SELECT emp_name, salary
FROM employees
WHERE salary >
(
SELECT AVG(salary)
FROM employees
);

-- 17. Salary Rank (Window Function)

SELECT emp_name,
salary,
RANK() OVER(ORDER BY salary DESC) AS salary_rank
FROM employees;




-- 18. Create a View

CREATE VIEW employee_summary AS
SELECT emp_name,
department,
salary
FROM employees;

SELECT * FROM employee_summary;

-- 19. Final Business Summary Query

SELECT
department,
COUNT(*) AS total_employees,
ROUND(AVG(salary),2) AS average_salary,
MAX(salary) AS highest_salary,
MIN(salary) AS lowest_salary,
SUM(salary) AS total_salary
FROM employees
GROUP BY department
ORDER BY total_salary DESC;


CREATE TABLE employee_transformed (
    emp_id INT,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2),
    salary_category VARCHAR(20),
    experience_years INT
);

-- 20. Creating stored Procedures

DROP PROCEDURE IF EXISTS TransformEmployeeData;

DELIMITER //

CREATE PROCEDURE TransformEmployeeData()
BEGIN
    INSERT INTO employee_transformed
    (emp_id, emp_name, department, salary, salary_category, experience_years)
    
    SELECT
        emp_id,
        emp_name,
        department,
        salary,
        CASE
            WHEN salary >= 80000 THEN 'High' 
            WHEN salary >= 60000 THEN 'Medium'
            ELSE 'Low'
        END AS salary_category,
        TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS experience_years
    FROM employees;
END //

DELIMITER ;


CALL TransformEmployeeData();

SELECT * FROM employee_transformed;


drop DATABASE employee_analysis;
