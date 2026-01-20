--customer table analysis
select
min(birth_date) min_bd,
max(birth_date) heigher_bd,
DATEDIFF(year,min(birth_date),getdate()) oldest_cust,
DATEDIFF(year,max(birth_date),getdate()) yeangest_cust
from gold.dim_customers
--min and max birthDate of customer
select 'min_bd' massore_names,min(birth_date) massore_values  from gold.dim_customers
union all
select 'heigher_bd' massore_names,max(birth_date) massore_values from gold.dim_customers
--oldest and youngest customer
select 'oldest_cust' massore_names,datediff(year,min(birth_date),getdate()) massore_values from gold.dim_customers
union all
select 'yaungest_cust' massore_names,datediff(year,max(birth_date),getdate()) massore_values from gold.dim_customers
--customer by male and female

select 'male_cust' massore_names,count(gender) massore_values  from gold.dim_customers where gender = 'male'
union all
select 'female_cust' massore_names,count(gender) massore_values  from gold.dim_customers where gender = 'female'
union all
select 'other_cust' massore_names,count(gender) massore_values  from gold.dim_customers where gender in (null,'', 'n/a')
--customer by country
select country,count(customer_id) cust_by_country from gold.dim_customers group by country order by count(customer_id) des
