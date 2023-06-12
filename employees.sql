show tables in employees;
use employees;

-- task 1
select departments.dept_name, employees.gender, avg(salaries.salary) as `Average Salary` from employees
join dept_emp on employees.emp_no=dept_emp.emp_no
join departments on departments.dept_no = dept_emp.dept_no
join salaries on salaries.emp_no=employees.emp_no
group by departments.dept_name, employees.gender
order by departments.dept_name, employees.gender;

-- task 2
select min(dept_no) as 'Minimum Department Number' from employees.dept_emp;
select max(dept_no) as 'Maximum Department Number' from employees.dept_emp;

-- task 3
use employees;
select employees.emp_no,
(select min(dept_no) from dept_emp
 where employees.emp_no = dept_emp.emp_no)
 as dept_no, 
case
        when employees.emp_no <= 10020 then 110022 
        when employees.emp_no between 10021 and 10040 then 110039 
end as manager
from employees
where  employees.emp_no<= 10040;

-- task 4
select *
from employees
where year(hire_date) = 2000;

-- task 5
select employees.first_name, employees.last_name, titles.title from employees
join titles using(emp_no)
where titles.title = 'Engineer'
limit 20;

select employees.first_name, employees.last_name, titles.title from employees
join titles using(emp_no)
where titles.title = 'Senior Engineer'
limit 20;

-- task 6
use employees;
drop procedure if exists last_dept;
delimiter $$
create procedure last_dept(in p_emp_no integer)
begin
  select dept_name as 'last department' from departments
  join dept_emp on departments.dept_no = dept_emp.dept_no
  where p_emp_no = emp_no
  and to_date =(select max(to_date) from dept_emp);
end$$
delimiter ;

call last_dept(10010);

-- task 7
select count(*) from salaries
where timestampdiff(year, from_date, if(to_date<now(), to_date, now())) > 1 
and salaries.salary > 100000;

-- task 8
delimiter $$
drop trigger if exists trg_hire_date;
create trigger trg_hire_date
before insert on employees
for each row
begin
  if new.hire_date > now() then
    set new.hire_date = date_format(now(), '%Y-%m-%d');
  end if;
end$$
delimiter ;

use employees;
insert employees values('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');
select * from employees order by emp_no desc limit 10;

-- task 9
drop function if exists get_highest_salary;
delimiter $$
create function get_highest_salary(p_emp_no int) returns decimal(10,2) deterministic
begin
    declare max_salary decimal(10,2);
    select max(salary) into max_salary 
    from salaries 
    where emp_no = p_emp_no;
    return max_salary;
end$$
delimiter ;

drop function if exists get_lowest_salary;
delimiter $$
create function get_lowest_salary(p_emp_no int) returns decimal(10,2) deterministic
begin
    declare min_salary decimal(10,2);
    select min(salary) into min_salary 
    from salaries 
    where emp_no = p_emp_no;
    return min_salary;
end$$
delimiter ;

select employees.get_highest_salary(10001) as 'highest salary';
select employees.get_lowest_salary(10001) as 'lowest salary';

-- task 10
drop function if exists get_extremum_salary;
delimiter $$
create function get_extremum_salary(p_emp_no int, p_type varchar(3)) returns decimal(10,2) deterministic
begin
    declare extremum_salary decimal(10,2);
    if (p_type = 'min') then
		select min(salary) into extremum_salary from salaries where emp_no = p_emp_no;
    elseif (p_type ='max') then 
		select max(salary) into extremum_salary from salaries where emp_no = p_emp_no;
	end if;
    return extremum_salary;
end$$
delimiter ;

select employees.get_extremum_salary(10001, 'min') as 'Minimum salary';
select employees.get_extremum_salary(10001, 'max') as 'Maximum salary';