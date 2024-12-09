select * from ocd_patient_dataset;
-- count of F vs M that have OCD & avg obsession score by gender
with data as (
select Gender, count(Gender) as patient_count, avg(`Y-BOCS Score (Obsessions)`) as avg
from healthcare.ocd_patient_dataset
group by 1
order by 2
)

select 
sum(case when Gender = 'Female' then patient_count else 0 end) as count_female,
sum(case when Gender = 'Male' then patient_count else 0 end) as count_male,
round(sum(case when Gender = 'Male' then patient_count else 0 end)/
(sum(case when Gender = 'Male' then patient_count else 0 end) + sum(case when Gender = 'Female' then patient_count else 0 end))*100,2) as male_percentage,
round(sum(case when Gender = 'Female' then patient_count else 0 end)/
(sum(case when Gender = 'Male' then patient_count else 0 end) + sum(case when Gender = 'Female' then patient_count else 0 end))*100,2) as female_percentage
from data;

-- count and average obession score by ethinicites
select Ethnicity,count(`Patient ID`),avg(`Y-BOCS Score (Obsessions)`)
FROM healthcare.ocd_patient_dataset
GROUP BY Ethnicity
;

-- count and average compulsions score by ethinicites
select Ethnicity,count(`Patient ID`),avg(`Y-BOCS Score (Compulsions)`)
FROM healthcare.ocd_patient_dataset
GROUP BY Ethnicity
;

-- number of people diagnosed with ocd Mom
alter table healthcare.ocd_patient_dataset
modify `OCD Diagnosis Date` Date;
select
date_format(`OCD Diagnosis Date`, '%Y-%m-01 00:00:00') as month,
count(`Patient ID`) patient_count
from healthcare.ocd_patient_dataset
group by 1
order by 1;

-- what is the most common obsession type(count)  & it's respective average obession score

select `Obsession Type`, count(`Obsession Type`) as Numbers, avg(`Y-BOCS Score (Obsessions)`) as obse_score
from healthcare.ocd_patient_dataset
group by `Obsession Type`
order by 2
;

-- what is the most common compulsion type (count) & its respective average obsession score
select `Compulsion Type`, count(`Compulsion Type`) as Numbers, avg(`Y-BOCS Score (Compulsions)`) as obse_score
from healthcare.ocd_patient_dataset
group by 1
order by 2
;

-- count of patient diagnosised by depression on the basis of Gender
select count(`Patient ID`), `Depression Diagnosis`
from healthcare.ocd_patient_dataset
group by 3
;

select `Medications`, count(`Patient ID`)
from healthcare.ocd_patient_dataset
group by 1; 