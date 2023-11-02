# 4. Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields #

with output1 as (select segment,count(product) as 'product_count_2020'
from dim_product d 
join fact_gross_price g 
on g.product_code = d.product_code 
where fiscal_year = 2020
group by segment),
output2 as (select segment,count(product) as 'product_count_2021'
from dim_product d 
join fact_gross_price g 
on g.product_code = d.product_code 
where fiscal_year = 2021
group by segment)
select output1.segment,output1.product_count_2020,output2.product_count_2021,
Output2.product_count_2021 - output1.product_count_2020 as difference
from Output1 join output2 
on output1.segment = output2.segment 
order by segment asc;
