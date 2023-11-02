--- Is for error 1055 --
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

# 1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region ---

select market,customer,region 
from dim_customer 
where customer = 'Atliq Exclusive' and region = 'APAC' 
group by market;
















