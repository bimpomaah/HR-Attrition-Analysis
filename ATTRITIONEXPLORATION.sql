-- DATA EXPLORATION ATTRITION RATE --

SELECT Attrition, count(*) AS employee_count
FROM genHRdata
GROUP BY Attrition;

SELECT Attrition, count(*) as count, 
       (count(*) * 100.0) / (select count(*) FROM genHRdata) as percentage
FROM genHRdata
GROUP BY Attrition;

Select EmployeeID,JobRole,count(*) as total_employees,
       sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (SUM(case when Attrition = 'Yes' then 1 else 0 end) * 100.0) / count(*) AS attrition_rate
from genHRdata
group by EmployeeID,Department,JobRole
order by attrition_rate desc;


-- creataing view so tableau connects to hr_dep_attrition, and it updates automatically when new data is added --
CREATE VIEW HR_dep_Attrition AS
SELECT EmployeeID,JobRole,count(*) as total_employees,
       sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (SUM(case when Attrition = 'Yes' then 1 else 0 end) * 100.0) / count(*) AS attrition_rate
from genHRdata
group by EmployeeID,Department,JobRole
order by attrition_rate desc;

drop view HRanalytics.hr_dep_attrition;

CREATE OR REPLACE VIEW  HR_dep_Attrition  AS
SELECT EmployeeID,Department,JobRole,count(*) as total_employees,
       sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (SUM(case when Attrition = 'Yes' then 1 else 0 end) * 100.0) / count(*) AS attrition_rate
from genHRdata
group by EmployeeID,Department,JobRole
order by attrition_rate desc;

-- Age bracket attrition --
Select case
           when Age < 25 then'Under 25'
           when Age between 25 and 35 then'25-35'
           when Age between 36 and 45 then '36-45'
           ELSE 'Above 45' 
       end as age_group,
       
       count(*) as total_employees,
       sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (SUM(case when Attrition = 'Yes' then 1 else 0 end) * 100.0) / count(*) AS attrition_rate
FROM genHRdata
GROUP BY age_group
ORDER BY attrition_rate DESC;

CREATE VIEW Age_Attrition AS
Select case
           when Age < 25 then'Under 25'
           when Age between 25 and 35 then'25-35'
           when Age between 36 and 45 then '36-45'
           ELSE 'Above 45' 
       end as age_group,
       
       count(*) as total_employees,
       sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (SUM(case when Attrition = 'Yes' then 1 else 0 end) * 100.0) / count(*) AS attrition_rate
FROM genHRdata
GROUP BY age_group
ORDER BY attrition_rate DESC;

-- distance from home -

SELECT DistanceFromHome, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       COUNT(*) AS total_employees,
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS attrition_rate
FROM genHRdata
GROUP BY DistanceFromHome
ORDER BY attrition_rate DESC;

select gender,Attrition ,count(gender)
from genHRdata
group by gender,Attrition
ORDER BY attrition DESC;


-- training time last year--
SELECT TrainingTimesLastYear, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       COUNT(*) AS total_employees,
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS attrition_rate
FROM genHRdata
GROUP BY TrainingTimesLastYear
ORDER BY TrainingTimesLastYear DESC;

CREATE VIEW Trainingtimes_Attrition AS
SELECT TrainingTimesLastYear, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       COUNT(*) AS total_employees,
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS attrition_rate
FROM genHRdata
GROUP BY TrainingTimesLastYear
ORDER BY TrainingTimesLastYear DESC;



-- worklife balance vs attrition--
select * from genHRdata gen
join employee_survey emp on 
gen.EmployeeID=emp.EmployeeID;

select WorkLifeBalance ,count(*) as total_employees,
       sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (SUM(case when Attrition = 'Yes' then 1 else 0 end) * 100.0) / count(*) AS attrition_rate
from genHRdata gen
join employee_survey emp on 
gen.EmployeeID=emp.EmployeeID
group by WorkLifeBalance
order by attrition_rate desc;

CREATE VIEW worklifebalance_Attrition AS
select WorkLifeBalance ,count(*) as total_employees,
       sum(case when Attrition = 'Yes' then 1 else 0 end) as attrition_count,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (SUM(case when Attrition = 'Yes' then 1 else 0 end) * 100.0) / count(*) AS attrition_rate
from genHRdata gen
join employee_survey emp on 
gen.EmployeeID=emp.EmployeeID
group by WorkLifeBalance
order by attrition_rate desc;

-- (would try further insights with department)--

-- Average Tenure of employees who left--
select avg(YearsAtCompany) as avg_tenure_before_leaving
from genHRdata
where attrition='Yes';
CREATE VIEW avgtenure_Attrition AS
select avg(YearsAtCompany) as avg_tenure_before_leaving
from genHRdata
where attrition='Yes';



select max(MonthlyIncome)
from genHRdata;

select department, max(MonthlyIncome) over(partition by department)
from genHRdata;

select  department,max(MonthlyIncome) max_income
from genHRdata
group by department
having max_income=199990
;

select  department,min(MonthlyIncome) min_income
from genHRdata
group by department
having min_income=10090;

-- check how salary hikes are distributed --
select PercentSalaryHike, count(*) as num_employees
from genHRdata
group by PercentSalaryHike
order by PercentSalaryHike;

-- salary hikes vs. attrition--
-- check if low salary hikes lead to higher attrition--
select percentsalaryhike, 
       count(*) as total_employees,
       sum(case when attrition = 'yes' then 1 else 0 end) as employees_left,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (sum(case when attrition = 'yes' then 1 else 0 end) * 100.0) / count(*) as attrition_rate
from genHRdata
group by percentsalaryhike
order by percentsalaryhike;

-- salary hikes vs. performance ratings vs attrition--
select PercentSalaryHike,PerformanceRating, count(*) as total_employees,
  sum(case when attrition = 'yes' then 1 else 0 end) as employees_left,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (sum(case when attrition = 'yes' then 1 else 0 end) * 100.0) / count(*) as attrition_rate
from genHRdata gen
join manager_survey mg on 
gen.EmployeeID=mg.EmployeeID
group by PercentSalaryHike,PerformanceRating
order by PercentSalaryHike;

select PerformanceRating, 
       avg(PercentSalaryHike) as avg_salary_hike, 
       count(*) as num_employees
from genHRdata gen
join manager_survey mg on 
gen.EmployeeID=mg.EmployeeID
group by PercentSalaryHike,PerformanceRating;

CREATE VIEW perc_perf_Attrition AS
select PercentSalaryHike,PerformanceRating, count(*) as total_employees,
  sum(case when attrition = 'yes' then 1 else 0 end) as employees_left,
       (count(*) - SUM(CASE WHEN Attrition = 'Yes' then 1 else 0 end)) AS still_employed,
       (sum(case when attrition = 'yes' then 1 else 0 end) * 100.0) / count(*) as attrition_rate
from genHRdata gen
join manager_survey mg on 
gen.EmployeeID=mg.EmployeeID
group by PercentSalaryHike,PerformanceRating
order by PercentSalaryHike;
