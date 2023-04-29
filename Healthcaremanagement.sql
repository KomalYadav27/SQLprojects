select*
from diabetic_data

-- calculating how many patients stay in hospital for different lengths

select time_in_hospital, count(patient_nbr) as numberofpatients
from diabetic_data
group by time_in_hospital 
order by numberofpatients desc

-- calculating list of specialities and number of procedures practised at hospital

ALTER TABLE diabetic_data
ALTER COLUMN num_lab_procedures bigint -- changing datatype from string to integer to perform aggegate funtion

ALTER TABLE diabetic_data
ALTER COLUMN num_procedures bigint -- changing datatype from string to integer to perform aggegate funtion


select medical_specialty, sum(num_lab_procedures) as totallabprocedures, round(avg(cast(num_lab_procedures as float)),1) as averagelabprocedures
from diabetic_data
where not medical_specialty = '?'
group by medical_specialty
order by averagelabprocedures desc

select medical_specialty, sum(num_procedures) as totalprocedures, round(avg(cast(num_procedures as float)),2) as averageprocedures
from diabetic_data
where not medical_specialty = '?'
group by medical_specialty
order by averageprocedures desc

-- checking if hospital treats patients of different ethnicity differently based on number of procedures

select race, sum(num_lab_procedures) as totallabprocedures, round(avg(cast(num_lab_procedures as float)),1) as averagelabprocedures
from diabetic_data
where not race = '?'
group by race
order by averagelabprocedures desc

-- checking if people need more procedures if they stay for longer duration

ALTER TABLE diabetic_data
ALTER COLUMN time_in_hospital bigint -- changing datatype from string to integer to perform aggegate funtion

select min(num_lab_procedures), avg(num_lab_procedures), max(num_lab_procedures)
from diabetic_data

select
case when num_lab_procedures > 0 and num_lab_procedures <= 25 then 'few'
     when num_lab_procedures > 25 and num_lab_procedures <=  55 then 'average'
	 when num_lab_procedures > 55 then 'many'
	 END AS procedurefrequency,
	 avg(time_in_hospital) as days_stay
from diabetic_data
group by case when num_lab_procedures > 0 and num_lab_procedures <= 25 then 'few'
     when num_lab_procedures > 25 and num_lab_procedures <=  55 then 'average'
	 when num_lab_procedures > 55 then 'many'
	 END
order by days_stay

-- calculating percentage of patients (success rate) who are admitted under emergency (admission_type_id = 1) and spent less than average time in hospital

select avg(time_in_hospital)
from diabetic_data --average time is 4 days

with 

select COUNT(patient_nbr)
from diabetic_data
where admission_type_id = '1' and time_in_hospital <(select avg(time_in_hospital) from diabetic_data)


select (select COUNT(patient_nbr)
from diabetic_data
where admission_type_id = '1' and time_in_hospital <(select avg(time_in_hospital) from diabetic_data)), count(patient_nbr) 
from diabetic_data
where admission_type_id = '1' -- this will be used to find percentage



