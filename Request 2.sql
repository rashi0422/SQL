# 2. What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields #

select X.A as unique_product_2020, Y.B as unique_product_2021 , round((B-A)*100/A,2) as  '% change' 
from (
(select count(distinct product_code) as 'A' from fact_sales_monthly where fiscal_year = 2020) as X, 
(select count(distinct product_code) as 'B' from fact_sales_monthly where fiscal_year = 2021) as Y 
) ;