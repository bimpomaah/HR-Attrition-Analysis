SELECT * FROM HRanalytics.general_data;
select distinct EmployeeCount FROM HRanalytics.general_data;

select businessTravel from HRanalytics.general_data;
update general_data 
set businessTravel='_'
where businessTravel like '%-%';
-- ecountered an error whuch changed the whole text to _ --

select distinct businessTravel FROM HRanalytics.general_data;
drop table HRanalytics.general_data;
-- dropped table to load all --
-- creating new table like general_data to have backup table --

create table genHRdata like HRanalytics.general_data;
insert into businessTravel 
select * from HRanalytics.general_data;

select * from HRanalytics.genHRdata ;
select distinct businessTravel FROM genHRdata ;

UPDATE  genHRdata
SET businessTravel = REPLACE(businessTravel, '-', '_')
WHERE businessTravel LIKE '%-%';

SELECT businessTravel
FROM genHRdata 
WHERE businessTravel = 'Non-Travel';

select distinct Department from genHRdata;
select distinct DistanceFromHome from genHRdata;
select distinct Education from genHRdata;

update genHRdata
set Education='Below College'
where Education =1;
-- updating the 'education column from int to text--
Alter table genHRdata
modify column Education varchar(50);

update genHRdata
set Education='College'
where Education ='2';

DESCRIBE genHRdata;
--  Education column contains numeric values stored as text (VARCHAR),
-- and by using single quotes ('2'), MySQL correctly treated it as a string rather than a number --


update genHRdata
set Education='Bachelor'
where Education ='3';

update genHRdata
set Education='Master'
where Education ='4';

update genHRdata
set Education='Doctor'
where Education ='5';

select distinct EducationField from genHRdata;
select distinct Gender from genHRdata;

select distinct Joblevel from genHRdata;

Alter table genHRdata
modify column Joblevel varchar(50);

UPDATE genHRdata
SET JobLevel = CASE JobLevel
    WHEN 1 THEN 'Entry-Level'
    WHEN 2 THEN 'Associate'
    WHEN 3 THEN 'Mid-Level'
    WHEN 4 THEN 'Senior'
    WHEN 5 THEN 'Executive'
    ELSE 'Unknown' -- Handle unexpected values, if any
END;

select distinct JobRole from genHRdata;
select distinct MaritalStatus from genHRdata;
select distinct Over18 from genHRdata;
select distinct NumCompaniesWorked 
from genHRdata
order by NumCompaniesWorked  asc;

select NumCompaniesWorked from genHRdata
where NumCompaniesWorked = 'NA';

select distinct StandardHours from genHRdata;
select distinct JobRole from genHRdata;
select distinct TrainingTimesLastYear from genHRdata;


SELECT * FROM HRanalytics.employee_survey_data;
-- creating working table --
-- checking for duplicates --

SELECT *,row_number() over(partition by EmployeeID) row_num
FROM HRanalytics.employee_survey_data;
 
 -- creating new table to filter row_num > 1 if there is duplicates--
 create table employee_survey
 SELECT *,row_number() over(partition by EmployeeID) row_num
FROM HRanalytics.employee_survey_data;

select * 
from employee_survey
where row_num>1;
-- returned no rows hence no duplicates --
select * 
from employee_survey;

UPDATE employee_survey
SET EnvironmentSatisfaction = CASE EnvironmentSatisfaction
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Medium'
    WHEN 3 THEN 'High'
    WHEN 4 THEN 'Very high'
    ELSE 'Unknown' -- Handle unexpected values, if any
END;

UPDATE employee_survey
SET JobSatisfaction = CASE JobSatisfaction
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Medium'
    WHEN 3 THEN 'High'
    WHEN 4 THEN 'Very high'
    ELSE 'Unknown' -- Handle unexpected values, if any
END;

UPDATE employee_survey
SET WorkLifeBalance = CASE WorkLifeBalance
    WHEN 1 THEN 'Bad'
    WHEN 2 THEN 'Good'
    WHEN 3 THEN 'Better'
    WHEN 4 THEN 'Best'
    ELSE 'Unknown' -- Handle unexpected values, if any
END;
-- deleting row_num column--
 alter table employee_survey
drop column row_num;

SELECT * FROM HRanalytics.manager_survey_data;
create table manager_survey
SELECT * FROM HRanalytics.manager_survey_data;

select * from manager_survey;

UPDATE manager_survey
SET JobInvolvement= CASE JobInvolvement
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Medium'
    WHEN 3 THEN 'High'
    WHEN 4 THEN 'Very high'
    ELSE 'Unknown' -- Handle unexpected values, if any
END;
-- encounted an error because datatype is set to int--
-- changing datatype --
alter table manager_survey
    modify column JobInvolvement text;
alter table manager_survey
    modify column PerformanceRating text;

UPDATE manager_survey
SET PerformanceRating= CASE PerformanceRating
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Good'
    WHEN 3 THEN 'Excellent'
    WHEN 4 THEN 'Outstanding'
    ELSE 'Unknown' -- Handle unexpected values, if any
END;


-- Attrition rate --

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



SELECT User, Host FROM mysql.user;
select * from mysql.user;

GRANT ALL PRIVILEGES ON *.* TO 'DAVIES'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;







