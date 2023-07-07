select *
from [Online Shop Customer Sales Data] 

-- data cleaning

select purchase_date, CONVERT(date,purchase_date,3)
from [Online Shop Customer Sales Data]

UPDATE [Online Shop Customer Sales Data]
SET Purchase_DATE = convert(date,purchase_date,3)

ALTER TABLE [Online Shop Customer Sales Data]
ALTER COLUMN Revenue_Total float

ALTER TABLE [Online Shop Customer Sales Data]
ALTER COLUMN age int

ALTER TABLE [Online Shop Customer Sales Data]
ALTER COLUMN age int

ALTER TABLE [Online Shop Customer Sales Data]
ALTER COLUMN N_Purchases int

ALTER TABLE [Online Shop Customer Sales Data]
ALTER COLUMN Purchase_VALUE float

UPDATE [Online Shop Customer Sales Data]
SET Purchase_DATE = convert(date,purchase_date,3)

ALTER TABLE [Online Shop Customer Sales Data]
ALTER COLUMN Time_Spent int

-- determining which quarter has highest revenue

with cte(purchasedate, year, quarter, quarterly_revenue) as (select purchase_date, year(purchase_date), datepart(qq, purchase_date), round(sum(revenue_total) over (partition by datepart(quarter, purchase_date)),2)
from [Online Shop Customer Sales Data])
select year, quarter, quarterly_revenue
from cte
group by year, quarter, quarterly_revenue
order by year, quarter

-- determining gender that generates maximum revenue in shopping

select gender, round(sum(revenue_total),2)
from [Online Shop Customer Sales Data]
group by Gender

-- determining age group that generates maximum revenue in shopping

with cte(age_group, revenue) as (select case 
when age <= 18 then 'age <18'
when age > 18 AND age <= 30 then 'age > 18 & age <=30'
when age > 30 AND age <= 45 then 'age > 30 & age <=45'
when age > 45 then 'age > 45'
end, Revenue_Total
from [Online Shop Customer Sales Data])
select round(sum(revenue),2) as totalrevenue, age_group
from cte
group by age_group

-- determining average time spent by a different age groups on a single purchase 

with cte (age_group, timespent, npurchases) as (select case 
when age <= 18 then 'age <18'
when age > 18 AND age <= 30 then 'age > 18 & age <=30'
when age > 30 AND age <= 45 then 'age > 30 & age <=45'
when age > 45 then 'age > 45'
end, Time_Spent, N_Purchases
from [Online Shop Customer Sales Data]),
age_cte(agegroup, ts, np) as(select age_group, sum(timespent), sum(npurchases)
from cte
group by age_group)
select agegroup, ts as totaltime, -- tells which age group spends maximum time
np as totalpurchase, -- tells which age group has maximum number of purchases
ts/np as avgtimespent
from age_cte

-- determining average time spent by a different genders on a single purchase 

with cte(gen, timespent, npurchase) as (select gender, sum(time_spent), sum(N_Purchases)
from [Online Shop Customer Sales Data]
group by gender)
select gen, timespent as totaltime, -- tells which gender spends maximum time
npurchase as totalpurchase, -- tells which gender has maximum number of purchases
timespent/npurchase as avgtimespent
from cte

-- determing which mode of payment is popular amongst different age groups (recheck this)

with cte(age_group, paymethod) as (select case 
when age <= 18 then 'age <18'
when age > 18 AND age <= 30 then 'age > 18 & age <=30'
when age > 30 AND age <= 45 then 'age > 30 & age <=45'
when age > 45 then 'age > 45'
end, Pay_Method
from [Online Shop Customer Sales Data]), 
paycte(ag, pm, cpay) as (select distinct age_group, paymethod, count(paymethod) over (partition by paymethod, age_group)
from cte)
select ag as agegroup, pm as payment_method, cpay as countofpaymentmethod
from paycte
group by ag, pm, cpay
order by ag, cpay -- Pay_Method = 0: Digital Wallets, 1: Card, 2: PayPal, 3: Other




