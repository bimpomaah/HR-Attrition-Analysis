
-- Viewing general hr dataset from HRanalytics database
SELECT * FROM HRanalytics.general_data;

select distinct EmployeeCount FROM HRanalytics.general_data;

select distinct businessTravel FROM HRanalytics.general_data;

-- creating new table like general_data to have backup table so i have original data
create table genHRdata like HRanalytics.general_data;

-- inserting contents of general_data into new table created (genHRdata)
insert into genHRdata 
select * from HRanalytics.general_data;

--Load new table genHRdata
select * from HRanalytics.genHRdata ;

select distinct businessTravel FROM genHRdata ;

-- Cleaning,formatting and standardizing data
UPDATE  genHRdata
SET businessTravel = REPLACE(businessTravel, '-', '_')
WHERE businessTravel LIKE '%-%';

-- Checking if change applied
SELECT businessTravel
FROM genHRdata 
WHERE businessTravel = 'Non-Travel';

select distinct Department from genHRdata;
select distinct DistanceFromHome from genHRdata;
select distinct Education from genHRdata;

update genHRdata
set Education='Below College'
where Education =1;

-- updating the 'education' column from datatype int to text
Alter table genHRdata
modify column Education varchar(50);

update genHRdata
set Education='College'
where Education ='2';
DESCRIBE genHRdata;

--  Education column contains numeric values stored as text (VARCHAR),
-- and by using single quotes ('2'), MySQL correctly treated it as a string rather than a number 
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

-- employee survry table
SELECT * FROM HRanalytics.employee_survey_data;

-- creating working table 
-- checking for duplicates 
SELECT *,row_number() over(partition by EmployeeID) row_num
FROM HRanalytics.employee_survey_data;
 
 -- creating new table to filter row_num > 1 if there is duplicates
 create table employee_survey
 SELECT *,row_number() over(partition by EmployeeID) row_num
FROM HRanalytics.employee_survey_data;

select * 
from employee_survey
where row_num>1;
-- returned no rows hence no duplicates 
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

-- manager survey table
select * from manager_survey;
-- standardizing
UPDATE manager_survey
SET JobInvolvement= CASE JobInvolvement
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Medium'
    WHEN 3 THEN 'High'
    WHEN 4 THEN 'Very high'
    ELSE 'Unknown' -- Handle unexpected values, if any
END;
-- encounted an error because datatype is set to int
-- changing datatype 
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





SELECT User, Host FROM mysql.user;
select * from mysql.user;

CREATE USER 'DAVIES'@'127.0.0.1' IDENTIFIED BY 'Mrdavies23$';
GRANT ALL PRIVILEGES ON *.* TO 'DAVIES'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON *.* TO 'DAVIES'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;





