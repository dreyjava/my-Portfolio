
--View data

select * from HospitalProject..admitted$

--Calculate admission period for a patient for each admission


Select patient_id ,DATEDIFF(day,admit_date,discharge_date) as DaysSpendAdmitted

from HospitalProject..admitted$

Order by DaysSpendAdmitted desc


--Total time spend in hospita for a patient

Select patient_id ,sum(DATEDIFF(day,admit_date,discharge_date)) as TotalDaysSpendAdmitted

from HospitalProject..admitted$

group by patient_id

Order by patient_id,TotalDaysSpendAdmitted desc


--select patient data to use

select ad.patient_id , fname,lname,sex,bdate,address
from HospitalProject..admitted$ ad

join patient_general_details$ gend
on ad.patient_id= gend.patient_id

--select disnctinct Patient General Details

select distinct ad.patient_id , fname,lname,sex,bdate,address
from HospitalProject..admitted$ ad

join patient_general_details$ gend
on ad.patient_id= gend.patient_id

--Count total patients admitted 

select distinct ad.patient_id 
from HospitalProject..admitted$ ad

join patient_general_details$ gend
on ad.patient_id= gend.patient_id

--How many females we have 


select sex , count(distinct(ad.patient_id)) as TotalGender
from HospitalProject..admitted$ ad

join patient_general_details$ gend
on ad.patient_id= gend.patient_id
 group by sex



 --Medical conditions of patience

 select ad.patient_id , fname,lname,sex,bdate,address,medical_history
from HospitalProject..admitted$ ad

join patient_general_details$ gend
on ad.patient_id= gend.patient_id

join patient_medical_conditions$ med on 
gend.patient_id = med.patient_id

--diesases affecting petients

select distinct medical_history from patient_medical_conditions$

--see treatements available

select * from treatments_available$


--see emploeyyes occupation

select fname,lname , DATEDIFF(years,date_of_join,date_of_resign)
from employee$

--experience years
select fname,lname , DATEDIFF(year,date_of_join,date_of_resign) as YearsWorked
from employee$
where date_of_resign is not null


--experience years
select fname,lname , DATEDIFF(year,date_of_join,date_of_resign) as YearsWorked
from employee$
where date_of_resign is null





--Display records where employee resigned and their years of service

--experience years
select fname,lname ,sex, DATEDIFF(year,date_of_join,date_of_resign) as YearsOfService
from employee$
where date_of_resign is not null

--Find number of males and females in each category

select emp_type,count(emp_id) as TotalEmployees
from employee$
where date_of_resign is  null

group by emp_type,sex

--Top 10 treatments
select  *
from treatments_available$

select  treatment_name,max(fees) as MaximumFees
from treatments_available$
group by treatment_name
order by 2 desc
limit 10

--list department name , and fees sped in that dpt

select  dep_name,treatment_name,fees
from treatments_available$ tr
inner join department$ dep
on dep.dep_no=tr.dep_no
--group by dep_name,treatment_name ?
order by 1 desc


select  dep_name,fees
from treatments_available$ tr
inner join department$ dep
on dep.dep_no=tr.dep_no
--group by dep_name,treatment_name ?
order by 1 desc

--3 departmets with top fees spend
select  dep_name,sum(fees) as FeesSpend , avg(fees) as AverageFees, max(fees) as MaxFees
from treatments_available$ tr
inner join department$ dep
on dep.dep_no=tr.dep_no
group by dep_name
order by 2 desc
LIMIT 3



--Use CTE

With DeptVsFees  (dep_name,FeesSpend,AverageFees,MaxFees) as
(select  dep_name,sum(fees) as FeesSpend , avg(fees) as AverageFees, max(fees) as MaxFees
from treatments_available$ tr
inner join department$ dep
on dep.dep_no=tr.dep_no
group by dep_name
--order by 2 desc
)

select *
 from DeptVsFees

 --Temp Table

 create table DepFeesSpend
 (
 dep_no nvarchar(255),
 dep_name nvarchar(255),
 fees numeric
 
 )

 Insert into DepFeesSpend
 select  dep.dep_no,dep_name,sum(fees) as FeesSpend 
from treatments_available$ tr
inner join department$ dep
on dep.dep_no=tr.dep_no
group by dep.dep_no,dep_name
order by 3 desc 

select *
 from DepFeesSpend

 
 
 